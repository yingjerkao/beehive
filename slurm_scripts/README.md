# Slurm Simple Guide

Here is a summary of how to generate a Slurm script and submit/monitor/manage jobs.

# Job Scripts

## Job Submission Options
|Use |	Directive |
|----|--------|
|Script directive|	`#SBATCH`|
|Job name|	`--job-name=<name>`|
|Queue or partition|	`--partition=queuename`|
|Wall time limit| `--time=hh:mm:ss`|
|Node count	|`--nodes=N`|
|Process count per node| `--ntasks-per-node=M`|
|Memory limit|	`--mem=Xgb` (it is MB by default)|
|Request GPUs|	`--gpus-per-node=G`|
|Standard output file|	`--output=<file path>/<file name>` |
|Standard error file|	`--error=<file path>/<file name>` |
|Job dependency|`--dependency=after:jobID[:jobID...]`<br>`--dependency=afterok:jobID[:jobID...]`<br>`--dependency=afternotok:jobID[:jobID...]`<br>`--dependency=afterany:jobID[:jobID...]`|
|Request event notification| `--mail-type=<events>` <br>Note: multiple mail-type requests may be specified in a comma-separated list:<br> `--mail-type=BEGIN,END,NONE,FAIL,ALL`|
|Email address|	`--mail-user=<email address>`|
|Require reservation|`--reservation=rsvid`|
|Quality of service	| `--qos=[name]`|
|Generic Resources|`--gres=[resource_spec]`|


## Job Environment Variables
| Info	| Variable |
|-------|-------|
|Job ID	|`$SLURM_JOB_ID`|
|Job name	|	`$SLURM_JOB_NAME`|
|Queue name	|`$SLURM_JOB_PARTITION`|
|Submit directory	|`$SLURM_SUBMIT_DIR`|
|Node file	|`srun hostname \| sort -n`|
|Number of processes| `$SLURM_NTASKS`|
|Number of nodes allocated | `$SLURM_JOB_NUM_NODES`|
|Number of processes per node |	`$SLURM_TASKS_PER_NODE` |
|Walltime | `$SLURM_TIME_LIMIT` |
|Job array ID | `$SLURM_ARRAY_JOB_ID` |
|Job array index |`$SLURM_ARRAY_TASK_ID` |


# Submit, Monitor and Manage Jobs

## Job Submission

| Action| Command|
|-------|---------|
| Submit batch job	|`sbatch <jobscript>`|
|Submit interactive | `sinteractive [options]` <br> `salloc [options]`|

## Manage Jobs
|Use|	Command|
|---|----------|
|Delete a job|	`scancel <jobid>`|
|Hold a job	| `scontrol hold <jobid>`|
|Release a job|	`scontrol release <jobid>`|
|Cancel a job|`scancel <jobid>`|

## Monitor Jobs
|Use	| Command |
|-------|---------|
|Job list summary| `squeue` or `squeue -l` for full information|
|Job information by a user	|	`squeue -u <user>`|
|Detailed job information	|	`sstat -a <jobid>` or `scontrol show job <jobid>`|


## Information
|Use	| Command |
|-------|---------|
|Show partitions/nodes| `sinfo` or `sinfo --all`|
|Show node information| `scontrol show node`|


## Example Scripts

The scripts are divided into different categories depending on the nature of the simulation.

Issue `make` under the directory to build the binary. Extra requirements are stated in each subsections. 

The jobscripts are `job.xxxx`. Submit the job by issuing `sbatch job.xxxx`.

### Serial
Typical single cpu, single thread computation.

```bash

#!/bin/bash
#SBATCH --job-name=SerialTest   # Job name
#SBATCH -o SerialTest.%j.out    # Name of stdout output file (%j expands to jobId)
#SBATCH --partition=gpu         # Queue name
#SBATCH --nodes=1               # Total number of nodes requested
#SBATCH --time=01:30:00         # Run time (hh:mm:ss) - 1.5 hours

echo "Serial Test(Single Thread)"
./single.e

```
### OpenMP
For multi-threaded jobs, change the number in `--cpus-per-task=8` to the number of threads available. 
```bash

#!/bin/bash
#SBATCH --job-name=ThreadTest # Job name
#SBATCH --output=ThreadTest.%j.out  # Name of stdout output file (%j expands to jobId)
#SBATCH --nodes=1                # Total number of nodes requested
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=01:30:00           # Run time (hh:mm:ss) - 1.5 hours

echo "Thread Test"
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
echo $OMP_NUM_THREADS
./thread.e

```
### GPU

```bash

#!/bin/bash  
#SBATCH --job-name=CudaTest             # Job name
#SBATCH --output=CudaTest.%j.out        # Name of stdout output file 
#SBATCH --nodes=1                       # Total number of nodes requested
#SBATCH --gpus-per-node=1               # Number of gpus
#SBATCH -t 01:30:00                     # Run time (hh:mm:ss) - 1.5 hours


./saxpy.e
```
### MPI
You need first to set the environment variables for Intel OneAPI by issuing `source /opt/intel/oneapi/setvars.sh`.

```bash
#!/bin/bash
#SBATCH --job-name=MPITest # Job name
#SBATCH -o MPITest.%j.out  # Name of stdout output file (%j expands to jobId)
#SBATCH --partition=gpu       # Queue name
#SBATCH --nodes=2                 # Total number of nodes requested
#SBATCH --ntasks-per-node=4       # Number of procersses per node
#SBATCH --time=01:30:00           # Run time (hh:mm:ss) - 1.5 hours

echo "MPI Test"
mpiexec ./mpi_test.e
```

