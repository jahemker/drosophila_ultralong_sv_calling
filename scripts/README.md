## Useful, supplementary scripts and other commands.

`submit_dorado_split.sh` will split raw nanopore data into batches, allowing it to be processed more quickly and with fewer resources per-job. Useful if samples were sequenced to extremely high coverage. Run this job, and then the assembly snakemake file should take over after the reads have been basecalled.

`vcf_to_bed.py` is a simple script that parses VCF files and outputs the coordinates of the variants in BED format. Can also output into a CSV format which was used for manual validation. Can also output variant sequence in FASTA format.

Other useful one- or two-liners for VCF data manipulation that were used in this paper:

Convert VCF to table that can easily be uploaded into R data.frames. Requires the GATK toolkit. These specific fields are only in VCFs merged with Jasmine.
```
gatk VariantsToTable -V [sample.vcf] -F CHROM -F POS -F END -F ID -F REF -F ALT -F SVTYPE -F SVLEN -F SUPP_VEC -F SUPP -O [sample_vcf.table]
```

For VCFs that include variants called by GRIDSS, the format must first be altered to play nice with GATK. All "." must be removed from the REF field.
```
awk '{IFS=OFS="\t"; if($4 == ".") $4 = "N"; print }' [sample_id.vcf] > [sample_id.gatk.vcf]
```

Get the read lengths from fastq in csv format. Requires `bioawk`
```
bioawk -c fastx '{ OFS = ","; print $name, length($seq),"strain_id" } < [strain_id.fastq.gz] > [strain_id.read_length.csv]
```

