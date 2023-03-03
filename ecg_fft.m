function [denoised_signal, snr_signal, rmse_signal, cc_signal] = ecg_fft(signal, noisy_signal, tm,fs)
    % Perform FFT on the noisy ECG signal
    fft_ecg = fft(noisy_signal);
    
    % Determine the frequency components to retain based on a threshold
    
    M = length(tm);
    w = linspace(0, (M-1)*(fs/M),M);
    w1 = w;
    w1(w >= fs/2) = w(w >= fs/2) - fs;
    ws = fftshift(w1);
    fft_shift = fftshift(fft_ecg);
    
    % Filter the frequency domain signal 
    lpf = abs(ws) < 1;
    fft_shift(lpf) = 0;
    hpf = abs(ws) > 30;
    fft_shift(hpf) = 0;

    % Reconstruct the denoised signal from the truncated FFT
    filtered_ecg = ifftshift(fft_shift);
    denoised_signal = ifft(filtered_ecg);

    %% Calculate the performance metrics for the denoised signals
    
    % calculate the RMSE for SVD denoised signal
    rmse_signal = sqrt(mean((signal - denoised_signal).^2)); 

    % calculate the SNR for SVD denoised signal
    %snr_signal = snr(signal, denoised_signal); 
   
    signal_power = sqrt(mean(signal).^2);
    snr_signal = signal_power/rmse_signal;

    % calculate the correlation coefficient for SVD denoised signal
    cc_signal = corrcoef(signal, denoised_signal);
    

end
