#Compare results

Dupe_results=list.files("blast_results/")
Dupe_filt=unlist(strsplit(Dupe_results,"_duplication_[0-9]*_blast_table.txt"))
Dupe_filt_df=data.frame(Duplication_blast_results=Dupe_filt,Corresponding_rep=c(1:length(Dupe_filt)),Left_flank=c(1:length(Dupe_filt)),Right_flank=c(1:length(Dupe_filt)),stringsAsFactors = F)
Rep_results=list.files("Rep_elements_blast_results/")
Rep_filtered=unlist(strsplit(Rep_results,"_genomic.fna_blast_rep_elements.txt"))

for(k in c(1:length(Rep_filtered)))
{
  Dupe_filt_df$Corresponding_rep[Dupe_filt_df$Duplication_blast_results%in%Rep_filtered[k]]=k
  
}

Dupe_filt_df[1,]

for(q in c(1:nrow(Dupe_filt_df)))
{
  Blast_result_temp=read.delim(paste("./blast_results/",Dupe_results[q],sep=""),header=F)
  Blast_result_temp=Blast_result_temp[which(Blast_result_temp$V4%in%max(Blast_result_temp$V4))[1],]
  rep_result_temp=read.delim(paste("./Rep_elements_blast_results/",Rep_results[Dupe_filt_df$Corresponding_rep[q]],sep=""),header=F)
  Dupe_filt_df$Left_flank[q]=min(abs(rep_result_temp$V9- Blast_result_temp$V10))
  Dupe_filt_df$Right_flank[q]=min(abs(rep_result_temp$V10- Blast_result_temp$V9))

}

jpeg("rplot3312312.jpg", width = 1000, height = "750")

barplot(table(c(Dupe_filt_df$Left_flank,Dupe_filt_df$Right_flank)<3000)/c(nrow(Dupe_filt_df)*2))

dev.off()
