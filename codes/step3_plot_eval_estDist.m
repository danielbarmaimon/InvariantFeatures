%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% prepare workspace 
% clear workspace
clc; clear all; close all;
addpath('functions');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% path of images
imSeq = 'Sequence3';
threshDist = 10;

dataDir = 'output';
%noise sequence labels
noiseSeq = {'a','b', 'c', 'd'};
nn=1;
% compute percentages below threshold 
for nn =1:numel(noiseSeq)
    noiseLabel = noiseSeq{nn};
    
    %read all 3 sequences for current noise label
    % dist original
    outType = '';
    nameDistFile = ['estDist_', imSeq, '_', outType, noiseLabel,'.mat'];
    locPercent{nn, 1} = getLocMatchFromDist(dataDir, nameDistFile, threshDist)*100;
    
    % dist 448
    outType = '448_';
    nameDistFile = ['estDist_', imSeq, '_', outType, noiseLabel,'.mat'];
    locPercent{nn, 2} = getLocMatchFromDist(dataDir, nameDistFile, threshDist)*100;

    % dist 338
    outType = '338_';
    nameDistFile = ['estDist_', imSeq, '_', outType, noiseLabel,'.mat'];
    locPercent{nn, 3} = getLocMatchFromDist(dataDir, nameDistFile, threshDist)*100;

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

descImp = {'VL 4x4', 'VL 3x3'};

%separate plots
for nn =1:numel(noiseSeq)
    figure(nn), cla,
    line(1:length(locPercent{nn, 1}), [locPercent{nn, :}], 'LineWidth', 2)
    grid on
    set(gca,'XTick',1:length(locPercent{nn, 1}) )
    set(gca,'XTickLabel',xTicklabels);
    legend(descImp)
    title([imSeq, ', noise type: ', noiseSeq{nn} ]);
    xlabel(xLab)
    ylabel('Correctly Matched (%)')
    % rotate X tick labels if needed
    if xTicRotAngle~=0
        xticklabel_rotate([], xTicRotAngle,[]);
    end
end
%%
% one plot
% legend entries
descImp = [strcat({'VL 4x4 '},noiseSeq), strcat({'VL 3x3 '},noiseSeq)];
nn=1;
figure, cla,
plotData = [locPercent{1:4, 2:3}];
plotPos = 1:length(plotData);
if strcmp(imSeq, 'Sequence1')
    plotData = [plotData(1:4,:); nan(1,size(plotData,2));
                plotData(5:8,:); nan(1,size(plotData,2));
                plotData(9:12,:); nan(1,size(plotData,2));
                plotData(13:16,:)];
    plotPos = 1:length(plotData);
    xTicklabels = [ xTicklabels(1:4), {' '}, xTicklabels(5:8), {' '}, xTicklabels(9:12), {' '}, xTicklabels(13:16)]
end
line(plotPos, plotData, 'LineWidth', 2)
grid on
set(gca,'XTick',plotPos )
set(gca,'XTickLabel',xTicklabels);
legend(descImp)
title(imSeq);
xlabel(xLab)
ylabel('Correctly Matched (%)')
% rotate X tick labels if needed
if xTicRotAngle~=0
    xticklabel_rotate([], xTicRotAngle,[]);
end