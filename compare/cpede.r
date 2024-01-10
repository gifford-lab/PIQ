cent.runstr=sapply(1:1316,function(tfid){
    paste0('cd /cluster/thashim/basepiq/compare/centrun/ ; ./run.cpede.r common.r /cluster/thashim/PIQ/141105-3618f89-hg19k562.pwms/ /scratch/tmp/ /cluster/thashim/basepiq/compare/centcalls/ /cluster/thashim/PIQ/rdata/hg19k562.RData ',tfid)
})

for(str in cent.runstr){
    system(paste0('echo \'',str,'\' | qsub -wd /cluster/thashim/basepiq/compare/centcalls/ -o out.txt -e err.txt -l mem_free=30G'))
}
