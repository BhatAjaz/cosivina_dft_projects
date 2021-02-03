nObjects = 12; %%total number of objects
%maxTR = ; %defined dynamically as sum of  early and late trials % total # of training trials
maxTRt = nObjects; % total # of test trials
t_max = floor((8000+1000)/scale_factor); %specify simulation time  % scale with Experiment training trial Duration   
t_maxt = floor((1000+1000)/scale_factor); %specify simulation time  % scale with Experiment test trial Duration

handle_historyL=sim.getElement('history lookL'); %reset lookingduration history variable                 
handle_historyL.timeSlots = t_max; 
handle_historyR=sim.getElement('history lookR');                       
handle_historyR.timeSlots = t_max; 
handle_historyLWB=sim.getElement('history lookLWB'); %reset lookingduration history variable                 
handle_historyLWB.timeSlots = t_max; 
handle_historyRWB=sim.getElement('history lookRWB');                       
handle_historyRWB.timeSlots = t_max; 
handle_historyC=sim.getElement('history lookC');                       
handle_historyC.timeSlots = t_max; 

handle_historyLt=sim.getElement('history lookLt');                       
handle_historyLt.timeSlots = t_maxt; 
handle_historyRt=sim.getElement('history lookRt');                       
handle_historyRt.timeSlots = t_maxt;
handle_historyLWBt=sim.getElement('history lookLWBt'); %reset lookingduration history variable                 
handle_historyLWBt.timeSlots = t_maxt; 
handle_historyRWBt=sim.getElement('history lookRWBt');                       
handle_historyRWBt.timeSlots = t_maxt; 
handle_historyCt=sim.getElement('history lookCt');                       
handle_historyCt.timeSlots = t_maxt;

if (mode == 1 )      
        gui.init();
        delete(gui.visualizations{1}.axesHandle);
        gui.visualizations{1}.axesProperties{2} = [-t_max, 10];
        gui.visualizations{1}.plotProperties{1}{end} = 0:-1:-t_max+1;
        gui.visualizations{1}.plotProperties{2}{end} = 0:-1:-t_max+1;
        gui.visualizations{1}.plotProperties{3}{end} = 0:-1:-t_max+1;
        gui.visualizations{1}.plotProperties{4}{end} = 0:-1:-t_max+1;
        gui.visualizations{1}.plotProperties{5}{end} = 0:-1:-t_max+1;        
        gui.visualizations{1}.init(gui.figureHandle);
end
for subject = 1:numSubjects
         
    sim2 = 5;
    if (mode == 1 )             
        sim2 = sim;
    elseif (mode == 0)
        sim2 = sim;
    elseif (mode == 2)
        sim2 = sim.copy();
    end
    
    visuals_On = 0;
    visuals_Off = floor(8000/scale_factor);
    word1_On  = floor(2000/scale_factor);
    word1_Off = floor(3000/scale_factor);
    word2_On  = floor(5000/scale_factor);
    word2_Off = floor(6000/scale_factor);
    %% DESIGN OBJECTS, FEARTURES and WORDS through random permutations
    Feature=[]; 
    Words=[]; 
    for j=1:nFeatures
        chosen_indices = randperm(size(Property{j},2),nObjects);
        TempFe=[];
        for i=1:nObjects
            %TempFe = [TempFe  Property{j}(chosen_indices(i))];
            TempFe = [TempFe  Property{j}(i)];
        end
        Feature{j}=TempFe;
    end
    % Choose Words to associate on random
    chosen_indices = randperm(size(Names,2),nObjects);
    for i=1:nObjects
        %Words = [Words  Names(chosen_indices(i))];
        Words = [Words  Names(i)];
    end
    EarlyLateSeq= randperm(nObjects);
    block1=EarlyLateSeq(1:nObjects/2);
    blockX=EarlyLateSeq((nObjects/2)+1:nObjects);
    LCond=3;
    ECond=4;
    iteration=mod(subject,LCond*ECond);       
    %% LATE TRIALS
    lateList=[];
    if ismember(iteration, [0,4,7,10]) %late pair 3 times
        lateSeq3=[block1' blockX'; blockX' block1'; block1' blockX';];
        for trs=1:size(lateSeq3,1)%add words
                if rand>0.5 
                    lateList(trs,:)=[lateSeq3(trs,1) lateSeq3(trs,2) lateSeq3(trs,1) lateSeq3(trs,2)];
                else
                    lateList(trs,:)=[lateSeq3(trs,1) lateSeq3(trs,2) lateSeq3(trs,2) lateSeq3(trs,1)];
                end
        end
    elseif  ismember(iteration, [2,5,8,11]) % late pair 6 times
        lateSeq6=[block1' blockX'; blockX' block1'; block1' blockX'; blockX' block1'; block1' blockX'; blockX' block1';];
        for trs=1:size(lateSeq6,1)
                if rand>0.5 
                    lateList(trs,:)=[lateSeq6(trs,1) lateSeq6(trs,2) lateSeq6(trs,1) lateSeq6(trs,2)];
                else
                    lateList(trs,:)=[lateSeq6(trs,1) lateSeq6(trs,2) lateSeq6(trs,2) lateSeq6(trs,1)];
                end
        end
    elseif  ismember(iteration, [3,6,9,1]) % late pair 9 times
        lateSeq9=[block1' blockX'; blockX' block1'; block1' blockX'; blockX' block1'; block1' blockX'; blockX' block1'; block1' blockX'; blockX' block1'; block1' blockX';];
        for trs=1:size(lateSeq9,1)
                if rand>0.5 
                    lateList(trs,:)=[lateSeq9(trs,1) lateSeq9(trs,2) lateSeq9(trs,1) lateSeq9(trs,2)];
                else
                    lateList(trs,:)=[lateSeq9(trs,1) lateSeq9(trs,2) lateSeq9(trs,2) lateSeq9(trs,1)];
                end
        end
    end    

    %% EARLY TRIALS
    earlyList=[];
    if  ismember(iteration, [0,5,9]) 
        %% 0 early trials
        earlyList=[];
    elseif   ismember(iteration, [2,6,10]) 
        block2=[];
        %% 9 trials, Each objects appears 3 times                  
        for b1=1:nObjects/2
            ind2=mod(b1+5,nObjects/2); %shift index by 5
            if ind2==0; ind2=nObjects/2; end
            block2(b1)=block1(ind2);
        end
        trialSeq=[];
        trialSeq= [block1' block2';  block1(1) block1(4); block1(2) block1(5); block1(3) block1(6);]
        for trs=1:size(trialSeq,1)
            if rand>0.5 
                earlyList(trs,:)=[trialSeq(trs,1) trialSeq(trs,2) trialSeq(trs,1) trialSeq(trs,2)];
            else
                earlyList(trs,:)=[trialSeq(trs,1) trialSeq(trs,2) trialSeq(trs,2) trialSeq(trs,1)];
            end
        end

    elseif   ismember(iteration, [3,7,11]) 
        block2=[];block3=[];
         %% 18 trials, Each object appears 6 times
        for b1=1:nObjects/2
            ind2=mod(b1+1,nObjects/2);
            ind3=mod(b1+3,nObjects/2);
            if ind2==0; ind2=nObjects/2; end
            if ind3==0; ind3=nObjects/2; end
            block2(b1)=block1(ind2);
            block3(b1)=block1(ind3);
        end
        trialSeq= [block1' block2';  block2' block3';   block3' block1'];
        for trs=1:size(trialSeq,1)
            if rand>0.5 
                earlyList(trs,:)=[trialSeq(trs,1) trialSeq(trs,2) trialSeq(trs,1) trialSeq(trs,2)];
            else
                earlyList(trs,:)=[trialSeq(trs,1) trialSeq(trs,2) trialSeq(trs,2) trialSeq(trs,1)];
            end
        end

    elseif   ismember(iteration, [4,8,1]) 
        block2=[];block3=[];
         %% 27 trials, Each object appears 9 times 
        for b1=1:nObjects/2
            ind2=mod(b1+1,nObjects/2);
            ind3=mod(b1+3,nObjects/2);
            if ind2==0; ind2=nObjects/2; end
            if ind3==0; ind3=nObjects/2; end
            block2(b1)=block1(ind2);
            block3(b1)=block1(ind3);
        end
        trialSeq= [block1' block2';  block2' block3';   block3' block1'];
        %earlyList=zeros(size(trialSeq,1),4);
        for trs=1:size(trialSeq,1)
            if rand>0.5 
                earlyList(trs,:)=[trialSeq(trs,1) trialSeq(trs,2) trialSeq(trs,1) trialSeq(trs,2)];
            else
                earlyList(trs,:)=[trialSeq(trs,1) trialSeq(trs,2) trialSeq(trs,2) trialSeq(trs,1)];
            end
        end
        for b1=1:nObjects/2
            ind2=mod(b1+5,nObjects/2);
            if ind2==0; ind2=nObjects/2; end
            block2(b1)=block1(ind2);
        end
        trialSeq=[];
        trialSeq= [block1' block2';  block1(1) block1(3); block1(2) block1(4); block1(5) block1(6);];
        prev=size(earlyList,1);
        for trs=1:size(trialSeq,1)
            if rand>0.5 
                earlyList(prev+trs,:)=[trialSeq(trs,1) trialSeq(trs,2) trialSeq(trs,1) trialSeq(trs,2)];
            else
                earlyList(prev+trs,:)=[trialSeq(trs,1) trialSeq(trs,2) trialSeq(trs,2) trialSeq(trs,1)];
            end
        end
    end
    % now i got to randomise lateList & earlyList presentation and run earlylist
    % followed by latelist
    lateList_rand = lateList(randperm(size(lateList,1)),:);
    earlyList_rand = earlyList(randperm(size(earlyList,1)),:);
    %seqLate=randperm(size(lateList,1));
    %seqEarly=randperm(size(earlyList,1));
    maxTR = size(lateList_rand,1)+ size(earlyList_rand,1);
    for i = 1 : nFeatures
        n=num2str(i);
        handle_hcon_f{subject}(i)=sim2.getElement(['hcon_f' n]);
        handle_hwm_f{subject}(i)=sim2.getElement(['hwm_f' n]);
        handle_hwf{subject}(i)=sim2.getElement(['hwf' n]);
        handle_hwm_c{subject}(i)=sim2.getElement(['hwm_c' n]);       
    end
    handle_hcon_s{subject}=sim2.getElement('hcon_s');
    handle_hwm_s{subject}=sim2.getElement('hwm_s');
    handle_hword{subject}=sim2.getElement('hword');

    savestate_hcon_f{subject}=zeros(nFeatures,fieldSize_ftr);
    savestate_hwm_f{subject}=zeros(nFeatures,fieldSize_ftr);
    savestate_hwf{subject}=zeros(nFeatures,fieldSize_ftr,fieldSize_wd);
    savestate_hwm_c{subject}=zeros(nFeatures,fieldSize_ftr,fieldSize_spt);
    savestate_hcon_s{subject}=zeros(fieldSize_spt);
    savestate_hwm_s{subject}=zeros(fieldSize_spt);
    savestate_hword{subject}=zeros(fieldSize_wd);
    savestate_historyL{subject}=zeros(maxTR,t_max);
    savestate_historyR{subject}=zeros(maxTR,t_max);
    %Sequence{subject}=EarlyLateSeq; %zeros(nObjects,1);
    training_pair{subject}=zeros(maxTR,size(lateList_rand,2));%
    %% RUN EARLY TRAINING TRIALS
    if (size(earlyList_rand,1)>1)
    for tr=1:size(earlyList_rand,1)
        %sim2.init();
        sim2.t =sim2.tZero;
        pos = tr; % Finds postion of a random tuple
        training_pair{subject}(tr,:)= earlyList_rand(pos,:);
        if tr > 1 
            for i = 1 : nFeatures
                n=num2str(i);
                handle_hcon_f{subject}(i).output = squeeze(savestate_hcon_f{subject}(i,:));
                handle_hwm_f{subject}(i).output = squeeze(savestate_hwm_f{subject}(i,:));
                handle_hwf{subject}(i).output = squeeze(savestate_hwf{subject}(i,:,:));
                handle_hwm_c{subject}(i).output = squeeze(savestate_hwm_c{subject}(i,:,:));
            end
            handle_hcon_s{subject}.output = savestate_hcon_s{subject};
            handle_hwm_s{subject}.output = savestate_hwm_s{subject};
            handle_hword{subject}.output = savestate_hword{subject};
        end

        while sim2.t <= t_max

            t = sim2.t;
            % STEP 1 Add sesame attention 3 second for first 4 trials
            if t == visuals_On
                for f=1:nFeatures

                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... % set feature dimension value
                        strcat('Feature_',num2str(f),'_Right')},{'positionY', 'positionY'}, ...
                        {cell2mat(Feature{f}(earlyList_rand(pos,1))),cell2mat(Feature{f}(earlyList_rand(pos,2)))});                    

                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... % set spatial dimension value
                        strcat('Feature_',num2str(f),'_Right')}, ...
                         {'positionX', 'positionX'}, {spt_L,spt_R});

                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... % set stimuli /signal strength
                        strcat('Feature_',num2str(f),'_Right')}, ...
                         {'amplitude', 'amplitude'}, vstrength * ones(1, 2));                     
                end
            end
            if t == word1_On 
                wrd1 = 2*nFeatures+1;
                sim2.setElementParameters({'Word_Label_1'}, {'position','amplitude'},... 
                    {cell2mat(Words((earlyList_rand(pos,3)))),wstrength});
            end
            if t == word1_Off
                wrd1 = 2*nFeatures+1;
                sim2.setElementParameters({'Word_Label_1'}, {'position','amplitude'},... 
                    {cell2mat(Words((earlyList_rand(pos,3)))),0});
            end
            if t == word2_On
                wrd2 = 2*nFeatures+2;
                sim2.setElementParameters({'Word_Label_2'}, {'position','amplitude'},... 
                    {cell2mat(Words((earlyList_rand(pos,4)))),wstrength});
            end
            if t == word2_Off
                wrd2 = 2*nFeatures+2;
                sim2.setElementParameters({'Word_Label_2'}, {'position','amplitude'},... 
                    {cell2mat(Words((earlyList_rand(pos,4)))),0});
            end

            if t == visuals_Off
                for f=1:nFeatures
                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... 
                        strcat('Feature_',num2str(f),'_Right')}, ...
                         {'amplitude', 'amplitude'}, 0 * ones(1, 2));% stop left right stimuli

                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... 
                        strcat('Feature_',num2str(f),'_Right')}, ...
                        {'positionY', 'positionY'},{0,0}); % Unset feature dimension value

                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... 
                        strcat('Feature_',num2str(f),'_Right')}, ...
                         {'positionX', 'positionX'}, {0,0});% Unset spatial dimension value
                end
            end
            
            if isalmost(t, t_max,tolerance)
                for i = 1 : nFeatures
                    n=num2str(i);
                    savestate_hcon_f{subject}(i,:) = sim2.getComponent(['hcon_f' n], 'output');
                    savestate_hwm_f{subject}(i,:) = sim2.getComponent(['hwm_f' n], 'output');
                    savestate_hwf{subject}(i,:,:) = sim2.getComponent(['hwf' n], 'output');
                    savestate_hwm_c{subject}(i,:,:) = sim2.getComponent(['hwm_c' n], 'output');
                end
                 savestate_hcon_s{subject} = sim2.getComponent('hcon_s', 'output');
                 savestate_hwm_s{subject} = sim2.getComponent('hwm_s', 'output');
                 savestate_hword{subject} = sim2.getComponent('hword', 'output');
                 savestate_historyL{subject}(tr,:) = flipud(sim2.getComponent('history lookL', 'output'));
                 savestate_historyR{subject}(tr,:) =flipud(sim2.getComponent('history lookR', 'output'));
            end

           if (mode == 1) && (mod(t,gui_speed)==0)
                if ~gui.pauseSimulation
                    sim2.step();
                end
                if gui.quitSimulation
                    gui.close();
                    break;
                end             
                gui.step();
                %gui.checkAndUpdateControls();
                %gui.updateVisualizations();                  
           else
                sim2.step();
           end
        end % Time sim.t
    end
    end % Trial EARLY trials loop
    e_len=size(earlyList_rand,1);
    %% RUN LATE TRAINING TRIALS
    if (mode == 1), tts('Late Trials start now','Microsoft Hazel Desktop - English (Great Britain)'),end 
    for tr=1:size(lateList_rand,1)
        %sim2.init();
        sim2.t =sim2.tZero;
        pos = tr % Finds postion of a random tuple
        training_pair{subject}(e_len+tr,:)= lateList_rand(pos,:);
        if ((size(earlyList_rand,1)>1) || (tr > 1))% if previously run early trials or at least first late trial
            for i = 1 : nFeatures
                n=num2str(i);
                handle_hcon_f{subject}(i).output = squeeze(savestate_hcon_f{subject}(i,:));
                handle_hwm_f{subject}(i).output = squeeze(savestate_hwm_f{subject}(i,:));
                handle_hwf{subject}(i).output = squeeze(savestate_hwf{subject}(i,:,:));
                handle_hwm_c{subject}(i).output = squeeze(savestate_hwm_c{subject}(i,:,:));
            end
            handle_hcon_s{subject}.output = savestate_hcon_s{subject};
            handle_hwm_s{subject}.output = savestate_hwm_s{subject};
            handle_hword{subject}.output = savestate_hword{subject};
        end

        while sim2.t <= t_max

            t = sim2.t;
            % STEP 1 Add sesame attention 3 second for first 4 trials
            if t == visuals_On
                for f=1:nFeatures
                    
                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... % set feature dimension value
                        strcat('Feature_',num2str(f),'_Right')},{'positionY', 'positionY'}, ...
                        {cell2mat(Feature{f}(lateList_rand(pos,1))),cell2mat(Feature{f}(lateList_rand(pos,2)))});                

                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... % set spatial dimension value
                        strcat('Feature_',num2str(f),'_Right')}, ...
                         {'positionX', 'positionX'}, {spt_L,spt_R});

                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... % set left right stimuli up
                        strcat('Feature_',num2str(f),'_Right')}, ...
                         {'amplitude', 'amplitude'}, vstrength * ones(1, 2));                     
                end
            end
            if t == word1_On 
                wrd1 = 2*nFeatures+1;
                sim2.setElementParameters({'Word_Label_1'}, {'position','amplitude'},... 
                    {cell2mat(Words((lateList_rand(pos,3)))),wstrength});
            end
            if t == word1_Off
                wrd1 = 2*nFeatures+1;
                sim2.setElementParameters({'Word_Label_1'}, {'position','amplitude'},... 
                    {cell2mat(Words((lateList_rand(pos,3)))),0});
            end
            if t == word2_On
                wrd2 = 2*nFeatures+2;
                sim2.setElementParameters({'Word_Label_2'}, {'position','amplitude'},... 
                    {cell2mat(Words((lateList_rand(pos,4)))),wstrength});
            end
            if t == word2_Off
                wrd2 = 2*nFeatures+2;
                sim2.setElementParameters({'Word_Label_2'}, {'position','amplitude'},... 
                    {cell2mat(Words((lateList_rand(pos,4)))),0});
            end

            if t == visuals_Off

                for f=1:nFeatures
                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... 
                        strcat('Feature_',num2str(f),'_Right')}, ...
                         {'amplitude', 'amplitude'}, 0 * ones(1, 2));% stop left right stimuli

                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... 
                        strcat('Feature_',num2str(f),'_Right')}, ...
                        {'positionY', 'positionY'},{0,0}); % Unset feature dimension value

                    sim2.setElementParameters({ strcat('Feature_',num2str(f),'_Left'), ... 
                        strcat('Feature_',num2str(f),'_Right')}, ...
                         {'positionX', 'positionX'}, {0,0});% Unset spatial dimension value
                end
            end
            
            if isalmost(t, t_max,tolerance)
                for i = 1 : nFeatures
                    n=num2str(i);
                    savestate_hcon_f{subject}(i,:) = sim2.getComponent(['hcon_f' n], 'output');
                    savestate_hwm_f{subject}(i,:) = sim2.getComponent(['hwm_f' n], 'output');
                    savestate_hwf{subject}(i,:,:) = sim2.getComponent(['hwf' n], 'output');
                    savestate_hwm_c{subject}(i,:,:) = sim2.getComponent(['hwm_c' n], 'output');
                end
                 savestate_hcon_s{subject} = sim2.getComponent('hcon_s', 'output');
                 savestate_hwm_s{subject} = sim2.getComponent('hwm_s', 'output');
                 savestate_hword{subject} = sim2.getComponent('hword', 'output');
                 savestate_historyL{subject}(e_len+tr,:) = flipud(sim2.getComponent('history lookL', 'output'));
                 savestate_historyR{subject}(e_len+tr,:) =flipud(sim2.getComponent('history lookR', 'output'));
            end

           if (mode == 1) && (mod(t,gui_speed)==0)
                if ~gui.pauseSimulation
                    sim2.step();
                end
                if gui.quitSimulation
                    gui.close();
                    break;
                end             
                gui.step();
                %gui.checkAndUpdateControls();
                %gui.updateVisualizations();                  
           else
                sim2.step();
           end
        end % Time sim.t
    end % Trial LATE trials loop
     OutName = [simName,num2str(subject),'_train.mat'];
     matTrain=matfile(OutName,'writable',true);
%     matTrain.hcon_f = savestate_hcon_f{subject};
     matTrain.hwm_f = savestate_hwm_f{subject};
%     matTrain.hwm_c = savestate_hwm_c{subject};
%     matTrain.hwf = savestate_hwf{subject};
%     matTrain.hcon_s = savestate_hcon_s{subject};
%     matTrain.hwm_s = savestate_hwm_s{subject};
%     matTrain.hword = savestate_hword{subject};
% 
%     matTrain.historyL = savestate_historyL{subject};
%     matTrain.historyR = savestate_historyR{subject};
%     matTrain.training_pair = training_pair{subject};
     matTrain.Feature1 = Feature{1};
     matTrain.Feature2 = Feature{2};
     matTrain.Words = Words;
    
    %% TEST TRIALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    visuals_On = 1;
    visuals_Off = floor(1000/scale_factor);
    word1_On  = 1;
    word1_Off  = floor(1000/scale_factor);
    %EarlyLateSeq=1:12;% randperm(nObjects);
    %block1=EarlyLateSeq(1:nObjects/2);
    %blockX=EarlyLateSeq((nObjects/2)+1:nObjects);
    Testseq=[];
    %%% testing quadrets for orignal mapping 
    for tseq=1:maxTRt
     % for tseq_th WORD
      %remove target n 2nd target to generate distractor list 
     if (tseq<=length(block1))
        disSet=EarlyLateSeq(EarlyLateSeq~=block1(tseq) & EarlyLateSeq~=blockX(tseq));
     else
         disSet=EarlyLateSeq(EarlyLateSeq~=block1(tseq-6) & EarlyLateSeq~=blockX(tseq-6));
     end
     dis3=disSet(randperm(length(disSet),3)); %pick 3 distractors
     indxr=randperm(4);
     for ds=1:3 Testseq(tseq,indxr(ds))=dis3(ds);end
     Testseq(tseq,indxr(4))=EarlyLateSeq(tseq);%object
     Testseq(tseq,5)=indxr(4);%location of target   
    end
    if (mode == 1), tts('Test Trials start now','Microsoft Hazel Desktop - English (Great Britain)'),end 
        %%% testing quadrets for late-paired-object mapping 
    for tseq=1:maxTRt
     % for tseq_th WORD
      %remove target n 2nd target from list
     if (tseq<=length(block1))
        disSet=EarlyLateSeq(EarlyLateSeq~=block1(tseq) & EarlyLateSeq~=blockX(tseq));
     else
         disSet=EarlyLateSeq(EarlyLateSeq~=block1(tseq-6) & EarlyLateSeq~=blockX(tseq-6));
     end
     dis3=disSet(randperm(length(disSet),3));
     indxr=randperm(4);
     for ds=1:3 Testseq(tseq+maxTRt,indxr(ds))=dis3(ds);end
     if (tseq<=length(block1))
        Testseq(tseq+maxTRt,indxr(4))=EarlyLateSeq(tseq+6);% paired object
     else
         Testseq(tseq+maxTRt,indxr(4))=EarlyLateSeq(tseq-6);% paired object
     end
     Testseq(tseq+maxTRt,5)=indxr(4);%location of target   
    end
    Testset{subject}=Testseq;
    %% RUN TEST TRIALS
    savestate_historyLt{subject}=zeros(2*maxTRt,t_maxt);
    savestate_historyRt{subject}=zeros(2*maxTRt,t_maxt);
    savestate_historyLWBt{subject}=zeros(2*maxTRt,t_maxt);
    savestate_historyRWBt{subject}=zeros(2*maxTRt,t_maxt);
    %TRIALS A- Correct Pairings
    for trt=1:maxTRt         
        %sim2.init();  
        sim2.t =sim2.tZero;
        for i = 1 : nFeatures
                n=num2str(i);
                handle_hcon_f{subject}(i).output = squeeze(savestate_hcon_f{subject}(i,:));
                handle_hwm_f{subject}(i).output = squeeze(savestate_hwm_f{subject}(i,:));
                handle_hwf{subject}(i).output = squeeze(savestate_hwf{subject}(i,:,:));
                handle_hwm_c{subject}(i).output = squeeze(savestate_hwm_c{subject}(i,:,:));
        end
        handle_hcon_s{subject}.output = savestate_hcon_s{subject};
        handle_hwm_s{subject}.output = savestate_hwm_s{subject};
        handle_hword{subject}.output = savestate_hword{subject};
        
        while sim2.t <= t_maxt

            t = sim2.t;
            
            if isalmost(t, word1_On,tolerance) 
                sim2.setElementParameters({'Word_Label_1'}, {'position','amplitude'},... 
                    {cell2mat(Words(EarlyLateSeq(trt))),wstrength});
            end
            if isalmost(t, visuals_On,tolerance)  
               
                for f=1:nFeatures
                    n=num2str(f);
                    
                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'positionY', 'positionY','positionY', 'positionY'}, ...
                        {cell2mat(Feature{f}(Testseq(trt,1))),cell2mat(Feature{f}(Testseq(trt,2))), ...
                        cell2mat(Feature{f}(Testseq(trt,3))),cell2mat(Feature{f}(Testseq(trt,4)))});                

                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'positionX', 'positionX','positionX', 'positionX'}, ...
                         {spt_L, spt_Lm, spt_Rm, spt_R});

                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'amplitude', 'amplitude','amplitude', 'amplitude'}, ...
                         { vstrength, vstrength, vstrength, vstrength }); 
                    
                end              
            end
           if isalmost(t, word1_Off,tolerance) 
                sim2.setElementParameters({'Word_Label_1'}, {'position','amplitude'},... 
                    {cell2mat(Words(EarlyLateSeq(trt))),0});
            end

            if isalmost(t, visuals_Off,tolerance)  
                
               for f=1:nFeatures
                    n=num2str(f);
                    
                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'positionY', 'positionY','positionY', 'positionY'}, ...
                        {cell2mat(Feature{f}(Testseq(trt,1))),cell2mat(Feature{f}(Testseq(trt,2))), ...
                        cell2mat(Feature{f}(Testseq(trt,3))),cell2mat(Feature{f}(Testseq(trt,4)))});                

                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'positionX', 'positionX','positionX', 'positionX'}, ...
                         {spt_L, spt_Lm, spt_Rm, spt_R});

                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'amplitude', 'amplitude','amplitude', 'amplitude'}, ...
                         { 0, 0, 0, 0}); 
                    
                end
            end
            if isalmost(t, t_maxt,tolerance)
               for i = 1 : nFeatures
                    n=num2str(i);
                    savestate_hcon_f{subject}(i,:) = sim2.getComponent(['hcon_f' n], 'output');
                    savestate_hwm_f{subject}(i,:) = sim2.getComponent(['hwm_f' n], 'output');
                    savestate_hwf{subject}(i,:,:) = sim2.getComponent(['hwf' n], 'output');
                    savestate_hwm_c{subject}(i,:,:) = sim2.getComponent(['hwm_c' n], 'output');
                end
                savestate_hcon_s{subject} = sim2.getComponent('hcon_s', 'output');
                savestate_hwm_s{subject} = sim2.getComponent('hwm_s', 'output');
                savestate_hword{subject} = sim2.getComponent('hword', 'output');
                savestate_historyLt{subject}(trt,:) = flipud(sim2.getComponent('history lookLt', 'output'));
                savestate_historyRt{subject}(trt,:) = flipud(sim2.getComponent('history lookRt', 'output'));
                savestate_historyLWBt{subject}(trt,:) = flipud(sim2.getComponent('history lookLWBt', 'output'));
                savestate_historyRWBt{subject}(trt,:) = flipud(sim2.getComponent('history lookRWBt', 'output'));
            end

           if (mode == 1) && (mod(t,gui_speed)==0)
                if ~gui.pauseSimulation
                    sim2.step();
                end
                if gui.quitSimulation
                    gui.close();
                    break;
                end             
                gui.step();
                %gui.checkAndUpdateControls();
                %gui.updateVisualizations();                  
           else
                sim2.step();
           end
        end
    end
    %% TEST TRIALS B
    for trt=1:maxTRt
          
    %sim2.init(); 
    sim2.t =sim2.tZero;
    for i = 1 : nFeatures
            n=num2str(i);
            handle_hcon_f{subject}(i).output = squeeze(savestate_hcon_f{subject}(i,:));
            handle_hwm_f{subject}(i).output = squeeze(savestate_hwm_f{subject}(i,:));
            handle_hwf{subject}(i).output = squeeze(savestate_hwf{subject}(i,:,:));
            handle_hwm_c{subject}(i).output = squeeze(savestate_hwm_c{subject}(i,:,:));
    end
    handle_hcon_s{subject}.output = savestate_hcon_s{subject};
    handle_hwm_s{subject}.output = savestate_hwm_s{subject};
    handle_hword{subject}.output = savestate_hword{subject};
    
        while sim2.t <= t_maxt

            t = sim2.t;
            
            if isalmost(t, word1_On,tolerance) 
                sim2.setElementParameters({'Word_Label_1'}, {'position','amplitude'},... 
                    {cell2mat(Words(EarlyLateSeq(trt))),wstrength});
            end
            if isalmost(t, visuals_On,tolerance) 
               
                for f=1:nFeatures
                    n=num2str(f);
                    
                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'positionY', 'positionY','positionY', 'positionY'}, ...
                        {cell2mat(Feature{f}(Testseq(maxTRt+trt,1))),cell2mat(Feature{f}(Testseq(maxTRt+trt,2))), ...
                        cell2mat(Feature{f}(Testseq(maxTRt+trt,3))),cell2mat(Feature{f}(Testseq(maxTRt+trt,4)))});                

                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'positionX', 'positionX','positionX', 'positionX'}, ...
                         {spt_L, spt_Lm, spt_Rm, spt_R});

                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'amplitude', 'amplitude','amplitude', 'amplitude'}, ...
                         { vstrength, vstrength, vstrength, vstrength }); 
                    
                end              
            end
           if isalmost(t, word1_Off,tolerance) 
                sim2.setElementParameters({'Word_Label_1'}, {'position','amplitude'},... 
                    {cell2mat(Words(EarlyLateSeq(trt))),0});
            end

            if isalmost(t, visuals_Off,tolerance)  
               for f=1:nFeatures
                    n=num2str(f);
                    
                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'positionY', 'positionY','positionY', 'positionY'}, ...
                        {cell2mat(Feature{f}(Testseq(maxTRt+trt,1))),cell2mat(Feature{f}(Testseq(maxTRt+trt,2))), ...
                        cell2mat(Feature{f}(Testseq(maxTRt+trt,3))),cell2mat(Feature{f}(Testseq(maxTRt+trt,4)))});                

                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'positionX', 'positionX','positionX', 'positionX'}, ...
                         {spt_L, spt_Lm, spt_Rm, spt_R});

                    sim2.setElementParameters({ strcat('Feature_',n,'_Left'), strcat('Feature_',n,'_LeftMid'), ... % set feature dimension value
                        strcat('Feature_',n,'_RightMid'), strcat('Feature_',n,'_Right')}, ...
                        {'amplitude', 'amplitude','amplitude', 'amplitude'}, ...
                         { 0, 0, 0, 0});                   
                end
            end
            if isalmost(t, t_maxt,tolerance)
                for i = 1 : nFeatures
                    n=num2str(i);
                    savestate_hcon_f{subject}(i,:) = sim2.getComponent(['hcon_f' n], 'output');
                    savestate_hwm_f{subject}(i,:) = sim2.getComponent(['hwm_f' n], 'output');
                    savestate_hwf{subject}(i,:,:) = sim2.getComponent(['hwf' n], 'output');
                    savestate_hwm_c{subject}(i,:,:) = sim2.getComponent(['hwm_c' n], 'output');
                end
                savestate_hcon_s{subject} = sim2.getComponent('hcon_s', 'output');
                savestate_hwm_s{subject} = sim2.getComponent('hwm_s', 'output');
                savestate_hword{subject} = sim2.getComponent('hword', 'output');
                savestate_historyLt{subject}(maxTRt+trt,:) = flipud(sim2.getComponent('history lookLt', 'output'));
                savestate_historyRt{subject}(maxTRt+trt,:) = flipud(sim2.getComponent('history lookRt', 'output'));
                savestate_historyLWBt{subject}(maxTRt+trt,:) = flipud(sim2.getComponent('history lookLWBt', 'output'));
                savestate_historyRWBt{subject}(maxTRt+trt,:) = flipud(sim2.getComponent('history lookRWBt', 'output'));
            end

           if (mode == 1) && (mod(t,gui_speed)==0)
                if ~gui.pauseSimulation
                    sim2.step();
                end
                if gui.quitSimulation
                    gui.close();
                    break;
                end             
                gui.step();
                %gui.checkAndUpdateControls();
                %gui.updateVisualizations();                  
           else
                sim2.step();
           end
        end
    
    end
    
    OutName = [simName,num2str(subject),'_test.mat'];
    matTest=matfile(OutName,'writable',true);

    matTest.hcon_ft = savestate_hcon_f{subject};
    matTest.hwm_ft = savestate_hwm_f{subject};
    matTest.hwm_ct = savestate_hwm_c{subject};
    matTest.hwft = savestate_hwf{subject};
    matTest.hcon_st = savestate_hcon_s{subject};
    matTest.hwm_st = savestate_hwm_s{subject};
    matTest.hwordt = savestate_hword{subject};
    
    matTest.historyLt = savestate_historyLt{subject};
    matTest.historyRt = savestate_historyRt{subject};
    matTest.historyLWBt = savestate_historyLWBt{subject};
    matTest.historyRWBt = savestate_historyRWBt{subject};
    matTest.Testset = Testset{subject};
end
            