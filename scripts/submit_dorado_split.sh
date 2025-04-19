#! /bin/bash
#
#SBATCH --job-name=dorado_split
#SBATCH --time=24:00:00
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
#sp_in is directory holding raw nanopore data
#sp is overall directory for that sample
#reads_dir is output directory of basecalled reads
sp_in="/scratch/users/jahemker/seasonal_inbred/longread_assembly_test/${strain_id}/nanopore_raw/"
sp="/scratch/users/jahemker/seasonal_inbred/longread_assembly_test/${strain_id}"
reads_dir="/scratch/users/jahemker/seasonal_inbred/longread_assembly_test/${strain_id}/reads"

num=${SLURM_ARRAY_TASK_ID}
#location of sif with dorado
simg="/scratch/users/jahemker/singularity_images/longread_sv_calling.sif"
#location of where dorado model should be stored, along with model name
model="dna_r10.4.1_e8.2_400bps_sup@v5.0.0"
model_dir="/scratch/users/jahemker/seasonal_inbred/longread_assembly_test/${model}"

mkdir -p ${sp}.${num}.tmp/
ln -sf $(find ${sp_in}/ -name "*.pod5" -type f | awk -vn=${num} 'NR % 10 == (n-1)') ${sp}.${num}.tmp/

# run basecaller, emit fastq output
# if statement for resuming stopped jobs
if [ -f ${sp}.${num}.bam ]; then
  mv ${sp}.${num}.bam ${sp}.${num}.old.bam \
   && singularity exec --nv ${simg} dorado basecaller --min-qscore 10 \
        --resume-from ${sp}.${num}.old.bam \
        ${model_dir} ${sp}.${num}.tmp \
        > ${sp}.${num}.bam
else
  singularity exec --nv ${simg} dorado basecaller --min-qscore 10 \
    ${model_dir} ${sp}.${num}.tmp \
    > ${sp}.${num}.bam
fi && [ -f ${sp}.${num}.old.bam ] && rm ${sp}.${num}.old.bam \

singularity exec ${simg} samtools bam2fq -@ $(nproc) ${sp}.${num}.bam | seqkit rmdup -n | pigz -p $(nproc) > ${sp}.${num}.fastq.gz \
 && rm -r ${sp}.${num}.tmp

#combine the batched reads to final output
mkdir -p ${reads_dir}
cat ${strain_id}.*.fastq.gz > ${reads_dir}/${strain_id}.dorado.clean.fastq.gz
rm ${strain_id}.*.bam
rm ${strain_id}.*.fastq.gz