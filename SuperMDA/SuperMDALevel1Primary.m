%% The SuperMDAGroup is the highest level object in MDA
% The SuperMDAGroup allows multiple multi-dimensional-acquisitions to be
% run simulataneously. Each group consists of 1 or more position. The
% settings at each position are coordinated in a group by having each
% additional position duplicate the first defined position. The settings at
% each position can be customized within each group if desired.
classdef SuperMDALevel1Primary < handle
    %%
    % * duration: the length of a time lapse experiment in seconds. A
    % duration of zero means only a single set of images are captured, e.g.
    % for a scan slide feature.
    % * filename_prefix: the string that is placed at the front of the
    % image filename.
    % * fundamental_period: the shortest period that images are taken in
    % seconds.
    % * output_directory: The directory where the output images are stored.
    %
    properties
        database;
        duration = 0;
        fundamental_period = 300; %5 minutes is the default. The units are seconds.
        group;
        mda_clock_absolute;
        mda_clock_pointer = 1;
        mda_clock_relative = 0;
        number_of_timepoints = 1;
        output_directory;
        runtime_imagecounter = 0;
        runtime_index = [0,0,0,0]; %when looping through the MDA object, this will keep track of where it is in the loop. [timepoint,group,position,settings]
    end
    %%
    %
    methods
        %% The constructor method
        % The first argument is always mmhandle
        function obj = SuperMDALevel1Primary(mmhandle)
            if nargin == 0
                return
            elseif nargin == 1
                obj.group = SuperMDALevel2Group(mmhandle, obj);
                return
            end
        end
        %% Copy
        %
        % Make a copy of a handle object.
        function new = copy(obj)
            % Instantiate new object of the same class.
            new = feval(class(obj));
            
            % Copy all non-hidden properties.
            p = properties(obj);
            for i = 1:length(p)
                if strcmp('group',p{i})
                    for j=1:length(obj.(p{i}))
                        if j==1
                            new.(p{i}) = obj.(p{i})(j).copy;
                        else
                            new.(p{i})(j) = obj.(p{i})(j).copy;
                        end
                    end
                else
                    new.(p{i}) = obj.(p{i});
                end
            end
        end
        %% clone
        %
        function obj = clone(obj,obj2)
            % Make sure objects are of the same type
            if class(obj) == class(obj2)
                % Copy all non-hidden properties.
                p = properties(obj);
                for i = 1:length(p)
                    if strcmp('group',p{i})
                        obj.(p{i}) = [];
                        for j=1:length(obj.(p{i}))
                            if j==1
                                obj.(p{i}) = obj2.(p{i})(j).copy;
                            else
                                obj.(p{i})(j) = obj2.(p{i})(j).copy;
                            end
                        end
                    else
                        obj.(p{i}) = obj2.(p{i});
                    end
                end
            end
        end
        %% create a new group
        %
        function obj = new_group(obj)
            %first, borrow the properties from the last group to provide a
            %starting point and make sure the parent object is consistent
            obj.group(end+1) = obj.group(end).copy_group;
        end
        %% Find the number of group objects.
        %
        function len = my_length(obj)
            obj_array = obj.group;
            len = length(obj_array);
        end
        %% change the same property for all group
        %
        function obj = change_all_group(obj,my_property_name,my_var)
            switch(lower(my_property_name))
                case 'travel_offset'
                    if isnumeric(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.group(i).travel_offset = my_var;
                        end
                    end
                case 'travel_offset_bool'
                    if islogical(my_var) && length(my_var) == 1
                        for i=1:obj.my_length
                            obj.group(i).travel_offset_bool = my_var;
                        end
                    end
                case 'group_function_after_name'
                    if ischar(my_var)
                        for i=1:obj.my_length
                            obj.group(i).group_function_after_name = my_var;
                        end
                    end
                case 'group_function_before_name'
                    if ischar(my_var)
                        for i=1:obj.my_length
                            obj.group(i).group_function_before_name = my_var;
                        end
                    end
                case 'parent_mdaprimary'
                    %This really shouldn't ever need to be called, because
                    %by definition every child shares the same parent
                    if isa(my_var,'SuperMDALevel2Group')
                        for i=1:max(size(obj.position))
                            obj.group(i).Parent_MDAGroup = my_var;
                        end
                    end
                case 'label'
                    if ischar(my_var)
                        for i=1:obj.my_length
                            obj.group(i).label = my_var;
                        end
                    end
                otherwise
                    warning('primary:chg_all','The property entered was not recognized');
            end
        end
        %% Configure the relative clock
        %
        function obj = configure_clock_relative(obj)
            obj.mda_clock_relative = 0:obj.fundamental_period:obj.duration;
            obj.number_of_timepoints = length(obj.mda_clock_relative);
        end
        %% Configure the absolute clock
        % Convert the MDA object unit of time (seconds) to the MATLAB unit
        % of time (days) for the serial date numbers, i.e. the number of
        % days that have passed since January 1, 0000.
        function obj = configure_clock_absolute(obj)
            obj.mda_clock_absolute = now + obj.mda_clock_relative/86400;
        end
        %% Update child objects to reflect number of timepoints
        % The highly customizable features of the mda include exposure, xyz
        % position, and timepoints. These properties must have the same
        % length. This function will ensure they all have the same length.
        function obj = update_children_to_reflect_number_of_timepoints(obj)
            obj.configure_clock_relative;
            for i = 1:obj.my_length
                for j = 1:max(size(obj.group(i).position))
                    mydiff = obj.number_of_timepoints - size(obj.group(i).position(j).xyz,1);
                    if mydiff < 0
                        mydiff = abs(mydiff)+1;
                        obj.group(i).position(j).xyz(mydiff:end,:) = [];
                    elseif mydiff > 0
                        obj.group(i).position(j).xyz(end+1:obj.number_of_timepoints,:) = bsxfun(@times,ones(mydiff,3),obj.group(i).position(j).xyz(end,:));
                    end
                    for k = 1:max(size(obj.group(i).position(j).settings))
                        mydiff = obj.number_of_timepoints - length(obj.group(i).position(j).settings(k).timepoints);
                        if mydiff < 0
                            mydiff = abs(mydiff)+1;
                            obj.group(i).position(j).settings(k).timepoints(mydiff:end) = [];
                        elseif mydiff > 0
                            obj.group(i).position(j).settings(k).timepoints(end+1:obj.number_of_timepoints) = 1;
                        end
                        mydiff = obj.number_of_timepoints - length(obj.group(i).position(j).settings(k).exposure);
                        if mydiff < 0
                            mydiff = abs(mydiff)+1;
                            obj.group(i).position(j).settings(k).exposure(mydiff:end) = [];
                        elseif mydiff > 0
                            obj.group(i).position(j).settings(k).exposure(end+1:obj.number_of_timepoints) = obj.group(i).position(j).settings(k).exposure(end);
                        end
                    end
                end
            end
        end
        %% finalize_MDA
        %
        function obj = run(obj)
            %% Update the dependent parameters in the MDA object
            % Some parameters in the MDA object are dependent on others.
            % This dependency came about from combining parameters that are
            % easy to configure by a user interface into data structures
            % that are convenient to code with.
            obj.update_children_to_reflect_number_of_timepoints;
            for i = 1:obj.my_length
                obj.group(i).group_function_before_handle = str2func(obj.group(i).group_function_before_name);
                for j = 1:max(size(obj.group(i).position))
                    obj.group(i).position(j).position_function_before_handle = str2func(obj.group(i).position(j).position_function_before_name);
                    for k = 1:max(size(obj.group(i).position(j).settings))
                        obj.group(i).position(j).settings(k).calculate_timepoints;
                        obj.group(i).position(j).settings(k).create_z_stack_list;
                        obj.group(i).position(j).settings(k).settings_function_handle = str2func(obj.group(i).position(j).settings(k).settings_function_name);
                    end
                    obj.group(i).position(j).position_function_after_handle = str2func(obj.group(i).position(j).position_function_after_name);
                end
                obj.group(i).group_function_after_handle = str2func(obj.group(i).group_function_after_name);
            end
            %%
            % initialize the dataset array that will store the history of
            % the MDA.
            VarNames_strings = {...
                'Channel_name',...
                'filename',...
                'group_label',...
                'position_label'};
            VarNames_numeric = {...
                'binning',...
                'Channel_number',...
                'continuous_focus_offset',...
                'exposure',...
                'matlab_serial_date_number',...
                'position_order',...
                'timepoint',...
                'x',...
                'y',...
                'z'};
            database_strings = cell(2,length(VarNames_strings));
            database_strings(1,:) = VarNames_strings;
            [database_strings{2:end,:}] = deal('');
            database_numeric = cell(2,length(VarNames_numeric));
            database_numeric(1,:) = VarNames_numeric;
            [database_numeric{2:end,:}] = deal(0);
            database_filenames = horzcat(database_strings,database_numeric);
            obj.database = cell2dataset(database_filenames);
        end
    end
end