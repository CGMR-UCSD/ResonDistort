function Stims = getratios(Stims, Params)

for stimNo = 1:length(Stims.names)
    %Identify rhythmClass for stimulus
    rc = Stims.names{stimNo}(1:2);
    rcNo = find(strcmp(Params.target.rcNames, rc));
    
    for layerNo = Params.grfnn_model.mfLayer
        for K = 1:length(Params.mix.kappa)
            for M = 1:length(Params.mix.mix)
                for bNo = 1:length(Params.target.rhythmClass{rcNo}.targets)
                    %Calculate Intervals
                    if bNo == length(Params.target.rhythmClass{rcNo}.targets)
                        currB = Stims.(['mixmean_l' num2str(layerNo)]){stimNo,bNo,K,M};
                        nextB = Stims.(['mixmean_l' num2str(layerNo)]){stimNo,1,K,M};
                    else
                        currB = Stims.(['mixmean_l' num2str(layerNo)]){stimNo,bNo,K,M};
                        nextB = Stims.(['mixmean_l' num2str(layerNo)]){stimNo,bNo+1,K,M};
                    end
                    currB = 2*pi*currB/Params.stim.measureLength;
                    nextB = 2*pi*nextB/Params.stim.measureLength;
                    interval = Params.stim.measureLength* angdiff(currB, nextB) / (2*pi) ;
                    
                    Stims.(['mixI_l' num2str(layerNo)]){stimNo,bNo,K,M} = interval;
                end
                for bNo = 1:length(Params.target.rhythmClass{rcNo}.targets)
                    for bNo2 = 1:length(Params.target.rhythmClass{rcNo}.targets)
                        I1 = Stims.(['mixI_l' num2str(layerNo)]){stimNo,bNo,K,M};
                        I2 = Stims.(['mixI_l' num2str(layerNo)]){stimNo,bNo2,K,M};
                        R = I1/I2;
                        Stims.(['ratio_l' num2str(layerNo)]){stimNo,bNo,K,M,bNo2} = R;
                        
                    end
                end
                
            end
        end
    end
end

end