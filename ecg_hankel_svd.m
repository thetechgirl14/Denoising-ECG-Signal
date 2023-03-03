function [denoised_signal, snr_signal, rmse_signal, cc_signal] = ecg_hankel_svd(signal, noisy_signal, window_size)
   
    % Define the Hankel matrix
    hankel_mat = hankel(noisy_signal(1:window_size), noisy_signal(window_size:end));
    
    % Perform SVD on the Hankel matrix
    [U, S, V] = svd(hankel_mat);
    
    % Determine the number of singular values to retain based on a threshold
    sv = sort(diag(S),"descend"); % get the singular values
    num_sv = 7; 
      
    U = U(:,1:num_sv);
    S = diag(sv(1:num_sv));
    V = V(:,1:num_sv);
    
    % Reconstruct the denoised signal from the truncated SVD
    new_hankel = U*S*V';
    
    % Reconstruct ECG signal from Hankel matrix
    [~,numcol] = size(new_hankel);
    h1 = new_hankel(1:1,:);
    h2 = new_hankel(2:window_size,numcol);
    h2 = h2';
    
    denoised_signal = [h1, h2]';

    %% Calculate the performance metrics for the denoised signals

    % calculate the RMSE for SVD denoised signal
    rmse_signal = sqrt(mean((signal-denoised_signal).^2)); 

    % calculate the SNR for SVD denoised signal
    %snr_signal = snr(signal, denoised_signal); 

    signal_power = sqrt(mean(signal).^2);
    snr_signal = signal_power/rmse_signal;

    % calculate the correlation coefficient for SVD denoised signal
    cc_signal = corrcoef(signal, denoised_signal); 

end
