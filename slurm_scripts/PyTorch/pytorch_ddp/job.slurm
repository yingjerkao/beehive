#!/bin/bash
#SBATCH --job-name=ddp-torch     # create a short name for your job
#SBATCH --output=dpp-torch%j.out # output filename
#SBATCH --nodes=2                # node count
#SBATCH --ntasks-per-node=2      # total number of tasks per node
#SBATCH --cpus-per-task=8        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --gpus-per-node=2             # number of gpus per node
#SBATCH --time=00:10:00          # total run time limit (HH:MM:SS)

export MASTER_PORT=$(expr 10000 + $(echo -n $SLURM_JOBID | tail -c 4))
export WORLD_SIZE=$(($SLURM_NNODES * $SLURM_NTASKS_PER_NODE))
echo "WORLD_SIZE="$WORLD_SIZE
export SLURM_GPUS_ON_NODE=2
master_addr=$(scontrol show hostnames "$SLURM_JOB_NODELIST" | head -n 1)
export MASTER_ADDR=$master_addr
echo "MASTER_ADDR="$MASTER_ADDR

module purge
module load anaconda3/2022.03
eval "$(conda shell.bash hook)"
conda activate torch-env

srun python mnist_classify_ddp.py --epochs=2
