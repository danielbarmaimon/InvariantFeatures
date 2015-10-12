imageIndex = 8;
% form transformed image filename for reading
if imageIndex<10
    im2FileName = strcat('Image_0', num2str(imageIndex), noiseSequence,'.png');
else
    im2FileName = strcat('Image_', num2str(imageIndex), noiseSequence,'.png');
end
im2Name = fullfile(pathIm, im2FileName);


currentHomography = allHomographies(imageIndex).H;

%estimate some points for plot
%     %pointPlotIm1Cnt = [[-200, -100]; [-200, 100]; [200, 100]; [200, -100]];
pointPlotIm1Cnt = [[29, 29]; [720, 29]; [720, 470]; [29, 470]];
pointPlotIm2CntEst = project2Points(currentHomography, pointPlotIm1Cnt);
if all(currentHomography(1:2,3)==0)
    pointPlotIm1 = pointPlotIm1Cnt + repmat(im1SizeXYHalf,  4, 1);
    pointPlotIm2Est = pointPlotIm2CntEst + repmat(im1SizeXYHalf,  4, 1);
else
    pointPlotIm1 = pointPlotIm1Cnt;
    pointPlotIm2Est = pointPlotIm2CntEst;
end


    %plot some points
    figure, imshow(im1), 
    hold on
%         plot(pointPlotIm1([1,3], 1), pointPlotIm1([1,3], 2), '-o',...
%         'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',10, 'LineWidth', 2.5);
%         plot(pointPlotIm1([2,4], 1), pointPlotIm1([2,4], 2), '-o',...
%         'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',10, 'LineWidth', 2.5);
        plot(pointPlotIm1([1:end,1], 1), pointPlotIm1([1:end,1], 2), '-o',...
        'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',10, 'LineWidth', 2.5);

    hold off;
    
    
    figure, imshow(imread(im2Name))
    hold on
%         plot(pointPlotIm2Est([1,3], 1), pointPlotIm2Est([1,3], 2), '-o',...
%         'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',10, 'LineWidth', 2.5);
%         plot(pointPlotIm2Est([2,4], 1), pointPlotIm2Est([2,4], 2), '-o',...
%         'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',10, 'LineWidth', 2.5);
         plot(pointPlotIm2Est([1:end,1], 1), pointPlotIm2Est([1:end,1], 2), '-o',...
        'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',10, 'LineWidth', 2.5);

    hold off;
