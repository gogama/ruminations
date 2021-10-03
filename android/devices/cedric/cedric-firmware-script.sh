fastboot getvar max-sparse-size
fastboot oem fb_mode_set
fastboot flash partition gpt.bin
fastboot flash bootloader bootloader.img
fastboot flash modem NON-HLOS.bin
fastboot flash fsg fsg.mbn
fastboot erase modemst1
fastboot erase modemst2
fastboot flash dsp adspso.bin
fastboot flash logo logo.bin
fastboot flash boot boot.img
fastboot flash recovery recovery.img
fastboot flash system system.img_sparsechunk.0
fastboot flash system system.img_sparsechunk.1
fastboot flash system system.img_sparsechunk.2
fastboot flash system system.img_sparsechunk.3
fastboot flash system system.img_sparsechunk.4
fastboot flash system system.img_sparsechunk.5
fastboot flash system system.img_sparsechunk.6
fastboot flash system system.img_sparsechunk.7
fastboot flash system system.img_sparsechunk.8
fastboot flash oem oem.img
fastboot erase cache
fastboot erase userdata
fastboot erase DDR
fastboot oem fb_mode_clear
fastboot reboot
