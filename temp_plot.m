

%Plot Tap Predictions for all targets by Kappa
figure;
for bNo = 1:length(Params.target.rhythmClass{rcNo}.targets)
    plot([Stims.mixmean_l2{1,bNo,1,:}]); hold on
end
title('Tap Predictions by Kappa');
xlabel('Kappa value')
ylabel('Distortion in ms');
hold off