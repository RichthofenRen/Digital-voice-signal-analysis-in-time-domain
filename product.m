% % ����ƽ̨��Windows 7 64bit�� MATLAB R2013a
% % ¼��¼2����
 clc
% recObj = audiorecorder(44100,16,1);
% disp('Start speaking.')
% recordblocking(recObj, 2);
% disp('End of Recording.');
% % �ط�¼������
% play(recObj);
% % ��ȡ¼������
% myRecording = getaudiodata(recObj);
% % ����¼�����ݲ���
% %plot(myRecording);
% x = myRecording;

%[x,fs]=audioread('C:\Users\dannis\Desktop\�����ź�ʶ��\������������\������_10��\1.4.wav');

%total=[];

pwd='C:\Users\Lenovo\Desktop\DSP_experiments\test_10_groups';
addpath(pwd);
total=[];
for i = 0:9
    for j = 1:10
        
    fileName = [num2str(i) '.' num2str(j) '.wav'];
    x = audioread(fileName);

    


    x = x / max(abs(x));%���ȹ�һ����[-1,1]
    %��������
    FrameLen = 256;     %֡��
    inc = 90;           %δ�ص�����
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    amp1 = 1 ;          %��ʱ������ֵ
    amp2 = 0.1;      
    zcr1 = 10;          %��������ֵ
    zcr2 = 5;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    minsilence = 6;  %�������ĳ������ж������Ƿ����
    minlen  = 15;    %�ж�����������С����
    status  = 0;     %��¼�����ε�״̬
    count   = 0;     %�������еĳ���
    silence = 0;     %�����ĳ���

    %���������
    tmp1  = enframe(x(1:end-1), FrameLen,inc);
    tmp2  = enframe(x(2:end)  , FrameLen,inc);
    signs = (tmp1.*tmp2)<0;
    diffs = (tmp1 -tmp2)>0.02;
    zcr   = sum(signs.*diffs,2);

    %�����ʱ����
    amp = sum((abs(enframe(filter([1 -0.9375], 1, x), FrameLen, inc))).^2, 2);

    %������������
    amp1 = min(amp1, max(amp)/4);
    amp2 = min(amp2, max(amp)/8);

    %��ʼ�˵���
    for n=1:length(zcr)
       goto = 0;
       switch status
       case {0,1}                   % 0 = ����, 1 = ���ܿ�ʼ
          if amp(n) > amp1          % ȷ�Ž���������
             x1 = max(n-count-1,1); % ��¼�����ε���ʼ��
             status  = 2;
             silence = 0;
             count   = count + 1;
          elseif amp(n) > amp2 || zcr(n) > zcr2 % ���ܴ���������
             status = 1;
             count  = count + 1;
          else                       % ����״̬
             status  = 0;
             count   = 0;
          end
       case 2,                       % 2 = ������
          if amp(n) > amp2 ||zcr(n) > zcr2     % ������������

             count = count + 1;
          else                       % ����������
             silence = silence+1;
             if silence < minsilence % ����������������δ����
                count  = count + 1;
             elseif count < minlen   % ��������̫�̣���Ϊ������
                status  = 0;
                silence = 0;
                count   = 0;
             else                    % ��������
                status  = 3;
             end
          end
       case 3,
          break;
       end
    end   

    count = count-silence/2;
    x2 = x1 + count -1;              %��¼�����ν�����
    % disp('length of effective voice sequence')
    head = x1*inc;
    tail = x2*inc;
    EVL = x2*inc-x1*inc;
    % �õ������˵�����е���������
    y = x(x1*inc:x2*inc,:);

    % subplot(2,1,1)
    % plot(x)
    % axis([1 length(x) -1 1])
    % ylabel('raw data');
    % subplot(2,1,2)
    % plot(y)
    % axis([1 length(y) -1 1])
    % ylabel('handled data');

    %���������
    tmp11  = enframe(y(1:end-1), FrameLen,inc);
    tmp21  = enframe(y(2:end)  , FrameLen,inc);
    signs = (tmp11.*tmp21)<0;
    diffs = (tmp11 -tmp21)>0.02;
    zcrm   = sum(signs.*diffs,2);
    length(zcrm);  
    totalZCR = sum(zcrm);
    averageZCR = totalZCR/length(zcrm);
    %ǰ���̹�����֮��
    zcr11=zcrm(1:floor(0.5*length(zcrm)),:);
    length(zcr11);
    zcr12=zcrm(floor(0.5*length(zcrm))+1 :end ,:);
    length(zcr12);
    divZCR = sum(zcr11)/sum(zcr12);
    %ƽ������
    ampm = sum((abs(enframe(filter([1 -0.9375], 1, y), FrameLen, inc))).^2, 2);
    length(ampm);
    totalAMP = sum(ampm);
    averageAMP = totalAMP/length(ampm);
    %ǰ��������֮��
    amp11=ampm(1:floor(0.5*length(ampm)),:);
    amp12=ampm(floor(0.5*length(ampm))+1 :end ,:);
    divAMP=sum(amp11)/sum(amp12);
    %��������������������
    eigenvector=[averageZCR;divZCR;averageAMP;divAMP];
    y_result=sim(net,eigenvector);
    [a,b]=max(y_result);
%     fprintf('the number is');
%     disp(b-1);
    total=[total b-1];
    end
end
%disp(total)

disp('NNʶ������');
for i=1:10
    fprintf('10��������������%d�Ĳ��Խ��Ϊ',i-1);
    disp(total((i-1)*10+1:(i-1)*10+10));

end

bb=[];
for i=0:9
    a(1:10)=i;
    bb=[bb a];
end

re=total-bb;

for i=1:10
    index=find(re((i-1)*10+1:(i-1)*10+10));
    tmp=size(index');
    num=tmp(1);
    error=num/10;
    fprintf('10��������������%d�Ĳ�����ȷ��Ϊ',i-1);
    disp(1-error);
end


index=find(re);
tmp=size(index');
num=tmp(1);
error=num/100;
fprintf('�ۺ���ȷ�ʣ�');
disp(1-error);










