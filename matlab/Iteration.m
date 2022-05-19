%ITERATION  calculates particles and concentration
%   [Partikel_inhaliert_summe,c_ges] = Iteration(Zeitschritte, PA_add,V_ap,Volume,V_br, VI, VD, VE, t_virus, t_vir_dis) calculates the particles and concentrations.
%
%   PA_add      - Adding particle count from infected person(s)
%   V_ap        - Volumeflow of air purifier (0 if non exists)
%   ap_eff      - Filter Efficency of air purifier (0-1)
%   Volume      - Volume of the Room (m^3)
%   V_br        - Breathing volume (m^3/s)
%
%   VD          - Ventilation Durration (s)
%   VI          - Ventilation Intervall (s)
%   AER          - Air exchange rate (Air exchange portion for 1 hour, %, 0 if no ventilation)
%
%   t_virus     - Average Virus living duration(mu) (s) (inf for no virus deaths)
%   t_vir_dis   - Distribution of virus death(sigma) (0 - sharp peak else normal
%                 distribution)
%
%
%



function [Partikel_inhaliert_summe,c_ges] = Iteration(Zeitschritte, PA_add,V_ap,ap_eff,Volume,V_br, VI, VD, AER, t_virus, t_vir_dis)
    
    
    
    c_add = PA_add/Volume;
    
    % Startwerte für die Berechnung
    PA_ges = zeros (1,Zeitschritte); % Gesamtpartikelanzahl im Raum
    c_ges  = zeros (1,Zeitschritte); % Mittlere Partikel-Konzentration im Raum
    Partikel_inhaliert = zeros (1,Zeitschritte); % Partikel die eine Person im aktuellen Zeitschritt inhaliert
    Partikel_inhaliert_summe = zeros (1,Zeitschritte); % Summe der inhalierten Partikel

    PA_VS = PA_add * ones(1,Zeitschritte); % Vieren die Sterben (Die Startanzahl ist mit PA_add bekannt, diese Anzhal reduziert nach ihrem Eintrag von Sekunde zu Sekunde. )
    c_VS = c_add * ones(1,Zeitschritte);  % Verringerung der Vierenkonzentration aufgrund des Virensterbens. (Die Startkonzentration ist mit c_add bekannt, diese Anzhal reduziert nach ihrem Eintrag von Sekunde zu Sekunde.
    
    % Iterative Berechnung der Entwicklung
    % 1. Partikelanzahl 2. Partikel-Konzentration 3. Partikelinhalation
    % =========================================================================
    
    % erster Zeitschritt
    
    % Gesamtpartikelanzahl im Raum in [Partikel]
    PA_ges (1)= PA_add;
    
    % Mittlere Partikelkonzentration im Raum in [Partikel/m3]
    c_ges (1) = c_add;
    c_ges_neu (1) = c_add;
    
    % Partikel die eine Person im aktuellen Zeitschritt inhaliert
    Partikel_inhaliert (1) = c_ges(1) *  V_br;
    % Aufsummation der inhalierten Partikel
    Partikel_inhaliert_summe (1) = 0 + Partikel_inhaliert (1);  % hier kann nochmal kontrolliert werden, ob
    
    
    
    % Kontrollvariable
    % nachfolgende Zeitschritte
    t_start = 1;
    for t=2:Zeitschritte
        % Es sterben nur die Viren die zum Zeitpunkt t-VS eingetragen wurden.
        % Von den zu einem Zeitpunkt eingetragenen Viren werden aber zu jedem Zeitschritt welche herausgefiltern
        % und zu den Lüftungsintervallen viele aus dem Raum getragen. Deswegen
        % muss in jedem Zeitschritt die vom Ursprungseintrag (PA_add) noch vorhandenen Viren neu bestimmt werden, wieviel Viren der
        % eingetragenen Menge noch anwesend sind.
        
        %PA_VS - Virusmenge aus der Zeit
        %Relevante time for virus death (all dead -> no analyze needed)
        
        
        
        %% Effect Air Purifier
        PA_VS (1:t)= PA_VS(1:t)  - V_ap * ap_eff * c_VS (1:t);
        
        
        %% Effect ventilation
        % Es wird gerade gelüftet.
        timeStep = max(1,floor(t/VI));
        if (timeStep * VI <= t && t <(timeStep * VI+VD))
            % Viruspartikel durch Lüften ausgetragen und durch
            % RLF entfernt
            PA_VS (1:t)= PA_VS(1:t) * (1-AER/3600) ;
        end
        
        %% Effect Virus Death
        PA_VS_step = PA_VS (1:t);
        if(t_virus ~= inf)
            % deathdist = 1;
            %Deathdistribution for virus
            if(t_vir_dis ~= 0)
                deathdist = integratedGaussDist(t_vir_dis,t_virus,t_start,t);
                deathdist = flip(deathdist);
            else
                if(t>t_virus)
                    deathdist = [ones(t-t_virus-t_start+1,1); zeros(t_virus,1)];
                else
                    deathdist = zeros(t-t_start+1,1);
                end
            end
            PA_VS_step = [zeros(1,t_start-1) PA_VS(t_start:t).* (1-deathdist')];
            
        end
        
        t_start = max(1,length(PA_VS_step(PA_VS_step<10^-5)));
        PA_ges(t) = sum(PA_VS_step);
        c_ges(t) = PA_ges(t)/Volume;
        c_VS (1:t) = PA_VS_step(1:t)/Volume;
        
        
        if(mod(t,600)==0 && 1==1)
            bar((1:t)/60,PA_VS_step);
            drawnow
        end
        
        % Partikel die eine Person im aktuellen Zeitschritt inhaliert
        Partikel_inhaliert (t) = c_ges(t) *  V_br;
        % Aufsummation der inhalierten Partikel
        Partikel_inhaliert_summe (t) = Partikel_inhaliert_summe (t-1) + Partikel_inhaliert (t);
        
    end