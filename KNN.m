%input：训练和测试数据，存于mat文件中
%output：KNN算法的测试结果

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
X=my_train_data;    %训练特征，每行是一个特征向量，列数是特征的维数，行数是特征的个数  
Y=train_label(:);   %与特征对应的label，每个类别都有picesPerclass个，共class_num 个类别  
mdl =ClassificationKNN.fit(X,Y,'NumNeighbors',1); %训练KNN模型  

characterClass= predict(mdl,my_test_data);  %得到最佳的分类。
characterClass=characterClass-1;
myClass=characterClass';
disp('k近邻识别结果：');
for i=1:10
    fprintf('10组语音测试样本%d的测试结果为',i-1);
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
    fprintf('10组语音测试样本%d的测试正确率为',i-1);
    disp(1-error);
end


index=find(re);
tmp=size(index);
num=tmp(1);
error=num/100;
fprintf('综合正确率：');
disp(1-error);
toc

 

 

 
 
 