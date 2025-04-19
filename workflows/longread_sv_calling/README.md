## Snakemake workflow for structural variant calling of Drosophila melanogaster from nanopore long reads

This workflow begins with basecalled, nanopore long-read for for multiple individuals and ends with a VCF that has been merged across samples and optionally filtered for euchromatic regions.

Specific rule resources can be modified.

Estimated time to complete: <1 day for 8 samples. PAV can take a large amount of time (8-12 hours). Everything else runs pretty quickly on the small D. melanogaster genome. More samples will increase time.

Also requires the PAV singularity image (https://github.com/EichlerLab/pav)

---
User-specific parameters are found in `parameters_config.yaml`. Please also note that `submit_snakemake.sh` will have to be changed for your own HPCC.

Explanation of all `parameters_config.yaml` commands:
```
reference:
  location: # path to reference fasta file
  euchromatic:# path to bedfile containing regions that final vcf will be filtered on
project:
  name: # specific name for this run
  dir: # path to directory storing all of the sample dirs/files
strains: # a file with each strain id on a single line. No headers or white-space
tools: # a file with each tool name on a single line. No headers or whites-space.
variant_params:
  min_length: # minimum variant length (bp) to be kept
  min_mapq: # minimum read mapping quality for callers
  min_caller_support: # minimum number of callers required for a variant to be kept in each sample
singularity_images:
  longread_sv_calling: # path to longread_sv_calling.sif
  pav: # path to PAV sif
```
