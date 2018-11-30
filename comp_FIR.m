% FIR filter design
clc
close all
COUCOU!!

% Sample the frequency vector
w1 = 0:4.06e-4:0.008;
w2 = 0.008:4.06e-4:0.04; 
w3 = 0.04:8.12e-4:0.1;
w4 = 0.1:8.12e-4:0.83;

n = 512;

A1 = [ones(length(w1),1) cos(kron(w1'.*(2*pi),[1:n-1]))];
A2 = [ones(length(w2),1) cos(kron(w2'.*(2*pi),[1:n-1]))];
A3 = [ones(length(w3),1) cos(kron(w3'.*(2*pi),[1:n-1]))];
A4 = [ones(length(w4),1) cos(kron(w4'.*(2*pi),[1:n-1]))];
B1 = [zeros(length(w1),1) sin(kron(w1'.*(2*pi),[1:n-1]))];
B2 = [zeros(length(w2),1) sin(kron(w2'.*(2*pi),[1:n-1]))];
B3 = [zeros(length(w3),1) sin(kron(w3'.*(2*pi),[1:n-1]))];
B4 = [zeros(length(w4),1) sin(kron(w4'.*(2*pi),[1:n-1]))];

% A1 = [ones(length(w1),1) cos(kron(w1'.*2*pi/(4.06e-4),[1:n-1]))];
% A2 = [ones(length(w2),1) cos(kron(w2'.*2*pi/(4.06e-4),[1:n-1]))];
% A3 = [ones(length(w3),1) cos(kron(w3'.*2*pi/(8.12e-4),[1:n-1]))];
% A4 = [ones(length(w4),1) cos(kron(w4'.*2*pi/(8.12e-4),[1:n-1]))];
% B1 = [zeros(length(w1),1) sin(kron(w1'.*2*pi/(4.06e-4),[1:n-1]))];
% B2 = [zeros(length(w2),1) sin(kron(w2'.*2*pi/(4.06e-4),[1:n-1]))];
% B3 = [zeros(length(w3),1) sin(kron(w3'.*2*pi/(4.06e-4),[1:n-1]))];
% B4 = [zeros(length(w4),1) sin(kron(w4'.*2*pi/(4.06e-4),[1:n-1]))];


% optimal complementary FIR filter design
cvx_begin
variable y(n+1,1)
%   variable t
  maximize(-y(1))
  for i = 1:length(w1)
      norm([0 A1(i,:);0 B1(i,:)]*y)<=8e-4;
  end
  for  i = 1:length(w2)
      norm([0 A2(i,:);0 B2(i,:)]*y)<=8*(w2(i)*2*pi)^3;
  end
  for i = 1:length(w3)
      norm([0 A3(i,:);0 B3(i,:)]*y)<=3;
  end
  for i = 1:length(w4)
      norm([[1 0]'- [0 A4(i,:);0 B4(i,:)]*y])<=y(1);
  end
cvx_end
h = y(2:end)
% plot the FIR impulse reponse
figure(1)
stem([0:n-1],h)
xlabel('n')
ylabel('h(n)')

w=[w1 w2 w3 w4];

% plot the frequency response
H = [exp(-j*kron(w'.*2*pi,[0:n-1]))]*h;

figure(2)
% magnitude
subplot(2,1,1);
loglog(w,abs(H),w,abs(1-H),'--')
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([1e-3 1]);
ylim([1e-4 10])
legend('Highpass','Lowpass','Location','SouthEast')
grid on
% phase
subplot(2,1,2)
semilogx(w,unwrap(angle(H)).*180/pi,w,unwrap(angle(1-H))*180/pi)
% axis([0,pi,-pi,pi])
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
xlim([0.001 1])
grid on