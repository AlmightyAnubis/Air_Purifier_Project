function [outputArg1] = gueltigeStellen(x,stellen)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
outputArg1 =  round(x ./ 10.^floor(log10(abs(x))), stellen - 1) .* 10.^floor(log10(abs(x)));
end

