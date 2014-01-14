%
% reference: cga01_Color transfer between images
%
% Copyright (c) 2014 Junjie Cao

clc;clear all;close all;
addpath(genpath('../../'));
DEBUG = 1;

src=imread('source.jpg');
src = im2double(src);
tgt=im2double(imread('target.jpg'));
tgt = im2double(tgt);
figure,subplot(131);imshow(src);title('Source');
subplot(132);imshow(tgt);title('Target');

%%
lAlphaBetaT = RGB2lAlphaBeta(tgt);
lAlphaBetaS = RGB2lAlphaBeta(src);
lAlphaBetaN = channels_transfer(lAlphaBetaT, lAlphaBetaS);

im=lAlphaBeta2RGB(lAlphaBetaN, size(src));
subplot(133);imshow(im);title('Result');
