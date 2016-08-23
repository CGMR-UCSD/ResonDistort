function Params = createtargets(Params)
%Calculate the motor target distributions (ie. 'tap distros')

%% Setup timing vectors
d = Params.stim.measureLength * Params.grfnn_model.fs;
if mod(d, 1)
    d = ceil(d);
    error('Measure length and FS are not consistent');
end

theta = 0:2*pi/d:2*pi; %Radian Measure
theta = theta(1:end-1);

%% Calculate distributions for all rhythmClasses
for rcNo = 1:length(Params.target.rhythmClass)
    
    %Create dist for each tap/beat target in pattern
    for bNo = 1:length(Params.target.rhythmClass{rcNo}.targets)
        targetTs = Params.target.rhythmClass{rcNo}.targets(bNo); %Target times, seconds
        targetTr = (targetTs / Params.stim.measureLength) * 2 * pi %Target times, radians
        
        %For each kappa (Peakiness), create distribution
        for K = 1:length(Params.mix.kappa)
            k = Params.mix.kappa(K);
            Params.target.rhythmClass{rcNo}.targetsDist{bNo,K} = circ_vmpdf(theta, targetTr, k)';
        end
    end
end

end
    
    
    
   