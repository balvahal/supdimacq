%%
%
classdef SuperMDALevel4Settings < hgsetget
    %%
    % * Channel: an integer that specifies a Channel group preset
    % * exposure: in milliseconds
    % * z_offset: a distance in micrometers away from the position z-value
    % * z_stack: a list of z-value offsets in micrometers. Images will be
    % acquired at each value offset in this list.
    properties
        timepoints;
        timepoints_custom_bool = false;
        Channel = 1;
        exposure = 100;
        label = 'settings';
        Parent_MDAPosition;
        period_multiplier = 1;
        snap_function_name = 'super_mda_snap_basic';
        snap_function_handle;
        z_origin_offset = 0;
        z_step_size = 0.3;
        z_stack_upper_offset = 0;
        z_stack_lower_offset = 0;
        z_stack;
        z_stack_bool = false;
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mmhandle
        function obj = SuperMDAPositionSettings(mmhandle,my_Parent,my_wavelength,my_exposure,my_z_offset,my_z_stack,my_z_stack_bool,my_period_multiplier,my_snap_function)
            if nargin == 0
                return
            elseif nargin == 2
                obj.Parent_MDAPosition = my_Parent;
                % make z_stack
                obj.create_z_stack_list;
                return
            end
        end
        %% Make z_stack list
        % The z_stack list is generated using the step_size, upper_offset,
        % and lower_offset;
        function create_z_stack_list(obj)
            range = obj.z_stack_upper_offset - obj.z_stack_lower_offset;
            if range<=0
                obj.z_stack_upper_offset = 0;
                obj.z_stack_lower_offset = 0;
                obj.z_stack = 0;
            else
                obj.z_stack = obj.z_stack_lower_limit:obj.z_step_size:obj.z_stack_upper_limit;
                obj.z_stack_upper_limit = obj.z_stack(end);
            end
        end
        %% Calculate timepoints
        %
        function calculate_timepoints(obj)
            if obj.timepoints_custom_bool
                return
            end
            obj.timepoints = zeros(size(obj.Parent_MDAPosition.Parent_MDAGroup.Parent_MDAPrimary.mda_clock_relative));
            obj.timepoints(1:obj.period_multiplier:length(obj.timepoints)) = 1;
        end
        %% 
        %
    end
end