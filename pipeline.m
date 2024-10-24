addpath('E:\Scaling-Project\Code');
addpath('C:\Users\Yitong\Documents\GitHub\chromsome_velocity_analysis');
%%
clearvars;
loadMTrackCurrent;
%%
FrameTime = [3.78];
%% Build dictionary (input)
%cckeys = ["CC9";"CC10";"CC11";"CC12";"CC13"]; %%%%%
cckeys = ["CC10";"CC11";"CC12";"CC13"];
tvalues = {[1 100];[171 260];[351 460];[601 700]};
tdict = dictionary(cckeys,tvalues);
disp(tdict)
%%
% [~,edges,~] = histcounts(parentchild(:,1),'NumBins',5);
% cycles = discretize(frame_track,edges,'categorical',{'CC9','CC10', 'CC11', 'CC12', 'CC13'});
[~,edges,~] = histcounts(parentchild(:,1),'NumBins',4);
cycles = discretize(frame_track,edges,'categorical',{'CC10', 'CC11', 'CC12', 'CC13'});
%%
% cycles(1:3) = 'CC9';
% cycles(4:9) = 'CC10';
% cycles(10:16) = 'CC11';

%%
getChrMov;
% assignDistance;
%%
% temp = chrDist(15,:);
% temp(temp==0)=NaN;
% [cleanedData,outlierIndices,thresholdLow,thresholdHigh] = filloutliers(temp, ...
%     "linear","movmean",20,"ThresholdFactor",2);
% chrDist(15,:) = cleanedData;
%%
sumAnaphase;
%loadMTrackCurrent;
%% Remake distance table
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
for roc = 1:size(distanceAll,1) % roc = row of cycle (CC10-13)
    d = cell2mat(distanceAll{roc,:});%essentially distance_CC10..
    for i = 1:size(d,1)
        dd = d(i,:);

            if  roc == 1 || roc==2
            %[minD,maxD,tAO,tMax] = getAnaphase_CC10(dd,FrameTime);
            [minD,maxD,tAO,tMax] = getAnaphaseFixThold(dd,FrameTime,0.01,0.04,0.065);

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
close all;
plotAnaphase;
%%
% files_nls = dir([proj_dir filesep '*ch00*']);
% I_nls = loadtiff([proj_dir filesep files_nls.name]);
nls;
%%
sumNER; %tNER = getNERwMin(nnls,20); % Plot nls with in the function
%% fix NER
close all;
for roc =  3%1:length(cckeys) % roc = row of cycle (CC10-13)
    nls = cell2mat(nlsAll{roc,:});%essentially distance_CC10...
    % cc = cckeys(roc);
    % nls = cell2mat(nlsAll{cc,:});
    for i = 1:size(nls,1)
        nnls = nls(i,:);
        % tNER = getNER(nnls,20);
        tNER = getNER(nnls,20); % Plot nls with in the function
        title(sprintf('cc = %d,i = %d',(roc+9),i));
        tNERSum(roc,i) = tNER*FrameTime;
    end
end
%%
open('C:\Users\Yitong\Documents\GitHub\chromsome_velocity_analysis\recordGenotypeData.m');