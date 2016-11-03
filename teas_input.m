%录制测试数据，每个数字读一遍，录入。录制时间为time秒。
freq=8000;
time=25;
samp_num=10;
recorder = audiorecorder(freq,16,2);
recordblocking(recorder,time);
y = getaudiodata(recorder,'int16');
audiowrite('chinese_1357924680.wav',y,freq); 

