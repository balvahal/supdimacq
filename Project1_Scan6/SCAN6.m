%%
%
classdef SCAN6 < handle
    properties
        smdaI;
        smdaTA;
        mm;
        sampleList = zeros(1,6);
        gui_main;
        numberOfPositions = zeros(1,6);
        ind=[]; %listboxInd
        ind2=1;
        perimeterPoints = cell(1,6);
        center = zeros(2,6);
        radius = zeros(1,6);
    end
    %%
    %
    methods
        %% The constructor method
        % |smdai| is the itinerary that has been initalized with the
        % micromanager core handler object
        function obj = SCAN6(mm,smdaI,smdaTA)
            %%
            %
            if nargin == 0
                return
            elseif nargin == 3
                %% Initialzing the SuperMDA object
                %
                obj.smdaI = smdaI;
                obj.mm = mm;
                obj.smdaTA = smdaTA;
                %% Create a simple gui to enable pausing and stopping
                %
                obj.gui_main = SCAN6_gui_main(obj);
                %obj.refresh_gui_main;
            end
        end
                %% delete (make sure its child objects are also deleted)
        % for a clean delete
        function delete(obj)
            delete(obj.gui_main);
        end
    end
end