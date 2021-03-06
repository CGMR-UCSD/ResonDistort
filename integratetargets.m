function Stims = integratetargets(Stims, Params)



for stimNo = 1:length(Stims.names)
    disp(['Integrating target and reson distributions for ' Stims.names{stimNo}]);

    %Identify rhythmClass for stimulus
    rc = Stims.names{stimNo}(1:2);
    rcNo = find(strcmp(Params.target.rcNames, rc));
    
    %create mixture for each tap/beat target in pattern
    for layerNo = Params.grfnn_model.mfLayer
        priorDist = Stims.(['avg_mf' num2str(layerNo)]){stimNo};
        for bNo = 1:length(Params.target.rhythmClass{rcNo}.targets)
            for K = 1:length(Params.mix.kappa)
                for M = 1:length(Params.mix.mix)
                    m = Params.mix.mix(M);
                    targetDist = Params.target.rhythmClass{rcNo}.targetsDist{bNo, K};
                    %Mix distros
                    mixDist = (targetDist * m) + (priorDist * (1-m));
                    Stims.(['mix_l' num2str(layerNo)]){stimNo, bNo, K, M} = mixDist;
                end
            end
        end
        
    end
end
    
    
end