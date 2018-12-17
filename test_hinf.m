clear; close all; clc;

load('open_cp1f.mat');
G = [1 0; 0 open_cp1f];
G = ss(G);

%Bode plot options
opts = bodeoptions('cstprefs');
opts.FreqUnits = 'Hz';
opts.PhaseWrapping = 'on';
opts.Xlim = [0.1 1000];

A = G.A;
Bw = G.B(:,1);
Bu = G.B(:,2);
Cz = G.C(1,:)-G.C(2,:); Dzw = G.D(1,1)-G.D(2,1);Dzu = G.D(1,2)-G.D(2,2);
Cy = G.C(1,:)-G.C(2,:); Dyw = G.D(1,1)-G.D(2,1);Dyu = G.D(1,2)-G.D(2,2);

P = ss(A,[Bw Bu],[Cz;Cy],[Dzw Dzu; Dyw Dyu]);
OLsys = tf(P);
% h infinity control
ny = 1; nu = 1; nw = 1;nz = 1;
[K1,CLsys,GAM,INFO] = hinfsyn(P, ny, nu,'GMIN', 5, 'DISPLAY', 'on');

figure
bode(CLsys(1,1), OLsys(1,1),opts)

