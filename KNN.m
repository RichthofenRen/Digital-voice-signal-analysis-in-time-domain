%input��ѵ���Ͳ������ݣ�����mat�ļ���
%output��KNN�㷨�Ĳ��Խ��

function[]=KNN()
tic
close all;   
clear all;
load('train_data_matrix0.mat','DATA');
load('test_data_matrix.mat','total');
 my_train_data = DATA;
 my_test_data = total;
piecesPerclass=10;  
class_num=10;
for i=1:class_num  
   train_label(:,i)=zeros(1,piecesPerclass)+i;  
end  
X=my_train_data;    %ѵ��������ÿ����һ������������������������ά���������������ĸ���  
Y=train_label(:);   %��������Ӧ��label��ÿ�������picesPerclass������class_num �����  
mdl =ClassificationKNN.fit(X,Y,'NumNeighbors',1); %ѵ��KNNģ��  

characterClass= predict(mdl,my_test_data);  %�õ���ѵķ��ࡣ
characterClass=characterClass-1;
myClass=characterClass';
disp('k����ʶ������');
for i=1:10
    fprintf('10��������������%d�Ĳ��Խ��Ϊ',i-1);
    disp(myClass((i-1)*10+1:(i-1)*10+10));

end
b=[];
for i=0:9
    a(1:10)=i;
    b=[b a];
end
re=characterClass-b';

for i=1:10
    index=find(re((i-1)*10+1:(i-1)*10+10));
    tmp=size(index);
    num=tmp(1);
    error=num/10;
    fprintf('10��������������%d�Ĳ�����ȷ��Ϊ',i-1);
    disp(1-error);
end


index=find(re);
tmp=size(index);
num=tmp(1);
error=num/100;
fprintf('�ۺ���ȷ�ʣ�');
disp(1-error);
toc

 

 

 
 
 