% make_panel.m
% Matthias Rath
% aufbauend auf:
% schweigi April 2015

global anz_var
anz_var = 10;

figure(9999);

clf

set(9999, 'MenuBar', 'none');
set(9999, 'ToolBar', 'none');

% Fenstergröße anpassen
tmp = get(9999,'Position');
set(9999, 'Position', [tmp(1) tmp(2) 360 anz_var*30+120]);
clear tmp

% Button erstellen
global stopButton
stopButton = uicontrol('Style', 'togglebutton', 'String', 'Stop', ...
                       'Position', [10 10 100 50]);
                   
%Rahmen erstellen
uicontrol('Style', 'frame','Position', [10 70 160 anz_var*30+10],'BackgroundColor',[0.8 0.8 0.8]);   
uicontrol('Style', 'frame','Position', [180 70 170 anz_var*30+10],'BackgroundColor',[0.8 0.8 0.8]);
uicontrol('Style', 'text', 'String', 'Input-Variablen:','Position', [10 anz_var*30+80 160 20],'HorizontalAlignment', 'left');                   
uicontrol('Style', 'text', 'String', 'Output-Variablen:','Position', [180 anz_var*30+80 220 20],'HorizontalAlignment', 'left'); 
  
%Status erstellen

global h_status
h_status = uicontrol('Style', 'text', 'String', 'Configuring','Position', [120 10 100 20],'HorizontalAlignment', 'left','BackgroundColor',[0.8 0.8 0.8]); 

% Variablenzeile erstellen (Schleife)

exist_in = false;
exist_out_label = false;
    
exist_in = exist('in','var');
exist_out_label = exist('out_label','var');

global h_in_value
global h_out_value
global h_out_label
global in
global out
global out_label
h_in_value=cell(1,anz_var);
h_out_value=cell(1,anz_var);
h_out_label=cell(1,anz_var);
out=cell(1,anz_var);

if ~exist_in
    in=cell(1,anz_var);
end

for i=1:anz_var
    
if ~exist_in
    in{i} = '1';
end
    
out{i} = sprintf('out{%d}',i);
    
h_in_value{i} = uicontrol('Style', 'edit', 'String', in{i}, ...
                       'Position', [60 80+anz_var*30-i*30 100 20]);
                uicontrol('Style', 'text', 'String', sprintf('in{%d}:',i), ...
                       'Position', [20 80+anz_var*30-i*30 40 20],'HorizontalAlignment', 'left','BackgroundColor',[0.8 0.8 0.8]);               

h_out_value{i} = uicontrol('Style', 'text', 'String', out{i}, ...
                       'Position', [240 80+anz_var*30-i*30 100 20]);
                 uicontrol('Style', 'text', 'String', sprintf('out{%d}:',i), ...
                       'Position', [190 80+anz_var*30-i*30 40 20],'HorizontalAlignment', 'left','BackgroundColor',[0.8 0.8 0.8]);
                   
end  
