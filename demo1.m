function final=demo1(aaa,N)
global result0 tim 
global k
tic
MFCC2(aaa,N);
train_mfcc=cell(10,10);
dist=zeros(1,10);
load('train_all_F3.mat','train_mfcc');
load('continus.mat','my_mfcc_cell');
result0=cell(1,N);
train_mfcc=train_mfcc';
k=0;
hwait=waitbar(0,'请等待...');
steps=N*100;
step=steps/100;
for one=1:N  %   test one.two.wav    the true value is (one-1)!
    index=[];
        for t=1:10   %与10组进行比较，如果速度慢，可以降低数值
                parfor group=1:10 %每个数测试   这个10不可以改变
                    dist(group) = dtw_polished1(my_mfcc_cell{one}, train_mfcc{group,t}); %修改采用的DTW算法类型
                end
                [minr,index0]=min(dist);
                index=[index index0-1];
                k=k+10;
                if steps-k<=15
                    waitbar(k/steps,hwait,'即将完成');
%                     pause(0.001);
                else
                    PerStr=fix(k/step);
                    str=['正在分析... ',num2str(PerStr),'%'];
                    waitbar(k/steps,hwait,str);
%                     pause(0.001);
                end
                
        end       
        table=tabulate(index);
        [F,I]=max(table(:,2));
        I=find(table(:,2)==F);
        result=table(I,1);
        result0{one}= result;
%       fprintf('\n');        
end
result0 = cell2mat(result0);
close(hwait);
tim=toc
final = result0;



