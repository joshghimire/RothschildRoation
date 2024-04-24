function org_conv12=removepointlessthen(mat,numpoints)
org_conv1=conv2(mat,ones(1,numpoints)) == numpoints;
org_conv12=org_conv1(:,numpoints:end);
for ilen=1:numpoints-1
    org_conv12=org_conv12+circshift(org_conv12,[0 1]);
end
org_conv12(org_conv12>0)=1;
end
