# Manual validation finds only “ultralong” long-read sequencing enables faithful, population-level structural variant calling in _Drosophila melanogaster_ euchromatin (Hemker et al. 2025)
This repository contains the Snakemake pipelines and supporting scripts used in Hemker et al. 2025. The pipelines are written for an HPCC running SLURM.
## Dependencies 
These Snakemake (v9+) pipelines are built to work with singularity images. The versions are what were used in Hemker et al. 2025, though there now may be newer versions of programs. Singularity images can either be made from the provided Dockerfiles, or they can be created by pulling from the dockerhub.
```
singularity build longread_sv_calling.sif docker://jahemker/longread_sv_calling:latest
singularity build shortread_sv_calling.sif docker://jahemker/shortread_sv_calling:latest
singularity build longread_assembly.sif docker://jahemker/longread_assembly:latest
```
A conda environment to run snakemake (version >=9) is easiest.
```
conda create -n snakemake -c conda-forge -c bioconda snakemake
```

For workflow-specific details, see README files.
