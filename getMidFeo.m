%%
close all;
clear failures;
clear feo_mid;
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
    try
        for t =  tTrack(1):tTrack(end)
            if  t < frame_track(i)
                I0 = (I1(:,:,t)== parentchild(i,2));
                angle = aSplit(i);               
            else
                I0 = double(I1(:,:,t)== parentchild(i,3) + (I1(:,:,t)== parentchild(i,4))); %logical segmentation
                I0_convex = regionprops(I0,'ConvexImage');
                stats2 = regionprops(I0_convex.ConvexImage,'Orientation');
                angle = stats2.Orientation;
            end

            %a(i,t) = angle; 
            Ifeo = I_feo(:,:,t);
            I0_rot = imrotate(I0,-angle);
            Ifeo_rot = imrotate(Ifeo,-angle);
            centroid = regionprops(I0_rot,'Centroid');
            centroid = struct2array(centroid);
            bbox = [centroid(1)-15,centroid(2)-7,30,14]; % make a 2 micron(14 pix) slice along spindle axis
            imshow(I0_rot);
            hold on
             h = drawrectangle('Position',bbox);
             BW = createMask(h);
             Ifeo_rot_mask = double(Ifeo_rot) .* double(BW);
             feo_f = sum(Ifeo_rot_mask);
             feo_mid(i,1:31,t) = feo_f(round(centroid(1)-15):round(centroid(1)+15));
             hold off

            %chrDist(i,t) = find(sum(I0_rot),1,'last')-find(sum(I0_rot),1,'first');% find first
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