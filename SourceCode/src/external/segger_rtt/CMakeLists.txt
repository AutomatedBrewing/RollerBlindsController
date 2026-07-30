set(rtt_path "SEGGER_RTT_V784b")

add_library(segger_rtt
	${rtt_path}/RTT/SEGGER_RTT.c
	${rtt_path}/RTT/SEGGER_RTT_printf.c
	${rtt_path}/Syscalls/SEGGER_RTT_Syscalls_GCC.c)
	
target_include_directories(segger_rtt PUBLIC
	${rtt_path}/RTT
	${rtt_path}/Config)