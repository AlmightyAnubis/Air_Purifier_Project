% Programm zur Berechnung der Inhalierten Partikel für den Fall 7 "Lüften, RLF an, Absterben der Viren"

function [Partikel_inhaliert_summe,c_ges] = Iteration_F7(PA_add,c_add,V_RLF,Raumvolumen,Atem_V, LE, LI,Zeitschritte, LD, VS)
    
    
    
    % Startwerte für die Berechnung (Die vorherigen Initialisierung der Vektoren beschleunigt die Berechnung in der for-Schleife ein wenig.)
    
    PA_ges = zeros (1,Zeitschritte); % Gesamtpartikelanzahl im Raum
    c_ges  = zeros (1,Zeitschritte); % Mittlere Partikel-Konzentration im Raum
    Partikel_inhaliert = zeros (1,Zeitschritte); % Partikel die eine Person im aktuellen Zeitschritt inhaliert
    Partikel_inhaliert_summe = zeros (1,Zeitschritte); % Summe der inhalierten Partikel
    PA_sub = zeros (1,Zeitschritte);  % Partikelanzahl die vom RLF entfernt werden
    c_sub = zeros (1,Zeitschritte);  % Verringerung der Partikelkonzentration im Raum durch den RLF in [Partikel/m3]
    PA_VS = PA_add * ones(1,Zeitschritte); % Vieren die Sterben (Die Startanzahl ist mit PA_add bekannt, diese Anzhal reduziert nach ihrem Eintrag von Sekunde zu Sekunde. )
    c_VS = c_add * ones(1,Zeitschritte);  % Verringerung der Vierenkonzentration aufgrund des Virensterbe. (Die Startkonzentration ist mit c_add bekannt, diese Anzhal reduziert nach ihrem Eintrag von Sekunde zu Sekunde.
    
    % Fall 7: "Lüften, RLF an, Absterben der Viren"
    % Iterative Berechnung der Entwicklung
    % 1. Partikelanzahl 2. Partikel-Konzentration 3. Partikelinhalation
    % =========================================================================
    
    % erster Zeitschritt
    
    % Gesamtpartikelanzahl im Raum in [Partikel]
    PA_ges (1)= PA_add;
    
    % Mittlere Partikelkonzentration im Raum in [Partikel/m3]
    c_ges (1) = c_add;
    
    % Partikel die eine Person im aktuellen Zeitschritt inhaliert
    Partikel_inhaliert (1) = c_ges(1) *  Atem_V;
    % Aufsummation der inhalierten Partikel
    Partikel_inhaliert_summe (1) = 0 + Partikel_inhaliert (1);  % hier kann nochmal kontrolliert werden, ob
    
    
    % nachfolgende Zeitschritte
    t=2;
    b=1;% Kontrollvariable
    while t<=Zeitschritte
        
        % Es sterben nur die Viren die zum Zeitpunkt t-VS eingetragen wurden.
        % Von den zu einem Zeitpunkt eingetragenen Viren werden aber zu
        % jedem Zeitschritt welche herausgefiltert
        % und zu den Lüftungsintervallen viele aus dem Raum getragen. Deswegen
        % muss in jedem Zeitschritt die vom Ursprungseintrag (PA_add) noch vorhandenen Viren neu bestimmt werden, wieviel Viren der
        % eingetragenen Menge noch anwesend sind.
        for i=1:t
            
            % Es wird gerade gelüftet.
            if (LI <= t && t <(LI+LD)) || (2*LI <= t && t<(2*LI+LD)) ||  (3*LI <= t && t <(3*LI+LD)) || (4*LI <= t && t <(4*LI+LD))|| (5*LI <= t && t <(5*LI+LD)) ||  (6*LI <= t && t <(6*LI+LD)) || (7*LI <= t && t <(7*LI+LD))|| (8*LI <= t && t <(8*LI+LD))|| (9*LI <= t && t <(9*LI+LD)) ||  (10*LI <= t && t <(10*LI+LD)) || (11*LI <= t && t <(11*LI+LD))|| (12*LI <= t && t<(12*LI+LD)) ||  (13*LI <= t && t <(13*LI+LD)) || (14*LI <= t && t <(14*LI+LD))|| (15*LI <= t && t <(15*LI+LD)) ||  (16*LI <= t && t <(16*LI+LD)) || (17*LI <= t && t <(17*LI+LD))
                % Viruspartikel durch Lüften ausgetragen und durch
                % RLF entfernt
                PA_VS (i)= (PA_VS(i) - V_RLF * c_VS (i)) * (1-LE/LD) ;
                
                c_VS (i) = (c_VS(i) - c_VS(i)* V_RLF/Raumvolumen) * (1-LE/LD);
            else
                % Es wird gerade nicht gelüftet.
                % Viruspartikel durch RLF entfernt
                PA_VS (i)= PA_VS(i)  - V_RLF * c_VS (i); % Einfache Summation, zwischen den Lüftungsphasen
                c_VS (i) = c_VS(i)  - c_VS(i)* V_RLF/Raumvolumen;
            end
        end
        
        
        if t<VS+1 % Es sterben noch keine Vieren ab (+1 weil das Absterben erst nach der Lüftung berücksichtigt werden soll.)
            
            %Hier gehe ich immer weiter mit der Zeit ohne dass vieren sterben.
            % Liegt gerade ein Zeitschritt in dem gelüftet wird vor?
            while (LI <= t && t <(LI+LD)) || (2*LI <= t && t<(2*LI+LD)) ||  (3*LI <= t && t <(3*LI+LD)) || (4*LI <= t && t <(4*LI+LD))|| (5*LI <= t && t <(5*LI+LD)) ||  (6*LI <= t && t <(6*LI+LD)) || (7*LI <= t && t <(7*LI+LD))|| (8*LI <= t && t <(8*LI+LD))|| (9*LI <= t && t <(9*LI+LD)) ||  (10*LI <= t && t <(10*LI+LD)) || (11*LI <= t && t <(11*LI+LD))|| (12*LI <= t && t<(12*LI+LD)) ||  (13*LI <= t && t <(13*LI+LD)) || (14*LI <= t && t <(14*LI+LD))|| (15*LI <= t && t <(15*LI+LD)) ||  (16*LI <= t && t <(16*LI+LD)) || (17*LI <= t && t <(17*LI+LD))
                if (t == Zeitschritte)
                    break
                end
                % Partikelanzahl die vom RLF entfernt werden
                PA_sub(t) = V_RLF * c_ges (t-1);
                % Verringerung der Partikelkonzentration im Raum durch den RLF in [Partikel/m3]
                c_sub(t) = c_ges(t-1)* V_RLF/Raumvolumen;
                
                % Hier wird in jeder Sekunde der Anteil für diese Lüftungs-Sekunde abgezogen
                % Gesamtpartikelanzahl im Raum in [Partikel]
                PA_ges (t)= (PA_ges(t-1) + PA_add - PA_sub(t)) * (1-LE/LD);
                % Mittlere Partikelkonzentration im Raum in [Partikel/m3]
                c_ges (t) = (c_ges(t-1) + c_add - c_sub(t)) * (1-LE/LD); %
                
                % Partikel die eine Person im aktuellen Zeitschritt inhaliert
                Partikel_inhaliert (t) = c_ges(t) *  Atem_V;
                % Aufsummation der inhalierten Partikel
                Partikel_inhaliert_summe (t) = Partikel_inhaliert_summe (t-1) + Partikel_inhaliert (t);
                
                % Zählen der Zeit
                t=t+1;
                b=b+1;
                
                % Immer wenn der Zeitschritt um 1 zunimmt muss die noch übrig gebliebene Virenanzahl neu berechnet werden
                for i=1:t
                    
                    % Es wird gerade gelüftet.
                    if (LI <= t && t <(LI+LD)) || (2*LI <= t && t<(2*LI+LD)) ||  (3*LI <= t && t <(3*LI+LD)) || (4*LI <= t && t <(4*LI+LD))|| (5*LI <= t && t <(5*LI+LD)) ||  (6*LI <= t && t <(6*LI+LD)) || (7*LI <= t && t <(7*LI+LD))|| (8*LI <= t && t <(8*LI+LD))|| (9*LI <= t && t <(9*LI+LD)) ||  (10*LI <= t && t <(10*LI+LD)) || (11*LI <= t && t <(11*LI+LD))|| (12*LI <= t && t<(12*LI+LD)) ||  (13*LI <= t && t <(13*LI+LD)) || (14*LI <= t && t <(14*LI+LD))|| (15*LI <= t && t <(15*LI+LD)) ||  (16*LI <= t && t <(16*LI+LD)) || (17*LI <= t && t <(17*LI+LD))
                        % Viruspartikel durch Lüften ausgetragen und durch
                        % RLF entfernt
                        PA_VS (i)= (PA_VS(i) - V_RLF * c_VS (i)) * (1-LE/LD) ;
                        
                        c_VS (i) = (c_VS(i) - c_VS(i)* V_RLF/Raumvolumen) * (1-LE/LD);
                    else
                        % Es wird gerade nicht gelüftet.
                        % Viruspartikel durch RLF entfernt
                        PA_VS (i)= PA_VS(i)  - V_RLF * c_VS (i); % Einfache Summation, zwischen den Lüftungsphasen
                        c_VS (i) = c_VS(i)  - c_VS(i)* V_RLF/Raumvolumen;
                    end
                end
            end
            
            % Es liegt gerade keine Lüftung vor.
            % Einfache Summation, zwischen den Lüftungsphasen
            % Partikelanzahl die vom RLF entfernt werden
            PA_sub(t) = V_RLF * c_ges (t-1);
            % Verringerung der Partikelkonzentration im Raum durch den RLF in [Partikel/m3]
            c_sub(t) = c_ges(t-1)* V_RLF/Raumvolumen;
            
            PA_ges (t)= PA_ges(t-1)  + PA_add  - PA_sub(t); % Einfache Summation, zwischen den Lüftungsphasen
            c_ges (t) = c_ges(t-1) + c_add - c_sub(t);
            
        else % Der Zeitpunkt in dem Viren absterben ist erreicht. Es sterben nur die Viren ab die noch von den t-VS hinzugefügten Viren noch übrig sind.
            
            % Wird gerade gelüftet?
            while (LI <= t && t <(LI+LD)) || (2*LI <= t && t<(2*LI+LD)) ||  (3*LI <= t && t <(3*LI+LD)) || (4*LI <= t && t <(4*LI+LD))|| (5*LI <= t && t <(5*LI+LD)) ||  (6*LI <= t && t <(6*LI+LD)) || (7*LI <= t && t <(7*LI+LD))|| (8*LI <= t && t <(8*LI+LD))|| (9*LI <= t && t <(9*LI+LD)) ||  (10*LI <= t && t <(10*LI+LD)) || (11*LI <= t && t <(11*LI+LD))|| (12*LI <= t && t<(12*LI+LD)) ||  (13*LI <= t && t <(13*LI+LD)) || (14*LI <= t && t <(14*LI+LD))|| (15*LI <= t && t <(15*LI+LD)) ||  (16*LI <= t && t <(16*LI+LD)) || (17*LI <= t && t <(17*LI+LD))
                if (t == Zeitschritte)
                    break
                end
                % Partikelanzahl die vom RLF entfernt werden
                PA_sub(t) = V_RLF * c_ges (t-1);
                % Verringerung der Partikelkonzentration im Raum durch den RLF in [Partikel/m3]
                c_sub(t) = c_ges(t-1)* V_RLF/Raumvolumen;
                
                % Hier wird in jeder Sekunde der Anteil für diese Lüftungs-Sekunde abgezogen
                % Gesamtpartikelanzahl im Raum in [Partikel]
                PA_ges (t)= (PA_ges(t-1) + PA_add - PA_sub(t)- PA_VS (t-VS)) * (1-LE/LD);
                % Mittlere Partikelkonzentration im Raum in [Partikel/m3]
                c_ges (t) = (c_ges(t-1) + c_add - c_sub(t)- c_VS (t-VS)) * (1-LE/LD); %
                
                % Partikel die eine Person im aktuellen Zeitschritt inhaliert
                Partikel_inhaliert (t) = c_ges(t) *  Atem_V;
                % Aufsummation der inhalierten Partikel
                Partikel_inhaliert_summe (t) = Partikel_inhaliert_summe (t-1) + Partikel_inhaliert (t);
                
                % Zählen der Zeit
                t=t+1;
                b=b+1;
                
                % Immer wenn der Zeitschritt um 1 zunimmt muss die noch übrig gebliebene Virenanzahl neu berechnet werden
                for i=1:t
                    
                    % Es wird gerade gelüftet.
                    if (LI <= t && t <(LI+LD)) || (2*LI <= t && t<(2*LI+LD)) ||  (3*LI <= t && t <(3*LI+LD)) || (4*LI <= t && t <(4*LI+LD))|| (5*LI <= t && t <(5*LI+LD)) ||  (6*LI <= t && t <(6*LI+LD)) || (7*LI <= t && t <(7*LI+LD))|| (8*LI <= t && t <(8*LI+LD))|| (9*LI <= t && t <(9*LI+LD)) ||  (10*LI <= t && t <(10*LI+LD)) || (11*LI <= t && t <(11*LI+LD))|| (12*LI <= t && t<(12*LI+LD)) ||  (13*LI <= t && t <(13*LI+LD)) || (14*LI <= t && t <(14*LI+LD))|| (15*LI <= t && t <(15*LI+LD)) ||  (16*LI <= t && t <(16*LI+LD)) || (17*LI <= t && t <(17*LI+LD))
                        % Viruspartikel durch Lüften ausgetragen und durch
                        % RLF entfernt
                        PA_VS (i)= (PA_VS(i) - V_RLF * c_VS (i)) * (1-LE/LD) ;
                        
                        c_VS (i) = (c_VS(i) - c_VS(i)* V_RLF/Raumvolumen) * (1-LE/LD);
                    else
                        % Es wird gerade nicht gelüftet.
                        % Viruspartikel durch RLF entfernt
                        PA_VS (i)= PA_VS(i)  - V_RLF * c_VS (i); % Einfache Summation, zwischen den Lüftungsphasen
                        c_VS (i) = c_VS(i)  - c_VS(i)* V_RLF/Raumvolumen;
                    end
                end
            end % der while Lüftungsschleife
            
            % es liegt gerade keine Lüftung vor
            % Einfache Summation, zwischen den Lüftungsphasen
            % Partikelanzahl die vom RLF entfernt werden
            PA_sub(t) = V_RLF * c_ges (t-1);
            % Verringerung der Partikelkonzentration im Raum durch den RLF in [Partikel/m3]
            c_sub(t) = c_ges(t-1)* V_RLF/Raumvolumen;
            
            PA_ges (t)= PA_ges(t-1)  + PA_add  - PA_sub(t) - PA_VS (t-VS); % Einfache Summation, zwischen den Lüftungsphasen
            c_ges (t) = c_ges(t-1) + c_add - c_sub(t)- c_VS (t-VS);
            
        end % der if Bedingung ob die Viren schon sterben
        
        
        
        % Partikel die eine Person im aktuellen Zeitschritt inhaliert
        Partikel_inhaliert (t) = c_ges(t) *  Atem_V;
        % Aufsummation der inhalierten Partikel
        Partikel_inhaliert_summe (t) = Partikel_inhaliert_summe (t-1) + Partikel_inhaliert (t);
        
        
        % Zählen der Zeit
        t=t+1;
    end
    
    %         % Zeichnen von Diagrammen
    %         figure (1)
    %         plot (1:Zeitschritte,c_ges,'r')
    %         %figure (2)
    %         %plot (1:Zeitschritte, c_add,'s',1:Zeitschritte,c_sub,'r')
    %         %figure (3)
    %         %plot (1:Zeitschritte,PA_ges,'b')
    %         %figure (4)
    %         %plot (1:Zeitschritte, PA_add,'s',1:Zeitschritte,PA_sub,'r')
    %         figure (5)
    %         plot (1:Zeitschritte,Partikel_inhaliert_summe,'r')
    %
    %
    %         figure (12)
    %         plot (1:Zeitschritte,PA_VS,'r')
    %
    %         figure (13)
    %         plot (1:Zeitschritte,PA_VS_t1,'b')
    
