function y = cutperiod(x_in)
%y = cutperiod(x)
%Sucht nach der Grundfrequenz in einem Signal x und liefert ein
%abgeschnittenes Signal y in dem möglichst viele ganze Perioden befinden.
x=x_in-mean(x_in);

N=length(x);
fft_length=10*N;

X=abs(fft(x,fft_length));

[maxval maxi] = max(X(2:fft_length/2));

f= maxi;
T=fft_length/f;

%not part of a period
rest= mod(N,T);

y=x_in(1:floor(N-rest));

end