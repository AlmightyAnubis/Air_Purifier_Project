x = { 
'STAT' 'JJJJMM'   'QN'    'TNN'    'TNM'    'TMM'    'TXM'    'TXX'    'SOS'    'NMM'    'RSS'    'RSX'    'FMM'    'FXX'
};
y= [10361 202204    1   -5.4    3.4    8.8   13.9   22.4  180.1    5.7   30.8    9.8    2.3   19.6
10361 202203    1   -4.1   -0.4    5.6   11.9   18.7  232.7    "-"    2.8    2.1    1.8   15.0
10361 202202    3   -3.2    2.0    5.6    9.2   13.7   81.0    5.9   44.7   11.8    3.0   25.3
10361 202201    3   -2.0    1.9    4.3    6.3   13.8   31.7    6.7   20.5    3.9    2.4   22.0
10361 202112    3  -12.6    0.0    2.9    5.4   14.8   42.5    6.4   22.1    7.3    2.0   18.2
10361 202111    3   -1.9    4.0    6.6    9.0   13.1   43.1    7.0   35.8   25.6    2.0   18.5
10361 202110    3   -0.2    6.1   10.7   15.5   21.9  128.3     ""    24.8   10.2    ""   20.9
10361 202109    3    7.2   11.4   16.2   21.5   28.7  155.1     ""    30.2   23.3   1.8   16.5
10361 202108    3    7.4   13.1   17.8   23.0   29.8  150.1     ""    94.3   27.7   2.1   15.9
10361 202107    3   11.4   15.0   20.3   25.6   31.0  188.6    5.6   22.2    9.7    1.9   14.6
10361 202106    3    7.9   14.4   20.5   26.2   34.6  251.2    5.2   59.1   21.0    1.8   15.2
10361 202105    3    0.4    7.1   12.3   17.2   29.0  196.5    5.7   53.3   10.2    2.3   21.4
10361 202104    3   -2.9    1.9    7.0   12.3   20.2  164.7    5.3   25.9    7.3    2.2   15.5
10361 202103    3   -4.4    1.4    5.8   10.7   24.4  126.3    5.7   18.2    3.5    2.1   18.8
10361 202102    3  -17.6   -3.2    1.3    5.1   19.8   92.6     ""    54.3   12.8    ""    13.9
10361 202101    3  -11.2   -0.9    1.3    3.4   11.5   28.5    7.1   40.6   12.2    2.0   15.7
10361 202012    3   -2.9    1.3    3.7    6.3   14.4   42.5    6.7   19.3    3.4    1.9   14.7
10361 202011    3   -1.4    4.2    7.4   10.6   21.1   84.4    6.2    2.7    1.2    1.9   13.6];
y = str2double(y);
T = array2table(y,"VariableNames",x);
temp = T.('TMM');
t_med = mean(temp);
q_out = (22 - t_med) * 1000 * 1.225 * 200 * 9.6/60/60 * 5/25;
q_p = 25*70;
dq = q_out - q_p;

