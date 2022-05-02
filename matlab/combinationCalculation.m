%% Aufräumen
close all
clc
clear
%% Einlesen
[~,sheet_name]=xlsfinfo('Daten_FJ.XLSX');
for k=1:numel(sheet_name)
    [~,~, data{k}]=xlsread('Daten_FJ.XLSX',sheet_name{k});
end

%% Split for times
abscheidung = cell2data(data{1});

times = [30 30 30 15 30 30 30 15 30 30];


for i = 1:length(times)
    splits{i} = abscheidung(abscheidung(:,1)<times(i)&abscheidung(:,1)>=0,:);
    abscheidung = abscheidung - times(i);
    
end
xsize = round(sqrt(length(splits)));
ysize = ceil(length(splits)/xsize);

figure();

myfittype = fittype('a*(1-exp(b*x))',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a','b'})

for i = 1:length(splits)
    subplot(xsize,ysize,i);
    datapoints = splits{i};
    smoth1 = smooth(datapoints(:,2),0.001);
    smoth2 = smooth(datapoints(:,3),0.001);
    plot(datapoints(:,1),smoth1);
    hold on
    plot(datapoints(:,1),smoth2);
    try
        diff = max(smoth1) - min(smoth1);
        plusminus = sign(smoth1(1) - smoth1(end));
        f1 = fit(datapoints(:,1),smoth1,myfittype,'StartPoint',[diff 0.02 * plusminus]);
        plot(datapoints(:,1),f1(datapoints(:,1)));
        fits{i,1} = f1;
        
    catch
        disp("Error:" + i + "," + 1);
    end
    
    try
        f2 = fit(datapoints(:,1),smoth2,myfittype,'StartPoint',[2 -1]);
        plot(datapoints(:,1),f2(datapoints(:,1)));        
        fits{i,2} = f2;        
    catch
        disp("Error:" + i + "," + 2);
    end
    
    
    
    hold off
    ylim([0 12000]);
end













