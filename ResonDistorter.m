%% ResonDistorter
%Calculate predicted distortion to motor targets due to auditory/rhythmic
%neural resonance using the GrFNN Toolbox.

%Note: stimuli filenames must begin with name of rhythm class,
%eg.: '23_agrcinska1.mid' is in rhythm class '23'.


%% Set Parameters
setparams_tapcomp;

%% Load Stimuli
%stimlist = load('stimlist')
Stims = getstimuli(Params);
save('RD_temp');

%% Calculate GrFNN motor mean fields
Stims = getmeanfields(Stims, Params);
save('RD_temp');

%% Calculate Motor Target Distributions
Params = createtargets(Params);
save('RD_temp');

%% Integrate Targets and motor mean fields
Stims = integratetargets(Stims, Params);
save('RD_temp');

%% Calculate mixture means
Stims = getdistortion(Stims, Params);
save('RD_temp');

%% Calculate Ratios between mixture means
Stims = getratios(Stims, Params);
save('RD_temp');

%% Plot Distortion
plotdistortion(targets, Params);


