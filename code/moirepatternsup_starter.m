%BBM415 Image Processing Practicum
%Dr. Erkut Erdem
%TAs. Levent Karacan



I = im2double(imread('3.jpg'));
F = fft2(I);% where I is the input
F = fftshift(F); % Center FFT
F = abs(F); % Get the magnitude
F = log(F+1); %+1 since log(0) is undefined
F = mat2gray(F); % Use mat2gray to scale the image between 0 and 1
f=figure;
imshow(F);
[x,y]=getpts(f);
hold on
plot(x,y,'r+')
