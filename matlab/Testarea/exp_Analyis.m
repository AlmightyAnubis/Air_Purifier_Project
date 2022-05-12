%close all
gw = exp(1)/(exp(1)-1);
maxVal = 500;
x = 1:maxVal;
y_OG = 0;
y_UG = -vent_int*P_add*exp(vent_eff)^(0)/V_room;

for i=2:maxVal
   y_OG(i) = y_OG(i-1) + vent_int*P_add*exp(vent_eff)^(-i+2)/V_room;
   y_UG(i) = y_UG(i-1) + vent_int*P_add*exp(vent_eff)^(-i+2)/V_room;
end
y_mid = y_UG - y_UG(1) * 0.5;
hold on
plot(x,y_OG);
plot(x,y_UG);
plot(x,y_mid);
plot([min(x) max(x)], [gw gw]);
hold off
%disp("Endwert: " + max(y));