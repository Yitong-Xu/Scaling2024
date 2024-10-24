%%
function feoSlope = getFeoSlope(ff,FrameTime)
feoData = rmmissing(ff);

[xData, yData] = prepareCurveData((1:length(feoData))*FrameTime, feoData);

smoothedData = smoothdata(yData,"sgolay","SmoothingFactor",0.1,"Degree",3, ...
    "SamplePoints",xData);

% Display results
figure
plot(xData,yData,"SeriesIndex",6,"DisplayName","Input data")
hold on
plot(xData,smoothedData,"SeriesIndex",1,"LineWidth",1.5, ...
    "DisplayName","Smoothed data")
%hold off
legend
xlabel("xData")

% Find change points
[changeIndices,segmentSlope,segmentIntercept] = ischange(smoothedData,"linear", ...
    "MaxNumChanges",4,"SamplePoints",xData);

% Display results
%figure
%plot(xData,smoothedData,"SeriesIndex",6,"DisplayName","Input data")
%hold on

% Plot segments between change points
plot(xData,segmentSlope(:).*xData(:)+segmentIntercept(:), ...
    "SeriesIndex","none","DisplayName","Linear regime")

% Plot change points
x = repelem(xData(changeIndices),3);
y = repmat([ylim(gca) missing]',nnz(changeIndices),1);
plot(x,y,"SeriesIndex",5,"LineWidth",1,"DisplayName","Change points")
title("Number of change points: " + nnz(changeIndices))


legend
xlabel("xData")
hold off
%clear segmentSlope segmentIntercept x y
%disp(unique(segmentSlope))

feoSlope = max(segmentSlope);
disp(feoSlope);
end