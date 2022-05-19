clear
close all
clc
%% Params
runtime = 5 * 60 * 60;
V_breath = 5/60/1000;
c_breath = 0.1 * 1000000;
V_ap = 1000/3600;
ap_eff = 0.0;
V_room = 200;
vent_int = 20*60;
vent_dur = 5*60; % Lüftungsdauer
n_vent = 6; %Luftwechselrate pro h
vir_lif = 90*60;


time = linspace(0,runtime,runtime/60+1);
space = 2.^(-2:2);


value = vent_dur;
name = "vent_dur";

setup();
figure();
T_conc = table(time'/60,'VariableNames',{'time'});
T_tot = table(time'/60,'VariableNames',{'time'});
for variable=data
    functionSelect();
    hold on
    p1 = subplot(1,3,1);
    plot(time/60,particlekonz(time),"-");
    xlabel("Time in min", 'FontSize', 10);
    ylabel("Particle conc. in Particle/m^3", 'FontSize', 10);
    xticks([0 30 60 90 120 180 240 300])
    ytickangle(0)
    ax = gca;
    ax.YAxis.Exponent = 2;
    ylim([0,200]);
    grid on
    hold off
    hold on
    p2 = subplot(1,3,2);
    plot(time/60,particleSum(time),"-");
    xlabel("Time in h", 'FontSize', 10);
    ylabel("Average number of inhaled particles", 'FontSize', 10);
    ylim([0,600]);
    xticks([0 30 60 90 120 180 240 300])
    ytickangle(0)
    ax = gca;
    ax.YAxis.Exponent = 2;
    grid on
    hold off
    endvalue = [endvalue ; particleSum(time(end))];
    text = convertStringsToChars(name + "_" + variable*factor);
    text = textCleaner(text);
    text =  matlab.lang.makeValidName(text);
    t2c = {text};
    T_conc = [T_conc table(particlekonz(time)','VariableNames',{text})];
    T_tot = [T_tot table(particleSum(time)','VariableNames',{text})];
    
end
text =  matlab.lang.makeValidName(textCleaner(convertStringsToChars(name)));
T_summary = table((data*factor)',endvalue,'VariableNames',{text,'endvalue'});
p3 = subplot(1,3,3);
plot([value,value]*factor,[0,600],"--");
hold on
plot(data*factor,endvalue,"x");
xlabel(name, 'FontSize', 10);
ylabel("Average number of inhaled particles", 'FontSize', 10);
sample = linspace(min(data),max(data),1000);
points = fit(data',endvalue,'smoothingspline');
plot(sample*factor,points(sample),"-");
legend("standard value");
xlim([0,max(data*factor)]);
xtickangle(0)
ax = gca;
ax.YAxis.Exponent = 2;
ylim([0,600]);
xticks(linspace(0,max(data*factor),5));
grid on
hold off


subplot(1,3,1);
text = name + " = "  + data*factor;
%legend(text,'Location','northeast','NumColumns',2);
subplot(1,3,2);
legend(text,'Location','northwest','NumColumns',1);

if(1==0)
    p1.Position(1) = 0.05;
    p1.Position(2) = 0.35;
    p1.Position(3) = 0.25;
    p1.Position(4) = 0.6;
    
    p2.Position(1) = 0.35;
    p2.Position(2) = 0.35;
    p2.Position(3) = 0.25;
    p2.Position(4) = 0.6;
    
    p3.Position(1) = 0.65;
    p3.Position(2) = 0.1;
    p3.Position(3) = 0.25;
    p3.Position(4) = 0.6;
else
    p1.Position(1) = 0.055;
    p1.Position(2) = 0.15;
    p1.Position(3) = 0.3;
    p1.Position(4) = 0.75;
    
    p2.Position(1) = 0.4275;
    p2.Position(2) = 0.15;
    p2.Position(3) = 0.3;
    p2.Position(4) = 0.75;
    
    p3.Position(1) = 0.7775;
    p3.Position(2) = 0.15;
    p3.Position(3) = 0.2;
    p3.Position(4) = 0.75;
end


Information = "Standard Values (Deviation shown in Plot): ";
Information = Information + "runtime = "  + runtime/60/60 + " h    ";
Information = Information +"c_{breath} = "  + c_breath + " particle/m^3    ";
Information = Information + "V_{breath} = "  + V_breath*1000*60 + " l/min    ";
Information = Information + "V_{ap} = "  + V_ap*3600 + " m^3/h   ";
Information = Information + "ap_{eff} = "  + ap_eff + "    ";
Information = Information + "V_{room} = "  + V_room + " m^3   ";
Information = Information + "vent_{int} = "  + vent_int/60 + " min    ";
%Information = Information + "vent_{dur} = "  + vent_dur/60 + " min    ";
Information = Information + "n_{vent} = "  + n_vent + "   ";
Information = Information + "vir_{lif} = "  + vir_lif/60 + " min   ";

%annotation('textbox', [0.05, 0.01, 0.85, 0.2], 'String', Information);

disp(Information);

fh = gcf;
fh.Position(1) = 100;
fh.Position(2) = 100;
fh.Position(3) = 800;
fh.Position(4) = 300;

hgexport(fh,'Testarea\' + name + '.eps')
%saveas(fh,'Testarea\' + name,'epsc')


filename = 'Testarea\' + name + '.xlsx';
delete(filename);
warning( 'off', 'MATLAB:xlswrite:AddSheet' ) ;
writetable(T_conc,filename,'Sheet','Concentration')
try
    for i=1:5
        current_sheet = get(Sheets, 'Item', (1));
        invoke(current_sheet, 'Delete');
    end
catch
    disp("all pages deleted");
end

writetable(T_conc,filename,'Sheet','Concentration')
writetable(T_tot,filename,'Sheet','Inhaled Particles')
writetable(T_summary,filename,'Sheet','Summary')
[type, sheet_names] = xlsfinfo(filename);

% First open Excel as a COM Automation server
Excel = actxserver('Excel.Application');
% Make the application invisible
set(Excel, 'Visible', 0);
% Make excel not display alerts
set(Excel,'DisplayAlerts',0);
% Get a handle to Excel's Workbooks
Workbooks = Excel.Workbooks;
% Open an Excel Workbook and activate it
pwdName = pwd + "\" + filename;
Workbook=Workbooks.Open(pwdName);
% Get the sheets in the active Workbook
Sheets = Excel.ActiveWorkBook.Sheets;


% Now save the workbook
Workbook.Save;
% Close the workbook
Workbooks.Close;
% Quit Excel
invoke(Excel, 'Quit');
% Delete the handle to the ActiveX Object
delete(Excel);










