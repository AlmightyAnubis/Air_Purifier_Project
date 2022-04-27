%Generates function, that can calculate the particle concentration and inhaled particles at a certain time in sec.
%   [Partikel_inhaliert_summe,c_ges] = Iteration(Zeitschritte, PA_add,V_ap,Volume,V_br, VI, VD, VE, t_virus, t_vir_dis) 
%
%   PA_add      - Adding particle count from infected person(s)
%   V_ap        - Volumeflow of air purifier (0 if non exists)
%   ap_eff      - Filter Efficency of air purifier (0-1)
%   V_room      - Volume of the Room (m^3)
%   V_br        - Breathing volume (m^3/s)
%
%   VD          - Ventilation Durration (s)
%   VI          - Ventilation Intervall (s)
%   VE          - Ventilation Efficiency (Air exchange portion for the ventilation period, %, 0 if no ventilation)
%
%   t_virus     - Average Virus living duration(mu) (s) (inf for no virus deaths)
%   t_vir_dis   - Distribution of virus death(sigma) (0 - sharp peak else normal
%                 distribution)
%
%
%



function [Partikel_inhaliert_summe,c_ges] = FunctionBased(c_breath,V_ap,ap_eff,V_room,V_br, vent_int, vent_eff, vir_lif)

%% Calculation
P_add = c_breath*V_br;
m_0 = P_add / V_room;

ventilation_Factor = (vent_eff./vent_int + V_ap*ap_eff/V_room);

if(ventilation_Factor == 0)
    c_ges = @(t) m_0 * min(t,vir_lif);
    %% Integrals
    a = @(t) m_0 * 0.5 * t.^2;
    b = @(t) m_0 * vir_lif * t;
    Partikel_inhaliert_summe = @(t) (a(min(t,vir_lif)) + b(max(t - vir_lif,0)))* V_br;
else
    c_ges = @(t) m_0  * (1 - exp(- ventilation_Factor .* min(t,vir_lif)))./ventilation_Factor;
    %% Integrals
    a = @(t) m_0 /ventilation_Factor * t;
    b = @(t) m_0 * exp(- ventilation_Factor * t)/(ventilation_Factor*ventilation_Factor);
    c = @(t) t * m_0 * exp(- ventilation_Factor * vir_lif)/(ventilation_Factor);
    Partikel_inhaliert_summe = @(t) (a(t) + b(min(t,vir_lif)) - c(max(t - vir_lif,0)) - b(0) - c(0)) * V_br;
end












