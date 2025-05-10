
%% ultrasound parameters

Fs = 15.00E6;                          % sampling frequency
TxFreq = 4;                            % MHz, Transmission frequency
depth = 160.2; %placenta               % mm 
SoS = 1540;                            % m/s

%% read rf data 

% replace with your directory
filenameRF = 'C:\Users\rajpa\Downloads\Codes\Codes\Anterior_Placenta\raw1\2024-04-18t17-56-15+0000_rf.raw'
numFrames = 1;
[dataRF_sample, headerSample] = rdataread(filenameRF, numFrames);
RF = permute(dataRF_sample,[2,3,1]);
envelope = abs(hilbert(RF));
Bmode = 20.*log10(envelope);

% diplay RF data
figure, plot(RF(:,100))
% diplay envelope data
figure, plot(envelope(:,100))

% Find the Fs1, Fs2, Fp1 and Fp2 from the following plot
figure, pwelch(RF(:,100),[],[],[],Fs)
% display Bmode image

figure; 
colormap(gray)
imagesc(Bmode); title('B-mode Image Original')

%% 
y_butter = filtfilt(SOSbutter, Gbutter,RF);
envelopeFilt = abs(hilbert(y_butter));
BmodeFilt = 20.*log10(envelopeFilt);
figure; 
colormap(gray)
imagesc(BmodeFilt); title('B-mode Image Butter')
figure, pwelch(y_butter(:,100),[],[],[],Fs)
title('part 2 butter')

y_cheb = filtfilt(SOScheb, Gcheb,RF);
envelopeFilt = abs(hilbert(y_cheb));
BmodeFilt = 20.*log10(envelopeFilt);
figure; 
colormap(gray)
imagesc(BmodeFilt); title('B-mode Image Cheb')
figure, pwelch(y_cheb(:,100),[],[],[],Fs)
title('part 2 cheb')

%% 
figure; 
colormap(gray)
imagesc(Bmode); title('B-mode Image')
h = imrect;
position = wait(h);
I = imcrop(RF,position);


IFilt = imcrop(y,position);

SSI =(sqrt(var(abs(IFilt(:))))/mean(abs(IFilt(:))))/(sqrt(var(abs(I(:))))/mean(abs(I(:))))

