#download genomes and make blastdb
#start: ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/001/605/365/GCA_001605365.1_ASM160536v1
#goal:ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/001/605/365/GCA_001605365.1_ASM160536v1/GCA_001605365.1_ASM160536v1_genomic.fna.gz

to_download=read.csv("genomes_to_download.csv",stringsAsFactors = F)
#substr(to_download$GenBank.FTP[1],56,83)
for(i in c(1:nrow(to_download)))
{
  command=paste(to_download$GenBank.FTP[i],"/",substr(to_download$GenBank.FTP[i],56,83),"_genomic.fna.gz",sep="")
  system(paste("wget",command,"-P","./Assembly/"))
  #unzip the file
  system(paste("gunzip ","./Assembly/",substr(to_download$GenBank.FTP[i],56,83),"_genomic.fna.gz",sep="") )
  #makeblastdb -in  -parse_seqids -dbtype nucl
  paste("./Assembly/",substr(to_download$GenBank.FTP[i],56,83),"_genomic.fna",sep="") 
}

