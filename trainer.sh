#!/bin/bash

# training settings
export num_train_epochs=3
export save_strategy="epoch"
export logging_strategy="epoch"

# validation settings
export evaluation_strategy="epoch" 

# model settings
# export model_name="csebuetnlp/banglabert_large"
export model_name="outputs_final_3/checkpoint-7575"

# optimization settings
export learning_rate=2e-5 
export warmup_ratio=0.1
export gradient_accumulation_steps=2
export weight_decay=0.01
export lr_scheduler_type="linear"

# misc. settings
export seed=1234

# input settings
# exactly one of `dataset_dir` or the (train / validation)
# dataset files need to be provided
input_settings=(
    "--dataset_dir banglabert/token_classification/sample_inputs"
    "--train_file sample_inputs/train.jsonl"
    "--validation_file sample_inputs/validation.jsonl"
    "--test_file sample_inputs/test.jsonl"
)

# output settings
export output_dir="outputs_final_3/"

# batch / sequence sizes
export PER_DEVICE_TRAIN_BATCH_SIZE=16
export PER_DEVICE_EVAL_BATCH_SIZE=16
export MAX_SEQUENCE_LENGTH=512

# optional arguments
optional_arguments=(
    "--metric_for_best_model macro_avg_f1"
    "--greater_is_better true" # this should be commented out if the reverse is required
    "--load_best_model_at_end"
    "--logging_first_step"
    "--overwrite_cache"
    "--cache_dir cache_dir/"
    "--fp16"
    "--fp16_backend auto"
)

# optional for logging
# export WANDB_PROJECT="Token_classification_finetuning"
# export WANDB_WATCH=false
# export WANDB_MODE="dryrun"
export WANDB_DISABLED=true

python banglabert/token_classification/token_classification.py \
    --model_name_or_path $model_name \
    --output_dir $output_dir \
    --learning_rate=$learning_rate --warmup_ratio $warmup_ratio --gradient_accumulation_steps $gradient_accumulation_steps \
    --weight_decay $weight_decay --lr_scheduler_type $lr_scheduler_type  \
    --per_device_train_batch_size=$PER_DEVICE_TRAIN_BATCH_SIZE --per_device_eval_batch_size=$PER_DEVICE_EVAL_BATCH_SIZE \
    --max_seq_length $MAX_SEQUENCE_LENGTH --logging_strategy $logging_strategy \
    --seed $seed --overwrite_output_dir \
    --num_train_epochs=$num_train_epochs --save_strategy $save_strategy \
    --evaluation_strategy $evaluation_strategy --do_predict\
    $(echo -n ${input_settings[@]}) \
    $(echo ${optional_arguments[@]})

