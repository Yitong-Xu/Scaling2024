%%
% clearvars;
% load('mTrackData.mat');
%%
% addpath('E:\Scaling-Project\Code');
% files_nls = dir([proj_dir filesep '*ch00*']);
% I_nls = loadtiff([proj_dir filesep files_nls.name]);
%%
total_nls = sum(sum(I_nls));
%% Check for Z adjustment
figure;
plot(squeeze(total_nls));
title('total NLS')
%%  tiaoshi
for i = 1:n_track
    cc = string(cycles(i));
    tTrack = cell2mat(tdict(cc));
    for t = tTrack(1):tTrack(end)
        I = I_nls(:,:,t);

        if  t < frame_track(i)
            I0 = (I1(:,:,t)== parentchild(i,2));% I0-segmentation for single nucleus
            %imshow(I0);

        elseif frame_track(i)<= t
            I0 = logical(I1(:,:,t)== parentchild(i,3) + (I1(:,:,t)== parentchild(i,4))); %logical segmentation
            %imshow(I0);
        end

        stats = regionprops(I0);
        if length(stats) == 2
            nucArea = stats(1).Area + stats(2).Area;
        elseif length(stats) == 1
            nucArea = stats.Area;
        else
            fprintf('Error:i = %d, cycle = %s, t = %d\n', i,cc,t);
            break;
        end
        nucNLS = sum(double(I0).* double(I),'all');
        aveNLS(i,t) = nucNLS/ nucArea;
        clear I I0 stats nucArea nucNLS
    end

    fprintf('Finish:i = %d t = %d\n\n', i,t);

end



%%
%load('distance_sum.mat');
% distance2 = distance;
%aveNLS(26,:)= [];
%%
figure;
yyaxis left
plot(1:length(chrDist),chrDist);
%colororder(lines);

yyaxis right
plot(1:length(aveNLS),aveNLS);

%%
nlsAll = table;
for roc = 1:length(cckeys) %%fix not all four
    cc = cckeys(roc);
    tTrack = cell2mat(tdict(cc));
    if ~isnan(tTrack)
        %distanceAll{cc,:} = {distance2(find(cycles == cc),tTrack(1):tTrack(2))};
        nlsAll{cc,:} = {aveNLS(find(cycles == cc),tTrack(1):(tTrack(2)))}; %% fix here
    end

end
%%
save('nlsData.mat','I_nls',"nlsAll");