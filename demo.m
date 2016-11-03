%运行环境：64bit win7  R2015a
%
%添加voicebox工具箱到路径中
%addpath(genpath('C:\Program Files\MATLAB\MATLAB Production Server\R2015a\toolbox'))
clc;
close all;
clear all;
pwd='C:\Users\Lenovo\Desktop\DSP_experiments';
train=audioread('C:\Users\Lenovo\Desktop\DSP_experiments\train_chinese_new.wav');
test=audioread('C:\Users\Lenovo\Desktop\DSP_experiments\chinese_1357924680.wav');
sampling_test(train);
test_data(test);
KNN();
