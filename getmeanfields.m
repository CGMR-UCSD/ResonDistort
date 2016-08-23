function Stims = getmeanfields(Stims, Params)
%Use the GrFNN Toolbox to simulate neural resonance along to stimuli.
%%Then, calculate the motor (and/or sensory) layer mean fields and
%%Create mean field bins for measures to be averaged over,
%%('Average measure motor activation')


%% Set default parameters (except fs, as from toolbox rhythm example)
%Full harmonic connectivity
if nargin < 2 | ~isfield(Params, 'grfnn_model')
    Params.grfnn_model.fs = 48;
    Params.grfnn_model.alpha1 =  1e-5;
    Params.grfnn_model.beta11 =  0;
    Params.grfnn_model.beta12 = -2;
    Params.grfnn_model.delta11 =  0;
    Params.grfnn_model.delta12 = 0;
    Params.grfnn_model.neps1 = 1;
    Params.grfnn_model.alpha2 =  -0.4;
    Params.grfnn_model.beta21 = 1.75;
    Params.grfnn_model.beta22 =-1.25;
    Params.grfnn_model.delta21 = 0;
    Params.grfnn_model.delta22 = 0;
    Params.grfnn_model.neps2 = 1;
    Params.grfnn_model.w = 0.4;
    Params.grfnn_model.lambda =  -1;
    Params.grfnn_model.mu1 = 4;
    Params.grfnn_model.mu2 = -2.2;
    Params.grfnn_model.ceps = 1;
    Params.grfnn_model.kappa = 1; % Critical
    Params.grfnn_model.ampMult = 0.05;
    Params.grfnn_model.makeModel = 'makeRhythm2c3BD';
    
    Params.grfnn_model.mfLayer = [1:2];
end

%% Run through each stimulus
for stimNo = 1:length(Stims.names)
    %Create s stimulus structure
    stimFName = Stims.names(stimNo);
    addpath(Params.stim.folder);
    s = stimulusMake(1,'mid', stimFName{:}, [0 Params.stim.maxTS ], Params.grfnn_model.fs, ...
        'display', 4, 'inputType', 'active');
    s.x = Params.grfnn_model.ampMult*s.x/rms(s.x);
    s.x = hilbert(s.x);
    
    disp(['Initializing GrFNN w/ ' stimFName{:}])
    disp([num2str(stimNo) '/' num2str(length(Stims.names))])
    %Run assigned model
    tic
    eval(Params.grfnn_model.makeModel);
    disp('...')
    %Calculate diff equations
    M = odeRK4fs(M);
    toc
    disp(['completed GrFNN w/ ' stimFName{:}])
    
    disp(['Initializing Mean Field Calcs w/ ' stimFName{:}])
    
    %Calculate mean fields & avgs
    for layerNo = Params.grfnn_model.mfLayer
        mf = real(mean(M.n{layerNo}.Z));
        
        %Avg measure meanfield
        bin_start = (Params.stim.testMeasures * Params.grfnn_model.fs * Params.stim.measureLength)...
            + Params.stim.initDelay;
        bin_end = bin_start + (Params.grfnn_model.fs * Params.stim.measureLength) - 1;
        
        avgmf = zeros(size(mf(bin_start(1):bin_end(1))));
        for mNo = 1:length(Params.stim.testMeasures)
            avgmf = avgmf + mf(bin_start(mNo):bin_end(mNo));
        end
        avgmf = avgmf/length(Params.stim.testMeasures);
        
        if Params.stim.norm
            avgnormmf = avgmf - min(avgmf);
            avgnormmf = avgnormmf / sum(avgnormmf);
            Stims.(['avg_norm_mf' num2str(layerNo)]){stimNo} = avgnormmf;

        end
        
        Stims.(['mf' num2str(layerNo)]){stimNo} = mf;
        Stims.(['avg_mf' num2str(layerNo)]){stimNo} = avgmf;
    end
    
    %Save full GrFNN model input?
    if Params.mem.fullGrfnn
        Stims.fullGrfnn.M = M;
        Stims.fullGrfnn.s = s;
    end
    
    %Save individual stimulus output;
    if Params.save.individualGrfnn
        if ~isdir('GrFNN_Output')
            mkdir('GrFNN_Output');
        end
        save(['GrFNN_Out_' stimFName], 'M', 's', 'Params');
    end
    
end

%Save all
if Params.save.allGrfnn
    if ~isdir('GrFNN_Output')
        mkdir('GrFNN_Output');
    end
    save(['GrFNN_Output' filesep 'GrFNN_Out_all'], 'Params', 'Stims');
end

end