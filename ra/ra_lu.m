% Roomacoustics

clear all, close all, clc;

% plot config
fig_size_long = [0, 0, 1200, 600];
xticklabel = ["63"; "125"; "250"; "500"; "1k"; "2k"; "4k"; "8k"];
ytick = [0.25 0.5 0.75 1.0 1.25 1.5];

% measures
f_oct = [63 125 250 500 1000 2000 4000 8000];
T_av = [1.553 1.081 0.729 0.871 1.051 1.210 1.053 1.040];
T_speech = [0.9 0.9 0.9 0.9 0.9 0.9 0.9 0.9];
T_com = [0.73 0.73 0.73 0.73 0.73 0.73 0.73 0.73];
T_opt = [0.68 0.78 0.62 0.74 0.84 0.85 0.82 0.85];



figure(1, 'position', fig_size_long)
hold on

semilogx(f_oct, T_av, 'LineWidth', 2)
semilogx(f_oct, T_speech, 'LineWidth', 1.5, 'c--')
semilogx(f_oct, T_com, 'LineWidth', 1.5, 'm-.')
semilogx(f_oct, T_opt, 'LineWidth', 3, 'r-')

scatter(f_oct, T_av, 10, 'b', 'd')
scatter(f_oct, T_opt, 10, 'r', 'd')

xlim([63, 8000])
ylim([0, 1.6])
grid on

ylabel('Nachhallzeit [s]', 'fontsize', 18)
xlabel('Frequenz [Hz]', 'fontsize', 18)
lgd = legend('Gemessen', 'Soll Sprache', 'Soll Kommunikation', 'Optimiert');

set(gca,'FontSize',14)
set(gca, 'xtick', f_oct)
set(gca, 'ytick', ytick)
set(gca,'xticklabel', xticklabel)
set(lgd, 'FontSize', 14);

print('T_all', "-S1200, 600",'-dpng')