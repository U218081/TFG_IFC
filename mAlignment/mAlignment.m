
function varargout = mAlignment(varargin)
% MALIGNMENT MATLAB code for mAlignment.fig
%      MALIGNMENT, by itself, creates a new MALIGNMENT or raises the existing
%      singleton*.
%
%      H = MALIGNMENT returns the handle to a new MALIGNMENT or the handle to
%      the existing singleton*.
%
%      MALIGNMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MALIGNMENT.M with the given input arguments.
%
%      MALIGNMENT('Property','Value',...) creates a new MALIGNMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mAlignment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mAlignment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mAlignment

% Last Modified by GUIDE v2.5 30-Jun-2022 12:18:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mAlignment_OpeningFcn, ...
    'gui_OutputFcn',  @mAlignment_OutputFcn, ...
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
end

% --- Executes just before mAlignment is made visible.
function mAlignment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mAlignment (see VARARGIN)

% Choose default command line output for mAlignment
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes mAlignment wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = mAlignment_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in changeModeButton.
function changeModeButton_Callback(hObject, eventdata, handles)
% hObject    handle to changeModeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Each click on this button changes the execution mode from
% plot MOVING MODE - This allows the user to move the alignment results.
% CORRECTING MODE - This allows the user to select a segment to
% interpolate
mihandles=checkHandles();
if handles.mode== 0
    %CORRECTING MODE
    handles.mode=1;

    %We must inform the user of what mode he is in:

    texto=findobj('Tag', 'textMode');
    set(texto, 'String', 'Correction mode');
    
    mihandles.mode=1;
   
    set(handles.Linea,  'buttondownfcn','');
    set(handles.Linea, 'buttondownfcn',{@buttondown, handles});

else
    %We return to mode 0 = > moving points
    %Informing the user again:

    texto=findobj('Tag', 'textMode');
    set(texto, 'String', 'Plot moving mode');

   
    mihandles=delPuntos();

    handles.mode=0;
    mihandles.mode=0;
    set(handles.Linea,  'buttondownfcn',{@buttondown,handles});
    
end


checkHandles(mihandles);
guidata(hObject, handles);
end

% --- Executes on button press in loadButton.
 
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
openFile_ClickedCallback(hObject, eventdata, handles);

    texto=findobj('Tag', 'textMode');
    set(texto, 'String', 'Moving plot mode');

end

% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setButtons(false)
setButton('loadButton','off')
p=evalin('base','p');
matrizTmxTr=evalin('base','matrizTmxTr');
tr_anclaje=evalin('base','tr_anclaje');
tm_anclaje=evalin('base','tm_anclaje');
text=findobj('tag','tSaving');
set(text,'visible', 'on')

if (all(tr_anclaje) && all(tm_anclaje))
uisave({'p','matrizTmxTr','tr_anclaje', 'tm_anclaje'},handles.nombremat)
msgbox('Saving process done.','Saved');
else
uisave({'p','matrizTmxTr'},handles.nombremat)
msgbox('Saving process done.','Saved');
end


%save(handles.nombremat, 'p', 'matrizTmxTr');
set(text,'visible', 'off')
setButtons(true);
setButton('loadButton','on')

end


% --- Executes on button press in correctButton.
function correctButton_Callback(hObject, eventdata, handles)
% hObject    handle to correctButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mihandles=checkHandles();
if mihandles.puntosCorreccion == 2

    %What do we do with these values? -> correcting segment function
    ydata=corregirTramo(mihandles);
    mihandles=delPuntos();
    set(handles.Linea ,'ydata',ydata);
    mihandles.ydata=ydata;
    assignin('base', 'p', ydata);
    checkHandles(mihandles);
   
else
    texto=findobj('Tag', 'tAnclaje');
    set(texto,'String',' You must set the beggining and end of the segment.');
    
end
end


% --- Executes on button press in zoomButton.
%Zoom mode on:
function zoomButton_Callback(hObject, eventdata, handles)
% hObject    handle to zoomButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=checkHandles();
if ~handles.zoom
    if handles.pan
        handles.pan=false;
    end
    
    %We must turn off all buttons other than the zoom ones
    setButtons(false);
    setButton('zoomButton','on');
    setButton('panButton', 'on');
    setButton('zoomOutButton','on');
    setButton('loadButton','off');

    zoom on;
    set(handles.Linea, 'buttondownfcn',      '');
    textZoom=findobj('Tag', 'zoomText');
    set(textZoom, 'String','Zoom tool enabled.');
    set(textZoom, 'visible','on');

    handles.zoom=true;
else
    setButton('panButton', 'on');
    zoom off;
    set(handles.Linea, 'buttondownfcn',      '');
    textZoom=findobj('Tag', 'zoomText');
    set(textZoom, 'visible','off');

    set(handles.Linea, 'buttondownfcn',{@buttondown, handles}); % uso normal de la aplicacion
    handles.zoom=false;
    %Lets turn the buttons back on
    setButtons(true);
    setButton('loadButton','on');
end
checkHandles(handles);
end


% --- Executes on button press in panButton.
%Activa el modo PAN
function panButton_Callback(hObject, eventdata, handles)
% hObject    handle to panButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=checkHandles();
if ~handles.pan
    %delPuntos();
    %All buttons other than zoom/pan must be turned off
    setButtons(false);
    setButton('panButton','on');
    setButton('zoomButton','on');
    if handles.zoom
        handles.zoom=false;
    end
    setButton('zoomOutButton','on');
    setButton('loadButton','off');
    pan on;
    set(handles.Linea, 'buttondownfcn',      '');
    textZoom=findobj('Tag', 'zoomText');
    set(textZoom, 'String','Pan tool enabled.');
    set(textZoom, 'visible','on');
    handles.pan=true;
else
    pan off
    set(handles.Linea, 'buttondownfcn',      '');
    textZoom=findobj('Tag', 'zoomText');
    set(textZoom, 'visible','off');

    set(handles.Linea, 'buttondownfcn',{@buttondown, handles}) % uso normal de la aplicacion
    handles.pan=false;
    %Lets turn on all the other buttons
    setButtons(true);
    setButton('loadButton','on');
end
checkHandles(handles);
end

% --- Executes on button press in zoomOutButton.
function zoomOutButton_Callback(hObject, eventdata, handles)
% hObject    handle to zoomOutButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=checkHandles();

zoom out; %this simply goes back 
pan off;
zoom off;
if handles.zoom || handles.pan
  set(handles.Linea, 'buttondownfcn',{@buttondown, handles}) % normal use of the application
end
handles.zoom=false;
handles.pan=false;

checkHandles(handles);
setButton('zoomButton','on');
setButton('panButton','on');
setButton('loadButton','on');

textZoom=findobj('Tag', 'zoomText');
set(textZoom, 'visible','off');
setButtons(true);
end




% --------------------------------------------------------------------
%Open button - to open the .mat files
function uiOpenTool_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiOpenTool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.mat');
if isequal(file,0)
    disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path,file)]);
    structP=load(file,'p');
    structM=load(file,'matrizTmxTr');
    % If p or m are missing... 
    if (isempty(fieldnames(structP)) || isempty(fieldnames(structM)))
        disp('Your .mat file doesnt have the p or matrizTmxTr variables (or maybe they have other names)')
        return;
    end
    setButtons(false)
    assignin('base','p',structP.p);
    assignin('base','matrizTmxTr', structM.matrizTmxTr);
    handles=inicializar(handles);
    handles.nombremat=file;
    menu=findobj('Tag', 'vMoveMenu');
    % after loading data, the application goes to the moving mode

    setButtons(true);
    checkHandles(handles);
    texto=findobj('Tag', 'textMode');
    set(texto, 'String', 'Moving plot mode');
    guidata(hObject,handles);
end

end

% --- Executes on button press in plusCSButton.
function plusCSButton_Callback(hObject, eventdata, handles)
% hObject    handle to plusCSButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n_handles=gestionCloud_Size(hObject, 1, handles); % bigger cloud size
handles=n_handles;
checkHandles(handles);
guidata(hObject,handles);

end

% --- Executes on button press in minusCSButton.
function minusCSButton_Callback(hObject, eventdata, handles)
% hObject    handle to minusCSButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n_handles=gestionCloud_Size(hObject, 2, handles); % smaller cloud size
checkHandles(n_handles);
guidata(hObject,n_handles);
end

% --- Executes on button press in tempoSegmentoButton.
%Calculo de tempo en un tramo determinado por los puntos de corregir
function tempoSegmentoButton_Callback(hObject, eventdata, handles)
% hObject    handle to tempoSegmentoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=checkHandles();
if (handles.puntosCorreccion==2)
text=findobj('Tag', 'tTempoError'); % 
set(text, 'visible', 'off');

tempo=getTempo(handles.indiceOrig, handles.indiceFin);
text=findobj('Tag', 'tTempoSegmento'); % the 2 texts we must change
tempoString = sprintf('%.1f', tempo);
set(text, 'String', tempoString);
delPuntos();
else
text=findobj('Tag', 'tTempoError'); % this in case we find an error
set(text, 'visible', 'on');
end
end


%% This function obtains the tempo on a segment
function tempo= getTempo(inicio,fin)
 handles=checkHandles();
 y_inicio=handles.ydata(inicio);
 y_fin=handles.ydata(fin);
 x_inicio=handles.xdata(inicio);
 x_fin=handles.xdata(fin);
 tempo=(y_fin-y_inicio)/(x_fin-x_inicio);
end
%%

%% With this function we obtain the average tempo
%This funtion is called when you load data
function tempo= getTempoMedio()
handles=checkHandles();
x_fin=handles.xdata(handles.xdata(length(handles.xdata)));
y_fin=handles.ydata(handles.ydata(length(handles.ydata)));
tempo = y_fin/x_fin;
end
%%

% --- Executes on button press in evalMatrixButton.
%This mode helps the user evaluate the values of the cost matrix
function evalMatrixButton_Callback(hObject, eventdata, handles)
% hObject    handle to evalMatrixButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles=checkHandles();
setButtons(false)
setButton('evalMatrixButton','on')
setButton('loadButton','off')
if ~handles.matrixeval
    set(handles.Linea,'HitTest','off');
    set(handles.Linea, 'buttondownfcn','');
    set(handles.Matriz,'ButtonDownFcn',{@evalMatrix, handles});
    %Text to inform the user
    textEval=findobj('Tag', 'evalText');
    set(textEval, 'Visible', 'on');
    handles.matrixeval=true;
else
    set(handles.Linea,'HitTest','on');
    set(handles.Matriz,'ButtonDownFcn','');
    set(handles.Linea, 'buttondownfcn',{@buttondown, handles});
    %Text to inform the user
    textEval=findobj('Tag', 'evalText');
    set(textEval, 'Visible', 'off');
    handles.matrixeval=false;
    %Lets reactivate all the buttons
    setButtons(true)
    setButton('loadButton','on')

end
checkHandles(handles);
end

% --------------------------------------------------------------------
%Funcion para abrir el fichero .mat
function openFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.mat');
if isequal(file,0)
    disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path,file)]);
    structP=load(file,'p');
    structM=load(file,'matrizTmxTr');
    % Si no tenemos la p o la m...
    if (isempty(fieldnames(structP)) || isempty(fieldnames(structM)))
        disp('Your .mat file doesnt have the p or matrizTmxTr variables (or maybe they have other names)')
        msgbox('Your .mat file doesnt have the p or matrizTmxTr variables (or maybe they have other names)');
        return;
    end
    setButtons(false);
    structTR=load(file,'tr_anclaje');
    structTM=load(file,'tm_anclaje'); %for anchor points
    if (~isempty(fieldnames(structTR)) || ~isempty(fieldnames(structTM)))
        assignin('base','tr_anclaje',structTR.tr_anclaje);
        assignin('base','tm_anclaje', structTM.tm_anclaje);
    else
        disp('Sin anclaje.')
        assignin('base','tr_anclaje',0);
        assignin('base','tm_anclaje', 0); % if there are no anchor points, this = 0
    end

    %Load all the other variables
    assignin('base','p',structP.p);
    assignin('base','matrizTmxTr', structM.matrizTmxTr);
    handles=inicializar(handles);
    handles.nombremat=file;
    menu=findobj('Tag', 'vMoveMenu');
    
    checkHandles(handles);
    guidata(hObject,handles);
end
end


%Functions to keep coherency between modes--------------------------------%

%-------------------------------------------------------------------------%
%% STATE 0 -- CLICK ON PLOT
function buttondown(Obj,~,handles)

pos = get(gca,'CurrentPoint');  %position of clicked point

xdata = get(Obj,'xdata'); %all x coordinates
ydata = get(Obj,'ydata'); %all y coordinates


%this gets the index of the point clicked and saves it on ind
[~,ind] = min(sum((xdata-pos(1)).^2+(ydata-pos(3)).^2,1));
%we use this index to move the cloud of points

%Feedback for our user, we show the coordinates of the clicked point on our
%GUI
textX=findobj('Tag', 'txValue');
textY=findobj('Tag', 'tyValue'); % We want to change this 2 static texts on the gui
x = sprintf('%d', xdata(ind));
y = sprintf('%d', ydata(ind)); %the strings with the respective values of the clicked point
set(textX, 'String', x);
set(textY, 'String', y);

%If we are on mode 0  (Moving mode):


if handles.mode== 0
    h=checkHandles();
    set(gcf,'WindowButtonMotionFcn',  {@move,Obj,ind,ydata,h.cloud_size,h}); 
    %this moves our values. cloud_size is the range of points we have to
    %move
    set(gcf, 'WindowButtonUpFcn',      {@buttonup}); %if we stop clicking we return to state 0

%Otherwise, we are in correct mode, so:
else
    set(gcf,'WindowButtonUpFcn',  {@buttonup}); %
    set(gcf, 'keypressfcn', {@setPuntoCambio,Obj, ind}); %callback for when the user selects one point

end

guidata(Obj, handles);
end

%%


%% STATE 1 --- MOVEMENT AND ENDING MOVEMENT
function move(hObject,~,Obj,ind, ydata, cloud_size, handles)
%We have to change the coordinates of the points for the user
pos = get(gca,'CurrentPoint'); %Punto seleccionado

%Lets move our points:
n_ydata=gestionPuntos(ydata, ind, pos(3),cloud_size);
%and now we graphically update the movement
ax = gca;
lim_axes= ax.YLim; %handles.Figura.YLim;
if ~(pos(3) >= lim_axes(2)  || pos(3) <=lim_axes(1)) %Be careful! you cant move the points over the figure's limit
    set(Obj,'ydata',n_ydata);

    assignin('base', 'p', n_ydata); %Lets keep the changes on the data
    textY=findobj('Tag', 'tyValue'); % and again, feedback for our user
    y = sprintf('%d', n_ydata(ind)); 
    set(textY, 'String', y); %
end




handles.ydata=n_ydata;
checkHandles(handles);
guidata(hObject, handles);

end
%%

%SEGMENT CORRECTION
%If we want to draw the segment points, we select our desired point and
%press X when the application is on correction mode
function setPuntoCambio(~,~,hObject,ind)
handles=checkHandles();
handles.key=get(gcf,'CurrentCharacter');
if(lower(handles.key) == 'x' )

    if handles.puntosCorreccion<2
        if handles.puntosCorreccion==0
            handles.puntoCorreccion1 = plot(handles.xdata(ind),handles.ydata(ind),'o-','MarkerFaceColor','green','MarkerEdgeColor','green');
            handles.indiceOrig=ind;
        end
        if handles.puntosCorreccion==1
            handles.puntoCorreccion2 = plot(handles.xdata(ind),handles.ydata(ind),'o-','MarkerFaceColor','green','MarkerEdgeColor','green');
            handles.indiceFin=ind;


            if handles.indiceFin < handles.indiceOrig
                %This mantains coherency if you select first a point
                %on the right instead of the "logical order" (first
                %plotting the left point of the segment, then the right
                %one.

                %we have to correct the variables:
                temporal = handles.puntoCorreccion1;
                ind_temporal = handles.indiceOrig;
                handles.puntoCorreccion1 = handles.puntoCorreccion2;
                handles.indiceOrig = handles.indiceFin;
                handles.puntoCorreccion2=temporal;
                handles.indiceFin=ind_temporal;
            end
        end
        drawnow;
    end
    %We can only draw 2 points:
    switch handles.puntosCorreccion
        case 0
            %disp('1');
            handles.puntosCorreccion=1;
        case 1
            %disp('2')
            handles.puntosCorreccion=2;
        case 2
            texto=findobj('Tag', 'tAnclaje');
            set(texto,'String','You have already selected both beggining and end points');
            set(texto, 'visible', 'on');
        otherwise
            disp('aqui no deberias llegar');
    end
    guidata(hObject, handles);
    checkHandles(handles);

end




end



%When you stop clicking, everything must stop moving
function buttonup(~,~)
%Back to state 0:
set(gcf,'WindowButtonUpFcn', '');
set(gcf,'WindowButtonMotionFcn',  '');
set(gcf, 'keypressfcn', '');




end

%Auxiliar functions--------------------------------------------------

%Managing points:
%Returns y_data, new vector with updated values based on where
%the user moved the plot using the GUI. This uses the cloud size of the
%points.
% ydata -> vector with the values of the y axis of the plot.
% ind -> the index where the user clicked
% move -> the new values changed
% cloud_size -> size of the cloud of points moved
% Returns: n_ydata, y_data with updated values
function [n_ydata] = gestionPuntos(ydata, ind, move, cloud_size)
handles=checkHandles();


if rem(cloud_size, 2) == 0
    rango=cloud_size/2;
    rankVector = (ind-rango-1:ind+rango);
    if ~isAnclaje(rankVector, handles.anclaje)
        %If the size of our cloud is even

        
        %The range of points goes from indice-rango-1 to indice+rango
        ydata(ind-rango-1:ind)=round(move);
        ydata(ind:ind+rango)=round(move);
        n_ydata=ydata;

        texto=findobj('Tag', 'tAnclaje');
        set(texto, 'visible', 'off'); 
    else
        n_ydata=handles.ydata;
        %Feedback for our user
        texto=findobj('Tag', 'tAnclaje');
        set(texto,'String','You cant move an anchor point!');
        set(texto, 'visible', 'on');
    end

else  %If the range size is odd
    rango=fix(cloud_size/2);
    rankVector = (ind-rango:ind+rango);
    if ~isAnclaje(rankVector, handles.anclaje)

        %Its similar to the even one:
        ydata(ind-rango:ind)=round(move);
        ydata(ind:ind+rango)=round(move);
        n_ydata=ydata;

        texto=findobj('Tag', 'tAnclaje');
        set(texto, 'visible', 'off'); 
    else
        n_ydata=handles.ydata;
        texto=findobj('Tag', 'tAnclaje'); %Feedback for our user
        set(texto,'String','You cant move an anchor point!');
        set(texto, 'visible', 'on');
    end
end
end

function bool = isAnclaje(rankVector, anclajearray)
bool=ismember(1, anclajearray(rankVector));
end


%With this function we can keep our handles variable the same, since a
%persistent variable is the same through executions of the function.
%If we call this function with no parameters, it returns the handles.
%If we put a handles as a parameter it works as a set function, saving the
%desired handles. With this function we can keep our handles coherent
%when we change it on callbacks that call other callbacks, as is the case
%with this application.
function n_handles= checkHandles(miHandles)
persistent HandlesActual;
if ~exist('miHandles','var')

    n_handles=HandlesActual;

else

    HandlesActual=miHandles;
    n_handles=HandlesActual;
end
end

%This function deletes all the drawed points by the user
function [mihandles]= delPuntos()
mihandles=checkHandles();
delete(mihandles.puntoCorreccion1);
delete(mihandles.puntoCorreccion2);

mihandles.indiceFin=[];
mihandles.indiceOrig=[];
mihandles.puntosCorreccion=0;
checkHandles(mihandles);
end

%Function to correct a segment
function[n_ydata] =corregirTramo(handles)
y1=handles.ydata(handles.indiceOrig);
y2=handles.ydata(handles.indiceFin);
x1=handles.xdata(handles.indiceOrig);
x2=handles.xdata(handles.indiceFin);

if ~isAnclaje(x1:x2, handles.anclaje)
    texto=findobj('Tag', 'tAnclaje');
    set(texto, 'visible', 'off');
    %m
    m=(y2-y1)/(x2-x1);
    %We use linear interpolation
    handles.ydata(handles.indiceOrig:handles.indiceFin)=round(y1+m*((x1:x2)-x1));
else
    texto=findobj('Tag', 'tAnclaje');
    set(texto,'String','You cant correct a segment with anchor points!');
    set(texto, 'visible', 'on');

end

n_ydata=handles.ydata;
end


function [n_handles]=inicializar(hObject,handles)
setButtons(true)

%We crate our figure and the variables we need to move it
p=evalin('base','p'); % y
matrizTmxTr=evalin('base','matrizTmxTr'); % cost matrix
handles.output = hObject;
handles.Figura = findobj('Tag', 'axes1'); %The figure we use to modify the plot

cla(handles.Figura)
xlim([0 length(p)]) 
ylim([0 p(length(p))])
handles.Matriz=imagesc(matrizTmxTr);
handles.xdata=1:length(p); % 1:p(length(p))
handles.ydata=p;
handles.mode=0; % We start on mode 0- move, we can change it to mode 1 - correct in the application
handles.cloud_size=50; %The range of points we move when the user clicks
handles.nombremat=''; %This helps us save the name of the file we use to load the graphs
%---- Feedback for the user: actual cloud size
texto=findobj('Tag', 't_cloud_size');
set(texto, 'String', string(handles.cloud_size));
%----For our zoom
handles.zoom=false;
%For panning
handles.pan=false;
%---- For matrix evaluation
handles.matrixeval=false;
%---- Buttons to change the cloud size
b1=findobj('Tag', 'minusCSButton');
b2=findobj('Tag', 'plusCSButton');
set(b1, 'visible','on');
set(b2, 'visible','on');
drawnow


%
%----
%This is necessary for the correction of segments
handles.puntoCorreccion1=[]; %This is used later
handles.puntoCorreccion2=[]; %Same
handles.puntosCorreccion=0; %How many points for correction are drawed. 0 right now.
handles.indiceOrig=[];
handles.indiceFin=[]; %These 2 represent the origin/end index of the correction points
axis xy;
hold on;
handles.Linea = plot(handles.xdata,p,'k','LineWidth',3,'buttondownfcn',{@buttondown, handles});
handles.puntos_anclaje=0;
%% Anclaje - 
tm_anclaje=evalin('base','tm_anclaje');
tr_anclaje=evalin('base','tr_anclaje');
if ~( (tm_anclaje==0) | (tr_anclaje == 0))
    handles.anclaje=zeros(1,length(p)); %As many 0s as points we have
    handles.anclaje(tr_anclaje(1:length(tr_anclaje)))=1; %We put 1 in the X index where there is one anchor point

    hold on
    handles.puntos_anclaje=plot(tr_anclaje,tm_anclaje,'rx','LineWidth',2);
    
else
    handles.tm_anclaje=0;
    handles.tr_anclaje=0;
    handles.anclaje=zeros(1,length(p)); %Vector that contains 1 in the X index where there is a anchor point
    %(well in this case all = 0 since there are no anchor points)
    

end


set(gcf, 'keypressfcn', ''); %just in case, callback set to state 0
%since we are changing to moving mode, lets keep everything working
%correctky
n_handles=handles;
checkHandles(n_handles);


%Average tempo
tempoMedio=getTempoMedio();
text=findobj('Tag', 'tTempoMedio'); % los dos static text que queremos cambiar
tempoString = sprintf('%.1f', tempoMedio);
set(text, 'String', tempoString);
end



%Manage cloud size if it gets bigger or smaller
function n_handles= gestionCloud_Size(hObject,key,handles)
switch key
    case 1
        handles.cloud_size=handles.cloud_size+1;
        if handles.cloud_size >= length(handles.xdata)
            handles.cloud_size=length(handles.xdata);
            
             msgbox('Cloudsize cant be higher than the number of points in the axis','Cloudsize');
        end

    case 2
        handles.cloud_size=handles.cloud_size-1;
        if handles.cloud_size <=0
            handles.cloud_size=1;
           
            msgbox('Cloudsize must be at least 1','Cloudsize');

        end

end
%---- Show the actual cloud size
texto=findobj('Tag', 't_cloud_size');
set(texto, 'String', string(handles.cloud_size));
n_handles=handles;
%----
end



%Function to evaluate the values of x and y of the matrix
function evalMatrix(Obj,~,handles)


pos = get(gca,'CurrentPoint');  %pos of the actual point



%Feedback for the user, we show on the application the coordinates of the
%clicked point
textX=findobj('Tag', 'txMatrixValue');
textY=findobj('Tag', 'tyMatrixValue'); % 
textM=findobj('Tag', 'tMatrixValue');
matrizTmxTr=evalin('base','matrizTmxTr'); % we get the matrix from the workspace

Mvalue=round(matrizTmxTr(round(pos(3)),round(pos(2))),5); % value of the clicked point


disp(Mvalue)
x = sprintf('%d', round(pos(2)));
y = sprintf('%d', round(pos(3))); %strings with the x and y values

stringMval=sprintf('%f',Mvalue);

set(textX, 'String', x);
set(textY, 'String', y);
set(textM, 'String', stringMval);
guidata(Obj, handles);
end


%To activate/disable buttons
function setButtons(bool)
saveB=findobj('Tag', 'saveButton');
changeB=findobj('Tag', 'changeModeButton');
correctB=findobj('Tag', 'correctButton');
zoomB=findobj('Tag', 'zoomButton');
resetB=findobj('Tag', 'zoomOutButton');
evalB=findobj('Tag', 'evalMatrixButton');
panB=findobj('Tag', 'panButton');
tempoB = findobj('Tag', 'tempoSegmentoButton');
plusB =findobj('Tag', 'plusCSButton');
minusB = findobj('Tag', 'minusCSButton');
if bool
    set(panB, 'Enable','on')
    set(saveB, 'Enable', 'on');
    set(changeB, 'Enable', 'on');
    set(correctB, 'Enable', 'on');
    set(zoomB, 'Enable', 'on');
    set(resetB, 'Enable', 'on');
    set(evalB, 'Enable', 'on');
    set(tempoB, 'Enable', 'on');
    set(plusB, 'Enable', 'on');
    set(minusB, 'Enable', 'on');
else
    set(panB, 'Enable','off')
    set(saveB, 'Enable', 'off');
    set(changeB, 'Enable', 'off');
    set(correctB, 'Enable', 'off');
    set(zoomB, 'Enable', 'off');
    set(resetB, 'Enable', 'off');
    set(evalB, 'Enable', 'off');
    set(tempoB, 'Enable', 'off');
    set(plusB, 'Enable', 'off');
    set(minusB, 'Enable', 'off');

end
end

%To enable/disable a certain button
%mode = 'on' enables it,  mode = 'off', disables it
function setButton(id,mode)
B=findobj('Tag', id);
set(B, 'Enable', mode);
end
 



 


 


 

 
