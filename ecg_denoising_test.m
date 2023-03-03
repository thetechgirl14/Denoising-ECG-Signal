function ecg_denoising_test()
    close all
    
    % Load ECG signal

    [ecg,fs,tm] = rdsamp('filename in .dat format');
    T = 1000;
    ecg = ecg(1:T);
    tm = tm(1:T);

    % Add noise to the ECG signal
    noisy_ecg = awgn(ecg, 10, 'measured','linear'); % add white Gaussian noise with SNR of 10 dB

    figure,
    plot(tm,ecg)
    title("Original ECG Signal");
    figure,
    plot(tm,noisy_ecg)
    title("ECG Signal with White Gaussian Noise of SNR 10 db");

    window_size_svd = 9;
     
    [denoised_signal_svd, snr_svd, rmse_svd, cc_svd] = ecg_hankel_svd(ecg, noisy_ecg, window_size_svd);
    figure,
    plot(tm,denoised_signal_svd)
    title(['Denoised ECG Signal (SVD), SNR=',num2str(snr_svd),', RMSE=',num2str(rmse_svd),', CC=',num2str(cc_svd(1,2))]);
    
    [denoised_signal_fft, snr_fft, rmse_fft, cc_fft] = ecg_fft(ecg, noisy_ecg, tm, fs);
    figure,
    plot(tm,denoised_signal_fft)
    title(['Denoised ECG Signal (FFT), SNR=',num2str(snr_fft),', RMSE=',num2str(rmse_fft),', CC=',num2str(cc_fft(1,2))]);

    rmse_noisy = sqrt(mean((ecg - noisy_ecg).^2)); 
    signal_power = sqrt(mean(ecg).^2);
    snr_noisy = signal_power/rmse_noisy;
    cc_noisy = corrcoef(ecg, noisy_ecg);
   
    disp("Performance Matrix for Noisy Signal");
    fprintf("Signal to Noise Ratio = %f \n", snr_noisy);
    fprintf("Root Mean Squared Error = %f \n", rmse_noisy);
    fprintf("Correlation Coefficient = %f \n", cc_noisy);
    
    fprintf("Performance Matrix for SVD using Hankel Matrix with window size = %d \n", window_size_svd);
    fprintf("Signal to Noise Ratio = %f \n", snr_svd);
    fprintf("Root Mean Squared Error = %f \n", rmse_svd);
    fprintf("Correlation Coefficient = %f \n", cc_svd);

    disp("Performance Matrix for Fast Fourier Transform");
    fprintf("Signal to Noise Ratio = %f \n", snr_fft);
    fprintf("Root Mean Squared Error = %f \n", rmse_fft);
    fprintf("Correlation Coefficient = %f \n", cc_fft);

    figure,hold on
    plot(tm,ecg,'Color','r');
    plot(tm,noisy_ecg,'Color','m');
    plot(tm,denoised_signal_svd,'Color','g');
    plot(tm,denoised_signal_fft, 'Color','b');
    hold off
    legend("Original ECG", "Noisy ECG", "Denoised ECG (SVD)", "Denoised ECG (FFT)");
    title("ECG Denoising Using SVD and FFT")

end