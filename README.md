# Manual validation finds only “ultralong” long-read sequencing enables faithful, population-level structural variant calling in _Drosophila melanogaster_ euchromatin (Hemker et al. 2025)
This repository contains the Snakemake pipelines and supporting scripts used in Hemker et al. 2025.
## Setup for pipelines
These pipelines are built to work with the conda environments provided in the `envs/` directory. The pipelines are written for an HPCC running SLURM.

```
mamba create  -n ultralong_paper -f envs/longread_sv_calling_env.yml -c conda-forge -c bioconda
```
