#blaster script
args = commandArgs(trailingOnly=TRUE)

library(stringr)
library(gtools)
#repetitive elements association with dups in de novo seqs
#gff=read.delim("B1917_duplications/B1917.gff",stringsAsFactors = F,header = F)
print("args[1] should be the gff,args[2] should be the SRA table,args[3] should be the CNV list,args[4] should be the the assemblies list")

gff=read.delim(args[1],stringsAsFactors = F,header = F)


#all_SRA=read.delim("SraRunTable (6).txt",stringsAsFactors = F)
all_SRA=read.delim(args[2],stringsAsFactors = F)

#dups=read.csv("B1917_duplications/all_CNVs_tidy.csv",stringsAsFactors = F)
dups=read.csv(args[3],stringsAsFactors = F)

#all_assem=read.csv("genomes_proks (1).csv",stringsAsFactors = F)
all_assem=read.csv(args[4],stringsAsFactors = F)

all_assem$RefSeq.FTP=str_extract(all_assem$GenBank.FTP,"GCA_.*")
all_assem$BioSample=gsub(" ","",all_assem$BioSample)
all_assem$Assembly=gsub(" ","",all_assem$Assembly)

#all_assem$BioSample[which(all_assem$BioSample%in%dups$Strains),]
dups_in_question=dups[which(dups$Strains%in%all_assem$BioSample),]


#we want to make a sys call to blast against the right ref

#sa,ple blast command:
# blastn -query kek -subject GCF_001605365.1_ASM160536v1_genomic.fna -outfmt 6 -qcov_hsp_perc 90

all_dups_fasta=list.files("./Duplication_fasta_files/")
all_dups_fasta=mixedsort(all_dups_fasta)
line_numbers=str_extract(all_dups_fasta,"[0-9]*")
#print(all_dups_fasta[1:10])
#We need to find the GCF ID of the duplications so that we can blast the duplication DNA against the right seq.
#GCF ID can be found in the all_assem column REFSEQ.
dups_in_question$Refseq="0"
dups_in_question$Strains
for(q in c(1:nrow(dups_in_question)))
{
  dups_in_question$Refseq[q]=all_assem$RefSeq.FTP[which(all_assem$BioSample%in%dups_in_question$Strains[q])]
}

#Okay, now a system call to do blasts
print("Running Blasts:")
for(i in c(1:length(all_dups_fasta)))
{
  print(i)
  query_file=paste("./Duplication_fasta_files/",all_dups_fasta[i],sep="")
  print(paste("Query file is:",query_file))
  subject_file=paste("./Assembly/",dups_in_question$Refseq[i],"_genomic.fna",sep="")
  print(paste("Subject file is:",subject_file))
  outfile=paste("./blast_results/",dups_in_question$Refseq[i],"_duplication_",i,"_blast_table.txt",sep = "")
  print(paste("outfile is:",outfile))

  command_line=paste("blastn -query ",query_file," -subject ",subject_file," -outfmt 6 -qcov_hsp_perc 90 > ",outfile,sep="")
  print(command_line)
system(command_line)
}
