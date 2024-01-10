require('CENTIPEDE')

datadir = paste0(tmpdir,'/',pwmid,'/')

validpos = list.files(datadir,paste0('positive.tf',pwmid,'-'),full.names=T)
makemat <- function(filename){
    print(filename)
    load(filename)
    x=cbind(t(as.matrix(pos.mat)),t(as.matrix(neg.mat)))
    rm(pos.mat)
    rm(neg.mat)
    gc()
    x
}

allmat=do.call(rbind,lapply(validpos,makemat))

chrids=match(sapply(strsplit(validpos,'[.-]'),function(i){i[grep('chr',i)]}),ncoords)
allpws=do.call(c,lapply(1:length(validpos),function(i){
    pws=coords.pwm[clengths>0][[chrids[i]]]
}))

chrs.vec=do.call(c,lapply(1:length(validpos),function(i){
    rep(ncoords[chrids[i]],length(coords[clengths>0][[chrids[i]]]))
}))

require('IRanges')
coords.vec=do.call(c,lapply(1:length(validpos),function(i){
    start(coords[clengths>0][[chrids[i]]])
}))

#jitter reads by numerical precision level noise to prevent crashing.
allmat=allmat+runif(length(allmat),0,1e-10)
centFit=fitCentipede(Xlist = list(DNase=allmat), Y=cbind(rep(1, dim(allmat)[1]), allpws))

pwname.short = gsub("[[:punct:]]","",pwmname)
if(match.rc){
    pwname.short=paste0(pwname.short,'.RC')
}

df.all=data.frame(chr=chrs.vec,coord=coords.vec,pwm=allpws,score=centFit$PostPr)
write.csv(df.all,file=file.path(outdir,paste0(pwmid,'-',pwname.short,'-cent.calls.all.csv')))

rm(allmat)
gc()
