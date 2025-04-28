#! /bin/bash
#
#SBATCH --job-name=dorado_split
#SBATCH --time=1:00:00
#SBATCH --partition=gpu,owners
#SBATCH --mail-type=BEGIN,FAIL,END --mail-user=jahemker@stanford.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --constraint="GPU_GEN:VLT|GPU_GEN:AMP"
#SBATCH --gres="gpu:4"
#SBATCH --array=1-10

. /home/users/jahemker/.bashrc

#id of sample. Can export via sbatch, or change here
strain_id="${strain_id:-"dmel12.ul"}"
#nanopore_raw_dir is directory holding raw nanopore data
#project_dir is overall directory for that sample
#reads_dir is output directory of basecalled reads
project_dir="/scratch/users/jahemker/seasonal_inbred/longread_assembly_test"
nanopore_raw_dir="${project_dir}/${strain_id}/nanopore_raw/"
reads_dir="${project_dir}/${strain_id}/reads"

num=${SLURM_ARRAY_TASK_ID}
#location of sif with dorado
simg="/scratch/users/jahemker/singularity_images/longread_assembly.sif"
#location of where dorado model should be stored, along with model name
model="dna_r10.4.1_e8.2_400bps_sup@v5.0.0"
model_dir="${project_dir}/${model}"

mkdir -p ${project_dir}/${strain_id}.${num}.tmp/
ln -sf $(find ${nanopore_raw_dir}/ -name "*.pod5" -type f | awk -vn=${num} 'NR % 10 == (n-1)') ${project_dir}/${strain_id}.${num}.tmp/

# run basecaller, emit fastq output
# if statement for resuming stopped jobs
if [ -f ${project_dir}/${strain_id}.${num}.bam ]; then
  mv ${project_dir}/${strain_id}.${num}.bam ${project_dir}/${strain_id}.${num}.old.bam \
   && singularity exec --nv ${simg} dorado basecaller --min-qscore 10 \
        --resume-from ${project_dir}/${strain_id}.${num}.old.bam \
        ${model_dir} ${project_dir}/${strain_id}.${num}.tmp \
        > ${project_dir}/${strain_id}.${num}.bam
else
  singularity exec --nv ${simg} dorado basecaller --min-qscore 10 \
    ${model_dir} ${project_dir}/${strain_id}.${num}.tmp \
    > ${project_dir}/${strain_id}.${num}.bam
fi && [ -f ${project_dir}/${strain_id}.${num}.old.bam ] && rm ${project_dir}/${strain_id}.${num}.old.bam \

singularity exec ${simg} samtools bam2fq -@ $(nproc) ${project_dir}/${strain_id}.${num}.bam | \
  singularity exec ${simg} seqkit rmdup -n | \
  singularity exec ${simg} pigz -p $(nproc) > ${project_dir}/${strain_id}.${num}.fastq.gz \
  && rm -r ${project_dir}/${strain_id}.${num}.tmp

#combine the batched reads to final output
mkdir -p ${reads_dir}
cat ${project_dir}/${strain_id}.${num}.fastq.gz > ${reads_dir}/${strain_id}.fastq.gz
rm ${project_dir}/${strain_id}.*.bam
rm ${project_dir}/${strain_id}.*.fastq.gz
