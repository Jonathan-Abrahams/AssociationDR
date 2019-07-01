# AssociationDR

Data needed at start:


Extract the duplications that correspond to closed genomes:

```bash
Rscript ./bin/extract\ duplications.R ./Accessory_files/B1917.gff ./Accessory_files/all_CNVs_tidy.csv ./Accessory_files/genomes_proks\ \(1\).csv ./Accessory_files/B1917.fna
```
This script will also create the file: genomes_to_download.csv.

These files are then downloaded and blastdb database are made for them.

This is the start of the file Blast_dupes_against_genomic.r:

```R
print("args[1] should be the gff,
args[2] should be the SRA table,
args[3] should be the CNV list,
args[4] should be the the assemblies list")
```


Then make them into blastdb.

Then we can blast each duplication against the appropriate assembly:

```bash
 Rscript ./bin/Blast_dupes_against_genomic.r ./Accessory_files/B1917.gff ./Accessory_files/SraRunTable\ \(6\).txt ./Accessory_files/all_CNVs_tidy.csv ./Accessory_files/genomes_proks\ \(1\).csv
```

Great! So now we have the location of each duplication in its constituant assembly, we need to obtain the locaiton of repetitive elements in these genomes!

```bash
ls -1 Duplication_fasta|grep ".fna$"|xargs -d '\n' -P 8 -n 1 -I TOK blastn -query ./blast_queries/all_blast -subject ./Duplication_fasta/TOK -outfmt 6 -qcov_hsp_perc 70 -out Rep_elements_blast_results/TOK_blast_rep_elements.txt
```

So now we need to compare these results- do any of the duplication boundaries fall within 2kb of these other elements?


then run the compare boundary script. Although we first need to exclude the rrna things
