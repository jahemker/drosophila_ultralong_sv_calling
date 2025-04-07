# Manual validation finds only “ultralong” long-read sequencing enables faithful, population-level structural variant calling in _Drosophila melanogaster_ euchromatin (Hemker et al. 2025)
This repository contains the Snakemake pipelines and supporting scripts used in Hemker et al. 2025. The pipelines are written for an HPCC running SLURM.
## Dependencies 

These snakemake pipelines are built to work with the conda environments provided in the `envs/` directory. The versions listed are what were used in Hemker et al. 2025, though there now may be newer versions of programs.

---
For long-read structural variant calling:
```
mamba create -n longread_sv -c conda-forge -c bioconda snakemake=9.1.7 minimap2=2.28 sniffles=2.0.7 cutesv=2.1.0 svim-asm=1.0.3 jasminesv=1.1.5 bcftools samtools
# Debreak requires minimap2=2.15, so install it in its own environment
# so that the up-to-date minimap2 can be used for for aligning.
mamba create -n debreak -c conda-forge -c bioconda debreak=1.3
```
Addtionally, the PAV `sif` is required from (https://github.com/EichlerLab/pav).

---
For short-read structural variant calling:
```
```

For long-read genome assembly:
```
```
