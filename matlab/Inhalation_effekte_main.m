% Haupt-Programm zur Berechnung der Partikelkonzentration und der Partikelaufnahme
clear all;
close all;
 
% Randbedingungen mit Parametervatiation 
% ======================================

% Zeit [min]                : 0...|90|...180
% V1 Raumvolumen [m3]          : 100 |200| 300 400 500
% V2 Atem-Volumenstrom [L/min] : 3 |5| 7 9 11
% V3 Atem-Partikel [P/cm3]     : |0.1| 1 2 3 4 

% V4 Lüften-Intervall LI [min] : 10 |20| 30 40 50
% V5 Lüften-Effizienz LE [%/100]: 10 30 |50| 70 90 (50 ist eher unrealistisch hoch)
% V6 Lüften-Dauer LD [min]     : 1 2 |3| 4 5 

% V7 RLF Volumenstrom [m3/h]   : 400 700 |1000| 1300 1600 (zwei Geräte mit je 800)
% V8 Absterben der Viren [h]   : 30  60  |90|  120  150 

% Die Variation erfolgt in 8 Schleifen die nacheinander abgearbeitet
% werden. Berechnet werden die Zeitverläuft für jede Parametervariation
% Das Speichern erfolgt in Weler Form? 5^8 = 390625 Versuche, wenn alle abgefahren
% werden.(hier sollten immer nur die PA_inhal_sum und c_ges zu den Zeiten 45 90 135 180 
% in einem cell in der die RB'S mit angegeben sind oder einer Matrix in dem die ersten 
% Werte die RB's sind) 
% Und wenn nur die Hauptwerte abgefahren werden 8*5=40 Rechnungen können
% die Zeitverläufe gespeichert werden.
% Kontrolle ob die Lüftungsphasen und das Absterbe nicht gleichzeitig
% liegen wegen While schleifen.
% Es gibt je 7 Fälle.
% Abspeichern c_ges = zeros(7,5,Zeitschritte) ; PA_inhal_sum = zeros(7,5,Zeitschritte);
% In den Zeilen die 5 Variationswerte in den Spalten die Zeitschritte

h = waitbar(0,'Auswertung, Bitte warten...');           % Waitbar
% 1 Nur Hauptwerte berechnen und für die Diagramme abspeichern
% ============================================================

% V1 Raumvolumen [m3]: 100 |200| 300 400 500 ============================================================== 
V_RLF = 1000/3600; 
Atem_Partikel_cm3 = 0.1; 
Atem_Partikel_m3 = Atem_Partikel_cm3 * 1000000; 
Atem_V_L_min = 5; 
Atem_V = Atem_V_L_min /60 /1000; 
LI_min = 20; 
LI = LI_min *60;
LE = 0.5; 
LD_min = 3; 
LD = LD_min *60; 
VS_min = 90; 
VS = VS_min *60; 
Zeitdauer = 90; 
Zeitschritte = Zeitdauer * 60;

c_ges = zeros(5,7,Zeitschritte) ; PA_inhal_sum = zeros(5,7,Zeitschritte);

for R = [100 200 300 400 500]

% Fall 1 keine Aktion
[PA_inhal_sum(1,1,:), c_ges(1,1,:)] = Iteration_VV1(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte);
% Fall 2 Lüften, kein RLF
[PA_inhal_sum(1,2,:), c_ges(1,2,:)] = Iteration_F2(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte,LD);
% Fall 3 kein Lüften, RLF an,  
[PA_inhal_sum(1,3,:), c_ges(1,3,:)] = Iteration_F3(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte);
% Fall 4 Lüften, RLF an
[PA_inhal_sum(1,4,:), c_ges(1,4,:)] = Iteration_F4(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte,LD); 
% Fall 5  Absterben der Viren nach VS (in s) (kein Lüften, kein RLF)
[PA_inhal_sum(1,5,:), c_ges(1,5,:)] = Iteration_F5(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte, VS);
% Fall 6 Lüften, RLF aus, Absterben der Viren
[PA_inhal_sum(1,6,:), c_ges(1,6,:)] = Iteration_F6(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte, LD, VS);
% Fall 7 Lüften, RLF an, Absterben der Viren
[PA_inhal_sum(1,7,:), c_ges(1,7,:)] = Iteration_F7(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte,LD, VS);

end

        waitbar(1/8); % Waitbar aktualisieren
% V2 Atem-Volumenstrom [L/min] : 3 |5| 7 9 11 ============================================================
        waitbar(2/7); % Waitbar aktualisieren
% V3 Atem-Partikel [P/cm3]     : |0.1| 1 2 3 4 ===========================================================
        waitbar(3/8); % Waitbar aktualisieren
% V4 Lüften-Intervall LI [min] : 10 |20| 30 40 50 ========================================================
        waitbar(4/8); % Waitbar aktualisieren
% V5 Lüften-Effizienz LE [%/100]: 10 30 |50| 70 90 (50 ist eher unrealistisch hoch)=======================
        waitbar(5/8); % Waitbar aktualisieren
% V6 Lüften-Dauer LD [min]     : 1 2 |3| 4 5 =============================================================
        waitbar(6/8); % Waitbar aktualisieren
% V7 RLF Volumenstrom [m3/h]   : 400 700 |1000| 1300 1600 (zwei Geräte mit je 800)========================
        waitbar(7/8); % Waitbar aktualisieren
% V8 Absterben der Viren [h]   : 0.5  1  |1.5|  2  2.5 ===================================================
        waitbar(8/8); % Waitbar aktualisieren

% =========================================================================    
% Berechnung
% =========================================================================
 
% Partikelstrom aus dem Atem der infizierten Person in [Partikel/s]
Atem_Patikelstrom = Atem_V * Atem_Partikel_m3; 
 
% Zur übersichtlicheren Berechnung der kontinuierliche zugeführten Partikel in[Partikel/s]
PA_add = Atem_Patikelstrom;
% und die kontinuierlich zugefügte mittlere Partikelkonzentration
% bezogen auf das Raumvolumen in [Partikel/(s*m3)]
c_add = Atem_Patikelstrom / Raumvolumen; % Mittlere Konzentrationswachstum in Partikel/m3/Sekunde pro Sekunde durch Ausatemluft 1 Partikel/cm3 bei 5 Liter /min (0.00008333m3/s) -->83.333cm3/s -->83 Partikel pro Sekunde - bezogen auf das Raumvolumen (Daten aus: Lelieveld 2020 Tabelle 1) 
 
% Erstellen von leeren Vektoren in denen dann nacheinander die berechneten Daten
% geschrieben werden. Die Zeilen 1 bis 6 stehen für die Fälle 1 bis 6 und
% in den Spalten werden die Werte für den jeweiligen Zeitschritt
% abgespeichert. 
PA_inhal = zeros (7,Zeitschritte); % Partikel die eine Person im aktuellen Zeitschritt inhaliert
PA_inhal_sum = zeros (7,Zeitschritte); % Summe der inhalierten Partikel
PA_ges = zeros (7,Zeitschritte); % Gesamtpartikelanzahl im Raum
c_ges  = zeros (7,Zeitschritte); % Mittlere Partikel-Konzentration im Raum
PA_sub = zeros (7,Zeitschritte);  % Partikelanzahl die vom RLF entfernt werden
c_sub = zeros (7,Zeitschritte);  % Verringerung der Partikelkonzentration im Raum durch den RLF in [Partikel/m3]




% Fall 1 kein Lüften, kein RLF
% Aufruf des Programmes zur Iteration der Ausgabewerte
[PA_inhal_sum(1,:),PA_inhal(1,:),PA_ges(1,:), c_ges(1,:)] = Iteration_F1(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte);
        


% Variation verschiedener Lüftungsvarientan
% Fall 2 Lüften, kein RLF
% Aufruf des Programmes zur Iteration der Ausgabewerte

%========================================================================
% Es wird so gelüftet, dass nach LD nur noch (1-LE)Prozent der
% ursprünglichen Partikel im Raum sind. Dadurch entspricht das LE einem
% vorgegebenen Partikelreduktion.
% [PA_inhal_sum(2,:),PA_inhal(2,:),PA_ges(2,:), c_ges(2,:)] = Iteration_F2_V3(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte,LD);

% Der Realistischere Fall: Es wird bei Lüften von einem Luftaustausch (LE) ausgegangen. Über die Lüftungsdauer LD
% werden auch (1-LE)Prozent der Luft ausgewechselt. So kann es sein das bei einem LE von 50% hinterher noch mehr als 50% der Partikel im Raum vorliegen Es kann der Fall auftreten, das während
% des Lüftens Partikel zugegeben werden, dann ist es nöglich, dass die
% Partikelanzahl trotz Lüftens nicht abnimmt. 
[PA_inhal_sum(2,:),PA_inhal(2,:),PA_ges(2,:), c_ges(2,:)] = Iteration_F2(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte,LD);

%=====================================



 
% Fall 3 kein Lüften, RLF an,  
  [PA_inhal_sum(3,:),PA_inhal(3,:),PA_ges(3,:),PA_sub(3,:), c_ges(3,:), c_sub(3,:)] = Iteration_F3(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte);


  
% Fall 4 Lüften, RLF an
  [PA_inhal_sum(4,:),PA_inhal(4,:),PA_ges(4,:),PA_sub(4,:), c_ges(4,:), c_sub(4,:)] = Iteration_F4(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte,LD);
 

  
% Fall 5  Absterben der Viren nach VS (in s) (kein Lüften, kein RLF)
 [PA_inhal_sum(5,:),PA_inhal(5,:),PA_ges(5,:),PA_sub(5,:), c_ges(5,:), c_sub(5,:)] = Iteration_F5(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte, VS);
 

  
% Fall 6 Lüften, RLF aus, Absterben der Viren
[PA_inhal_sum(6,:),PA_inhal(6,:),PA_ges(6,:),PA_sub(6,:), c_ges(6,:), c_sub(6,:)] = Iteration_F6(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte, LD, VS);

          
% Fall 7 Lüften, RLF an, Absterben der Viren
  [PA_inhal_sum(7,:),PA_inhal(7,:),PA_ges(7,:),PA_sub(7,:), c_ges(7,:), c_sub(7,:)] = Iteration_F7(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte,LD, VS);
 
 
% Abbildungen 

Farbe={'k' 'b' 'g' 'r' 'k--' 'b--' 'g--'};

    figure (1)
    hold on
    for z= 1:7
    plot (1:Zeitschritte,PA_inhal_sum(z,:),Farbe{1,z})
    end
    xticks([0 900 1800 2700 3600 4500 5400]);
    xticklabels({'0','15','30','45','60','75','90'});
    xlabel('Zeit in min'); 
    ylabel('Inhalierte Partikel akkumuliert');
    legend ({'geschlossener Raum', ['nur Lüften dt= ' num2str(LI_min) ', LE= ' num2str(LE)], ...
            ['RLF an, LWR',num2str(round(V_RLF*3600/Raumvolumen*10)/10), 'pro h'], 'Lüften + RLF', ...
            ['nur Absterben der Viren nach dT=' num2str(VS_min)], 'Lüften + Absterben','Lüften + RLF + Absterben'}...
            ,'Location','northwest');
    box on
    grid on
    hold off
    
    savefig([pwd '/Diagramme/' 'PA_inhal_sum.fig'])
    print('-f1',[pwd '/Diagramme/' 'PA_inhal_sum'],'-dpng')
 
  
    figure (2)
    hold on
    for z= 1:7
    plot (1:Zeitschritte,PA_inhal(z,:),Farbe{1,z})
    end
    xticks([0 900 1800 2700 3600 4500 5400]);
    xticklabels({'0','15','30','45','60','75','90'});
    xlabel('Zeit in min'); 
    ylabel('Zum aktuellen Zeitschritt inhalierte Partikel');
    legend ({'geschlossener Raum', ['nur Lüften dt= ' num2str(LI_min) ', LE= ' num2str(LE)], ...
            ['RLF an, LWR',num2str(round(V_RLF*3600/Raumvolumen*10)/10), 'pro h'], 'Lüften + RLF', ...
            ['nur Absterben der Viren nach dT=' num2str(VS_min)], 'Lüften + Absterben','Lüften + RLF + Absterben'}...
            ,'Location','northwest');
    box on
    grid on    
    hold off
    savefig([pwd '/Diagramme/' 'PA_inhal.fig'])
    print('-f2',[pwd '/Diagramme/' 'PA_inhal'],'-dpng');
    
    figure (3)
    hold on
    for z= 1:7
    plot (1:Zeitschritte,PA_ges(z,:),Farbe{1,z})
    end
    xticks([0 900 1800 2700 3600 4500 5400]);
    xticklabels({'0','15','30','45','60','75','90'});
    xlabel('Zeit in min'); 
    ylabel('Partikelanzahl im Raum');
    legend ({'geschlossener Raum', ['nur Lüften dt= ' num2str(LI_min) ', LE= ' num2str(LE)], ...
            ['RLF an, LWR',num2str(round(V_RLF*3600/Raumvolumen*10)/10), 'pro h'], 'Lüften + RLF', ...
            ['nur Absterben der Viren nach dT=' num2str(VS_min)], 'Lüften + Absterben','Lüften + RLF + Absterben'}...
            ,'Location','northwest');
    box on
    grid on    
    hold off
    savefig([pwd '/Diagramme/' 'PA_ges.fig'])
    print('-f3',[pwd '/Diagramme/' 'PA_ges'],'-dpng');
    
    figure (4)
    hold on
    for z= 1:7
    plot (1:Zeitschritte,c_ges(z,:),Farbe{1,z})
    end
    xticks([0 900 1800 2700 3600 4500 5400]);
    xticklabels({'0','15','30','45','60','75','90'});
    xlabel('Zeit in min'); 
    ylabel('Mittlere Konzentration im Raum');
    legend ({'geschlossener Raum', ['nur Lüften dt= ' num2str(LI_min) ', LE= ' num2str(LE)], ...
            ['RLF an, LWR',num2str(round(V_RLF*3600/Raumvolumen*10)/10), 'pro h'], 'Lüften + RLF', ...
            ['nur Absterben der Viren nach dT=' num2str(VS_min)], 'Lüften + Absterben','Lüften + RLF + Absterben'}...
            ,'Location','northwest');
    box on
    grid on    
    hold off
    savefig([pwd '/Diagramme/' 'c_ges.fig'])
    print('-f4',[pwd '/Diagramme/' 'c_ges'],'-dpng');
    
    
% Speichern
% =========================================================================

 save([pwd '/Ergebniswerte'],'PA_inhal','PA_inhal_sum', 'PA_ges', 'c_ges','PA_sub','c_sub');
delete(h)
% % Startwerte für die Berechnung
% % PA_ist und c_ist sind eigentlich nur für den ersten Berechnungsschritt
% % notwendig, danach könnte man mit den PA_ges und c_ges vom jeweils
% % vorhergehenden Zeitschritt rechnen. 
%  PA_ist = zeros (1,Zeitschritte); % die aktulle Partikelanzahl im Raum
%  c_ist  = zeros (1,Zeitschritte); % die aktuelle mittlere Partikel-Konzentration 
%  
% % Fall 1: nur RLF, keine Lüftung
% % Iterative Berechnung der Entwicklung 
% % 1. Partikelanzahl 2. Partikel-Konzentration 3. Partikelaufnahme
% % =========================================================================
% for t=1:Zeitschritte
%     
%      % Partikelanzahl die vom RLF entfernt werden
%      PA_sub (t) = V_RLF * c_ist (t);
%      % Gesamtpartikelanzahl im Raum
%      PA_ges (t)= PA_ist(t)  + PA_add - PA_sub(t); 
%         % Partikelanzahl für den nächsten Rechenschritt
%         PA_ist(t+1) = PA_ges (t); % auch = c_ist*Raumvolumen
%     
%     % Verringerung der Partikelkonzentration im Raum durch den RLF in [Partikel/m3]
%     c_sub(t) = c_ist(t)*V_RLF/Raumvolumen; 
%     % Mittlere Partikelkonzentration im Raum in [Partikel/m3]
%     c_ges (t) = c_ist(t) + c_add - c_sub(t); 
%         % Partikelkonzentration für den nächsten Rechenschritt
%         c_ist (t+1) = c_ges (t);
%     
%     % Partikel die eine Person im aktuellen Zeitschritt inhaliert
%     Partikel_inhaliert (t) = c_ges(t) *  Atem_V;
%     % Aufsummation der inhalierten Partikel
%     if t>1
%     Partikel_inhaliert_summe (t) = Partikel_inhaliert_summe (t-1) + Partikel_inhaliert (t);    
%     else
%        Partikel_inhaliert_summe (t) = 0 + Partikel_inhaliert (t);  
%     end
%     
% end
%  
%         % Zeichnen von Diagrammen
%         figure (1)
%         hold on
%         plot (1:Zeitschritte,c_ges,'r')
%         %figure (2)
%         %plot (1:Zeitschritte, c_add,'s',1:Zeitschritte,c_sub,'r')
%         %figure (3)
%         %plot (1:Zeitschritte,PA_ges,'b')
%         %figure (4)
%         %plot (1:Zeitschritte, PA_add,'s',1:Zeitschritte,PA_sub,'r')
%         figure (5)
%         hold on
%         plot (1:Zeitschritte,Partikel_inhaliert_summe,'r')
%  
% % Startwerte für die Berechnung
% % PA_ist und c_ist sind eigentlich nur für den ersten Berechnungsschritt
% % notwendig, danach könnte man mit den PA_ges und c_ges vom jeweils
% % vorhergehenden Zeitschritt rechnen. 
%  PA_ist = zeros (1,Zeitschritte); % die aktullle Partikelanzahl im Raum
%  c_ist  = zeros (1,Zeitschritte); % die aktuelle mittlere Partikel-Konzentration 
% % 
%  
% % Fall 2: nur Lüftung
% % Iterative Berechnung der Entwicklung 
% % 1. Partikelanzahl 2. Partikel-Konzentration 3. Partikelaufnahme
% % =========================================================================
%  
% for t=1:Zeitschritte
%     
%     if round(t/LI) ==(t/LI) % Liegt gerade ein Zeitschritt in dem Gelüftet wird vor?
%     % Gesamtpartikelanzahl im Raum in [Partikel]
%     PA_ges (t)= (PA_ist(t)  + PA_add) * (1-LE); 
%     else
%     PA_ges (t)= PA_ist(t)  + PA_add; % Einfache Summation, zwischen den Lüftungsphasen
%     end
%         % Partikelanzahl für den nächsten Rechenschritt
%         PA_ist(t+1) = PA_ges (t); % auch = c_ist*Raumvolumen
%     
%      if round(t/LI) ==(t/LI) % Liegt gerade ein Zeitschritt in dem gelüftet wird vor?
%         % Mittlere Partikelkonzentration im Raum in [Partikel/m3]
%         c_ges (t) = (c_ist(t) + c_add) * (1-LE); %
%      else
%         c_ges (t) = c_ist(t) + c_add; % Gesamtkonzentration Partikel/m3
%         % Partikelkonzentration für den nächsten Rechenschritt
%      end
%              c_ist (t+1) = c_ges (t);
%      
%     % Partikel die eine Person im aktuellen Zeitschritt inhaliert
%     Partikel_inhaliert (t) = c_ges(t) *  Atem_V;
%     % Aufsummation der inhalierten Partikel
%     if t>1
%     Partikel_inhaliert_summe (t) = Partikel_inhaliert_summe (t-1) + Partikel_inhaliert (t);    
%     else
%        Partikel_inhaliert_summe (t) = 0 + Partikel_inhaliert (t);  
%     end
%     
% end
%  
%             % Zeichnen von Diagrammen
%             figure (1)
%             plot (1:Zeitschritte,c_ges,'b')
%  
%             %figure (3)
%             %plot (1:Zeitschritte,PA_ges,'b')
%  
%             figure (5)
%             plot (1:Zeitschritte,Partikel_inhaliert_summe,'b')
%  
% % Startwerte für die Berechnung
% % PA_ist und c_ist sind eigentlich nur für den ersten Berechnungsschritt
% % notwendig, danach könnte man mit den PA_ges und c_ges vom jeweils
% % vorhergehenden Zeitschritt rechnen. 
%  PA_ist = zeros (1,Zeitschritte); % die aktulle Partikelanzahl im Raum
%  c_ist  = zeros (1,Zeitschritte); % die aktuelle mittlere Partikel-Konzentration 
%  
%             
% Fall 3: RLF + Lüften
% Iterative Berechnung der Entwicklung 
% 1. Partikelanzahl 2. Partikel-Konzentration 3. Partikelaufnahme
% =========================================================================
%  
% for t=1:Zeitschritte
%     
%      % Partikelanzahl die vom RLF entfernt werden
%      PA_sub (t) = V_RLF * c_ist (t);
%     
%     if round(t/LI) ==(t/LI) % Liegt gerade ein Zeitschritt in dem Gelüftet wird vor?
%     % Gesamtpartikelanzahl im Raum in [Partikel]
%     PA_ges (t)= (PA_ist(t)  + PA_add) * (1-LE)  - PA_sub(t); 
%     else
%     PA_ges (t)= PA_ist(t)  + PA_add  - PA_sub(t); % Einfache Summation, zwischen den Lüftungsphasen
%     end
%         % Partikelanzahl für den nächsten Rechenschritt
%         PA_ist(t+1) = PA_ges (t); % auch = c_ist*Raumvolumen
%     
%     % Verringerung der Partikelkonzentration im Raum durch den RLF in [Partikel/m3]
%     c_sub(t) = c_ist(t)*V_RLF/Raumvolumen;  
%         
%      if round(t/LI) ==(t/LI) % Liegt gerade ein Zeitschritt in dem gelüftet wird vor?
%         % Mittlere Partikelkonzentration im Raum in [Partikel/m3]
%         c_ges (t) = (c_ist(t) + c_add) * (1-LE)- c_sub(t); %
%      else
%         c_ges (t) = c_ist(t) + c_add - c_sub(t); 
%      end
%             % Partikelkonzentration für den nächsten Rechenschritt
%             c_ist (t+1) = c_ges (t);
%      
%     % Partikel die eine Person im aktuellen Zeitschritt inhaliert
%     Partikel_inhaliert (t) = c_ges(t) *  Atem_V;
%     % Aufsummation der inhalierten Partikel
%     if t>1
%     Partikel_inhaliert_summe (t) = Partikel_inhaliert_summe (t-1) + Partikel_inhaliert (t);    
%     else
%        Partikel_inhaliert_summe (t) = 0 + Partikel_inhaliert (t);  
%     end
%     
% end
%  
%  
%             % Zeichnen von Diagrammen
%             figure (1)
%             plot (1:Zeitschritte,c_ges,'g')
%             legend ('RLF an', ['Lüften LI= ', num2str(LI_min), ', LE= ', num2str(LE)], 'RLF+Lüften')
%             xlabel('Zeit in s') 
%             ylabel('Konzentration in Partikel/m3')
%             %figure (3)
%             %plot (1:Zeitschritte,PA_ges,'b')
%  
%             figure (5)
%             plot (1:Zeitschritte,Partikel_inhaliert_summe,'g')
%             legend ('RLF an', ['Lüften LI= ', num2str(LI_min), ', LE= ', num2str(LE)], 'RLF+Lüften')
%             xlabel('Zeit in s') 
%             ylabel('Inhalierte Partikel')
%            
            
% Im paper wäre Effekt-Diagramme interessant:
% Inhalierte Partikel vs. Lüftungsintervall
% Inhalierte Partikel vs. Lüftungseffektivität
% Inhalierte Partikel vs. Luftwechselrate des RLF
 
% Alles auf "1" normiert, wobei 1 die Inhalierten Partikel ohne Lüften und
% ohne RLF darstellen. 
% Wenn wir Aussagen über das Lüften machen wollen, sollten wir herausfinden
% wieviel Prozent der Luft bei verschiedenen Lüftungsszenarien wirklich
% ausgetauscht werden. (1 Fenster komplett auf für verschiedene Zeitdauern,
% Mehrere Fenster angeklappt, mehrere Fenster auf ) natürlich ist das auch
% von Umgebungsbedingungen abhängig (Wind, Temperatur usw.) aber alles geht
% nicht.
 
%figure (11)
%semilogy (1:Zeitschritte,c_ges,'g')
  


