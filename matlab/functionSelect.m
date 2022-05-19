switch name
    case "V_breath"
        [particleSum,particlekonz] = FunctionBased(c_breath,V_ap,ap_eff,V_room,variable, vent_int, vent_dur, n_vent, vir_lif);
    case "c_{breath}"
        [particleSum,particlekonz] = FunctionBased(variable,V_ap,ap_eff,V_room,V_breath, vent_int, vent_dur, n_vent, vir_lif);
    case "V_{ap}"
        [particleSum,particlekonz] = FunctionBased(c_breath,variable,ap_eff,V_room,V_breath, vent_int, vent_dur, n_vent, vir_lif);
    case "\eta_{ap}"
        [particleSum,particlekonz] = FunctionBased(c_breath,V_ap,variable,V_room,V_breath, vent_int, vent_dur, n_vent, vir_lif);
    case "V_{room}"
        [particleSum,particlekonz] = FunctionBased(c_breath,V_ap,ap_eff,variable,V_breath, vent_int, vent_dur, n_vent, vir_lif);
    case "t_{ventintervall}"
        [particleSum,particlekonz] = FunctionBased(c_breath,V_ap,ap_eff,V_room,V_breath, variable, vent_dur, n_vent, vir_lif);
    case "t_{ventduration}"
        [particleSum,particlekonz] = FunctionBased(c_breath,V_ap,ap_eff,V_room,V_breath, vent_int, variable, n_vent, vir_lif);
    case "n_{vent}"
        [particleSum,particlekonz] = FunctionBased(c_breath,V_ap,ap_eff,V_room,V_breath, vent_int, vent_dur, variable, vir_lif);
    case "t_{vir}"
        [particleSum,particlekonz] = FunctionBased(c_breath,V_ap,ap_eff,V_room,V_breath, vent_int, vent_dur, n_vent, variable);
end




