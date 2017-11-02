#!/usr/bin/env bash

#to be used to data munge those gff's
#put in the genome directory where your gff's are

#get rid of empty lines
egrep -v '^$' 520.613.RefSeq.gff > 520.613.gff.temp
#get rid of comments
egrep -v '^#' 520.613.gff.temp > temp2
#only get CDS
grep -P "\tCDS\t" temp2 > 520.613-CDS.gff
#get the rRNA for bowtie2 (or other aligners) that support filtering by rRNA seq
grep -P "\trRNA\t" temp2 > 520.613-rRNA.gff
