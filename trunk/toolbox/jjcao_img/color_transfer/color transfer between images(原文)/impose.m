function spie=impose(source,target)
sstar=source-mean2(source);
ssig=std2(source);
tsig=std2(target);
spie=(tsig/ssig)*sstar+mean2(target);


