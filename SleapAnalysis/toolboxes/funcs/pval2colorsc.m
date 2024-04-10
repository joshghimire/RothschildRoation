function [colorsc] = pval2colorsc(pvals)
%PVAL2COLORSC Summary of this function goes here
%   Detailed explanation goes here
levels=[-inf .001 .01 .05 inf];
colorsc=zeros(size(pvals));
highestlevel=length(levels)-1;
grayscale=flipud(gray(highestlevel));

for ilevel=2:length(levels)
    biggerthanfirst=(pvals>=levels(ilevel-1));
    smallerthansecond=(pvals<levels(ilevel));
    selected=biggerthanfirst&smallerthansecond ;
    colorsc(selected)=highestlevel-ilevel+2;
end
end

