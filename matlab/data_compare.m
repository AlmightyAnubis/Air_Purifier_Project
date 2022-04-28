%% Aufräumen
close all
clc
clear
%% Einlesen
[~,sheet_name]=xlsfinfo('Messdaten_FJ.xlsx');
for k=1:numel(sheet_name)
    [~,~, data{k}]=xlsread('Messdaten_FJ.xlsx',sheet_name{k});
end

%% Wandeffekte
abscheidung = cell2data(data{1});

plot(abscheidung(:,1),abscheidung(:,2));
hold on
plot(abscheidung(:,1),abscheidung(:,3));
plot(abscheidung(:,1),(abscheidung(:,3)+abscheidung(:,2))/2);
%ylim([0,inf]);

scheidung1 = smooth(abscheidung(:,2),0.4);
scheidung2 = smooth(abscheidung(:,3),0.4);
scheidung3 = smooth((abscheidung(:,3)+abscheidung(:,2))/2,0.4);
plot(abscheidung(:,1),scheidung1);
plot(abscheidung(:,1),scheidung2);
plot(abscheidung(:,1),scheidung3);
hold off
return
%% Luftreiniger
figure();
air_purifier = cell2data(data{3});

plot(air_purifier(:,1),air_purifier(:,2),'--');
hold on
plot(air_purifier(:,1),air_purifier(:,3),'--');

data1 = smooth(air_purifier(:,2),0.01);
plot(air_purifier(:,1),data1);



data2 = smooth(air_purifier(:,3),0.02);
plot(air_purifier(:,1),data2);
hold off

peak1 = max(data1);
dataAnalyse = data1(data1<peak1*0.75);
timeAnalyse = air_purifier(data1<peak1*0.75);
figure();
plot(timeAnalyse,dataAnalyse);

for i = length(dataAnalyse):-1:3
    if(dataAnalyse(i)>(dataAnalyse(i-1) + dataAnalyse(i-2))/2)
        dataAnalyse(i) = 0;
    end
end
timeAnalyse = timeAnalyse(dataAnalyse~=0);
dataAnalyse = dataAnalyse(dataAnalyse~=0);

plot(timeAnalyse,dataAnalyse);

j = 1;
startpoint = 1;
while i < length(dataAnalyse)
    if(dataAnalyse(i)<dataAnalyse(i+1))
        if(max(dataAnalyse(startpoint:i))>= peak1*0.2)
            splitElements{j,1} = timeAnalyse(startpoint:i);
            splitElements{j,2} = dataAnalyse(startpoint:i);
            j = j + 1;
        end       
        startpoint = i+1;        
    end
    i = i+1;
end

figure();
hold on
average = 0;
for i = 1:size(splitElements,1)
    plot(splitElements{i,1},splitElements{i,2});
    fitFkt=fit(splitElements{i,1} - splitElements{i,1}(1),splitElements{i,2},'exp1');
    plot(splitElements{i,1},fitFkt(splitElements{i,1}- splitElements{i,1}(1)));
    f{i} = confint(fitFkt);
    average = (average * (i-1) + f{i})/i;
end
f1 = @(x) average(1,1)*exp(average(1,2)*x);

f2 = @(x) average(2,1)*exp(average(2,2)*x);
x = 0:100;


hold off

plot(x,f1(x));
hold on
plot(x,f2(x));

halbwertszeit = 1/(-log(exp(1))/log(2)*(average(1,2) + average(2,2))/2);

startwert = (average(1,1) + average(2,1))/2;
f3 = @(x) startwert*(1/2).^(x/halbwertszeit);
plot(x,f3(x));


hold off










