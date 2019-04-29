function result = not_stop ()
% schweigi April 2015

try
    
    global stopButton

    result = ~get(stopButton,'Value');

    global h_status
    global h_in_value
    global in
    global h_out_value
    global out
    global anz_var

    if result
        set(h_status,'String','Running'); 
    else
        set(h_status,'String','Stopped');
    end

    for i=1:anz_var

    in{i} = str2double(get(h_in_value{i},'String'));

    set(h_out_value{i},'String',out{i});

    drawnow

    end

catch
    result = 0;
    return
end
end


