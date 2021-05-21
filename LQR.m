f1 = figure;
ax = axes('Parent',f1,'position',[0.13 0.25  0.77 0.65],'FontSize',25);
p1 = uipanel(f1,'Position',[0.0 0.0 5 0.15],'Title','Control Panel','FontSize',25);

c1 = uicontrol(p1,'Style', 'slider',...
    'Min',0.01,'Max',2,'Value',1,...
    'Position', [140 20 120 20],...
    'Tag','slider1',...
    'Callback', @slider_Callback); 

c2 = uicontrol(p1,'Style', 'slider',...
    'Min',0.1,'Max',20,'Value',1,...
    'Position', [270 20 120 20],...
    'Tag','slider2',...
    'Callback', @slider_Callback2); 

c3 = uicontrol(p1,'Style', 'slider',...
    'Min',0.1,'Max',20,'Value',1,...
    'Position', [400 20 120 20],...
    'Tag','slider3',...
    'Callback', @slider_Callback3); 

function slider_Callback(c1, eventdata, handles) %#ok<*INUSD>

    R  = get(c1, 'Value');
    data = struct('val',R);
    c1.UserData = data;
    plot_data()
     
end

function slider_Callback2(c2, eventdata, handles)

    Q1  = get(c2, 'Value');
    data = struct('val',Q1);
    c2.UserData = data;
    plot_data()
     
end

function slider_Callback3(c3, eventdata, handles)

    Q2  = get(c3, 'Value');
    data = struct('val',Q2);
    c3.UserData = data;
    plot_data()
     
end


function plot_data()
    
    h1 = findobj('Tag','slider1');
	data1 = h1.UserData;
    c1.UserData = data1;
    
    h2 = findobj('Tag','slider2');
	data2 = h2.UserData;
    c2.UserData = data2;
 
    h3 = findobj('Tag','slider3');
	data3 = h3.UserData;
    c3.UserData = data3;
    
    i = 0;
    t = 0:0.1:6;

    A = [0 1; -5 -6];
    B = [0 ; 1];
    C = [1 0];
    x0 = [1 ;0];
    
    
    disp("------------------------")
    try
        R  = data1.val
    catch
        R = 1
    end
    
    try
        Q1 = data2.val;
    catch
        Q1 = 1;
    end
    
    try
        Q2 = data3.val; 
    catch
        Q2 = 1;
    end
    
    Q = [Q1 0 ; 0 Q2]
    [K,S,e] = lqr(A,B,Q,R); %#ok<*ASGLU>
    
    for n = t
        i = i + 1;
        x = expm((A-B*K) * n) * x0;
        x1(i) = x(1); %#ok<*AGROW>
        x2(i) = x(2);
        %y(i) = C * x;
    end
    
    plot(t,x1,t,x2)
    xlim([0 6])
    ylim([-1 1])
    legend({'x1','x2'},'Location','southeast','FontSize',25)
    xlabel("time") 
    ylabel('state') 

    grid on   

end
