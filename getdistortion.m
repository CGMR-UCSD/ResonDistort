function Stims = getdistortion(Stims, Params)

%% Setup timing vectors

d = Params.stim.measureLength * Params.grfnn_model.fs;
if mod(d, 1)
    d = ceil(d);
    error('Measure length and FS are not consistent');
end

theta = 0:2*pi/d:2*pi; %Radian Measure
theta = theta(1:end-1);

if ~isfield(Params, 'simNo')
    Params.simNo = 30000;
end


for stimNo = 1:length(Stims.names)
    disp(['Calculate tap prediction and distortion for ' Stims.names{stimNo}]);
    disp([num2str(stimNo) '/' num2str(length(Stims.names))])

    %Identify rhythmClass for stimulus
    rc = Stims.names{stimNo}(1:2);
    rcNo = find(strcmp(Params.target.rcNames, rc));
    
    %create mixture for each tap/beat target in pattern
    for layerNo = Params.grfnn_model.mfLayer
        for bNo = 1:length(Params.target.rhythmClass{rcNo}.targets)
            for K = 1:length(Params.mix.kappa)
                for M = 1:length(Params.mix.mix)
                    m = Params.mix.mix(M);
                    MixDistro = Stims.(['mix_l' num2str(layerNo)]){stimNo, bNo, K, M};
                    
                    simpoints = [];
                    for ang = 1:length(theta)
                        for p = 1:round(MixDistro(ang)*Params.simNo)
                            simpoints(end+1) = theta(ang);
                        end
                    end
                    Stims.(['mixmean_l' num2str(layerNo)]){stimNo, bNo, K, M} = ...
                        mod(circ_rad2ang(circ_mean(simpoints')),360) / 360 * 1.75;
                    
                    Stims.(['mixDistort_l' num2str(layerNo)]){stimNo, bNo, K, M} = ...
                       Params.target.rhythmClass{rcNo}.targets(bNo) - ...
                       Stims.(['mixmean_l' num2str(layerNo)]){stimNo, bNo, K, M};
                    
                end
            end
            
        end
    end
    
end





end