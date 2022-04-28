function [abscheidung] = cell2data(abscheidung)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
abscheidung = string(abscheidung);
abscheidung = regexprep(abscheidung,',','.');
abscheidung = str2double(abscheidung);
abscheidung(all(isnan(abscheidung), 2), :) = [];
abscheidung(:, all(isnan(abscheidung), 1)) = [];
end

