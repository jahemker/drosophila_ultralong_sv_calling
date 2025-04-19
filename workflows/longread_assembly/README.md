## Snakemake workflow for longread haploid assembly of Drosophila melanogaster

This workflow begins with raw, nanopore sequencing data and ends with a scaffolded, RepeatMasked genome assembly.

Requires nodes with GPUs and nodes with access to high memory (>= 512Gb). Specific rule resources can be modified.

Estimated time to complete: ~1 week. Most of the time will be due to Dorado basecalling (~1 day), Flye assembly (especially for very long reads; ~1-2 days), and RepeatModeler library generation (~3-4 days). A pre-existing repeat library can be used to signficantly speed up the workflow.

For the Foreign Contamination Screen, please find relevant information and singularity images here: https://github.com/ncbi/fcs
---
User-specific parameters are found in `parameters_config.yaml`. Please also note that `submit_snakemake.sh` will have to be changed for your own HPCC.

Explanation of all `parameters_config.yaml` commands:
```
reference:
  location: # path to reference fasta
project:
  dir: # path to directory with all sample dirs/files
  fcsgx_dir: # path to download location of FCS (requires significant storage)
  busco_dir: # path to download busco lineage group
strains: # a file with each strain_id on its own line. No header or white-space
models: 
  dorado: # dorado basecalling model to be used
  medaka: # medaka model to be used
  busco: # busco lineage to be used
singularity_images:
  longread_assembly: # path to longread_assembly.sif
  fcsgx_sif: # path to fcs-gx.sif
  fcs-adaptor: # path to fcs-adaptor.sif
scripts:
  fcs-adaptor: # path to run_fcsadaptor.sh script
  fcs-gx: # path to run_fcsgx.py script
```
