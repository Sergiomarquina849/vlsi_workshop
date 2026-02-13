create_mode Normal
set corner_list {Slow_LowV_LT  Fast_HighV_HT}
foreach corner $corner_list {
create_corner $corner
}

create_scenario -mode Normal -corner Slow_LowV_LT -name Normal_Slow_LowV_LT
current_scenario Normal_Slow_LowV_LT
source "$SDC"
set_temperature -40
set_process_number 0.9
set_process_label Slow
set_voltage 0.75 -object_list VDD
read_parasitic_tech -tlup $TLUPLUS_MAX_FILE -layermap $TLUPLUS_MAP_FILE -name tlup_max
set_scenario_status Normal_Slow_LowV_LT -none -setup true -hold false -leakage_power false -dynamic_power false -max_transition true -max_capacitance true -min_capacitance false -active true

create_scenario -mode Normal -corner Fast_HighV_HT -name Normal_Fast_HighV_HT
current_scenario Normal_Fast_HighV_HT
source "$SDC"
set_temperature 125
set_process_number 1.1
set_process_label Fast
set_voltage 0.95 -object_list VDD
read_parasitic_tech -tlup $TLUPLUS_MIN_FILE -layermap $TLUPLUS_MAP_FILE -name tlup_min
set_scenario_status Normal_Fast_HighV_HT -none -setup true -hold true -leakage_power false -dynamic_power false -max_transition true -max_capacitance true -min_capacitance false -active true

set_parasitics_parameters \
        -early_spec tlup_min \
        -late_spec tlup_min \
        -corners {Fast_HighV_HT}

set_parasitics_parameters \
        -early_spec tlup_max \
        -late_spec tlup_max \
        -corners {Slow_LowV_LT}
