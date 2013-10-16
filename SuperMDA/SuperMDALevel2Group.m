%% The SuperMDAGroup is the highest level object in MDA
% The SuperMDAGroup allows multiple multi-dimensional-acquisitions to be
% run simulataneously. Each group consists of 1 or more positions. The
% settings at each position are coordinated in a group by having each
% additional position duplicate the first defined position. The settings at
% each position can be customized within each group if desired.
classdef SuperMDALevel2Group
    %%
    % * duration: the length of a time lapse experiment in seconds. A
    % duration of zero means only a single set of images are captured, e.g.
    % for a scan slide feature.
    % * filename_prefix: the string that is placed at the front of the
    % image filename.
    % * fundamental_period: the shortest period that images are taken
    % in seconds.
    % * output_directory: The directory where the output images are stored.
    %
    properties
        filename_prefix = 'mda';
        label = 'group';
        output_directory_group;
        Parent_MDAPrimary;
        positions;
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mmhandle
        function obj = SuperMDAGroup(mmhandle, my_Parent, my_positions,my_fundamental_period)
            if nargin == 0
                return
            elseif nargin == 1
                obj.Parent_MDAPrimary = my_Parent;
                obj.positions = SuperMDALevel3Position(mmhandle, obj);
                return
            end
        end
    end
end