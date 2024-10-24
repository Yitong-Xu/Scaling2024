%clearvars;
%load("mTrackData.mat");
%%
%FrameTime = 2.558;
 %%
%  for t = tstart:tend
%     imagesc(double(I1(:,:,t)))
%     colormap(colorcube)
%     clim([0 300])
%     Division(t) = getframe(gcf);
%  end
%  close;
% %%
% implay(Division); 
% 
% %% Build dictionary (input)
% cckeys = ["CC9";"CC10";"CC11";"CC12";"CC13";]; %%%%%
% tvalues = {[NaN];[1 80];[121 200];[281 360];[491 560]};
% tdict = dictionary(cckeys,tvalues);
% disp(tdict)
% %%
% n_track = size(parentchild,1);
% % [~,edges,~] = histcounts(parentchild(:,1),'NumBins',5);
% % cycles = discretize(frame_track,edges,'categorical',{'CC9','CC10', 'CC11', 'CC12', 'CC13'});
% [~,edges,~] = histcounts(parentchild(:,1),'NumBins',4);
% cycles = discretize(frame_track,edges,'categorical',{'CC10','CC11', 'CC12', 'CC13'});
% %%
close all;
clear failures;
tic
failures = struct('iter', {},'time',{}, 'str', {});
for i = 1:n_track
    %try
    cc = string(cycles(i));
    tTrack = cell2mat(tdict(cc));
    t = frame_track(i);
    I0 = double(I1(:,:,t)== parentchild(i,3) + (I1(:,:,t)== parentchild(i,4)));

    I0_convex = regionprops(I0,'ConvexImage');
    stats = regionprops(I0_convex.ConvexImage,'Orientation');
    aSplit(i) = stats.Orientation;
    % fprintf('i = %d\n',i);
    % fprintf('Cycle = %s\n',cc);
    % fprintf('Frame of Split = %d\n',t);
    % fprintf('angle = %f\n',aSplit(i));
    try
        for t = tTrack(1):tTrack(end)
            if  t < frame_track(i)
                I0 = (I1(:,:,t)== parentchild(i,2));
                angle = aSplit(i);
            else
                I0 = double(I1(:,:,t)== parentchild(i,3) + (I1(:,:,t)== parentchild(i,4))); %logical segmentation
                I0_convex = regionprops(I0,'ConvexImage');
                stats2 = regionprops(I0_convex.ConvexImage,'Orientation');
                angle = stats2.Orientation;
            end
            a(i,t) = angle;
            I0_rot = imrotate(I0,-angle);
            chrDist(i,t) = find(sum(I0_rot),1,'last')-find(sum(I0_rot),1,'first');% find first
            %imshow(I0_rot);
            %pause;

        end

        fprintf('Finish:i = %d t = %d\n\n', i,t);
    catch ME
        %rethrow(ME);
        disp(ME.message);
        fprintf('Error:i = %d, cycle = %s, t = %d\n\n', i,cc,t);
        failures(end + 1).iter = i;
        failures(end).time = t;
        failures(end).str  = getReport(ME);

    end

end

disp('distance complete!')
toc
%% Check distance
figure;
plot(1:size(chrDist,2),chrDist);