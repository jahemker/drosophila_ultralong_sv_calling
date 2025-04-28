# James Hemker 2025
# Takes in a structural variant VCF file (arg 1)
# Outputs a BED file of the variants (arg 2)
# Other useful, alt outputs at bottom of script

import sys

vcf = sys.argv[1]
bedfile = sys.argv[2]

with open(bedfile, 'w') as f1:
    with open(vcf, 'r') as f2:
        lines = f2.readlines()
        for l in lines:
            if '#' in l:
                continue
            chrom = l.rstrip().split()[0]
            start = int(l.rstrip().split()[1]) - 1
            ref = l.rstrip().split()[3]
            alt = l.rstrip().split()[4]
            end1 = l.rstrip().split("END=")[1]
            end = end1[:end1.index(";")]
            length1 = l.rstrip().split("SVLEN=")[1]
            length = length1[:length1.index(";")]
            suppvec1 = l.rstrip().split("SUPP_VEC=")[1]
            suppvec = suppvec1[:suppvec1.index(";")]
            supp1 = l.rstrip().split("SUPP=")[1]
            supp = supp1[:supp1.index(";")]
            svtype1 = l.rstrip().split("SVTYPE=")[1]
            svtype = svtype1[:svtype1.index(";")]
            name = l.rstrip().split()[2]
            # BED output
            f1.write(f"{chrom}\t{start}\t{end}\t{name}\n")

            # BED output with extra details
            # f1.write(f"{chrom}\t{start}\t{end}\t{name}\t{svtype}\t{length}\t{suppvec}\t{supp}\n")

            # CSV output that can be pasted into excel for easier manual validation
            #f1.write(f"{chrom},{start},{int(start)+1},{chrom},{end},{int(end)+1},{name},{svtype},{length},{suppvec}\n")

            # Fasta output of INS and DEL variant sequence
            # if svtype=="DEL" and "DEL" not in ref:
            #     f1.write(f">{name}\n")
            #     f1.write(f"{ref}\n")
            # if svtype=="INS" and "INS" not in alt:
            #     f1.write(f">{name}\n")
            #     f1.write(f"{alt}\n")
