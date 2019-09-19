function varargout = untitled_6may(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_6may_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_6may_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before untitled_6may is made visible.
function untitled_6may_OpeningFcn(hObject, eventdata, handles, varargin)

set(handles.togglebutton1,'Enable','off')
set(handles.togglebutton2,'Enable','off')
set(handles.togglebutton3,'Enable','off')
set(handles.pushbutton1,'Enable','on')
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
instrreset;



% --- Outputs from this function are returned to the command line.
function varargout = untitled_6may_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

guidata(hObject, handles);
global serial_Port; 
serial_Port = serial('COM6');   
set(serial_Port, 'BaudRate', 19200); 
fopen(serial_Port);
set(handles.togglebutton1,'Enable','off')
set(handles.togglebutton2,'Enable','on')
set(handles.togglebutton1,'Enable','off')
set(handles.pushbutton1,'Enable','off')


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)

while get(hObject,'Value')
    set(handles.togglebutton1,'Enable','on')
     set(handles.togglebutton2,'Enable','off')
     set(handles.togglebutton3,'Enable','on')
    global serial_Port; 
set(handles.pushbutton1,'Enable','off')

%%%%%%%file scanning%%%%%%%%%%%%%%%
% cla reset;
file2 = fopen('output4.txt','r');
sizeB = [3 Inf];
formatSpec = '%f %f %f'; 
Z = fscanf(file2,formatSpec,sizeB);
fclose(file2);

if (size(Z)>=[3,12])

    
    
file_sys= fopen('output6.txt','r');
sizeC = [1 Inf];
max_sys= fscanf(file_sys,formatSpec,sizeC);
max_sys=max_sys';
fclose(file_sys);
max_sys=max_sys(end);   

    
    
yMax  = 5000;                          
yMin  = 0;                    
plotGrid = 'on';               
min = 0;                         % set y-min
max_1 =inf;                        % set y-max                 
time = 0;
data = 0;
count = 0;
F3_out = 0;
axes(handles.axes1);
  set(gca,'Color','k') 
  %%%%%%%%%%Black background
  
 cla reset; 
plotGraph= plot(time,data,'g','linewidth',2 ); 
hold on
hline = refline([0 max_sys]);
% hline.Color = 'k';
title('RAW Data') 
xlabel('Time(sec)')                     
ylabel('Voltage(V)')
axis([yMin yMax min max_1]);
grid(plotGrid);
fileID = fopen('output3.txt','w'); 
 running_time = 10; 
  grid minor
  set(gca,'Color','k')   %%%%%%%%%%Black background
 set(gca, 'XColor', [0.5 0.5 0.5],'YColor', [0.5 0.5 0.5],'LineWidth',0.02);%%%x and y axis plot line

fig=gcf;
set(fig,'Color',[0.8 0.8 0.8]);%%%%gui background color 0to1
tic
while (toc<running_time) 
      
    
    dat = fscanf(serial_Port,'%f %f %f');
     dat= (dat*5)/65536;
     fwrite(fileID,fscanf(serial_Port));     
         count = count + 1;    
         time(count) = toc;    
         data(count) = dat(1);  
         
         set(plotGraph,'XData',time,'YData',data);
        
if toc>5
          axis([(time(count)-5) (time(count)+0) min max_1]);
           axis 'auto y';
                 drawnow
                 hline = refline([0 max_sys]);
                 

else
    axis([0 time(count) min max_1]);
     axis 'auto y';

    
end

          drawnow       
end
cla reset;

else

yMax  = 5000;                          
yMin  = 0;                    
plotGrid = 'on';               
min = 0;                         % set y-min
max_1 =inf;                        % set y-max                 
time = 0;
data = 0;
count = 0;
F3_out = 0;
axes(handles.axes1);
  set(gca,'Color','k')   %%%%%%%%%%Black background
  cla reset;
plotGraph= plot(time,data,'g','linewidth',2 ); 
hold on

title('RAW Data') 
xlabel('Time(sec)')                     
ylabel('Voltage(V)')
axis([yMin yMax min max_1]);
grid(plotGrid);
fileID = fopen('output3.txt','w'); 
 running_time = 10; 
  grid minor
  set(gca,'Color','k')   %%%%%%%%%%Black background
 set(gca, 'XColor', [0.5 0.5 0.5],'YColor', [0.5 0.5 0.5],'LineWidth',0.02);%%%x and y axis plot line

fig=gcf;
set(fig,'Color',[0.8 0.8 0.8]);%%%%gui background color 0to1
tic
while (toc<running_time) 
      
    
    dat = fscanf(serial_Port,'%f %f %f');
     dat= (dat*5)/65536;
     fwrite(fileID,fscanf(serial_Port));     
         count = count + 1;    
         time(count) = toc;    
         data(count) = dat(1);  
         
         set(plotGraph,'XData',time,'YData',data);
        
if toc>5
          axis([(time(count)-5) (time(count)+0) min max_1]);
           axis 'auto y';
                 drawnow
%                  hline = refline([0 max_sys]);
% hline = refline([0 mu]);
% hline.Color = 'k';
% hline.LineStyle = ':';
else
    axis([0 time(count) min max_1]);
     axis 'auto y';

    
end

          drawnow       
end
cla reset;
end

[b_F3,a_F3]=butter(4,0.08);                              

pulse_pressure_F3_out = filter(b_F3,a_F3,data);
[sis, locations] = findpeaks(pulse_pressure_F3_out);
[dia, locations1] = findpeaks(-pulse_pressure_F3_out);
 
axes(handles.axes2);
plot(time,pulse_pressure_F3_out,'r'),grid on;  

hold on
scatter(time(locations1),pulse_pressure_F3_out(locations1),40,'filled');
scatter(time(locations),pulse_pressure_F3_out(locations),40,'filled');
title('Filtered Data')              
xlabel('Time(sec)')                     
ylabel('voltage(V)')
hold off
%%%%%%%%AVG%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sis1= mean(sis);
dia1=mean(dia);

pp=sis1+dia1;

%%%%%%%%AVG PP%%%%%%%%%%%%Previous Value Reading%%%%%%%%%%%%%%
file2 = fopen('output4.txt','r');
sizeB = [3 Inf];
formatSpec = '%f %f %f'; 
Z = fscanf(file2,formatSpec,sizeB);
Previous_pp= Z(1,end);

if (size(Z)>=[3,10])
    
pp_matrix=Z(1,:);
Max_pp=max(pp_matrix);
I = Z(1,end-5:end);

K=max(I);

[max_num,max_idx]=max(Z(1,:));
a=max_num;
max_sys=Z(2,max_idx);
max_dia=Z(3,max_idx);
max_dia=-1*max_dia;

file_sys = fopen('output6.txt','wt');
fmt= '%6.2f\n';
fprintf(file_sys,fmt,max_sys);
fclose(file_sys); 
text11 = sprintf('%0.4f', max_sys);
set(handles.text2,'String',text11);


file_dia = fopen('output7.txt','wt');
fmt= '%6.2f\n';
fprintf(file_dia,fmt,max_dia);
fclose(file_dia); 
text12 = sprintf('%0.4f', max_dia);
set(handles.text3,'String',text12);


    else
  Previous_pp= Z(1,end);
end
Previous_pp_1 = Previous_pp+0.05;
Previous_pp_2 = Previous_pp-0.05;
fclose(file2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%Printing the new pp and sys value in o/p4%%%%%%%%%%%%%%%%%%%%%%%
file2 = fopen('output4.txt','a');
fmt= '%6.2f %12.8f %18.2f\r\n';
y = [pp; sis1; dia1];
fprintf(file2,fmt,y);
fclose(file2); 
file2 = fopen('output4.txt','r');  
formatSpec = '%f %f %f'; 
sizeB = [3 Inf]; 
B = fscanf(file2,formatSpec,sizeB);
fclose(file2); 
pp_matrix= B(1,:);
pp=B(1,end);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%steps file%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file3 = fopen('output5.txt','r');
sizeC = [1 Inf];
C = fscanf(file3,formatSpec,sizeC);
C= C(end);
%C=C';
fclose(file3);
C=C+1;
fmt_1='%6.2f\n';
file3 = fopen('output5.txt','a');
fprintf(file3,fmt_1,C);
fclose(file3);
file3= fopen('output5.txt','r');
C= fscanf(file3,formatSpec,sizeC);
C=C';
fclose(file3);
t=C(:,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Plotting pp vs step %%%%%%%%%%%%%%%%%%%%%%%%


axes(handles.axes3);

    plot(t,pp_matrix,'r','linewidth',3);
    hold on
    xlim([0 50])
     ylim([0 0.5])
    hold on
   
    %%%%%%%%%%%%%legand %%%%%%%%%%%%%%%%
    if (size(Z)<=[3,10]) 
        hold on
if (pp>Previous_pp_1)
hold on
legend('UP');
elseif (pp<Previous_pp_2)

legend('DOWN');

else 
  hold on  
 legend('SAME');
 
end
    else
     hold on
     if (a>pp)
         hline = refline([0 a]);
         hline = refline([0 a-0.03]);
hline = refline([0 a+0.03]);

legend('UP');
 elseif (a<pp)

     hline = refline([0 a]);
     hline = refline([0 a-0.03]);
hline = refline([0 a+0.03]);

legend('DOWN')
     elseif (pp~=Previous_pp)
         hline = refline([0 a]);
         hline = refline([0 a-0.03]);
hline = refline([0 a+0.03]);

 legend('keep hold');
 elseif (a~=K)
         hline = refline([0 a]);
         hline = refline([0 a-0.03]);
hline = refline([0 a+0.03]);

 legend('STABLE');
 hold on

     end
     
     hold on
    end
 hold on 
scatter(t,pp_matrix,40,'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5')     

xlabel('Steps')                     
ylabel('PP')
title('Dynamic Average') 
hold off


end


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% set(handles,textmyoutput


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in togglebutton2. %%%centering
function togglebutton2_Callback(hObject, eventdata, handles)
while get(hObject,'Value')
    set(handles.togglebutton1,'Enable','on')
     set(handles.togglebutton2,'Enable','off')
     set(handles.togglebutton3,'Enable','on')
    global serial_Port; 
set(handles.pushbutton1,'Enable','off')
yMax  = 5000;                          %y Maximum Value
yMin  = 0;                     %y minimum Value
plotGrid = 'on';                 % 'off' to turn off grid
min = 0;                         % set y-min
max_1 =inf;                        % set y-max
time = 0;
data = 0;
count = 0;
axes(handles.axes1);
plotGraph = plot(time,data,'g','linewidth',2);
title('Centering') 
xlabel('Time(sec)')                     
ylabel('Voltage(V)')
hold on 
axis([yMin yMax min max_1]);
grid(plotGrid);
 running_time_1 = 60; 
 grid minor
  set(gca,'Color','k')   %%%%%%%%%%Black background
 set(gca, 'XColor', [0.5 0.5 0.5],'YColor', [0.5 0.5 0.5],'LineWidth',0.02);%%%x and y axis plot line
fig=gcf;
set(fig,'Color',[0.8 0.8 0.8]);%%%%gui background color 0to1
tic;
while (toc<running_time_1)
         
    dat = fscanf(serial_Port,'%f %f %f'); 
    dat= (dat*5)/65536;
    count = count + 1;    
         time(count) = toc;    
         data(count) = dat(1);  
         set(plotGraph,'XData',time,'YData',data);
if toc>5
          axis([(time(count)-5) (time(count)+0.5) min max_1]);
         axis 'auto y';
else
    axis([0 time(count) min max_1]);
   axis 'auto y';
end
          drawnow   
end

cla reset;
end


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
while get(hObject,'Value')
    set(handles.togglebutton1,'Enable','on')
     set(handles.togglebutton2,'Enable','off')
     set(handles.togglebutton3,'Enable','off')
    global serial_Port; 
set(handles.pushbutton1,'Enable','off')

file_sys= fopen('output6.txt','r');
sizeC = [1 Inf];
formatSpec = '%f %f %f'; 
max_sys= fscanf(file_sys,formatSpec,sizeC);
max_sys=max_sys';
fclose(file_sys);
max_sys=max_sys(end);   



yMax  = 5000;                          %y Maximum Value
yMin  = 0;                     %y minimum Value
plotGrid = 'on';                 % 'off' to turn off grid
min = 0;                         % set y-min
max_1 =inf;                        % set y-max
time = 0;
data = 0;
count = 0;
% cla reset;
axes(handles.axes1);
plotGraph = plot(time,data,'g','linewidth',2);
title('Recording') 
xlabel('Time(sec)')                     
ylabel('Voltage(V)')
hline = refline([0 max_sys]);
hold on 
axis([yMin yMax min max_1]);
grid(plotGrid);
fileID = fopen('output3.txt','w'); 
 running_time_1 = 60; 
 grid minor
  set(gca,'Color','k')   %%%%%%%%%%Black background
 set(gca, 'XColor', [0.5 0.5 0.5],'YColor', [0.5 0.5 0.5],'LineWidth',0.02);%%%x and y axis plot line
fig=gcf;
set(fig,'Color',[0.8 0.8 0.8]);%%%%gui background color 0to1

% load s1
tic;
while (toc<running_time_1)
  
    dat = fscanf(serial_Port,'%f %f %f'); 
    dat= (dat*5)/65536;
     fwrite(fileID,fscanf(serial_Port));    
         count = count + 1;    
         time(count) = toc;    
         data(count) = dat(1);  
         set(plotGraph,'XData',time,'YData',data);
         
if toc>5
          axis([(time(count)-5) (time(count)+0.5) min max_1]);
         axis 'auto y';
         hline = refline([0 max_sys]);
else
    axis([0 time(count) min max_1]);
   axis 'auto y';
end
          drawnow   
          hold off
end
cla reset;

[b_F3,a_F3]=butter(4,0.08);                              
F3_out = filter(b_F3,a_F3,data);
[sIs, locations] = findpeaks(F3_out);
[dia, locations1] = findpeaks(-F3_out);
axes(handles.axes2);
plot(time,F3_out,'r'),grid on;  
%ylim([0 4])
hold on
scatter(time(locations1),F3_out(locations1),40,'filled');
scatter(time(locations),F3_out(locations),40,'filled');
title('Filtered Data') 
t=title(['\fontsize{16}\color {red}Filtered Data']);
% t.Color = 'red';
xlabel('Time(sec)','Color','r','FontSize',10)                     
ylabel('Volts','Color','r','FontSize',10)
%h=legend('Filtered Data');  
hold off

file_sis = fopen('output9.txt','wt');
fmt= '%6.8f %12.8f\n';
y = [F3_out(locations1); time(locations1)];
fprintf(file_sis,fmt,y);
fclose(file_sis); 
file_sis = fopen('output9.txt','r'); 
formatSpec = '%f %f %f'; 
sizeD = [2 Inf]; 
D = fscanf(file_sis,formatSpec,sizeD);
D=D';
fclose(file_sis); 
sys= D(:,1);
loc=D(:,2);
file_dia = fopen('output10.txt','wt');
fmt= '%6.8f %12.8f\n';
z = [F3_out(locations); time(locations)];
fprintf(file_dia,fmt,z);
fclose(file_dia); 
file_dia = fopen('output10.txt','r'); 
formatSpec = '%f %f %f'; 
sizeE = [2 Inf]; 
E = fscanf(file_dia,formatSpec,sizeE);
E=E';
fclose(file_dia); 
dias= E(:,1);
loc1=E(:,2);
load s1
Force =sim(net,sys');
Area=pi*0.005^2;
Pressure_pascal=Force/Area;
Pressure_mmhg=0.007500617*Pressure_pascal;
Force_DC = sim(net,dias');
Pressure_pascal_DC=Force_DC/Area;
Pressure_mmhg_DC=0.007500617*Pressure_pascal_DC;
axes(handles.axes3);
plot(loc,Pressure_mmhg,'r')
hold on
plot(loc1,Pressure_mmhg_DC,'r')
hold on
xlabel('Time(sec)','Color','r','FontSize',10)                     
ylabel('mmHg','Color','r','FontSize',10)
% title('SYS & DIA Peak (mmHg)')
title(['\fontsize{16}\color {red}SYS & DIA Peak (mmHg)']);
% t.Color = 'red';
scatter(loc,Pressure_mmhg,40,'filled');
scatter(loc1,Pressure_mmhg_DC,40,'filled');
drawnow

end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
