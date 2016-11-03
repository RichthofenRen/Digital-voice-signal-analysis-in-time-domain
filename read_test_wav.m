clear all;
% x=audioread('C:\Users\Lenovo\Desktop\DSP_experiments\test_10_groups\0.1.wav');
% y=audioread('C:\Users\Lenovo\Desktop\DSP_experiments\test_10_groups\0.8.wav');
x=zeros();
pwd='C:\Users\Lenovo\Desktop\DSP_experiments\test_10_groups';
addpath(pwd);
[DATA,TXT,RAW]=xlsread('C:\Users\Lenovo\Desktop\DSP_experiments\matrix.xlsx');
DATA=DATA';
DATA0=[];
clock=9;
for i=1:100
    if rem(i,10)~=0
        for j=1:4       
            DATA0((rem(i,10)-1)*10+fix(i/10)+1,j) = DATA(i,j);
            
        end
        disp((rem(i,10)-1)*10+fix(i/10)+1);
    else
        for k=1:4
            DATA0(clock*10+fix(i/10),k) = DATA(i,k);
            
        end
        disp(clock*10+fix(i/10));
           % clock = clock+1;  
    end
end
   

DATA=DATA0;
save('train_data_matrix0.mat','DATA');
% total=[];
% for i = 0:9
%     for j = 1:10
%         
%     fileName = [num2str(i) '.' num2str(j) '.wav'];
%     x = audioread(fileName);
%     [averageZCR,divZCR,averageAMP,divAMP] =endpoint_detection(x);
%     data=[averageZCR,divZCR,averageAMP,divAMP] ;
%     total=[total data'];
%     
%     end
% end
% total=total';
% save('test_data_matrix.mat','total');