%%
%   ___                    __  __ ___   _
%  / __|_  _ _ __  ___ _ _|  \/  |   \ /_\
%  \__ \ || | '_ \/ -_) '_| |\/| | |) / _ \
%  |___/\_,_| .__/\___|_| |_|  |_|___/_/ \_\     _
%  |_   _| _|_| ___ _____| |   /_\  __ _ ___ _ _| |_
%    | || '_/ _` \ V / -_) |  / _ \/ _` / -_) ' \  _|
%    |_||_| \__,_|\_/\___|_| /_/ \_\__, \___|_||_\__|
%                                  |___/
classdef SuperMDATravelAgent_object < handle
    %% Properties
    %   ___                       _   _
    %  | _ \_ _ ___ _ __  ___ _ _| |_(_)___ ___
    %  |  _/ '_/ _ \ '_ \/ -_) '_|  _| / -_|_-<
    %  |_| |_| \___/ .__/\___|_|  \__|_\___/__/
    %              |_|
    %
    properties
        ity; %the SuperMDAItineraryTimeFixed_object
        gui_main;
        mm;
        pointerGroup = 1;
        pointerPosition = 1;
        pointerSettings = 1;
        uot_conversion = 1;
    end
    %% Methods
    %   __  __     _   _            _
    %  |  \/  |___| |_| |_  ___  __| |___
    %  | |\/| / -_)  _| ' \/ _ \/ _` (_-<
    %  |_|  |_\___|\__|_||_\___/\__,_/__/
    %
    methods
        %% The first method is the constructor
        %    ___             _               _
        %   / __|___ _ _  __| |_ _ _ _  _ __| |_ ___ _ _
        %  | (__/ _ \ ' \(_-<  _| '_| || / _|  _/ _ \ '_|
        %   \___\___/_||_/__/\__|_|  \_,_\__|\__\___/_|
        %
        % |smdai| is the itinerary that has been initalized with the
        % micromanager core handler object
        function obj = SuperMDATravelAgent_object(smdaITF,mm)
            %%%
            % parse the input
            q = inputParser;
            addRequired(q, 'smdaITF', @(x) isa(x,'SuperMDAItineraryTimeFixed_object'));
            addRequired(q, 'mm', @(x) isa(x,'Core_MicroManagerHandle'));
            parse(q,smdaITF,mm);
            %% Initialzing the SuperMDA object
            %
            obj.ity = q.Results.smdaITF;
            obj.mm = q.Results.mm;
            %% Create a gui to enable pausing and stopping
            %    ___ _   _ ___    ___              _   _
            %   / __| | | |_ _|  / __|_ _ ___ __ _| |_(_)___ _ _
            %  | (_ | |_| || |  | (__| '_/ -_) _` |  _| / _ \ ' \
            %   \___|\___/|___|  \___|_| \___\__,_|\__|_\___/_||_|
            %   / _|___ _ _
            %  |  _/ _ \ '_|  __  __      _
            %  |_| \___/_(_) |  \/  |__ _(_)_ _
            %  / _` | || | | | |\/| / _` | | ' \
            %  \__, |\_,_|_|_|_|  |_\__,_|_|_||_|
            %  |___/      |___|
            % Create the figure
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
                'CloseRequestFcn',{@obj.fDeleteFcn},'Name','Travel Agent Main');
            
            textBackgroundColorRegion1 = [176 224 230]/255; %PowderBlue
            buttonBackgroundColorRegion1 = [135 206 235]/255; %SkyBlue
            textBackgroundColorRegion2 = [144 238 144]/255; %LightGreen
            buttonBackgroundColorRegion2 = [50 205  50]/255; %LimeGreen
            textBackgroundColorRegion3 = [255 250 205]/255; %LemonChiffon
            buttonBackgroundColorRegion3 = [255 215 0]/255; %Gold
            textBackgroundColorRegion4 = [255 192 203]/255; %Pink
            buttonBackgroundColorRegion4 = [255 160 122]/255; %Salmon
            buttonSize = [20 3.0769]; %[100/ppChar(3) 40/ppChar(4)];
            region1 = [0 56.1538]; %[0 730/ppChar(4)]; %180 pixels
            region2 = [0 42.3077]; %[0 550/ppChar(4)]; %180 pixels
            region3 = [0 13.8462]; %[0 180/ppChar(4)]; %370 pixels
            region4 = [0 0]; %180 pixels
            
            %% Assemble Region 1
            %   ___          _            _
            %  | _ \___ __ _(_)___ _ _   / |
            %  |   / -_) _` | / _ \ ' \  | |
            %  |_|_\___\__, |_\___/_||_| |_|
            %          |___/
            %%% Time Info
            %
            hpopupmenuUnitsOfTime = uicontrol('Style','popupmenu','Units','characters',...
                'FontSize',14,'FontName','Verdana',...
                'String',{'seconds','minutes','hours','days'},...
                'Position',[region1(1)+2, region1(2)+0.7692, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.popupmenuUnitsOfTime_Callback});
            
            uicontrol('Style','text','Units','characters','String','Units of Time',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+2, region1(2)+4.2308, buttonSize(1),1.5385]);
            
            heditFundamentalPeriod = uicontrol('Style','edit','Units','characters',...
                'FontSize',14,'FontName','Verdana',...
                'String',num2str(obj.ity.fundamental_period),...
                'Position',[region1(1)+2, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.editFundamentalPeriod_Callback});
            
            uicontrol('Style','text','Units','characters','String','Fundamental Period',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+2, region1(2)+10, buttonSize(1),2.6923]);
            
            heditDuration = uicontrol('Style','edit','Units','characters',...
                'FontSize',14,'FontName','Verdana',...
                'String',num2str(obj.ity.duration),...
                'Position',[region1(1)+24, region1(2)+0.7692, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.editDuration_Callback});
            
            uicontrol('Style','text','Units','characters','String','Duration',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+24, region1(2)+4.2308, buttonSize(1),1.5385]);
            
            heditNumberOfTimepoints = uicontrol('Style','edit','Units','characters',...
                'FontSize',14,'FontName','Verdana',...
                'String',num2str(obj.ity.number_of_timepoints),...
                'Position',[region1(1)+24, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.editNumberOfTimepoints_Callback});
            
            uicontrol('Style','text','Units','characters','String','Number of Timepoints',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+24, region1(2)+10, buttonSize(1),2.6923]);
            %%% Output directory
            %
            heditOutputDirectory = uicontrol('Style','edit','Units','characters',...
                'FontSize',12,'FontName','Verdana','HorizontalAlignment','left',...
                'String',num2str(obj.ity.output_directory),...
                'Position',[region1(1)+46, region1(2)+0.7692, buttonSize(1)*3.5,buttonSize(2)],...
                'Callback',{@obj.editOutputDirectory_Callback});
            
            uicontrol('Style','text','Units','characters','String','Output Directory',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+46, region1(2)+4.2308, buttonSize(1)*3.5,1.5385]);
            
            hpushbuttonOutputDirectory = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
                'String','...',...
                'Position',[region1(1)+48+buttonSize(1)*3.5, region1(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonOutputDirectory_Callback});
            %%% Save or load current SuperMDAItinerary
            %
            hpushbuttonSave = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
                'String','Save',...
                'Position',[region1(1)+46, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.pushbuttonSave_Callback});
            
            uicontrol('Style','text','Units','characters','String','Save an Itinerary',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+46, region1(2)+10, buttonSize(1),2.6923]);
            
            hpushbuttonLoad = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion1,...
                'String','Load',...
                'Position',[region1(1)+68, region1(2)+6.5385, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.pushbuttonLoad_Callback});
            
            uicontrol('Style','text','Units','characters','String','Load an Itinerary',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion1,...
                'Position',[region1(1)+68, region1(2)+10, buttonSize(1),2.6923]);
            %% Assemble Region 2
            %   ___          _            ___
            %  | _ \___ __ _(_)___ _ _   |_  )
            %  |   / -_) _` | / _ \ ' \   / /
            %  |_|_\___\__, |_\___/_||_| /___|
            %          |___/
            %%% The group table
            %
            htableGroup = uitable('Units','characters',...
                'BackgroundColor',[textBackgroundColorRegion2;buttonBackgroundColorRegion2],...
                'ColumnName',{'label','group #','# of positions','function before','function after'},...
                'ColumnEditable',logical([1,0,0,0,0]),...
                'ColumnFormat',{'char','numeric','numeric','char','char'},...
                'ColumnWidth',{30*ppChar(3) 'auto' 'auto' 30*ppChar(3) 30*ppChar(3)},...
                'FontSize',8,'FontName','Verdana',...
                'CellEditCallback',@obj.tableGroup_CellEditCallback,...
                'CellSelectionCallback',@obj.tableGroup_CellSelectionCallback,...
                'Position',[region2(1)+2, region2(2)+0.7692, 91.6, 13.0769]);
            %%% add or drop a group
            %
            hpushbuttonGroupAdd = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','Add',...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+7.6923, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupAdd_Callback});
            
            uicontrol('Style','text','Units','characters','String','Add a group',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+11.1538, buttonSize(1)*.75,2.6923]);
            
            hpushbuttonGroupDrop = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','Drop',...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+0.7692, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupDrop_Callback});
            
            uicontrol('Style','text','Units','characters','String','Drop a group',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region2(2)+4.2308, buttonSize(1)*.75,2.6923]);
            %%% change group functions
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Group\nFunction\nBefore'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonGroupFunctionBefore = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','...',...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupFunctionBefore_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Group\nFunction\nAfter'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonGroupFunctionAfter = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','...',...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region2(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupFunctionAfter_Callback});
            %%% Change group order
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nGroup\nDown'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonGroupDown = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','Dn',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupDown_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nGroup\nUp'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion2,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonGroupUp = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion2,...
                'String','Up',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region2(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonGroupUp_Callback});
            %% Assemble Region 3
            %   ___          _            ____
            %  | _ \___ __ _(_)___ _ _   |__ /
            %  |   / -_) _` | / _ \ ' \   |_ \
            %  |_|_\___\__, |_\___/_||_| |___/
            %          |___/
            %%% The position table
            %
            htablePosition = uitable('Units','characters',...
                'BackgroundColor',[textBackgroundColorRegion3;buttonBackgroundColorRegion3],...
                'ColumnName',{'label','position #','X','Y','Z','PFS','PFS offset','function before','function after','# of settings'},...
                'ColumnEditable',logical([1,0,1,1,1,1,1,0,0,0]),...
                'ColumnFormat',{'char','numeric','numeric','numeric','numeric',{'yes','no'},'numeric','char','char','numeric'},...
                'ColumnWidth',{30*ppChar(3) 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 30*ppChar(3) 30*ppChar(3) 'auto'},...
                'FontSize',8,'FontName','Verdana',...
                'CellEditCallback',{@obj.tablePosition_CellEditCallback},...
                'CellSelectionCallback',{@obj.tablePosition_CellSelectionCallback},...
                'Position',[region3(1)+2, region3(2)+0.7692, 91.6, 28.1538]);
            %%% add or drop positions
            %
            hpushbuttonPositionAdd = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Add',...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+7.6923, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionAdd_Callback});
            
            uicontrol('Style','text','Units','characters','String','Add a position',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+11.1538, buttonSize(1)*.75,2.6923]);
            
            hpushbuttonPositionDrop = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Drop',...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+0.7692, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionDrop_Callback});
            
            uicontrol('Style','text','Units','characters','String','Drop a position',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 4 - buttonSize(1)*1.25, region3(2)+14.0769+4.2308, buttonSize(1)*.75,2.6923]);
            %%% change position order
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nPosition\nDown'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonPositionDown = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Dn',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionDown_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nPosition\nUp'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonPositionUp = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Up',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+14.0769+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionUp_Callback});
            %%% move to a position
            %
            hpushbuttonPositionMove = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Move',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+7.6923, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionMove_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Move the stage\nto the\nselected position'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+11.1538, buttonSize(1),2.6923]);
            %%% change a position value to the current position
            %
            hpushbuttonPositionSet = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','Set',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+0.7692, buttonSize(1),buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionSet_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Set the position\nto the current\nstage position'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region3(2)+4.2308, buttonSize(1),2.6923]);
            %%% add a grid
            %
            hpushbuttonSetAllZ = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String',sprintf('Set All Z'),...
                'Position',[fwidth - 2 - buttonSize(1)*.75, region3(2)+7.6923, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSetAllZ_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Add a grid\nof positions'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 2 - buttonSize(1)*.75, region3(2)+11.1538, buttonSize(1)*.75,2.6923]);
            %%% change position functions
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Position\nFunction\nBefore'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonPositionFunctionBefore = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','...',...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionFunctionBefore_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Position\nFunction\nAfter'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion3,...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonPositionFunctionAfter = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion3,...
                'String','...',...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region3(2)+14.0769+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonPositionFunctionAfter_Callback});
            %% Assemble Region 4
            %   ___          _            _ _
            %  | _ \___ __ _(_)___ _ _   | | |
            %  |   / -_) _` | / _ \ ' \  |_  _|
            %  |_|_\___\__, |_\___/_||_|   |_|
            %          |___/
            %%% The settings table
            %
            
            htableSettings = uitable('Units','characters',...
                'BackgroundColor',[textBackgroundColorRegion4;buttonBackgroundColorRegion4],...
                'ColumnName',{'channel','exposure','binning','Z step size','Z upper','Z lower','# of Z steps','Z offset','period mult.','function','settings #'},...
                'ColumnEditable',logical([1,1,1,1,1,1,0,1,1,0,0]),...
                'ColumnFormat',{transpose(obj.mm.Channel),'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','char','numeric'},...
                'ColumnWidth',{'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto' 'auto'},...
                'FontSize',8,'FontName','Verdana',...
                'CellEditCallback',@obj.tableSettings_CellEditCallback,...
                'CellSelectionCallback',@obj.tableSettings_CellSelectionCallback,...
                'Position',[region4(1)+2, region4(2)+0.7692, 79.6, 13.0769]);
            %%% add or drop a group
            %
            hpushbuttonSettingsAdd = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Add',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+7.6923, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsAdd_Callback});
            
            uicontrol('Style','text','Units','characters','String','Add a settings',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+11.1538, buttonSize(1)*.75,2.6923]);
            
            hpushbuttonSettingsDrop = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Drop',...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+0.7692, buttonSize(1)*.75,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsDrop_Callback});
            
            uicontrol('Style','text','Units','characters','String','Drop a settings',...
                'FontSize',10,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 6 - buttonSize(1)*1.75, region4(2)+4.2308, buttonSize(1)*.75,2.6923]);
            %%% change Settings functions
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Settings\nFunction'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region4(2)+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonSettingsFunction = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',20,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','...',...
                'Position',[fwidth - 2 - buttonSize(1)*0.5, region4(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsFunction_Callback});
            %%% Change Settings order
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nSettings\nDown'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonSettingsDown = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Dn',...
                'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsDown_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Move\nSettings\nUp'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonSettingsUp = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Up',...
                'Position',[fwidth - 8 - buttonSize(1)*2.25, region4(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsUp_Callback});
            %%% Set Z upper or Z lower boundaries
            %
            uicontrol('Style','text','Units','characters','String',sprintf('Set Z\nLower'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 4 - buttonSize(1), region4(2)+4.2308, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonSettingsZLower = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Z-',...
                'Position',[fwidth - 4 - buttonSize(1), region4(2)+0.7692, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsZLower_Callback});
            
            uicontrol('Style','text','Units','characters','String',sprintf('Set Z\nUpper'),...
                'FontSize',7,'FontName','Verdana','BackgroundColor',textBackgroundColorRegion4,...
                'Position',[fwidth - 4 - buttonSize(1), region4(2)+11.1538, buttonSize(1)*0.5,2.6923]);
            
            hpushbuttonSettingsZUpper = uicontrol('Style','pushbutton','Units','characters',...
                'FontSize',14,'FontName','Verdana','BackgroundColor',buttonBackgroundColorRegion4,...
                'String','Z+',...
                'Position',[fwidth - 4 - buttonSize(1), region4(2)+7.6923, buttonSize(1)*.5,buttonSize(2)],...
                'Callback',{@obj.pushbuttonSettingsZUpper_Callback});
            %% Handles
            %   _  _              _ _
            %  | || |__ _ _ _  __| | |___ ___
            %  | __ / _` | ' \/ _` | / -_|_-<
            %  |_||_\__,_|_||_\__,_|_\___/__/
            %
            % store the uicontrol handles in the figure handles via guidata()
            handles.popupmenuUnitsOfTime = hpopupmenuUnitsOfTime;
            handles.editFundamentalPeriod = heditFundamentalPeriod;
            handles.editDuration = heditDuration;
            handles.editNumberOfTimepoints = heditNumberOfTimepoints;
            handles.editOutputDirectory = heditOutputDirectory;
            handles.pushbuttonOutputDirectory = hpushbuttonOutputDirectory;
            handles.pushbuttonSave = hpushbuttonSave;
            handles.pushbuttonLoad = hpushbuttonLoad;
            handles.pushbuttonGroupAdd = hpushbuttonGroupAdd;
            handles.pushbuttonGroupDrop = hpushbuttonGroupDrop;
            handles.pushbuttonGroupFunctionBefore = hpushbuttonGroupFunctionBefore;
            handles.pushbuttonGroupFunctionAfter = hpushbuttonGroupFunctionAfter;
            handles.pushbuttonGroupDown = hpushbuttonGroupDown;
            handles.pushbuttonGroupUp = hpushbuttonGroupUp;
            handles.pushbuttonPositionAdd = hpushbuttonPositionAdd;
            handles.pushbuttonPositionDown = hpushbuttonPositionDown;
            handles.pushbuttonPositionDrop = hpushbuttonPositionDrop;
            handles.pushbuttonPositionFunctionAfter = hpushbuttonPositionFunctionAfter;
            handles.pushbuttonPositionFunctionBefore = hpushbuttonPositionFunctionBefore;
            handles.pushbuttonPositionMove = hpushbuttonPositionMove;
            handles.pushbuttonPositionSet = hpushbuttonPositionSet;
            handles.pushbuttonPositionUp = hpushbuttonPositionUp;
            handles.pushbuttonSetAllZ = hpushbuttonSetAllZ;
            handles.pushbuttonSettingsAdd = hpushbuttonSettingsAdd;
            handles.pushbuttonSettingsDown = hpushbuttonSettingsDown;
            handles.pushbuttonSettingsDrop = hpushbuttonSettingsDrop;
            handles.pushbuttonSettingsFunction = hpushbuttonSettingsFunction;
            handles.pushbuttonSettingsUp = hpushbuttonSettingsUp;
            handles.pushbuttonSettingsZUpper = hpushbuttonSettingsZUpper;
            handles.pushbuttonSettingsZLower = hpushbuttonSettingsZLower;
            handles.tableGroup = htableGroup;
            handles.tablePosition = htablePosition;
            handles.tableSettings = htableSettings;
            guidata(f,handles);
            %%%
            % make the gui visible
            set(f,'Visible','on');
            
            obj.gui_main = f;
            obj.refresh_gui_main;
        end
        %% Callbacks for gui_main
        %    ___      _ _ _             _
        %   / __|__ _| | | |__  __ _ __| |__ ___
        %  | (__/ _` | | | '_ \/ _` / _| / /(_-<
        %   \___\__,_|_|_|_.__/\__,_\__|_\_\/__/
        %             _   __  __      _
        %   __ _ _  _(_) |  \/  |__ _(_)_ _
        %  / _` | || | | | |\/| / _` | | ' \
        %  \__, |\_,_|_|_|_|  |_\__,_|_|_||_|
        %  |___/      |___|
        %%
        %
        function obj = fDeleteFcn(obj,~,~)
            %do nothing. This means only the master object can close this
            %window.
        end
        %% Callbacks for Region 1
        %   ___          _            _
        %  | _ \___ __ _(_)___ _ _   / |
        %  |   / -_) _` | / _ \ ' \  | |
        %  |_|_\___\__, |_\___/_||_| |_|
        %          |___/
        %% popupmenuUnitsOfTime_Callback
        %
        function obj = popupmenuUnitsOfTime_Callback(obj,~,~)
            handles = guidata(obj.gui_main);
            seconds2array = [1,60,3600,86400];
            obj.uot_conversion = seconds2array(handles.popupmenuUnitsOfTime.Value);
            obj.refresh_gui_main;
        end
        %% editFundamentalPeriod_Callback
        %
        function obj = editFundamentalPeriod_Callback(obj,~,~)
            handles = guidata(obj.gui_main);
            myValue = str2double(handles.editFundamentalPeriod.String)*obj.uot_conversion;
            obj.ity.newFundamentalPeriod(myValue);
            obj.refresh_gui_main;
        end
        %% editDuration_Callback
        %
        function obj = editDuration_Callback(obj,~,~)
            handles = guidata(obj.gui_main);
            myValue = str2double(handles.editDuration.String)*obj.uot_conversion;
            obj.ity.newDuration(myValue);
            obj.refresh_gui_main;
        end
        %% editNumberOfTimepoints_Callback
        %
        function obj = editNumberOfTimepoints_Callback(obj,~,~)
            handles = guidata(obj.gui_main);
            myValue = str2double(handles.editNumberOfTimepoints.String);
            obj.ity.newNumberOfTimepoints(myValue);
            obj.refresh_gui_main;
        end
        %% editOutputDirectory_Callback
        %
        function obj = editOutputDirectory_Callback(obj,~,~)
            handles = guidata(obj.gui_main);
            folder_name = handles.editOutputDirectory.String;
            if exist(folder_name,'dir')
                obj.ity.output_directory = folder_name;
            else
                str = sprintf('''%s'' is not a directory',folder_name);
                disp(str);
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonOutputDirectory_Callback
        %
        function obj = pushbuttonOutputDirectory_Callback(obj,~,~)
            folder_name = uigetdir;
            if folder_name==0
                return
            elseif exist(folder_name,'dir')
                obj.ity.output_directory = folder_name;
            else
                str = sprintf('''%s'' is not a directory',folder_name);
                disp(str);
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonSave_Callback
        %
        function obj = pushbuttonSave_Callback(obj,~,~)
            obj.ity.export;
        end
        %%
        %
        function obj = pushbuttonLoad_Callback(obj,~,~)
            uiwait(warndlg('The current SuperMDA will be erased!','Load a SuperMDA','modal'));
            mypwd = pwd;
            cd(obj.ity.output_directory);
            [filename,pathname] = uigetfile({'*.mat'},'Load a SuperMDAItinerary');
            cd(mypwd);
            if exist(fullfile(pathname,filename),'file')
                obj.ity.import(fullfile(pathname,filename));
            else
                disp('The SuperMDAItinerary file selected was invalid.');
            end
            obj.refresh_gui_main;
        end
        %% Callbacks for Region 2
        %   ___          _            ___
        %  | _ \___ __ _(_)___ _ _   |_  )
        %  |   / -_) _` | / _ \ ' \   / /
        %  |_|_\___\__, |_\___/_||_| /___|
        %          |___/
        %% tableGroup_CellEditCallback
        %
        function obj = tableGroup_CellEditCallback(obj,~,eventdata)
            %%
            % |obj.pointerGroup| should always be a singleton in this case
            myCol = eventdata.Indices(2);
            myGroupOrder = obj.ity.order_group;
            myRow = myGroupOrder(eventdata.Indices(1));
            switch myCol
                case 1 %label change
                    if isempty(eventdata.NewData) || any(regexp(eventdata.NewData,'\W'))
                        return
                    else
                        obj.ity.group_label{myRow} = eventdata.NewData;
                    end
            end
            obj.refresh_gui_main;
        end
        %% tableGroup_CellSelectionCallback
        %
        function obj = tableGroup_CellSelectionCallback(obj,~,eventdata)
            %%
            % The main purpose of this function is to keep the information
            % displayed in the table consistent with the Itinerary object.
            % Changes to the object either through the command line or the gui
            % can affect the information that is displayed in the gui and this
            % function will keep the gui information consistent with the
            % Itinerary information.
            %
            % The pointer of the TravelAgent should always point to a valid
            % group from the the group_order.
            if isempty(eventdata.Indices)
                % if nothing is selected, which triggers after deleting data,
                % make sure the pointer is still valid
                if any(obj.pointerGroup > obj.ity.number_group)
                    % move pointer to last entry
                    obj.pointerGroup = obj.ity.number_group;
                end
                return
            else
                obj.pointerGroup = sort(unique(eventdata.Indices(:,1)));
            end
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            if any(obj.pointerPosition > obj.ity.number_position(gInd))
                % move pointer to first entry
                obj.pointerPosition = 1;
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupAdd_Callback
        %
        function obj = pushbuttonGroupAdd_Callback(obj,~,~)
            gInd = obj.ity.newGroup;
            obj.pointerGroup = obj.ity.number_group;
            pInd = obj.ity.newPosition;
            obj.ity.connectGPS('g',gInd,'p',pInd,'s',obj.ity.order_settings{1});
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupDrop_Callback
        %
        function obj = pushbuttonGroupDrop_Callback(obj,~,~)
            if obj.ity.number_group == 1
                return
            elseif length(obj.pointerGroup) == obj.ity.number_group
                obj.pointerGroup(1) = [];
            end
            myGroupOrder = obj.ity.order_group;
            gInds = myGroupOrder(obj.pointerGroup);
            for i = 1:length(gInds)
                obj.ity.dropGroup(gInds(i));
            end
            obj.pointerGroup = obj.ity.numberOfGroup;
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupFunctionBefore_Callback
        %
        function obj = pushbuttonGroupFunctionBefore_Callback(obj,~,~)
            myGroupInd = obj.ity.ind_group;
            mypwd = pwd;
            cd(obj.ity.output_directory);
            [filename,pathname] = uigetfile({'*.m'},'Choose the group-function-before');
            if exist(fullfile(pathname,filename),'file')
                [obj.ity.group_function_before{myGroupInd}] = deal(char(regexp(filename,'.*(?=\.m)','match')));
            else
                disp('The group-function-before selection was invalid.');
            end
            cd(mypwd);
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupFunctionAfter_Callback
        %
        function obj = pushbuttonGroupFunctionAfter_Callback(obj,~,~)
            myGroupInd = obj.ity.ind_group;
            mypwd = pwd;
            cd(obj.ity.output_directory);
            [filename,pathname] = uigetfile({'*.m'},'Choose the group-function-after');
            if exist(fullfile(pathname,filename),'file')
                [obj.ity.group_function_after{myGroupInd}] = deal(char(regexp(filename,'.*(?=\.m)','match')));
            else
                disp('The group-function-after selection was invalid.');
            end
            cd(mypwd);
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupDown_Callback
        %
        function obj = pushbuttonGroupDown_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved down 1.
            if max(obj.pointerGroup) == obj.ity.number_group
                return
            end
            currentOrder = 1:obj.ity.number_group; % what the table looks like now
            movingGroup = obj.pointerGroup+1; % where the selected rows want to go
            reactingGroup = setdiff(currentOrder,obj.pointerGroup); % the rows that are not moving
            fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
            fillmeinArray(movingGroup) = obj.pointerGroup; % the selected rows are moved
            fillmeinArray(fillmeinArray==0) = reactingGroup; % the remaining rows are moved
            % use the fillmeinArray to rearrange the groups
            obj.ity.order_group = obj.ity.order_group(fillmeinArray);
            %
            obj.pointerGroup = movingGroup;
            obj.refresh_gui_main;
        end
        %% pushbuttonGroupUp_Callback
        %
        function obj = pushbuttonGroupUp_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved up 1.
            if min(obj.pointerGroup) == 1
                return
            end
            currentOrder = 1:obj.ity.number_group; % what the table looks like now
            movingGroup = obj.pointerGroup-1; % where the selected rows want to go
            reactingGroup = setdiff(currentOrder,obj.pointerGroup); % the rows that are not moving
            newOrderArray = zeros(1,length(currentOrder)); % a vector to store the new order
            newOrderArray(movingGroup) = obj.pointerGroup; % the selected rows are moved
            newOrderArray(newOrderArray==0) = reactingGroup; % the remaining rows are moved
            % use the newOrderArray to rearrange the groups
            obj.ity.order_group = obj.ity.order_group(newOrderArray);
            %
            obj.pointerGroup = movingGroup;
            obj.refresh_gui_main;
        end
        %% Callbacks for Region 3
        %   ___          _            ____
        %  | _ \___ __ _(_)___ _ _   |__ /
        %  |   / -_) _` | / _ \ ' \   |_ \
        %  |_|_\___\__, |_\___/_||_| |___/
        %          |___/
        %% tablePosition_CellEditCallback
        %
        function obj = tablePosition_CellEditCallback(obj,~,eventdata)
            %%
            % |obj.pointerPosition| should always be a singleton in this
            % case
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            myCol = eventdata.Indices(2);
            myPositionOrder = obj.ity.order_position{gInd};
            myRow = myPositionOrder(eventdata.Indices(1));
            switch myCol
                case 1 %label change
                    if isempty(eventdata.NewData) || any(regexp(eventdata.NewData,'\W'))
                        return
                    else
                        obj.ity.position_label{myRow} = eventdata.NewData;
                    end
                case 3 %X
                    obj.ity.position_xyz(myRow,1) = eventdata.NewData;
                case 4 %Y
                    obj.ity.position_xyz(myRow,2) = eventdata.NewData;
                case 5 %Z
                    obj.ity.position_xyz(myRow,3) = eventdata.NewData;
                case 6 %PFS
                    if strcmp(eventdata.NewData,'yes')
                        obj.ity.position_continuous_focus_bool(myRow) = true;
                    else
                        obj.ity.position_continuous_focus_bool(myRow) = false;
                    end
                    obj.ity.position_continuous_focus_bool(myPositionOrder) = obj.ity.position_continuous_focus_bool(myRow);
                case 7 %PFS offset
                    obj.ity.position_continuous_focus_offset(myRow) = eventdata.NewData;
            end
            obj.refresh_gui_main;
        end
        %% tablePosition_CellSelectionCallback
        %
        function obj = tablePosition_CellSelectionCallback(obj,~,eventdata)
            %%
            % The main purpose of this function is to keep the information
            % displayed in the table consistent with the Itinerary object.
            % Changes to the object either through the command line or the gui
            % can affect the information that is displayed in the gui and this
            % function will keep the gui information consistent with the
            % Itinerary information.
            %
            % The pointer of the TravelAgent should always point to a valid
            % position from the the position_order in a given group.
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            if isempty(eventdata.Indices)
                % if nothing is selected, which triggers after deleting data,
                % make sure the pointer is still valid
                if any(obj.pointerPosition > obj.ity.number_position(gInd))
                    % move pointer to last entry
                    obj.pointerPosition = obj.ity.number_position(gInd);
                end
                return
            else
                obj.pointerPosition = sort(unique(eventdata.Indices(:,1)));
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionAdd_Callback
        %
        function obj = pushbuttonPositionAdd_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pFirst = obj.ity.order_position{gInd}(1);
            pInd = obj.ity.newPosition;
            obj.ity.connectGPS('g',gInd,'p',pInd,'s',obj.ity.order_settings{pFirst});
            obj.pointerPosition = obj.ity.number_position(gInd);
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionDrop_Callback
        %
        function obj = pushbuttonPositionDrop_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            if obj.ity.number_position(gInd)==1
                return
            elseif length(obj.pointerPosition) == obj.ity.number_position(gInd)
                obj.pointerPosition(1) = [];
            end
            myPositionInd = obj.ity.order_position{gInd};
            for i = 1:length(obj.pointerPosition)
                obj.ity.dropPosition(myPositionInd(obj.pointerPosition(i)));
            end
            obj.pointerPosition = obj.ity.number_position(gInd);
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionDown_Callback
        %
        function obj = pushbuttonPositionDown_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved down 1.
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            if max(obj.pointerPosition) == obj.ity.number_position(gInd)
                return
            end
            currentOrder = 1:obj.ity.number_position(gInd); % what the table looks like now
            movingPosition = obj.pointerPosition+1; % where the selected rows want to go
            reactingPosition = setdiff(currentOrder,obj.pointerPosition); % the rows that are not moving
            fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
            fillmeinArray(movingPosition) = obj.pointerPosition; % the selected rows are moved
            fillmeinArray(fillmeinArray==0) = reactingPosition; % the remaining rows are moved
            % use the fillmeinArray to rearrange the positions
            obj.ity.order_position{gInd} = obj.ity.order_position{gInd}(fillmeinArray);
            %
            obj.pointerPosition = movingPosition;
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionUp_Callback
        %
        function obj = pushbuttonPositionUp_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved up 1.
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            if min(obj.pointerPosition) == 1
                return
            end
            currentOrder = 1:obj.ity.number_position(gInd); % what the table looks like now
            movingPosition = obj.pointerPosition-1; % where the selected rows want to go
            reactingPosition = setdiff(currentOrder,obj.pointerPosition); % the rows that are not moving
            fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
            fillmeinArray(movingPosition) = obj.pointerPosition; % the selected rows are moved
            fillmeinArray(fillmeinArray==0) = reactingPosition; % the remaining rows are moved
            % use the fillmeinArray to rearrange the positions
            obj.ity.order_position{gInd} = obj.ity.order_position{gInd}(fillmeinArray);
            %
            obj.pointerPosition = movingPosition;
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionMove_Callback
        %
        function obj = pushbuttonPositionMove_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.ity.order_position{gInd};
            pInd = pInd(obj.pointerPosition(1));
            xyz = obj.ity.position_xyz(pInd,:);
            if obj.ity.position_continuous_focus_bool(pInd)
                %% PFS lock-on will be attempted
                %
                obj.mm.setXYZ(xyz(1:2)); % setting the z through the focus device will disable the PFS. Therefore, the stage is moved in the XY direction before assessing the status of the PFS system.
                obj.mm.core.waitForDevice(obj.mm.xyStageDevice);
                if strcmp(obj.mm.core.getProperty(obj.mm.AutoFocusStatusDevice,'State'),'Off')
                    %%
                    % If the PFS is |OFF|, then the scope is moved to an
                    % absolute z that will give the system the best chance of
                    % locking onto the correct z.
                    obj.mm.setXYZ(xyz(3),'direction','z');
                    obj.mm.core.waitForDevice(obj.mm.FocusDevice);
                    obj.mm.core.setProperty(obj.mm.AutoFocusDevice,'Position',obj.ity.position_continuous_focus_offset(pInd));
                    obj.mm.core.fullFocus(); % PFS will return to |OFF|
                else
                    %%
                    % If the PFS system is already on, then changing the offset
                    % will adjust the z-position. fullFocus() will have the
                    % system wait until the new z-position has been reached.
                    obj.mm.core.setProperty(obj.mm.AutoFocusDevice,'Position',obj.ity.position_continuous_focus_offset(pInd));
                    obj.mm.core.fullFocus(); % PFS will remain |ON|
                end
            else
                %% PFS will not be utilized
                %
                obj.mm.setXYZ(xyz);
                obj.mm.core.waitForDevice(obj.mm.FocusDevice);
                obj.mm.core.waitForDevice(obj.mm.xyStageDevice);
            end
        end
        %% pushbuttonPositionSet_Callback
        %
        function obj = pushbuttonPositionSet_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.ity.order_position{gInd};
            pInd = pInd(obj.pointerPosition(1));
            obj.mm.getXYZ;
            obj.ity.position_xyz(pInd,:) = obj.mm.pos;
            obj.ity.position_continuous_focus_offset(pInd) = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
            obj.refresh_gui_main;
        end
        %% pushbuttonSetAllZ_Callback
        %
        function obj = pushbuttonSetAllZ_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            myPInd = obj.ity.ind_position{gInd};
            obj.ity.position_continuous_focus_offset(myPInd) = str2double(obj.mm.core.getProperty(obj.mm.AutoFocusDevice,'Position'));
            xyz = obj.mm.getXYZ;
            obj.ity.position_xyz(myPInd,3) = xyz(3);
            fprintf('positions in group %d have Z postions updated!\n',gInd);
        end
        %% pushbuttonPositionFunctionBefore_Callback
        %
        function obj = pushbuttonPositionFunctionBefore_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            mypwd = pwd;
            myPositionInd = obj.ity.ind_position{gInd};
            cd(obj.ity.output_directory);
            [filename,pathname] = uigetfile({'*.m'},'Choose the position-function-before');
            if exist(fullfile(pathname,filename),'file')
                [obj.ity.position_function_before{myPositionInd}] = deal(char(regexp(filename,'.*(?=\.m)','match')));
            else
                disp('The position-function-before selection was invalid.');
            end
            cd(mypwd);
            obj.refresh_gui_main;
        end
        %% pushbuttonPositionFunctionAfter_Callback
        %
        function obj = pushbuttonPositionFunctionAfter_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            mypwd = pwd;
            myPositionInd = obj.ity.ind_position{gInd};
            cd(obj.ity.output_directory);
            [filename,pathname] = uigetfile({'*.m'},'Choose the position-function-after');
            if exist(fullfile(pathname,filename),'file')
                [obj.ity.position_function_after{myPositionInd}] = deal(char(regexp(filename,'.*(?=\.m)','match')));
            else
                disp('The position-function-before selection was invalid.');
            end
            cd(mypwd);
            obj.refresh_gui_main;
        end
        %% Callbacks for Region 4
        %   ___          _            _ _
        %  | _ \___ __ _(_)___ _ _   | | |
        %  |   / -_) _` | / _ \ ' \  |_  _|
        %  |_|_\___\__, |_\___/_||_|   |_|
        %          |___/
        %% tableSettings_CellEditCallback
        %
        function obj = tableSettings_CellEditCallback(obj,~,eventdata)
            %%
            % |obj.pointerSettings| should always be a singleton in this
            % case
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.ity.ind_position{gInd};
            pInd = pInd(1);
            myCol = eventdata.Indices(2);
            mySettingsOrder = obj.ity.order_settings{pInd};
            myRow = mySettingsOrder(eventdata.Indices(1));
            switch myCol
                case 1 %channel
                    obj.ity.settings_channel(myRow) = find(strcmp(eventdata.NewData,obj.mm.Channel));
                case 2 %exposure
                    obj.ity.settings_exposure(myRow) = eventdata.NewData;
                case 3 %binning
                    obj.ity.settings_binning(myRow) = eventdata.NewData;
                case 4 %Z step size
                    obj.ity.settings_z_step_size(myRow) = eventdata.NewData;
                case 5 %Z upper
                    obj.ity.settings_z_stack_upper_offset(myRow) = eventdata.NewData;
                case 6 %Z lower
                    obj.ity.settings_z_stack_lower_offset(myRow) = eventdata.NewData;
                case 8 %Z offset
                    obj.ity.settings_z_origin_offset(myRow) = eventdata.NewData;
                case 9 %period multiplier
                    obj.ity.settings_period_multiplier(myRow) = eventdata.NewData;
            end
            obj.refresh_gui_main;
        end
        %% tableSettings_CellSelectionCallback
        %
        function obj = tableSettings_CellSelectionCallback(obj,~,eventdata)
            %%
            % The |Travel Agent| aims to recreate the experience that
            % microscope users expect from a multi-dimensional acquistion tool.
            % Therefore, most of the customizability is masked by the
            % |TravelAgent| to provide a streamlined presentation and simple
            % manipulation of the |Itinerary|. Unlike the group and position
            % tables, which edit the itinerary directly, the settings table
            % will modify the the prototype, which will then be pushed to all
            % positions in a group.
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.ity.ind_position{gInd};
            pInd = pInd(1);
            if isempty(eventdata.Indices)
                % if nothing is selected, which triggers after deleting data,
                % make sure the pointer is still valid
                if any(obj.pointerSettings > obj.ity.number_settings(pInd))
                    % move pointer to last entry
                    obj.pointerSettings = obj.ity.number_settings(pInd);
                end
                return
            else
                obj.pointerSettings = sort(unique(eventdata.Indices(:,1)));
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsAdd_Callback
        %
        function obj = pushbuttonSettingsAdd_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pFirst = obj.ity.order_position{gInd}(1);
            sInd = obj.ity.newSettings;
            obj.ity.connectGPS('p',pFirst,'s',sInd);
            obj.ity.mirrorSettings(pFirst,gInd);
            obj.pointerSettings = obj.ity.number_settings(pFirst);
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsDrop_Callback
        %
        function obj = pushbuttonSettingsDrop_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.ity.ind_position{gInd};
            pInd = pInd(1);
            if obj.ity.number_settings(pInd) == 1
                return
            elseif length(obj.pointerSettings) == obj.ity.number_settings(pInd)
                obj.pointerSettings(1) = [];
            end
            mySettingsInd = obj.ity.order_settings{pInd};
            for i = 1:length(obj.pointerSettings)
                obj.ity.dropSettings(mySettingsInd(obj.pointerSettings(i)));
            end
            obj.pointerSettings = obj.ity.number_settings(pInd);
            obj.ity.find_ind_last_group(gInd);
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsFunction_Callback
        %
        function obj = pushbuttonSettingsFunction_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.ity.ind_position{gInd};
            pInd = pInd(1);
            sInds = obj.ity.ind_settings{pInd};
            mypwd = pwd;
            cd(obj.ity.output_directory);
            [filename,pathname] = uigetfile({'*.m'},'Choose the settings-function');
            if exist(fullfile(pathname,filename),'file')
                [obj.ity.settings_function{sInds}] = deal(char(regexp(filename,'.*(?=\.m)','match')));
            else
                disp('The settings-function selection was invalid.');
            end
            cd(mypwd);
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsDown_Callback
        %
        function obj = pushbuttonSettingsDown_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved down 1.
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.ity.ind_position{gInd};
            pInd = pInd(1);
            if max(obj.pointerSettings) == obj.ity.number_settings(pInd);
                return
            end
            currentOrder = 1:obj.ity.number_settings(pInd); % what the table looks like now
            movingSettings = obj.pointerSettings+1; % where the selected rows want to go
            reactingSettings = setdiff(currentOrder,obj.pointerSettings); % the rows that are not moving
            fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
            fillmeinArray(movingSettings) = obj.pointerSettings; % the selected rows are moved
            fillmeinArray(fillmeinArray==0) = reactingSettings; % the remaining rows are moved
            % use the fillmeinArray to rearrange the settings
            obj.ity.order_settings{pInd} = obj.ity.order_settings{pInd}(fillmeinArray);
            obj.pointerSettings = movingSettings;
            obj.ity.mirrorSettings(pInd,gInd);
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsUp_Callback
        %
        function obj = pushbuttonSettingsUp_Callback(obj,~,~)
            %%
            % What follows below might have a more elegant solution.
            % essentially all selected rows are moved up 1. This will only work
            % if all positions have the same settings
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.ity.ind_position{gInd};
            pInd = pInd(obj.pointerPosition(1));
            if min(obj.pointerSettings) == 1
                return
            end
            currentOrder = 1:obj.ity.number_settings(pInd); % what the table looks like now
            movingSettings = obj.pointerSettings-1; % where the selected rows want to go
            reactingSettings = setdiff(currentOrder,obj.pointerSettings); % the rows that are not moving
            fillmeinArray = zeros(1,length(currentOrder)); % a vector to store the new order
            fillmeinArray(movingSettings) = obj.pointerSettings; % the selected rows are moved
            fillmeinArray(fillmeinArray==0) = reactingSettings; % the remaining rows are moved
            % use the fillmeinArray to rearrange the settings
            obj.ity.order_settings{pInd} = obj.ity.order_settings{pInd}(fillmeinArray);
            obj.pointerSettings = movingSettings;
            obj.ity.mirrorSettings(pInd,gInd);
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsZLower_Callback
        %
        function obj = pushbuttonSettingsZLower_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.ity.ind_position{gInd};
            pInd = pInd(obj.pointerPosition(1));
            mySettingsOrder = obj.ity.ind_settings{pInd};
            sInd = mySettingsOrder(obj.pointerSettings);
            obj.mm.getXYZ;
            xyz = obj.mm.pos;
            if strcmp(smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusDevice,'Status'),'On')
                currentPFS = str2double(smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusDevice,'Position'));
                offset = obj.ity.position_continuous_focus_offset(pInd) - currentPFS;
            else
                offset = obj.ity.position_xyz(pInd,3)-xyz(3);
            end
            if offset <0
                obj.ity.settings_z_stack_lower_offset(sInd) = 0;
            else
                obj.ity.settings_z_stack_lower_offset(sInd) = -offset;
            end
            obj.refresh_gui_main;
        end
        %% pushbuttonSettingsZUpper_Callback
        %
        function obj = pushbuttonSettingsZUpper_Callback(obj,~,~)
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            pInd = obj.ity.ind_position{gInd};
            pInd = pInd(obj.pointerPosition(1));
            mySettingsOrder = obj.ity.ind_settings{pInd};
            sInd = mySettingsOrder(obj.pointerSettings);
            obj.mm.getXYZ;
            xyz = obj.mm.pos;
            if strcmp(smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusDevice,'Status'),'On')
                currentPFS = str2double(smdaPilot.mm.core.getProperty(smdaPilot.mm.AutoFocusDevice,'Position'));
                offset = currentPFS - obj.ity.position_continuous_focus_offset(pInd);
            else
                offset = xyz(3)-obj.ity.position_xyz(pInd,3);
            end
            if offset <0
                obj.ity.settings_z_stack_upper_offset(sInd) = 0;
            else
                obj.ity.settings_z_stack_upper_offset(sInd) = offset;
            end
            obj.refresh_gui_main;
        end
        %%
        %    ___                       _   __  __     _   _            _
        %   / __|___ _ _  ___ _ _ __ _| | |  \/  |___| |_| |_  ___  __| |___
        %  | (_ / -_) ' \/ -_) '_/ _` | | | |\/| / -_)  _| ' \/ _ \/ _` (_-<
        %   \___\___|_||_\___|_| \__,_|_| |_|  |_\___|\__|_||_\___/\__,_/__/
        %
        %%
        %
        function obj = refresh_gui_main(obj)
            handles = guidata(obj.gui_main);
            %% Region 1
            %
            %% Time elements
            %
            set(handles.editFundamentalPeriod,'String',num2str(obj.ity.fundamental_period/obj.uot_conversion));
            set(handles.editDuration,'String',num2str(obj.ity.duration/obj.uot_conversion));
            set(handles.editNumberOfTimepoints,'String',num2str(obj.ity.number_of_timepoints));
            %% Output Directory
            %
            set(handles.editOutputDirectory,'String',obj.ity.output_directory);
            %% Region 2
            %
            %% Group Table
            % Show the data in the ity |group_order| property
            tableGroupData = cell(obj.ity.number_group,...
                length(get(handles.tableGroup,'ColumnName')));
            n=1;
            for i = obj.ity.order_group
                tableGroupData{n,1} = obj.ity.group_label{i};
                tableGroupData{n,2} = i;
                tableGroupData{n,3} = obj.ity.number_position(i);
                tableGroupData{n,4} = obj.ity.group_function_before{i};
                tableGroupData{n,5} = obj.ity.group_function_after{i};
                n = n + 1;
            end
            set(handles.tableGroup,'Data',tableGroupData);
            %% Region 3
            %
            %% Position Table
            % Show the data in the ity |position_order| property for a given
            % group
            myGroupOrder = obj.ity.order_group;
            gInd = myGroupOrder(obj.pointerGroup(1));
            myPositionOrder = obj.ity.order_position{gInd};
            if isempty(myPositionOrder)
                set(handles.tablePosition,'Data',cell(1,10));
            else
                tablePositionData = cell(length(myPositionOrder),...
                    length(get(handles.tablePosition,'ColumnName')));
                n=1;
                for i = myPositionOrder
                    tablePositionData{n,1} = obj.ity.position_label{i};
                    tablePositionData{n,2} = i;
                    tablePositionData{n,3} = obj.ity.position_xyz(i,1);
                    tablePositionData{n,4} = obj.ity.position_xyz(i,2);
                    tablePositionData{n,5} = obj.ity.position_xyz(i,3);
                    if obj.ity.position_continuous_focus_bool(i)
                        tablePositionData{n,6} = 'yes';
                    else
                        tablePositionData{n,6} = 'no';
                    end
                    tablePositionData{n,7} = obj.ity.position_continuous_focus_offset(i);
                    tablePositionData{n,8} = obj.ity.position_function_before{i};
                    tablePositionData{n,9} = obj.ity.position_function_after{i};
                    tablePositionData{n,10} = obj.ity.number_settings(i);
                    n = n + 1;
                end
                set(handles.tablePosition,'Data',tablePositionData);
            end
            %% Region 4
            %
            %% Settings Table
            % Show the prototype_settings
            pInd = obj.ity.order_position{gInd}(1);
            mySettingsOrder = obj.ity.order_settings{pInd};
            if isempty(mySettingsOrder)
                set(handles.tableSettings,'Data',cell(1,11));
            else
                tableSettingsData = cell(length(mySettingsOrder),...
                    length(get(handles.tableSettings,'ColumnName')));
                n=1;
                for i = mySettingsOrder
                    tableSettingsData{n,1} = obj.mm.Channel{obj.ity.settings_channel(i)};
                    tableSettingsData{n,2} = obj.ity.settings_exposure(i);
                    tableSettingsData{n,3} = obj.ity.settings_binning(i);
                    tableSettingsData{n,4} = obj.ity.settings_z_step_size(i);
                    tableSettingsData{n,5} = obj.ity.settings_z_stack_upper_offset(i);
                    tableSettingsData{n,6} = obj.ity.settings_z_stack_lower_offset(i);
                    tableSettingsData{n,7} = length(obj.ity.settings_z_stack_lower_offset(i)...
                        :obj.ity.settings_z_step_size(i)...
                        :obj.ity.settings_z_stack_upper_offset(i));
                    tableSettingsData{n,8} = obj.ity.settings_z_origin_offset(i);
                    tableSettingsData{n,9} = obj.ity.settings_period_multiplier(i);
                    tableSettingsData{n,10} = obj.ity.settings_function{i};
                    tableSettingsData{n,11} = i;
                    n = n + 1;
                end
                set(handles.tableSettings,'Data',tableSettingsData);
            end
        end
        %% delete (make sure its child objects are also deleted)
        % for a clean delete
        function delete(obj)
            delete(obj.gui_main);
        end
    end
end