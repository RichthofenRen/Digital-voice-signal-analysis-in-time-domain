%���л�����64bit win7  R2015a
%
%���voicebox�����䵽·����
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
