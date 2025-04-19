#!/usr/bin/env python3
# This script will take in a vcf and 
# will convert all of the duplications to insertions
# Importantly, the duplicated sequence needs to be obtained
# and added to the vcfs.
# Needs an indexed reference genome, and samtools in the path

import sys
from subprocess import run
import re

vcf = sys.argv[1]
outfile = sys.argv[2]
reffile= sys.argv[3] #"/scratch/users/jahemker/seasonal_inbred/D.melanogaster.fa"

with open(outfile, 'w') as f1:
    with open(vcf, 'r') as f2:
        lines = f2.readlines()
        for l in lines:
            #If a header line or non-dup line, just write as is
            if '#' in l:
                f1.write(l)
                continue
            if "SVTYPE=DUP" not in l:
                f1.write(l)
                continue
            #Parse the vcf line
            chrom = l.rstrip().split()[0]
            start = l.rstrip().split()[1]
            end1 = l.rstrip().split("END=")[1]
            end = end1[:end1.index(";")]
            name = l.rstrip().split()[2]
            ref = l.rstrip().split()[3]
            alt = l.rstrip().split()[4]
            qual = l.rstrip().split()[5]
            filt = l.rstrip().split()[6]
            info = l.rstrip().split()[7]
            newinfo = re.sub(r"END=[0-9]+;", f"END={int(start)+1};",info)
            newinfo2 = re.sub(r"SVTYPE=DUP","SVTYPE=INS",newinfo)
            fmt = l.rstrip().split()[8]
            gt = l.rstrip().split()[9]
            #need to get DUP sequence
            command = f"samtools faidx {reffile} {chrom}:{start}-{end}"
            data = run(command, capture_output=True, shell=True, text=True)
            newalt = ('').join(data.stdout.split("\n")[1:])
            #write new INS line
            f1.write(f"{chrom}\t{start}\t{name}\t{ref}\t{newalt}\t{qual}\t{filt}\t{newinfo2}\t{fmt}\t{gt}\n")
