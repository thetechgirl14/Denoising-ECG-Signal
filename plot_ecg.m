function plot_ecg(signal, tm, graph_name)
    %Thresholding to Find Peaks of Interest
    %The QRS-complex consists of three major components: Q-wave, R-wave, S-wave. The R-waves can be detected by thresholding peaks above 0.5mV. Notice that the R-waves are separated by more than 200 samples. Use this information to remove unwanted peaks by specifying a 'MinPeakDistance'.
    
    [~,locs_Rwave] = findpeaks(signal,'MinPeakHeight',0.6,'MinPeakDistance',40);
    %Finding Local Minima in Signal
    %Local minima can be detected by finding peaks on an inverted version of the original signal.
    ECG_inverted = -signal;
    [~,locs_Qwave] = findpeaks(ECG_inverted,'MinPeakHeight',0.1,'MinPeakDistance',40); 
    [~,locs_Swave] = findpeaks(ECG_inverted,'MinPeakHeight',0.4,'MinPeakDistance',40);    
    [~,locs_Twave] = findpeaks(signal,'MinPeakHeight',-0.02,'MinPeakDistance',40);                         
    [~,locs_Pwave] = findpeaks(signal,'MinPeakHeight',-0.01,'MinPeakDistance',40);                           
    
    figure,hold on; plot(tm*100,signal);
    plot(locs_Twave,signal(locs_Twave),'X','MarkerFaceColor','y');
    plot(locs_Pwave,signal(locs_Pwave),'*','MarkerFaceColor','g');                                
    plot(locs_Rwave,signal(locs_Rwave),'rv','MarkerFaceColor','r');
    plot(locs_Swave,signal(locs_Swave),'rs','MarkerFaceColor','c');
    plot(locs_Qwave,signal(locs_Qwave),'o','MarkerFaceColor','b');
    grid on, title(graph_name)
    xlabel('time msec'); ylabel('Voltage(mV)')
    legend('ECG signal','P-wave', 'T-Wave','R-wave','S-wave', 'Q-Wave');
    hold off;
  
end
