%%
addpath('C:\Users\Yitong\Documents\GitHub\chromsome_velocity_analysis');
%cckeys = ["CC10";"CC11";"CC12";"CC13";"CC9"]; %%%%%
%%
distanceAll = table;
for roc = 1:length(cckeys) %%fix not all four
    cc = cckeys(roc);
    tTrack = cell2mat(tdict(cc));
    if ~isnan(tTrack)
        distanceAll{cc,:} = {chrDist(find(cycles == cc),tTrack(1):tTrack(2))};
    end

end

%%
close all;
for roc =  1:size(distanceAll,1) % roc = row of cycle (CC10-13)
    d = cell2mat(distanceAll{roc,:});%essentially distance_CC10..
    for i = 1:size(d,1)
        dd = d(i,:);

        if  roc == 1 || roc==2 
           [minD,maxD,tAO,tMax] = getAnaphase_CC10(dd,FrameTime);
           % [minD,maxD,tAO,tMax] = getAnaphaseFixThold(dd,FrameTime,0.01,0.04,0.065);


        else
            %[minD,maxD,tAO,tMax] = getAnaphaseFixThold(dd,FrameTime,0.01,0.04,0.065);
            [minD,maxD,tAO,tMax] = getAnaphase(dd,FrameTime);
            %[minD,maxD,tAO,tMax] = getAnaphaseQuick(dd,FrameTime);
        end
        AD(roc,i) = tMax-tAO;
        v(roc,i) = (maxD-minD)/(tMax-tAO)/2;
        tMaxSum(roc,i) = tMax;
        tAOSum(roc,i) = tAO;
        maxDSum(roc,i) = maxD;

    end
end
%%
AD(find(AD==0))=NaN;%Due to different numbers of nuclei, AD and CM are not fullfilled matices;
%AD(find(AD>100))=NaN;%filter
v(isnan(AD))=NaN;%Remove AnaDur = 0 and ChrMov = 0;
tAOSum(isnan(AD))=NaN;
maxDSum(isnan(AD))=NaN;
tMaxSum(isnan(AD))=NaN;
%% Plot average speed against cycle
meanv = mean(v,2,'omitnan');
disp(meanv);
sev = std(v,0,2,'omitnan')./sqrt(sum(~isnan(v),2));
figure;
errorbar(1:length(meanv),meanv,sev)

%% Plot correlation by cycles
% 
ccmap6 = [5  80 91;
    48 151 164;
    255 170 50;
    240 100 73;
    ]/255;
% ccmap6 = [62 43 109;%%CC9
%     5  80 91;
%      48 151 164;
%      255 170 50;
%      240 100 73;
%      ]/255; 
figure
for roc = 1:size(distanceAll,1)
    scatter(AD(roc,:),v(roc,:),'filled','MarkerFaceColor',ccmap6(roc,:))
    hold on
end
legend('CC10','CC11','CC12','CC13','Location','NorthWest')
%legend('CC9','CC10','CC11','CC12','CC13','Location','NorthWest')

xlabel('Chromosome movement period (s)')
ylabel('Maximum chromosome distance (\mum)')
%%
figure
for roc = 1:size(distanceAll,1)
    scatter(maxDSum(roc,:),v(roc,:),'filled','MarkerFaceColor',ccmap6(roc,:))
    hold on
end
legend('CC10','CC11','CC12','CC13','Location','NorthWest')
%legend('CC9','CC10','CC11','CC12','CC13','Location','NorthWest')

ylabel('Chromosome velocity (\mum/s)')
xlabel('Maximum chromosome distance (\mum)')
%xlim([10 24]);
%ylim([0.06 0.2]);
axis padded;
%title('WT')
config_plot4;
ax.XLabel.FontSize = 22;
%ax.XLabel.FontWeight = 'bold';
ax.YLabel.FontSize = 22;
%ax.YLabel.FontWeight = 'bold';



% get handles
f = gcf; ax = gca;
%
legend_f = findobj(f.Children,'Type','Legend');
if ~isempty(legend_f)
    %set(legend_f,'color', 'none','location','northeast','box','off','fontsize', 18);
    set(legend_f,'color', 'none','box','off','location','northeastoutside','fontsize', 18);
end
% scaling
f.Position(3)         = 700;
f.Position(4)         = 500;
xlim([10 24])
xticks(10:2:24)
ylim([0.03 0.12])