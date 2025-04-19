## Snakemake workflow for structural variant calling of Drosophila melanogaster from short reads

This workflow begins with paired-end short reads for for multiple individuals and ends with a VCF that has been merged across samples and optionally filtered for euchromatic regions.

Specific rule resources can be modified. Requires GPU nodes for parabricks.

Estimated time to complete: ~1 day for 8 samples. Everything runs pretty quickly on the small D. melanogaster genome. More samples will increase time.

Also requires the parabricks singularity image. Version 4.0.1 was used in this paper. (https://catalog.ngc.nvidia.com/orgs/nvidia/teams/clara/containers/clara-parabricks)

---
User-specific parameters are found in `parameters_config.yaml`. Please also note that `submit_snakemake.sh` will have to be changed for your own HPCC.

Explanation of all `parameters_config.yaml` commands:
```
reference:
  location: # path to reference fasta
  euchromatic: # path to bedfile containing coordinates for final region filtering
project:
  name: # name of this run
  dir: # path to directory where all strain dirs/files are found
strains: # a file with each strain id on a single line. No headers or whitespace.
tools: # a file with each tool name on a single line. No headers or whitespace.
variant_params:
  min_length: # minimum variant length (bp) to be kept
  min_mapq: # minimum read mapping quality for callers
  min_caller_support: # minimum number of callers required for a variant to be kept in each sample
singularity_images:
  parabricks: # path to parabricks simg
  shortread_sv_calling: # path to shortread_sv_calling.sif
```
