% % 运行平台：Windows 7 64bit， MATLAB R2013a
% % 录音录2秒钟
 clc
% recObj = audiorecorder(44100,16,1);
% disp('Start speaking.')
% recordblocking(recObj, 2);
% disp('End of Recording.');
% % 回放录音数据
% play(recObj);
% % 获取录音数据
% myRecording = getaudiodata(recObj);
% % 绘制录音数据波形
% %plot(myRecording);
% x = myRecording;

%[x,fs]=audioread('C:\Users\dannis\Desktop\语音信号识别\数字语音样本\测试组_10组\1.4.wav');

%total=[];

pwd='C:\Users\Lenovo\Desktop\DSP_experiments\test_10_groups';
addpath(pwd);
total=[];
for i = 0:9
    for j = 1:10
        
    fileName = [num2str(i) '.' num2str(j) '.wav'];
    x = audioread(fileName);

    


    x = x / max(abs(x));%幅度归一化到[-1,1]
    %参数设置
    FrameLen = 256;     %帧长
    inc = 90;           %未重叠部分
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    amp1 = 1 ;          %短时能量阈值
    amp2 = 0.1;      
    zcr1 = 10;          %过零率阈值
    zcr2 = 5;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    minsilence = 6;  %用无声的长度来判断语音是否结束
    minlen  = 15;    %判断是语音的最小长度
    status  = 0;     %记录语音段的状态
    count   = 0;     %语音序列的长度
    silence = 0;     %无声的长度

    %计算过零率
    tmp1  = enframe(x(1:end-1), FrameLen,inc);
    tmp2  = enframe(x(2:end)  , FrameLen,inc);
    signs = (tmp1.*tmp2)<0;
    diffs = (tmp1 -tmp2)>0.02;
    zcr   = sum(signs.*diffs,2);

    %计算短时能量
    amp = sum((abs(enframe(filter([1 -0.9375], 1, x), FrameLen, inc))).^2, 2);

    %调整能量门限
    amp1 = min(amp1, max(amp)/4);
    amp2 = min(amp2, max(amp)/8);

    %开始端点检测
    for n=1:length(zcr)
       goto = 0;
       switch status
       case {0,1}                   % 0 = 静音, 1 = 可能开始
          if amp(n) > amp1          % 确信进入语音段
             x1 = max(n-count-1,1); % 记录语音段的起始点
             status  = 2;
             silence = 0;
             count   = count + 1;
          elseif amp(n) > amp2 || zcr(n) > zcr2 % 可能处于语音段
             status = 1;
             count  = count + 1;
          else                       % 静音状态
             status  = 0;
             count   = 0;
          end
       case 2,                       % 2 = 语音段
          if amp(n) > amp2 ||zcr(n) > zcr2     % 保持在语音段

             count = count + 1;
          else                       % 语音将结束
             silence = silence+1;
             if silence < minsilence % 静音还不够长，尚未结束
                count  = count + 1;
             elseif count < minlen   % 语音长度太短，认为是噪声
                status  = 0;
                silence = 0;
                count   = 0;
             else                    % 语音结束
                status  = 3;
             end
          end
       case 3,
          break;
       end
    end   

    count = count-silence/2;
    x2 = x1 + count -1;              %记录语音段结束点
    % disp('length of effective voice sequence')
    head = x1*inc;
    tail = x2*inc;
    EVL = x2*inc-x1*inc;
    % 得到经过端点检测剪切的语音序列
    y = x(x1*inc:x2*inc,:);

    % subplot(2,1,1)
    % plot(x)
    % axis([1 length(x) -1 1])
    % ylabel('raw data');
    % subplot(2,1,2)
    % plot(y)
    % axis([1 length(y) -1 1])
    % ylabel('handled data');

    %计算过零率
    tmp11  = enframe(y(1:end-1), FrameLen,inc);
    tmp21  = enframe(y(2:end)  , FrameLen,inc);
    signs = (tmp11.*tmp21)<0;
    diffs = (tmp11 -tmp21)>0.02;
    zcrm   = sum(signs.*diffs,2);
    length(zcrm);  
    totalZCR = sum(zcrm);
    averageZCR = totalZCR/length(zcrm);
    %前后半程过零率之比
    zcr11=zcrm(1:floor(0.5*length(zcrm)),:);
    length(zcr11);
    zcr12=zcrm(floor(0.5*length(zcrm))+1 :end ,:);
    length(zcr12);
    divZCR = sum(zcr11)/sum(zcr12);
    %平均能量
    ampm = sum((abs(enframe(filter([1 -0.9375], 1, y), FrameLen, inc))).^2, 2);
    length(ampm);
    totalAMP = sum(ampm);
    averageAMP = totalAMP/length(ampm);
    %前后半程能量之比
    amp11=ampm(1:floor(0.5*length(ampm)),:);
    amp12=ampm(floor(0.5*length(ampm))+1 :end ,:);
    divAMP=sum(amp11)/sum(amp12);
    %构造特征向量并带入检测
    eigenvector=[averageZCR;divZCR;averageAMP;divAMP];
    y_result=sim(net,eigenvector);
    [a,b]=max(y_result);
%     fprintf('the number is');
%     disp(b-1);
    total=[total b-1];
    end
end
%disp(total)

disp('NN识别结果：');
for i=1:10
    fprintf('10组语音测试样本%d的测试结果为',i-1);
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
    fprintf('10组语音测试样本%d的测试正确率为',i-1);
    disp(1-error);
end


index=find(re);
tmp=size(index');
num=tmp(1);
error=num/100;
fprintf('综合正确率：');
disp(1-error);










