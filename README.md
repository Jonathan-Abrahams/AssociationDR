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


