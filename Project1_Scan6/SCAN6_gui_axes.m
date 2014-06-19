%% SCAN6_gui_main
% a simple gui to pause, stop, and resume a running MDA
function [f] = SCAN6_gui_axes(scan6)
%% Create the figure
%
myunits = get(0,'units');
set(0,'units','pixels');
Pix_SS = get(0,'screensize');
set(0,'units','characters');
Char_SS = get(0,'screensize');
ppChar = Pix_SS./Char_SS;
set(0,'units',myunits);
fwidth = 243; %1215/ppChar(3);
fheight = 70; %910/ppChar(4);
fx = Char_SS(3) - (Char_SS(3)*.1 + fwidth);
fy = Char_SS(4) - (Char_SS(4)*.1 + fheight);
f = figure('Visible','off','Units','characters','MenuBar','none','Position',[fx fy fwidth fheight],...
    'CloseRequestFcn',{@fDeleteFcn},'Name','Main');

%% Assemble the Map
%
%%
%
% Resize axes so that the width and height are the same ratio as the
% physical xy stage
xyLim = scan6.mm.xyStageLimits;
axesRatio = (0.9*fwidth*ppChar(3))/(0.9*fheight*ppChar(4)); % based on space set aside for the map on the gui
if (xyLim(2)- xyLim(1)) > (xyLim(4) - xyLim(3)) && (xyLim(2)- xyLim(1))/(xyLim(4) - xyLim(3)) >= axesRatio
    smapWidth = 0.9*fwidth*ppChar(3);
    smapHeight = smapWidth*(xyLim(4) - xyLim(3))/(xyLim(2)- xyLim(1));
else
    smapHeight = 0.9*fheight*ppChar(4);
    smapWidth = smapHeight*(xyLim(2) - xyLim(1))/(xyLim(4)- xyLim(3));
end
%convert from pixels to characters
smapWidth = round(smapWidth)/ppChar(3);
smapHeight = round(smapHeight)/ppChar(4);

haxesStageMap = axes(...    % Axes for plotting location of dishes/groups and positions
                 'Parent', f, ...
                 'Units', 'characters', ...
                 'HandleVisibility','callback', ...
                 'XLim',[xyLim(1) xyLim(2)],...
                 'YLim',[xyLim(3) xyLim(4)],...
                 'YDir','reverse',...
                 'TickDir','out',...
                 'Position',[(fwidth-smapWidth)/2, (fheight-smapHeight)/2, smapWidth,smapHeight],...
                 'ButtonDownFcn',{@axesStageMap_ButtonDownFcn});
%% Patches and Rectangles
% # current objective position is a rectangle
% # the perimeter of up to 6 dishes are rectangles made to be circles
% # the positions chosen for mda
mm = scan6.mm;
imageHeight = mm.core.getPixelSizeUm*mm.core.getImageHeight;
imageWidth = mm.core.getPixelSizeUm*mm.core.getImageWidth;
handles.colorDish = [176 224 230]/255;
handles.colorActiveDish = [135 206 235]/255;
handles.colorPerimeter = [105 105 105]/255;
handles.colorActivePerimeter = [0 0 0]/255;

hrectangleDishPerimeter = cell(6,1);
for i = 1:length(hrectangleDishPerimeter)
    hrectangleDishPerimeter{i} = rectangle('Parent',haxesStageMap,...
            'Position',[0,0,1,1],...
            'EdgeColor',handles.colorDish,...
            'FaceColor','none',...
            'Curvature',[1,1],...
            'LineWidth',3,...
            'Visible','off');
end

mm.getXYZ;
x = mm.pos(1);
y = mm.pos(2);
hrectangleCurrentPosition = rectangle('Parent',haxesStageMap,...
    'Position',[x,y,imageWidth,imageHeight],...
    'EdgeColor','none',...
    'FaceColor',[255 215 0]/255);

hpatchPerimeterPositions = cell(6,1);
for i = 1:length(hpatchPerimeterPositions)
    hpatchPerimeterPositions{i} = patch('Parent',haxesStageMap,...
            'XData',[],'YData',[],...
            'Marker','x',...
            'MarkerFaceColor','none',...
            'MarkerEdgeColor',handles.colorPerimeter,...
            'MarkerSize',16,...
            'FaceColor','none',...
            'EdgeColor','none',...
            'LineWidth',2,...
            'Visible','off');
end

%%
% store the uicontrol handles in the figure handles via guidata()
handles.axesStageMap = haxesStageMap;
handles.rectangleCurrentPosition = hrectangleCurrentPosition;
handles.rectangleDishPerimeter = hrectangleDishPerimeter;
handles.patchPerimeterPositions = hpatchPerimeterPositions;
%handles.patchSmdaPositions = hpatchSmdaPositions;
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
    function axesStageMap_ButtonDownFcn(a,b)
        disp('hello button push');
        
    end
end
