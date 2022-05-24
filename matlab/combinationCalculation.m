%% Aufräumen
close all
%clc
clear
%% Einlesen
[~,sheet_name]=xlsfinfo('Daten_FJ.XLSX');
for k=1:numel(sheet_name)
    [~,~, data{k}]=xlsread('Daten_FJ.XLSX',sheet_name{k});
end

%% Split for times
abscheidung = cell2data(data{1});

functionSystem = @(x) 4206*(1-exp(-0.001486*(x+5000)));

times = [30 30 30 15 30 30 30 15 30 30];
textArray = ["Fenster"	"Tuer"	"LR"	"AG"];
setting =[
    '-'	'-'	'-'	'x';
    '-'	'-'	'x'	'-';
    '-'	'-'	'x'	'x';
    '-'	'-'	'-'	'x';
    'x'	'x'	'-'	'-';
    'x'	'x'	'-'	'x';
    'x'	'x'	'x'	'x';
    '-'	'-'	'x'	'-';
    'x'	'x'	'-'	'-';
    'x'	'x'	'x'	'-';
    ];

setting = 'x' == setting;


for i = 1:length(times)
    splits{i} = abscheidung(abscheidung(:,1)<times(i)&abscheidung(:,1)>=0,:);
    abscheidung(:,1) = abscheidung(:,1) - times(i);
    
end
xsize = round(sqrt(length(splits)));
ysize = ceil(length(splits)/xsize);

figure();

approchingfittype = fittype('a*(1-exp(b*(x+c)))',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b','c'});
expon2 = fittype('a*exp(b*x)+c',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b','c'});
expon =fittype("exp1");
expon = expon2;
pol =fittype("poly1");
FittingTypes = {pol expon approchingfittype pol expon  approchingfittype expon expon expon expon};

for i = 1:length(splits)
    %subplot(xsize,ysize,i);
    datapoints = splits{i};
    smoth1 = smooth(datapoints(:,2),0.001);
    smoth2 = smooth(datapoints(:,3),0.001);
    maxValue1 = max(smoth1);
    maxValue2 = max(smoth2);
    maxValue = max(maxValue1,maxValue2);
    datapoints(:,1) = datapoints(:,1);%*60;
    plot(datapoints(:,1),smoth1);
    hold on
    plot(datapoints(:,1),smoth2);
    %plot(datapoints(:,1),functionSystem(datapoints(:,1)));
    clearvars f1 f2
    usedType = FittingTypes{i};
    
    try
        if(isequal(usedType,approchingfittype))
            diff = max(smoth1) - min(smoth1);
            plusminus = sign(smoth1(1) - smoth1(end));
            f1 = fit(datapoints(:,1),smoth1,usedType,'StartPoint',[diff 0.02 * plusminus 0]);
        elseif(isequal(usedType,expon2))
            diff = max(smoth1) - min(smoth1);
            plusminus = sign(smoth1(end) - smoth1(1));
            f1 = fit(datapoints(:,1),smoth1,usedType,'StartPoint',[diff * 2 0.02 * plusminus 0],'Upper',[diff*2 1 diff*2],'Lower',[-diff*2 -1 0]);
        else
            f1 = fit(datapoints(:,1),smoth1,usedType);
        end
        plot(datapoints(:,1),f1(datapoints(:,1)));
        fits{i,1} = f1;
    catch e
        disp("Error:" + i + "," + 1);
    end
    
    try
        if(isequal(usedType,approchingfittype))
            diff = max(smoth2) - min(smoth2);
            plusminus = sign(smoth2(1) - smoth2(end));
            f2 = fit(datapoints(:,1),smoth2,usedType,'StartPoint',[diff  0.02 * plusminus 0]);
        elseif(isequal(usedType,expon2))
            diff = max(smoth2) - min(smoth2);
            plusminus = sign(smoth2(end) - smoth2(1));
            f2 = fit(datapoints(:,1),smoth2,usedType,'StartPoint',[diff * 2 0.02 * plusminus 0],'Upper',[diff*2 1 diff*2],'Lower',[-diff*2 -1 0]);
        else
            f2 = fit(datapoints(:,1),smoth2,usedType);
        end
        plot(datapoints(:,1),f2(datapoints(:,1)));
        fits{i,2} = f2; %#ok<*SAGROW>
    catch e
        disp("Error:" + i + "," + 2);
    end
    legendString = ["data1" "data2"];
    if(exist('f1','var'))
        if(isequal(usedType,approchingfittype))
            textString =gueltigeStellen(f1.a,3) + "*(1-exp(" +  gueltigeStellen(f1.b,3) + "*(x+ " + gueltigeStellen(f1.c,3) + ")))";
        elseif(isequal(usedType,pol))
            textString = gueltigeStellen(f1.p1,3) + "*x+" + gueltigeStellen(f1.p2,3);
        elseif(isequal(usedType,expon2))
            textString = gueltigeStellen(f1.a,3) + "*exp(" +  gueltigeStellen(f1.b,3) + "*x) + " + gueltigeStellen(f1.c,3);
        elseif(isequal(usedType,expon))
            textString = gueltigeStellen(f1.a,3) + "*exp(" +  gueltigeStellen(f1.b,3) + "*x)";
        end
        legendString = [legendString textString];
    end
    if(exist('f2','var'))
        if(isequal(usedType,approchingfittype))
            textString = gueltigeStellen(f2.a,3) + "*(1-exp(" + gueltigeStellen(f2.b,3) + "*(x+ " + gueltigeStellen(f2.c,3) + ")))";
        elseif(isequal(usedType,pol))
            textString = gueltigeStellen(f2.p1,3) + "*x+" + gueltigeStellen(f2.p2,3);
        elseif(isequal(usedType,expon2))
            textString = gueltigeStellen(f2.a,3) + "*exp(" + gueltigeStellen(f2.b,3) + "*x) + " + gueltigeStellen(f2.c,3);
        elseif(isequal(usedType,expon))
            textString = gueltigeStellen(f2.a,3) + "*exp(" + gueltigeStellen(f2.b,3) + "*x)";
                end
        legendString = [legendString textString];
    end
    legend(legendString,'Location','northwest');
    xlabel("Time in min", 'FontSize', 10);
    ylabel("Particle conc. in Particle/m^3", 'FontSize', 10);
    
    ax = gca;
    ax.YAxis.Exponent = 2;
    
    hold off
    ylim([0 maxValue*3/2]);
    
    fh = gcf;
    fh.Position(1) = 100;
    fh.Position(2) = 100;
    fh.Position(3) = 400;
    fh.Position(4) = 300;
    drawnow
    %pause(1);
    
    name = strjoin(textArray(setting(i,:)),"_");
    str = sprintf('%03d',i);
    hgexport(fh,'Testarea\' + "timesplit" + str + "_" + name + '.eps')
end













