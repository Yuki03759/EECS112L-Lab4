#set PathSeparator .

set WLFFilename waveform.wlf
log -r /*

log -r /tb_top/riscV/dp/rf/register_file
log -r /tb_top/riscV/dp/data_mem/mem

#log -r /* 
run -all
quit
