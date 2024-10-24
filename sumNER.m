%load('nlsAll.mat');
%load('nlsData.mat', 'nlsAll');
%load('nlsAll2.mat');
%% find change in nls，roc 4 i 4 nls incomplete
close all;
for roc =  1:length(cckeys) % roc = row of cycle (CC10-13)
    nls = cell2mat(nlsAll{roc,:});%essentially distance_CC10...
    % cc = cckeys(roc);
    % nls = cell2mat(nlsAll{cc,:});
    for i = 1:size(nls,1)
        nnls = nls(i,:);
        % tNER = getNER(nnls,20);
        tNER = getNERwMin(nnls,20); % Plot nls with in the function
        title(sprintf('cc = %d,i = %d',(roc+9),i));
        tNERSum(roc,i) = tNER*FrameTime;
    end
end
%%
close all;
tNERSum(find(tNERSum == 0)) = NaN;
%%
% temp = tNERSum'*FrameTime;
% temp2 = temp(:);
% temp2 = nonzeros(temp2);
% temp2 = rmmissing(temp2);

%% plot cycle by cylcle, record NEB, Anaphase onset, Chromosome distance,NER manually
%close all;
for roc =  1:length(cckeys)%:4 % roc = row of cycle (CC10-13)
    d = cell2mat(distanceAll{roc,:});%essentially distance_CC10...
    nls = cell2mat(nlsAll{roc,:});
    for i = 1:size(d,1)
        dd = d(i,:);% FrameTime
        nn = nls(i,:);
        figure
        yyaxis left
        plot(dd) 
       
        yyaxis right
        plot(nn)
        hold on
        xline(tAOSum(roc,i)/FrameTime)
        xline(tNERSum(roc,i)/FrameTime,'--')

        title(sprintf('cc = %d,i = %d',(roc+9),i))
%pause
    end
end


