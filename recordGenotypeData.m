%%
clear gd;
%gd = genotypeData;
gd.genotype = 'Klp61F_2';
%%
% load('mTrackData.mat');
% load('analysis.mat')
% %% Build dictionary (input)
% cckeys = ["CC10";"CC11";"CC12";"CC13";"CC9"]; %%%%%
% tvalues = {[NaN];[121 301];[302 531];[625 819];[NaN]};
% tdict = dictionary(cckeys,tvalues);
% disp(tdict);
% %% Add CC10
% %ccCatergoties = categorical({'CC9','CC10', 'CC11', 'CC12', 'CC13'});
% cycles = [repmat(("CC10"),9,1);string(cycles)];
% %%
% cycles = categorical(cycles);
%cycles = [repmat("CC10",4,1);repmat("CC11",5,1);repmat("CC12",16,1);repmat("CC13",27,1)];%%
%files1 = files;
%%
gd.movie = files1.folder;
gd.frametime = FrameTime;
gd.tdict = tdict;
gd.cycles = cycles;
%gd.distance = distance;

gd.distance = chrDist;
gd.distanceAll = distanceAll;

% gd.nls = aveNLS;
% gd.nlsAll = nlsAll;


% gd.midfeo = feo_mid;
% gd.meanfeo = mean_feo_mid;
% gd.feoSlope = feoSlope_sum';
%%
gd.meanv = meanv;
gd.sev = sev;
gd.tAO = rmmissing(reshape(tAOSum',[],1));
gd.tMax = rmmissing(reshape(tMaxSum',[],1));
gd.anaDur2 = rmmissing(reshape(AD',[],1)); 
gd.maxD = rmmissing(reshape(maxDSum',[],1));
gd.v = rmmissing(reshape(v',[],1));

% gd.tNER = rmmissing(reshape(tNERSum',[],1));
% gd.tNER = rmmissing(reshape(tNERSum',[],1));
% gd.anaRate = 1./(gd.tNER-gd.tAO);
%%
Klp61F_2 = gd; %%
disp(gd);
%%
save('/Users/yitongxu/Documents/GitHub/chromsome_velocity_analysis/Data/v_sum.mat','Klp61F_2','-append');
%save('/Users/yitongxu/Documents/GitHub/chromsome_velocity_analysis/Data/anaRate_sum_short.mat','Klp59C-2','-append');
%save('/Users/yitongxu/Documents/GitHub/chromsome_velocity_analysis/Data/anaRate_sum_new.mat','Klp59C-2','-append');
%save('C:\Users\Yitong\Documents\GitHub\chromsome_velocity_analysis\Data\anaRate_sum.mat','WT_nls');
%save('C:\Users\Yitong\Documents\GitHub\chromsome_velocity_analysis\Data\v_sum.mat','Klp10A_het');
%save('C:\Users\Yitong\Documents\GitHub\chromsome_velocity_analysis\Data\v_sum.mat','Klp10A_nls2','-append');%%
%save('C:\Users\Yitong\Documents\GitHub\chromsome_velocity_analysis\Data\anaRate_sum_short.mat','Klp10A_nls2','-append');%%
%save('C:\Users\Yitong\Documents\GitHub\chromsome_velocity_analysis\Data\feo_sum.mat','twsP_feo2','-append');