close all;
t = 100;
LI = 30;
LD = 5;
value = zeros(t,1);
value2 = zeros(t,1);
sigma = 3;
mu = inf; 
summe = 0;


for i=1:t    
    % Lüftungsphase (Zu beginn findet keine Lüftung statt)
    timeStep = max(1,floor(i/LI));
    % Es wird gerade gelüftet.
    if (timeStep * LI <= i && i <(timeStep * LI + LD))
        value(i,1) = 1;
    end
    if(sigma ~= 0)
        value2(i,1) = 1/sqrt(2 * pi() * sigma^2) * exp(-(i-mu)^2/(2 * sigma^2));
    else
       if(mu == i)
           value2(i,1) = 1;
       end
    end
    summe = summe + value2(i,1);
end

plot(value);
figure();

bar(value2);
disp(summe);
