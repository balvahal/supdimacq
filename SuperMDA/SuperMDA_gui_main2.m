%% SuperMDA_gui_main2
% a simple gui to pause, stop, and resume a running MDA
function [f] = SuperMDA_gui_main2(smdaTA)
%% Create the figure
%
myunits = get(0,'units');
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','characters');
Char_SS = get(0,'screensize');
ppChar = Pix_SS./Char_SS;
set(0,'units',myunits);
fwidth = 136.6; %683/ppChar(3);
fheight = 70; %910/ppChar(4);
fx = Char_SS(3) - (Char_SS(3)*.1 + fwidth);
fy = Char_SS(4) - (Char_SS(4)*.1 + fheight);
f = figure('Visible','off','Units','characters','MenuBar','none','Position',[fx fy fwidth fheight],...
    'CloseRequestFcn',{@fDeleteFcn},'Name','Main');

textBackgroundColorRegion1 = [176 224 230]/255; %PowderBlue
buttonBackgroundColorRegion1 = [216 191 216]/255; %Thistle
textBackgroundColorRegion2 = [152 251 152]/255; %PaleGreen
buttonBackgroundColorRegion2 = [154 205 50]/255; %YellowGreen
textBackgroundColorRegion3 = [238 232 170]/255; %PaleGoldenrod
buttonBackgroundColorRegion3 = [255 160 122]/255; %LightSalmon
textBackgroundColorRegion4 = [240 128 128]/255; %LightCoral
buttonBackgroundColorRegion4 = [220 20 60]/255; %Crimson
buttonSize = [20 3.0769]; %[100/ppChar(3) 40/ppChar(4)];
region1 = [0 56.1538]; %[0 730/ppChar(4)]; %180 pixels
region2 = [0 42.3077]; %[0 550/ppChar(4)]; %180 pixels
region3 = [0 13.8462]; %[0 180/ppChar(4)]; %370 pixels
region4 = [0 0]; %180 pixels

%% Assemble Region 1
%
%% Time Info
%
hpopupmenuUnitsOfTime = uicontrol('Style','popupmenu','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',{'seconds','minutes','hours','days'},...
    'Position',[region1(1)+2, region1(2)+0.7692, buttonSize(1),buttonSize(2)],...
    'Callback',{@popupmenuUnitsOfTime_Callback});

uicontrol('Style','text','Units','characters','String','Units of Time',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+2, region1(2)+4.2308, buttonSize(1),1.5385]);

heditFundamentalPeriod = uicontrol('Style','edit','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.fundamental_period),...
    'Position',[region1(1)+2, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
    'Callback',{@editFundamentalPeriod_Callback});

uicontrol('Style','text','Units','characters','String','Fundamental Period',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+2, region1(2)+10, buttonSize(1),2.6923]);

heditDuration = uicontrol('Style','edit','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.duration),...
    'Position',[region1(1)+24, region1(2)+0.7692, buttonSize(1),buttonSize(2)],...
    'Callback',{@editDuration_Callback});

uicontrol('Style','text','Units','characters','String','Duration',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+24, region1(2)+4.2308, buttonSize(1),1.5385]);

heditNumberOfTimepoints = uicontrol('Style','edit','Units','characters',...
    'FontSize',14,'FontName','Verdana',...
    'String',num2str(smdaTA.itinerary.number_of_timepoints),...
    'Position',[region1(1)+24, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
    'Callback',{@editNumberOfTimepoints_Callback});

uicontrol('Style','text','Units','characters','String','Number of Timepoints',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+24, region1(2)+10, buttonSize(1),2.6923]);
%% Output directory
%
heditOutputDirectory = uicontrol('Style','edit','Units','characters',...
    'FontSize',12,'FontName','Verdana','HorizontalAlignment','left',...
    'String',num2str(smdaTA.itinerary.output_directory),...
    'Position',[region1(1)+46, region1(2)+0.7692, buttonSize(1)*3.5,buttonSize(2)],...
    'Callback',{@editOutputDirectory_Callback});

uicontrol('Style','text','Units','characters','String','Output Directory',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+46, region1(2)+4.2308, buttonSize(1)*3.5,1.5385]);

hpushbuttonOutputDirectory = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',20,'FontName','Verdana',...
    'String','...',...
    'Position',[region1(1)+48+buttonSize(1)*3.5, region1(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
    'Callback',{@pushbuttonOutputDirectory_Callback});
%% Save or load current SuperMDAItinerary
%
hpushbuttonSave = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
    'String','Save',...
    'Position',[region1(1)+46, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
    'Callback',{@pushbuttonSave_Callback});

uicontrol('Style','text','Units','characters','String','Save an Itinerary',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+46, region1(2)+10, buttonSize(1),2.6923]);

hpushbuttonLoad = uicontrol('Style','pushbutton','Units','characters',...
    'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
    'String','Load',...
    'Position',[region1(1)+68, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
    'Callback',{@pushbuttonLoad_Callback});

uicontrol('Style','text','Units','characters','String','Load an Itinerary',...
    'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
    'Position',[region1(1)+68, region1(2)+10, buttonSize(1),2.6923]);
%% Assemble Region 2
%
%% The group table
%
htableGroup = uitable('Units','characters',...
    'Position',[region2(1)+2, region2(2)+0.7692, 100, 12.3078]);
%%
% store the uicontrol handles in the figure handles via guidata()
handles.popupmenuUnitsOfTime = hpopupmenuUnitsOfTime;
handles.editFundamentalPeriod = heditFundamentalPeriod;
handles.editDuration = heditDuration;
handles.editNumberOfTimepoints = heditNumberOfTimepoints;
handles.editOutputDirectory = heditOutputDirectory;
handles.pushbuttonOutputDirectory = hpushbuttonOutputDirectory;
handles.pushbuttonSave = hpushbuttonSave;
handles.pushbuttonLoad = hpushbuttonLoad;
handles.tableGroup = htableGroup;
guidata(f,handles);
%%
% make the gui visible
set(f,'Visible','on');

%% Callbacks
%
%%
%
    function fDeleteFcn(~,~)
        %do nothing. This means only the master object can close this
        %window.
    end
%%
%
    function popupmenuUnitsOfTime_Callback(~,~)
        seconds2array = [1,60,3600,86400];
        smdaTA.uot_conversion = seconds2array(get(hpopupmenuUnitsOfTime,'Value'));
        smdaTA.refresh_gui_main;
    end
%%
%
    function editFundamentalPeriod_Callback(~,~)
        myValue = str2double(get(heditFundamentalPeriod,'String'))*smdaTA.uot_conversion;
        smdaTA.itinerary.newFundamentalPeriod(myValue);
        smdaTA.refresh_gui_main;
    end
%%
%
    function editDuration_Callback(~,~)
        myValue = str2double(get(heditDuration,'String'))*smdaTA.uot_conversion;
        smdaTA.itinerary.newDuration(myValue);
        smdaTA.refresh_gui_main;
    end
%%
%
    function editNumberOfTimepoints_Callback(~,~)
        myValue = str2double(get(heditNumberOfTimepoints,'String'));
        smdaTA.itinerary.newNumberOfTimepoints(myValue);
        smdaTA.refresh_gui_main;
    end

%%
%
    function editOutputDirectory_Callback(~,~)
        folder_name = get(heditOutputDirectory,'String');
        if exist(folder_name,'dir')
            smdaTA.itinerary.output_directory = folder_name;
        else
            str = sprintf('''%s'' is not a directory',folder_name);
            disp(str);
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonOutputDirectory_Callback(~,~)
        folder_name = uigetdir;
        if folder_name==0
            return
        elseif exist(folder_name,'dir')
            smdaTA.itinerary.output_directory = folder_name;
        else
            str = sprintf('''%s'' is not a directory',folder_name);
            disp(str);
        end
        smdaTA.refresh_gui_main;
    end
%%
%
    function pushbuttonSave_Callback(~,~)
        myitinerary = smdaTA.itinerary;
        myitinerary.mm = [];
        warning('off','all');
        save(fullfile(myitinerary.output_directory,'mySuperMDAItinerary.mat'),'myitinerary');
        warning('on','all');
    end
%%
%
    function pushbuttonLoad_Callback(~,~)
        uiwait(warndlg('The current SuperMDA will be erased!','Load a SuperMDA','modal'));
        mypwd = pwd;
        cd(smdaTA.itinerary.output_directory);
        [filename,pathname] = uigetfile({'*.mat'},'Load a SuperMDAItinerary');
        cd(mypwd);
        if exist(fullfile(pathname,filename),'file')
            load(fullfile(pathname,filename),'myitinerary');
            if isa(myitinerary,'SuperMDAItinerary')
                smdaTA.itinerary = myitinerary;
                smdaTA.itinerary.mm = smdaTA.mm;
                disp('import successful');
            else
                disp('a valid SuperMDAItinerary object was not found');
            end
        else
            disp('The SuperMDAItinerary file selected was invalid.');
        end
        smdaTA.refresh_gui_main;
    end
end