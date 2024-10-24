function [minD,maxD,tAO,tMax] = getAnaphaseFixThold(distanceData,FrameTime,SmoothingParam,vAO,vMaxD)
% Set default smoothing parameter
if nargin < 3
    SmoothingParam = 0.01;
    vAO = 0.04;
    vMaxD = 0.05;
end
vAO = vAO;
vMaxD = vMaxD;

distanceData = nonzeros(distanceData)';

[xData, yData] = prepareCurveData((1:length(distanceData))*FrameTime, distanceData*0.145);

% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = SmoothingParam;

% Fit model to data.
fitresult = fit( xData, yData, ft, opts );

% Calculate instantaneous velocity and smoothed velocity - smV
%instantV = gradient(yData,xData);
splDist = feval(fitresult,xData);
smV = gradient(splDist,xData);

% Find time point of maximum speed - xmax
% Based on smoothed velocity, start from xmax
% Find time of anaphase onset - t1
% Find time of maximum chromosome distance = t2
xmax = find(smV == max(smV));
% Dynamic velocity threshold
% thold1 = smV(xmax)*0.1;
% thold2 = smV(xmax)*0.04;
% 
% for dt = 1:xmax
%     if smV(xmax-dt)< thold1
%         t1 = xmax-dt+1;
%         break
%     end
% end
% 
% for dt = 1:length(xData)
%     if smV(xmax+dt)< thold2
%         t2 = xmax+dt;
%         break
%     end
% end
% Fixed velocity threshold
    for dt = 1:xmax
        if smV(xmax-dt) < vAO
            t1 = xmax-dt+1;
        break
        end
    end

    for dt = 1:length(xData)
        if smV(xmax+dt)< vMaxD %default 0.01
            t2 = xmax+dt;
            break
        end
    end

tAO = t1*FrameTime;
tMax = t2*FrameTime;
minD = splDist(t1);
maxD = splDist(t2);

% Plot result
figure
title(sprintf('Smoothing Parameter %0.4f',SmoothingParam))

% Plot chromomsome distance and spline fit
yyaxis left
%plot( fitresult, xData, yData);
scatter(xData,yData,'DisplayName','Raw distance')
grid on
hold on
plot(xData,splDist,'-',"LineWidth",1.5,'DisplayName','Smoothened distance')

%
yline(minD,'-','DisplayName','Anaphase onset')
yline(maxD,'--','DisplayName','Maximum Distance')

% Plot velocity
yyaxis right
pV = plot(xData,smV,"LineWidth",1.5);
pV.Color(4) = 0.5;
pV.DisplayName = 'Velocity';

%
xline(tAO,'-','DisplayName','tAO')
xline(tMax,'--','DisplayName','tMax')

legend Location best%southeast


