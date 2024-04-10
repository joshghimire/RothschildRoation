function [  ] = getEmptyLay(channels)
%GETEMPTYLAY Summary of this function goes here
%   Detailed explanation goes here
ft_defaults;
load('easycapMR64.mat')
point='yes';
box='no';
label='no';
mask='no';
outline='yes';
verbose='no';
pointsymbol='.';
pointcolor='k';
pointsize=8;
ft_plot_lay(lay,...
    'point',point,...
    'box',box,...  % /no
    'label',label,...  %     = yes/no
    'mask',mask,...  %         = yes/no
    'outline',outline,...  %      = yes/no
    'verbose',verbose,...  %      = yes/no
    'pointsymbol',pointsymbol,...  %  = string with symbol (e.g. 'o') - all three point options need to be used together
    'pointcolor',pointcolor,...  %   = string with color (e.g. 'k')
    'pointsize',pointsize );
try
    [~,Locb] =ismember(channels,lay.label)
    Locs=lay.pos(Locb,:);hold on
    p1=plot(gca,Locs(:,1),Locs(:,2),'k');
    p1.Marker='.';
    p1.LineStyle='none';
    p1.MarkerSize=30;
catch
end
% filename=sprintf('easycapMR64_%s %s %s %s %s %s %s %s %d',...
%     point,box,label,mask,outline,verbose,pointsymbol,pointcolor,...
%     pointsize)
% savefig([filename '.fig']);
% print([filename '.png'],'-dpng','-r300');

end

