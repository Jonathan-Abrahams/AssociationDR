#Script to extract duplication sequence from CNV list

args = commandArgs(trailingOnly=TRUE)

library(stringr)
library(Biostrings)
library(seqinr)
#CNV_list
gff=read.delim(args[1],stringsAsFactors = F,header = F)

#dups=read.csv("B1917_duplications/all_CNVs_tidy.csv",stringsAsFactors = F)
dups=read.csv(args[2],stringsAsFactors = F)

#all_assem=read.csv("genomes_proks (1).csv",stringsAsFactors = F)
all_assem=read.csv(args[3],stringsAsFactors = F)

Ref_fasta=readDNAStringSet(args[4])

all_assem$RefSeq.FTP=str_extract(all_assem$RefSeq.FTP,"GCF_.*")
all_assem$BioSample=gsub(" ","",all_assem$BioSample)
all_assem$Assembly=gsub(" ","",all_assem$Assembly)

#all_assem$BioSample[which(all_assem$BioSample%in%dups$Strains),]
dups_in_question=dups[which(dups$Strains%in%all_assem$BioSample),]
dups_in_question$Dupe_ID=rownames(dups_in_question)
dups_in_question$group=dups$group[rownames(dups_in_question)]

write.csv(dups_in_question,"Dups_in_question.csv")

#Lets make the fastas
for( q in c(1:nrow(dups_in_question)))
{
  start_bp=gff$V4[dups_in_question$Starts[q]]
  end_bp=gff$V4[dups_in_question$Ends[q]]
  Dup_seq=Ref_fasta[[1]][start_bp:end_bp]
  print(paste("Writing fasta file: ",paste("./Duplication_fasta_files/","Duplication_",dups_in_question$Dupe_ID[q],sep=""),sep=""))
  write.fasta(as.character(Dup_seq),as.string=T,names=paste("./Duplication_fasta_seqs/","Duplication_",q,sep=""),file.out=paste("./Duplication_fasta_files/", "Duplication_fasta_",q,".fasta",sep=""))
}

write.csv(all_assem[all_assem$BioSample%in%dups$Strains,],"genomes_to_download.csv")
