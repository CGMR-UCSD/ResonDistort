function plotdistortion(Stims, Params)


%% Plot Predictions by Kappa for each rhythmClass
for layerNo = Params.plot.layers
    for stimNo = 1:length(Stims.names)
        rc = Stims.names{stimNo}(1:2);
        rcNo = find(strcmp(Params.target.rcNames, rc));
        
        
        figure(str2num([num2str(layerNo) '100' num2str(stimNo)]));
   
        for bNo = 1:length(Params.target.rhythmClass{rcNo}.targets)
            points = mod([Stims.(['mixmean_l' num2str(layerNo)]){stimNo,bNo,:,Params.plot.steadyM}], Params.stim.measureLength);
            iFlip = (Params.stim.measureLength - points) < Params.plot.pointFlip;
            points(iFlip) = points(iFlip) - Params.stim.measureLength;
            
            plot(Params.mix.kappa, points, '-x'); hold on
        end
         xlim = [min(Params.mix.kappa) max(Params.mix.kappa)];
        line(xlim, [0 0], 'Color', 'black', 'LineStyle', ':');
        line(xlim, [Params.stim.measureLength Params.stim.measureLength],...
            'Color', 'black', 'LineStyle', ':');
        
        title(['Tap Predictions by Kappa (' Params.target.rcPrettyNames{rcNo} ' ' num2str(stimNo) ')' ]);
        xlabel('Kappa value')
        ylabel('Distortion in seconds');
        hold off
        
    end
end


%% Plot Predictions by Mixture for each rhythmClass

for layerNo = Params.plot.layers
    for rcNo = Params.plot.rhythmClasses
        
        figure(str2num([num2str(layerNo) '200' num2str(rcNo)]));
        xlim = [min(Params.mix.kappa) max(Params.mix.kappa)];
        line(xlim, [0 0], 'Color', 'black', 'LineStyle', ':');
        line(xlim, [Params.stim.measureLength Params.stim.measureLength],...
            'Color', 'black', 'LineStyle', ':');
        for bNo = 1:length(Params.target.rhythmClass{rcNo}.targets)
            points = mod([Stims.(['mixmean_l' num2str(layerNo)]){1,bNo,Params.plot.steadyK,:}], Params.stim.measureLength);
            iFlip = (Params.stim.measureLength - points) < Params.plot.pointFlip;
            points(iFlip) = points(iFlip) - Params.stim.measureLength;
            
            plot(Params.mix.mix, points, '-x'); hold on
        end
        
        title(['Tap Predictions by Mixture (' Params.target.rcPrettyNames{rcNo} ')' ]);
        xlabel('Mixture value')
        ylabel('Distortion in seconds');
        hold off
        
    end
end
% 
% %% Plot Ratios of interest by Kappa
% 
% for stimNo = 1:length(Stims.names)
%     for layerNo = Params.plot.layers
%         for rcNo = Params.plot.rhythmClasses
%             
%             figure(str2num([num2str(layerNo) '300' num2str(rcNo)]));
%             for rNo = Params.target.rhythmClass{rcNo}.interestratios
%                 
%                 
%             end
%             for bNo = 1:length(Params.target.rhythmClass{rcNo}.targets)
%                 points = mod([Stims.(['mixmean_l' num2str(layerNo)]){stimNo,bNo,P::}], Params.stim.measureLength);
%                 iFlip = (Params.stim.measureLength - points) < Params.plot.pointFlip;
%                 points(iFlip) = points(iFlip) - Params.stim.measureLength;
%                 
%                 plot(Params.mix.mix, points, '-x'); hold on
%             end
%             
%             title(['Tap Predictions by Mixture (' Params.target.rcPrettyNames{rcNo} ')' ]);
%             xlabel('Mixture value')
%             ylabel('Distortion in seconds');
%             hold off
%             
%         end
%     end
% end
% 
% Params.target.rhythmClass{1}.interestratios


end