%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace 
% clear workspace
clc; clear all; close all;
addpath('functions');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% path of images
imSeq = 'Sequence1';
threshDist = 1;

%noise sequence labels
noiseSeq = {'a','b', 'c', 'd'};

locPercent = double.empty(0, numel(noiseSeq));

nn=1;
% compute percentages below threshold 
for nn =1:numel(noiseSeq)
    noiseLabel = noiseSeq{nn};
    nameDistFile = ['estDist_', imSeq, '_', noiseLabel,'.mat'];
    load( fullfile('output', nameDistFile) );
    %dist{nn} = eval('estDistAll');
    %clear 'estDistAll' 'nameDistFile';
    
    for ii=1:length(estDistAll)
        estDist= estDistAll{ii};
        numberOfMatches= numel(estDist);
        checkDist = (estDist < threshDist);
        % save in array
        locPercent(ii, nn) = sum(checkDist)/numberOfMatches*100; 
    end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prepare plot labels

switch imSeq
    case 'Sequence1'
        xTicklabels = {'25 U','50 U','75 U','100 U', '25 D','50 D','75 D','100 D', '25 L','50 L','75 L','100 L', '25 R','50 R','75 R','100 R'};
        xLab = 'Offset type';
        xTicRotAngle =90;
    case 'Sequence2'
        xTicklabels = 110:5:150;
        xLab = 'Zoom Factor(%)';
        xTicRotAngle = 0;
    case 'Sequence3'
        xTicklabels = [-45:5:-5, 5:5:45];
        xLab = 'Rotation angles';
        xTicRotAngle = 0;
    otherwise
        disp('undefined sequence');
        xTicklabels ='';
        xLab = '';
        xTicRotAngle = 0;
end

figure(1), cla,  
line(1:length(locPercent), locPercent, 'LineWidth', 2)
grid on
set(gca,'XTick',1:length(estDistAll));
set(gca,'XTickLabel',xTicklabels);
xlabel(xLab);
ylabel('Correctly Matched (%)');
legend(noiseSeq);
title(imSeq);
% rotate X tick labels if needed
if xTicRotAngle~=0
    xticklabel_rotate([], xTicRotAngle,[]);
end



