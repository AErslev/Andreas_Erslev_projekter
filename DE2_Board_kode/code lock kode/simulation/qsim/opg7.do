onerror {quit -f}
vlib work
vlog -work work opg7.vo
vlog -work work opg7.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.code_lock_vlg_vec_tst
vcd file -direction opg7.msim.vcd
vcd add -internal code_lock_vlg_vec_tst/*
vcd add -internal code_lock_vlg_vec_tst/i1/*
add wave /*
run -all
