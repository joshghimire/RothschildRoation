function [zval, tval, fval,s]=getMyPeak(abswavelet,t,rfreq,trange,frange)
[zmax,imax,~,~] = extrema2(abswavelet);
[imaxf, imaxt]=ind2sub(size(abswavelet),imax);

% figure
% surf(t,rfreq,abswavelet),shading interp;
% rotate3d on
%         set(gca,'YDir','normal');
% % set(gca,'YDir','normal','CLim',clim);
% hold on;
indt=(t(imaxt) > max(trange) | t(imaxt)<min(trange));
indf=(rfreq(imaxf) > max(frange) | rfreq(imaxf)<min(frange));
ind=indt|indf;
zmax(ind)=[];
imax(ind)=[];
imaxf(ind)=[];
imaxt(ind)=[];

% plot3(t(imaxt),rfreq(imaxf),zmax,'bo')
%         text(tval,fval,zval,['  ' num2str(zval)])
%         text(tval,fval+3,zval,['  ' num2str(tval)])
s=length(zmax);
if ~isempty(zmax)
    zval=zmax;
    tval=t(imaxt);
    fval=rfreq(imaxf)';
else
    zval=NaN;
    tval=NaN;
    fval=NaN;
end


end
