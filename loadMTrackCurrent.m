clearvars; close all;
addpath('C:\Users\Yitong\Documents\GitHub\chromsome_velocity_analysis');
current_directory = strsplit(pwd, '\');
date = current_directory{end-1};
series =current_directory{end};
fprintf('load manual tracking: %s / %s \n', date, series)
%% Manually define time interval
%FrameTime = []; %3.800
%FrameTime = 2.52;%3.780; %3.800
%% load tracking file in hdf5
proj_dir = strcat('..\..\..\', date, '\', series);
files1 = dir([proj_dir filesep '*Manual Tracking.h5']);
%files1 = dir([proj_dir filesep '*Tracking-Result.h5']);
%% Extract hdf5 file
tstart = 1;
datainfo = h5info([proj_dir filesep files1.name],'/exported_data');
tend = datainfo.Dataspace.Size(end);
%tend = 200;
trkData = h5read([proj_dir filesep files1.name],'/exported_data');
trkData = squeeze(trkData);
%% Load images into a matrix
% I1 is a 500*800*t matrix
I1 = permute(trkData,[2,1,3]); 
%% Load divsion file
parentchild = readmatrix([proj_dir filesep 'divisions.csv']);
frame_track = parentchild(:,1)+2;
%% Load NLS data
addpath('E:\Scaling-Project\Code');
% files_nls = dir([proj_dir filesep '*ch00*']);
% I_nls = loadtiff([proj_dir filesep files_nls.name]);
%% Build dictionary (input)
%cckeys = ["CC9";"CC10";"CC11";"CC12";"CC13"]; %%%%%
% cckeys = ["CC10";"CC11";"CC12";"CC13"];
% tvalues = {[21 110];[161 240];[321 410];[541 650]};
% tdict = dictionary(cckeys,tvalues);
% disp(tdict)

 %%
 for t = tstart:tend
    imagesc(double(I1(:,:,t)))
    colormap(colorcube)
    clim([0 300])
    Division(t) = getframe(gcf);
 end
 close;
%%
implay(Division);
%%
 n_track = size(parentchild,1);
% [~,edges,~] = histcounts(parentchild(:,1),'NumBins',5);
% cycles = discretize(frame_track,edges,'categorical',{'CC9','CC10', 'CC11', 'CC12', 'CC13'});
% [~,edges,~] = histcounts(parentchild(:,1),'NumBins',4);
% cycles = discretize(frame_track,edges,'categorical',{'CC10', 'CC11', 'CC12', 'CC13'});
%ccCatergoties = categorical({'CC9','CC10', 'CC11', 'CC12', 'CC13'});
% [~,edges,~] = histcounts(parentchild(:,1),'NumBins',3);
% cycles = discretize(frame_track,edges,'categorical',{'CC11', 'CC12', 'CC13'});
%%
clear Division;
clear trkData;
%% Save workspace
save('mTrackData.mat');