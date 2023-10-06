#!/bin/bash

cd "${destination_dir}/examples/text_to_image"

# setup virtual environment
if [ ! -d "momalisa" ]; then
    python3 -m venv momalisa
fi
. ./momalisa/bin/activate

# install packages
pip install -r requirements.txt
pip install git+https://github.com/huggingface/diffusers.git
pip install wandb

# set global variables
export MODEL_NAME= "CompVis/stable-diffusion-v1-4"
export TRAIN_DIR= "./train"
export OUTPUT_DIR= "moma-sd-finetuned"

# initialize accelerate environment
# TODO: change to accelarate config --default
accelerate config

# wandb setup
json_file="../../../../secrets/wandb_api_key.json"
if [ ! -s ~/.netrc ]; then
    API_KEY=$(cat "${json_file}")
    wandb login $API_KEY
else
    wandb login
fi


accelerate launch train_text_to_image.py \
  --pretrained_model_name_or_path=$MODEL_NAME \
  --train_data_dir=$TRAIN_DIR \
  --use_ema \
  --resolution=512 --center_crop --random_flip \
  --train_batch_size=1 \
  --gradient_accumulation_steps=4 \
  --gradient_checkpointing \
  --mixed_precision="fp16" \
  --max_train_steps=50000 \
  --learning_rate=1e-06 \
  --max_grad_norm=1 \
  --lr_scheduler="constant" --lr_warmup_steps=0 \
  --output_dir=${OUTPUT_DIR} \
  --validation_prompts "A MOMA artwork of: changing seasons" "A MOMA artwork of: a coffee" "A MOMA artwork of: an industrial setting" "A MOMA artwork of: critique of the USA" "A MOMA artwork of: Picasso and Monet combined"  \
  --num_train_epochs=100 \
  --report_to="wandb"