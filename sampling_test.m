%input:wav��ʽѵ������
%output����ȡ��ʱ�����ͷֶι����ʣ�������ά��������������mat�ļ���������KNN�㷨�ж�ȡ
function[]=sampling_test(train)
clc;
close all;
%train=audioread('C:\Users\Lenovo\Desktop\DSP_experiments\train_chinese_new.wav');
%set(gcf,'outerposition',get(0,'screensize'));

tmp=size(train);
length_y=tmp(1);
% xx = xx / max(abs(xx));
total=[];
total0=[];
total1=[];
total11=[];
%filename='0923.wav';
%my=[y',yy'];
%audiowrite(filename,my',freq);
yy=train;
num=50;
for k=1:num
%     subplot(num,1,k);
%     figure;
    [x1, x2]=voice_segment(yy);
    sample=yy(x1:x2);
    yy=yy(x2+2000:size(yy,1),:);
    
% figure;
% plot(xx);
% title('�����ź�ʱ����');
% xlabel('��������'); 
% ylabel('����'); 

%���ȡ��  2��
% [x1,y1]=ginput(1);
% [x2,y2]=ginput(1);
% x01=round(x1);
% x02=round(x2);
% %plot(yy(x01:x02))%func 
% 
% yy=xx(x01:x02);% �����źŷ���

% figure;
% 
% subplot(411);
% plot(xx);
% title('Դ�ź�ʱ����');
% line([x01 x01], [-1 1], 'Color', 'red');
% line([x02 x02], [-1 1], 'Color', 'red');

% subplot(412);
%axis([0,length_y,-3,3]);
% plot(yy);
% title('Ԥ�����ź�ʱ����');
%��ʱ����������źŶ˵�  ����ѡ����δ�
LEN =100; 
INC=100;
win0=enframe(sample,LEN,INC);  % y=enframe(x,framelength,step);
energy=sum(abs(win0),2);% �������
% save('energy.mat','energy');
% subplot(413);
% plot(energy);
sum_erengy=sum(energy);
total1=[total1 sum_erengy];
% title('��ʱ����');
% xlabel('֡��');
% ylabel('��ʱ����');

  
window = enframe(sample, LEN, INC);  %��֡ 
% �����ʱ������ 
z = zeros(size(window,1),1);   
difs =0.01;                     
for i=1:size(window,1)  
    s=window(i,:);                     
    for j=1:(length(s)-1)  
        if (s(j)* s(j+1)<0)&&(abs(s(j)-s(j+1))>difs) 
            z(i)= z(i)+2; 
        end
    end
end
z=z./2;
size_z=size(z,1);
sum_z1=sum(z(1:floor(size_z/3)));
sum_z2=sum(z(ceil(size_z/3):floor(2*size_z/3)));
sum_z3=sum(z(ceil(2*size_z/3):size_z));
total0=[total0 sum_z1];
total=[total sum_z2];
total11=[total11 sum_z3];

% subplot(414);
% plot(z);                  
% title('��ʱ������');
% xlabel('֡��'); 
% ylabel('��ʱ������');

total_last=[total1' total0' total' total11'];

%pause(1);
 end
 
save('train_data_chinese.mat','total_last');

%close all;






