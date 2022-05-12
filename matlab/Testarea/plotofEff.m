 close all
x=(0:5) * 0.2;
y = [1 1.22 1.49 1.82 2.225 2.72];
y2 = exp(x);
a = fit(x',y','exp1');
plot(x,y,'x');
xlim([0,1]);
ylim([0,inf]);
values = a(x);
hold on
plot(x,values);
plot(x,y2,'x');
hold off
