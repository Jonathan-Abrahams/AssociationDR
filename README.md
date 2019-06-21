# AssociationDR

Data needed at start:

print("args[1] should be the gff,
args[2] should be the SRA table,
args[3] should be the CNV list,
args[4] should be the the assemblies list")

Need to find the matching asemlbies of the strains with duplications and download them

Then make them into blastdb.

Then we can blast each duplication against the appropriate assembly:

```bash
 Rscript ./bin/Blast_dupes_against_genomic.r ./Accessory_files/B1917.gff ./Accessory_files/SraRunTable\ \(6\).txt ./Accessory_files/all_CNVs_tidy.csv ./Accessory_files/genomes_proks\ \(1\).csv
```


