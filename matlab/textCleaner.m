function [text] = textCleaner(text)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
text = text(text~='{');
text = text(text~='}');
text = text(text~='(');
text = text(text~=')');
text = text(text~=' ');
end

