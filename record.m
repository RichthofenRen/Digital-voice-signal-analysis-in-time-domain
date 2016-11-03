%录制训练数据，0-9，共计10个数字，分别连续读5遍，录入。录制时间为time秒。
close all;
time=15;
freq=44100;
samp_num=10;
recorder = audiorecorder(freq,16,2);
recordblocking(recorder,time);
y = getaudiodata(recorder,'int16');
audiowrite('9876543210.wav',y,freq); %保存为文件为y.wav 
%上面在matlab录入音频时用
% wavrecord() 那些函数现在都不能用了
