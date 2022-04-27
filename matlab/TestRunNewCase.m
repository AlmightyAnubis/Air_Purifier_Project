close all
clear
%% ValueMatrix


%% Params
runtime = 5 * 60 * 60;
V_br = 5/60/1000;
c_breath = 0.1 * 1000000;
V_ap = 500/3600;
ap_eff = 0;%0.95;
V_room = 200;
vent_int = 20*60;
vent_eff = 0.5;%0.1;
vir_lif = 22.5*60;
P_add = V_br * c_breath;
vent_dur = 2*60;
t_vir_dis = 1;

%% Calc
[summe,konz] = Iteration(runtime,P_add,V_ap,ap_eff,V_room,V_br,vent_int,vent_dur,vent_eff,vir_lif,t_vir_dis);
time = (1:runtime);
%% Grahpics
figure();
plot(time/60,summe);
konz_sm = smooth(konz,vent_int);
konz_sm = konz_sm(1:end-vent_int);
figure();
plot(time/60,konz);
hold on
plot(time(1:end-vent_int)/60,konz_sm);
hold off
xlabel("Zeit in Minuten");
ylabel("Viruskonzentraton");
legend(["Realer Verlauf","Mittelwert gemittelt über eine Lüftungsperide"]);


disp("Simulation Max: " + max(konz_sm));
time_to_half_max = size(konz_sm(konz_sm<max(konz_sm)/2),1);
%disp("Halftime: " + time_to_half_max/60);



%% Data Analysis
m_0 = P_add / V_room;
max_ap = P_add/V_ap;
%Modellgrenze Vent_eff over vent_dur => vent_dur -> 0 => result not usefull
max_vent = (exp(vent_eff)/(exp(vent_eff) - 1) - 0.5) * P_add*vent_int/V_room;
max_death = P_add*vir_lif/V_room;
% Lifetime >> vent_int
if(vir_lif<100*vent_int)
    intervalls = floor(vir_lif/vent_int);
else
    intervalls = 100;
end
gw = -0.5 * vent_int*P_add/V_room;
for i=1:intervalls
    particles = P_add*exp(vent_eff)^(-i+1);
    gw = gw + vent_int*particles/V_room;
end

disp("Max calc: " + gw);
if(vir_lif<100*vent_int)
    lastMult = mod(vir_lif,vent_int)/vent_int + 0.5;
    gw = gw + lastMult * vent_int*P_add*exp(vent_eff)^(-intervalls-1)/V_room;
end


disp("Max calc: " + gw);

max2 = (1/(1/max_vent + 1/max_ap));
disp("Max all calc: " + max2);
disp("Max all calc: " + gw/max_vent);

hLine = time(1:end-vent_int)*0 + gw;

hold on  

ventilation_Factor = (vent_eff/vent_int + V_ap*ap_eff/V_room);

virusConcFunction = @(t) m_0 * (1 - exp(- ventilation_Factor * min(t,vir_lif)))/ventilation_Factor;
virusConcFunctionDeathLess = @(t) m_0 * 60 * (1 - exp(- ventilation_Factor * t))/ventilation_Factor;


ventilation_Factor = 60*(vent_eff*1.2/vent_int + V_ap*ap_eff/V_room);
virusConcFunction_Pos = @(t) m_0 * 60 * (1 - exp(- ventilation_Factor * min(t,vir_lif/60)))/ventilation_Factor;

ventilation_Factor = 60*(vent_eff*0.8/vent_int + V_ap*ap_eff/V_room);
virusConcFunction_Neg = @(t) m_0 * 60 * (1 - exp(- ventilation_Factor * min(t,vir_lif/60)))/ventilation_Factor;

%time = time:60;
plot(time/60,virusConcFunction(time));
%plot(time,virusConcFunctionDeathLess(time));

xlabel("Zeit in Stunden");
ylabel("Viruskonzentraton");


ventilation_Factor = 60*(vent_eff/vent_int + V_ap*ap_eff/V_room);
a = @(t) m_0 * 60 /ventilation_Factor * t;
b = @(t) m_0 * 60 * exp(- ventilation_Factor * t)/(ventilation_Factor*ventilation_Factor);
c = @(t) t * m_0 * 60 * exp(- ventilation_Factor * vir_lif/60)/(ventilation_Factor);
inhaledAmount = @(t) a(min(t,vir_lif/60)) + b(min(t,vir_lif/60)) + c(max(t - vir_lif/60,0)) - b(0) - c(0);
%inhaledAmountDeathLess = @(t) a(t) + b(t) - b(0);

%plot(time,inhaledAmount(time)/100);
%plot(time,inhaledAmountDeathLess(time)/100);
legend(["Simulation","Mittelwert der Simulation","Modellfunktion"]);
%legend(["Simulation","Mittelwert der Simulation","Modellfunktion","Modellfunktion(Deathless)","Summe","Summe(Deathless)"]);
hold off








