function [returnvalue] = integratedGaussDist(sigma,mu,x_start,x_end)
    %UNTITLED4 Summary of this function goes here
    %   Detailed explanation goes here
    returnvalue = zeros(x_end - x_start + 1,1);
    
    for lauf = 2:length(returnvalue)
       returnvalue(lauf) = returnvalue(lauf-1) + gaussDistValue(lauf,sigma,mu);        
    end
    
    
    
end

