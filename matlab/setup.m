
switch name
    case "V_breath"
        name = "V_{breath}";
    case "c_breath"
        name = "c_{breath}";
    case "V_ap"
        name = "V_{ap}";
    case "ap_eff"
        name = "\eta_{ap}";
    case "V_room"
        name = "V_{room}";
    case "vent_int"
        name = "t_{ventintervall}";
    case "vent_eff"
        name = "\eta_{vent}";
    case "vir_lif"
        name = "t_{vir}";
end


switch name
    case "c_{breath}"
        factor = 1/1000;
    case "V_{breath}"
        factor = 1*60*1000;
    case "V_{ap}"
        factor = 1*3600;
    case "t_{ventintervall}"
        factor = 1/60;
    case "t_{vir}"
        factor = 1/60;       
    otherwise
        factor = 1;
end

if(contains(name,"c_{breath}"))
    space = 2.^(-1:5);
end

data = value*space;

if(contains(name,"eta"))
    data = 0.0:0.2:1;
end


endvalue = [];