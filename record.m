%¼��ѵ�����ݣ�0-9������10�����֣��ֱ�������5�飬¼�롣¼��ʱ��Ϊtime�롣
close all;
time=15;
freq=44100;
samp_num=10;
recorder = audiorecorder(freq,16,2);
recordblocking(recorder,time);
y = getaudiodata(recorder,'int16');
audiowrite('9876543210.wav',y,freq); %����Ϊ�ļ�Ϊy.wav 
%������matlab¼����Ƶʱ��
% wavrecord() ��Щ�������ڶ���������
