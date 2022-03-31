#!/bin/bash
#SBATCH --job-name=MNIST         # create a short name for your job
#SBATCH --output=MNIST%j.out
#SBATCH --nodes=1                # node count
#SBATCH --gres=gpu:1             # number of gpus per node
#SBATCH --time=00:05:00          # total run time limit (HH:MM:SS)

module purge
module load anaconda3/2022.03
eval "$(conda shell.bash hook)"
conda activate torch-env


python3 mnist_classify.py --epochs=3
