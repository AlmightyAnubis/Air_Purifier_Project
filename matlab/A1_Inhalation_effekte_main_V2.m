% Haupt-Programm zur Berechnung der Partikelkonzentration und der Partikelaufnahme
clear all;
close all;

% Doku Effekt des Lüftungsintervall bei 180min der Inhalierten
% gesamtpartikel: bei LI= 10 Minuten ist die Partikelzahl höher als bei 20 min da stimmt was nicht.

% Randbedingungen mit Parametervatiation (PV) der Effekte E1-E8 und
% Standardwerte
% ======================================

% Zeit [min]                : 0...|90|...180
Zeitdauer = 180; Zeitschritte = Zeitdauer * 60; % in s

% P1 Raumvolumen [m3]       : 100 |200| 300 400 500
PV(1,1:5)  = [50  100 200 300 400]; %in m3
SW(1,1)    = 200;
Faktor(1,1)= 1;
Name(1,1)  = {'V_Raum'};
Name(1,2)  = {'m^3'};
Name(1,3)  = {'Raumvolumen'};

% P2 Lüften-Intervall LI [min] : 10 |20| 30 40 50
PV(2,1:5)  = [10 20 30 40 50]* 60; %in s
SW(2,1)    = 20 * 60;
Faktor(2,1)= 1/60;
Name(2,1)  = {'LI'};
Name(2,2)  = {'min'};
Name(2,3)  = {'Lüftungsintervall'};

% P3 Lüften-Effizienz LE [%]: 10 30 |50| 70 90 (50 ist eher unrealistisch hoch, Air Exchange Part)
PV(3,1:5)  = [10 30 50 70 90]/100; %in %/100
SW(3,1)    = 50 / 100;
Faktor(3,1)= 100;
Name(3,1)  = {'LE'};
Name(3,2)  = {'% Luftaustausch'};
Name(3,3)  = {'Lüftungseffizienz'};

% P4 Lüften-Dauer LD [min]     : 1 2 |3| 4 5
PV(4,1:5)  = [1 2 3 4 5]*60; %in s
SW(4,1)    = 3 * 60;
Faktor(4,1)= 1/60;
Name(4,1)  = {'LD'};
Name(4,2)  = {'min'};
Name(4,3)  = {'Lüftungsdauer'};

% P5 RLF Volumenstrom [m3/h]   : 400 700 |1000| 1300 1600 (zwei Geräte mit je 800)
PV(5,1:5)  = [ 400 700 1000 1300 1600]/3600; %in s
SW(5,1)    = 1000 /3600;
Faktor(5,1)= 3600;
Name(5,1)  = {'V_RLF'};
Name(5,2)  = {'m3/h'};
Name(5,3)  = {'RLF Volumenstrom'};

% P6 Atem-Volumenstrom [L/min] : 3 |5| 7 9 11 Dieser Entspricht auch dem Volumenstrom der einatmenden Person.
PV(6,1:5)  = [3 5 7 9 11] /60/1000; %in m3/s
SW(6,1)    = 5 /60/1000;
Faktor(6,1)= 60*1000;
Name(6,1)  = {'Atem_V'};
Name(6,2)  = {'L/min'};
Name(6,3)  = {'Atem Volumenstrom'};

% P7 Atem-Partikel [P/cm3]     : |0.1| 1 2 3 4
PV(7,1:5)  = [0.1 1 2 3 4]* 1000000; %in Partikel/m3
SW(7,1)    = 0.1 * 1000000;
Faktor(7,1)= 1/1000000;
Name(7,1)  = {'Atem_P'};
Name(7,2)  = {'P/cm3'};
Name(7,3)  = {'Atem Partikel'};

% P8 Absterben der Viren [min]   : 30  60  |90|  120  150
PV(8,1:5)  = [20 40 60 80 100]* 60; % in s
SW(8,1)    = 90 *60;
Faktor(8,1)= 1/60;
Name(8,1)  = {'Viren_LD'};
Name(8,2)  = {'min'};
Name(8,3)  = {'Viren Lebensdauer'};

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

% Initialisierung der Ergebnismatizen
c_ges = zeros(8,5,7,Zeitschritte) ; PA_inhal_sum = zeros(8,5,7,Zeitschritte);
Zeile_Excel =4;
%Excel file abspeichern
filename = 'Ergebnisdaten.xlsx';

for Parameter = 1:8  % Effekte der Parameter P1-P8
    
    % Allgemeine Randbedingungen bzw. Standardwerte
    V_Raum = SW(1);
    
    LI = SW(2,1);
    LE = SW(3,1);
    LD = SW(4,1);
    
    V_RLF = SW(5,1);
    Atem_V = SW(6,1); Atem_P_m3 = SW(7,1);
    VS = SW(8,1);
    
    for Stufe = 1:5 % Jeder Parameter wird in 5 Stufen variiert
        
        if     Parameter ==1
            V_Raum = PV(1,Stufe);
        elseif Parameter ==2
            LI = PV(2,Stufe);
        elseif Parameter ==3
            LE = PV(3,Stufe);
        elseif Parameter ==4
            LD = PV(4,Stufe);
        elseif Parameter ==5
            V_RLF = PV(5,Stufe);
        elseif Parameter ==6
            Atem_V = PV(6,Stufe);
        elseif Parameter ==7
            Atem_P_m3 = PV(7,Stufe);
        elseif Parameter ==8
            VS = PV(8,Stufe);
        end
        %  die kontinuierlich zugeführten Partikel aus dem Atem der infizierten Person in[Partikel/s]
        PA_add = Atem_V * Atem_P_m3;
        c_add = PA_add / V_Raum; %in [Partikel/(s*m3)]
        
        [PA_inhal_sum(Parameter,Stufe,:,:), c_ges(Parameter,Stufe,:,:)] = A2_Faelle_aufrufen_V2(PA_add,c_add,V_Raum,LI,LE, LD, V_RLF,Atem_V, VS,Zeitschritte);
        
        % A3 Diagramme
        PA_inhal_sum_u(:,:)= PA_inhal_sum(Parameter,Stufe,:,:); c_ges_u(:,:)= c_ges(Parameter,Stufe,:,:);
        
        [a] = A3_Diagramme_speichern_V2(Parameter, Name{Parameter,1},Name{Parameter,2},Name{Parameter,3}, PV(Parameter,Stufe), Faktor(Parameter,1),PA_inhal_sum_u, c_ges_u,V_RLF,V_Raum,Atem_V, LE, LI/60,Zeitschritte,LD/60, VS/60);
        
        
        P_Wert = [V_Raum*Faktor(1,1),LI*Faktor(2,1),LE*Faktor(3,1), LD*Faktor(4,1), V_RLF*Faktor(5,1),Atem_V*Faktor(6,1), Atem_P_m3*Faktor(7,1),VS*Faktor(8,1)]; %Die Aktuellen Parameter/Faktoren für die Exceltabelle
        
        Matrix_c = horzcat(c_ges_u(:,2700)',c_ges_u(:,5400)',c_ges_u(:,8100)',c_ges_u(:,10800)'); % Die Konzentrationswerte bei 45, 90, 135 und 180Minuten Minuten als Zeilenvektor für das Excelfile
        Matrix_PA_inh = horzcat(PA_inhal_sum_u(:,2700)',PA_inhal_sum_u(:,5400)',PA_inhal_sum_u(:,8100)',PA_inhal_sum_u(:,10800)'); % Die P_inhal Werte bei bei 45, 90, 135 und 180Minuten Minuten als Zeilenvektor für das Excelfile
        
        Vektor = horzcat(P_Wert,Matrix_c,Matrix_PA_inh);
        %Position = Zeile; % Zeile in der die Daten geschrieben werden sollen
        % Abspeichern des Excelfiles
        writematrix(Vektor,filename,'Sheet',1,'Range',['C' num2str(Zeile_Excel) ]);
        
        Zeile_Excel =Zeile_Excel+1;
    end
    tx =[45 90 180];% zwelche Zeitschritte sollen verglichen werden
    % Effektdiagramme
    [a] = A4_Diagramme_effekt_speichern_V2(tx,Parameter, Name{Parameter,1},Name{Parameter,2},Name{Parameter,3}, PV(Parameter,:), Faktor(Parameter,1),PA_inhal_sum(Parameter,:,:,:), c_ges(Parameter,:,:,:),V_RLF,V_Raum,Atem_V, LE, LI/60,Zeitschritte,LD/60, VS/60);
    
    
    
    waitbar(Parameter/8); % Waitbar aktualisieren
end


% % Speichern
% % =========================================================================
%
%  %save([pwd '/Ergebniswerte'],'PA_inhal','PA_inhal_sum', 'PA_ges', 'c_ges','PA_sub','c_sub');
close(h)
%
%
% % Im paper wäre Effekt-Diagramme interessant:
% % Inhalierte Partikel vs. Lüftungsintervall
% % Inhalierte Partikel vs. Lüftungseffektivität
% % Inhalierte Partikel vs. Luftwechselrate des RLF
%
% % Alles auf "1" normiert, wobei 1 die Inhalierten Partikel ohne Lüften und
% % ohne RLF darstellen.
% % Wenn wir Aussagen über das Lüften machen wollen, sollten wir herausfinden
% % wieviel Prozent der Luft bei verschiedenen Lüftungsszenarien wirklich
% % ausgetauscht werden. (1 Fenster komplett auf für verschiedene Zeitdauern,
% % Mehrere Fenster angeklappt, mehrere Fenster auf ) natürlich ist das auch
% % von Umgebungsbedingungen abhängig (Wind, Temperatur usw.) aber alles geht
% % nicht.


