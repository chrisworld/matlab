clear all;
close all;
clc;

n_samples = 1E6;
x = 2 * rand(1, n_samples);

n_bins = 50;

% calculate pdf 
%hist(x, n_bins, n_samples)
%hist(x, n_bins)

% pdf of x
pdf_x = @(x) 0.5 * ((x >= 0) & (x <= 2));

% test samples
z = 0 : 0.001 : 10;

%{
% plot the stuff
figure 1
hist(x, n_bins, 1);
xlim([-0.5 2.5])
title('Histogram of X')
xlabel('x')
ylabel('PDF of X')
print('PDF_X', '-dpng')
%}


% -- Ex1.1
% functions to estimate
g1 = @(x) exp(x);
g2 = @(x) x .+ x.^2;
g3 = @(x) sqrt(x);

% calculate analytic expressions for pdfs
pdf_y1 = @(y) abs(1 ./ y) .* pdf_x(log(y));
pdf_y2 = @(y) abs(0.5 .* (0.25 + y).^(-1 / 2)) .* pdf_x(-0.5 + sqrt(0.25 + y)) + abs(0.5 .* (0.25 + y).^(-1 / 2)) .* pdf_x(-0.5 - sqrt(0.25 + y));
pdf_y3 = @(y) abs(2 * y) .* pdf_x(y.^2);

pdf_y_index = [1 2 3];
%y_xlim = [[0 10]; [0 10]; [0 2]];
y_xlim = [[-2 8]; [-2 8]; [0 1.5]];

% -- Ex1.2
% verify with analytic plot and histogram

pdf_y = [pdf_y1(z); pdf_y2(z); pdf_y3(z)];
y = [g1(z); g2(z); g3(z)];

% plot
%{
for idx = 1 : length(pdf_y_index)

  % analytic solution
  figure (10 + idx)
  plot(z, pdf_y(idx, :))
  xlim(y_xlim(idx, :))
  title(['Analytic function of PDF of y' int2str(pdf_y_index(idx))])
  xlabel('x')
  ylabel(['PDF of y' int2str(pdf_y_index(idx))])
  print(['PDF_Y' int2str(pdf_y_index(idx)) '_analytic'],'-dpng')

  % histogram sampling
  figure (20 + idx)  
  hist(y(idx, :), n_bins, 1);
  title(['Histogram of Y' int2str(pdf_y_index(idx))])
  xlabel(['y' int2str(pdf_y_index(idx))])
  ylabel(['PDF of Y' int2str(pdf_y_index(idx))])
  print(['PDF_Y' int2str(pdf_y_index(idx)) '_hist'],'-dpng')

end
%}


% -- Ex1.3
% means and variance

% from random var x
mu_x = 1;
var_x = 1 / 3;

% --
% with samples
mu_y_samples = [mean(g1(x)) mean(g2(x)) mean(g3(x))]
var_y_samples = [var(g1(x)) var(g2(x)) var(g3(x))]

% --
% with linearization

% mean
mu_y_lin = [g1(mu_x) g2(mu_x) g3(mu_x)]

% calculate jacobian
J1 = @(x) exp(x);
J2 = @(x) 1 + 2 .* x;
J3 = @(x) 0.5 .* (1 / sqrt(x));

% variance
var_y_lin = [ J1(mu_x) * var_x * J1(mu_x)' ...
              J2(mu_x) * var_x * J2(mu_x)' ...
              J3(mu_x) * var_x * J3(mu_x)' ]

% --
% with unscented transform

% sigma points 2N = 2
N = 1;

x_tilde = sqrt(N * var_x)';
x_sigma = [mu_x + x_tilde mu_x - x_tilde];

% propagate sigma points through system
y_sigma = [g1(x_sigma); g2(x_sigma); g3(x_sigma)];

% estimate mean and variance
mu_unsc = @(N, y) 1 / (2 * N) * sum(y);
var_unsc = @(N, y, y_mu) 1 / (2 * N) * sum((y - y_mu) * (y - y_mu)');

mu_y_unsc = [ mu_unsc(N, y_sigma(1, :)) ...
              mu_unsc(N, y_sigma(2, :)) ...
              mu_unsc(N, y_sigma(3, :))]

var_y_unsc = [  var_unsc(N, y_sigma(1, :), mu_y_unsc(1)) ...
                var_unsc(N, y_sigma(2, :), mu_y_unsc(2)) ...
                var_unsc(N, y_sigma(3, :), mu_y_unsc(3))]


% all means and vars
mu_y_all = [mu_y_samples; mu_y_lin; mu_y_unsc];
var_y_all = [var_y_samples; var_y_lin; var_y_unsc];


pdf_y_analytic = @(z) [pdf_y1(z); pdf_y2(z); pdf_y3(z)];

% plot params
marker = ['rx'; 'mo'; 'g+'];
y_xlim = [[-2 8]; [-2 8]; [0 1.8]];
v_line = [0.05, 0.05, 0.2];

% plot with mean
% %{
for idx = 1 : length(pdf_y_index)

  % analytic solution
  figure (30 + idx)
  hold on

  % for legend
  h(1) = plot(0,0, marker(1, :), 'visible', 'off');
  h(2) = plot(0,0, marker(2, :), 'visible', 'off');
  h(3) = plot(0,0, marker(3, :), 'visible', 'off');
  %legend(h, 'red','blue','black');

  plot(z, pdf_y(idx, :))

  % mean marker
  for method = 1 : 3
    v = var_y_all(method, idx);
    x_m = mu_y_all(method, idx);
    y_m = pdf_y_analytic(x_m)(idx);
    plot([x_m - v, x_m + v], [y_m, y_m], [marker(method, 1)], 'linewidth',1)
    plot([x_m - v, x_m - v], [y_m - v_line(idx), y_m + v_line(idx)], [marker(method, 1)],'linewidth',1)
    plot([x_m + v, x_m + v], [y_m - v_line(idx), y_m + v_line(idx)], [marker(method, 1)],'linewidth',1)
    plot(x_m, y_m, [marker(method, :)],'markersize',8)
  end

  xlim(y_xlim(idx, :))
  title(['Analytic function of PDF of y' int2str(pdf_y_index(idx))])
  xlabel('x')
  ylabel(['PDF of y' int2str(pdf_y_index(idx))])
  legend('sample', 'linear', 'unscented')
  grid on
  hold off
  %print(['PDF_Y' int2str(pdf_y_index(idx)) '_marks'],'-dpng')
end
%}