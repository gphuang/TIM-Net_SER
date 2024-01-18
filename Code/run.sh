#!/bin/bash
#SBATCH --time=20:30:00
#SBATCH --mem-per-cpu=4G
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=6
#SBATCH --output=logs/%A.out
#SBATCH --job-name=tim-net
#SBATCH -n 1

module load miniconda
module load gcc/8.4.0 
module load cuda

source activate mmer

# !mkdir -p logs 

# Extract features
data_path='/scratch/work/huangg5/ravdess_ser/data/audio_speech'
echo $data_path
python extract_feature.py --data_name RAVDESS --data_path $data_path --mean_signal_length 110000

# training
python main.py --mode train --data RAVDESS --split_fold 10 --random_seed 46 --epoch 500 --gpu 0

# testing
python main.py --mode test --data RAVDESS  --test_path ./Test_Models/RAVDE_46 --split_fold 10 --random_seed 46