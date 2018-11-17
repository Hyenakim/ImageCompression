function [sum] = clipping(sum)
if sum>255 %clipping
   sum = 255;
elseif sum<0
   sum = 0;
end