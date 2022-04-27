function [outputArg1] = gaussDistValue(x,sigma,mu)
    %UNTITLED3 Summary of this function goes here
    %   Detailed explanation goes here
    outputArg1 = 1/sqrt(2 * pi() * sigma^2) * exp(-(x-mu)^2/(2 * sigma^2));
end

