clear all;
close all;
clc;

% packages for octave
pkg load signal

% load data for octave
%load('mic_signals.mat');
load('mic_signals_hw2.mat');

% variables
c = 343;

% Time of flight calculation
toF = @(xm, xs) 1 / c * norm(xm - xs);