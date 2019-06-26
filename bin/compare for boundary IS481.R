#Compare results

Dupe_results=list.files("blast_results/")
Dupe_filt=unlist(strsplit(Dupe_results,"_duplication_[0-9]*_blast_table.txt"))
Dupe_filt_df=data.frame(Duplication_blast_results=Dupe_filt,Corresponding_rep=c(1:length(Dupe_filt)),Left_flank=c(1:length(Dupe_filt)),Right_flank=c(1:length(Dupe_filt)),stringsAsFactors = F)
head(Dupe_filt_df)

Rep_results=list.files("Rep_elements_blast_results/")
Rep_filtered=unlist(strsplit(Rep_results,"_genomic.fna_blast_rep_elements.txt"))

for(k in c(1:length(Rep_filtered)))
{
  Dupe_filt_df$Corresponding_rep[Dupe_filt_df$Duplication_blast_results%in%Rep_filtered[k]]=k
  
}

Dupe_filt_df[1,]
print("Beginning process of comparing results...")
for(q in c(1:nrow(Dupe_filt_df)))
{
  if(file.info(paste("./blast_results/",Dupe_results[q],sep=""))$size>0)
{
print(paste("File is right size",paste("./blast_results/",Dupe_results[q],sep="")))

  Blast_result_temp=read.delim(paste("./blast_results/",Dupe_results[q],sep=""),header=F)
  print(paste("Blast result read:",q))
  Blast_result_temp=Blast_result_temp[which(Blast_result_temp$V4%in%max(Blast_result_temp$V4))[1],]
  rep_result_temp=read.delim(paste("./Rep_elements_blast_results/",Rep_results[Dupe_filt_df$Corresponding_rep[q]],sep=""),header=F)
  Dupe_filt_df$Left_flank[q]=min(abs(rep_result_temp$V9- Blast_result_temp$V10))
  Dupe_filt_df$Right_flank[q]=min(abs(rep_result_temp$V10- Blast_result_temp$V9))

}
}

results_table=table(c(Dupe_filt_df$Left_flank,Dupe_filt_df$Right_flank)<3000)/c(nrow(Dupe_filt_df)*2)
names(results_table)=c("No association","Association<=3kb")
results_frame=as.data.frame(results_table)
library(ggplot2)
jpeg("rplot3312312.jpg", width = 1000, height = 750)

ggplot(data=results_frame, aes(x=Var1, y=Freq)) +
  geom_bar(stat="identity")+
  scale_y_continuous(limits=c(0,1))


dev.off()
