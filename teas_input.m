%¼�Ʋ������ݣ�ÿ�����ֶ�һ�飬¼�롣¼��ʱ��Ϊtime�롣
freq=8000;
time=25;
samp_num=10;
recorder = audiorecorder(freq,16,2);
recordblocking(recorder,time);
y = getaudiodata(recorder,'int16');
audiowrite('chinese_1357924680.wav',y,freq); 

