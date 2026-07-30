config=blink_F091
target=STM32F091RC

cd build/$config
    touch flashscript
    echo device $target > flashscript
    echo -e si 1'\n'speed 4000 >> flashscript
    echo loadbin $config.bin 0x8000000 >> flashscript
    echo -e r'\n'g'\n'qc >> flashscript


JLinkExe -commanderscript flashscript 
rm flashscript
