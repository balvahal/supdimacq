%%
%
function super_mda_acquisition_start(mmhandle)
%% create a dataset that contains the relevant info for each timepoint
%
SuperMDA = mmhandle.SuperMDA;
SuperMDA.finalize_MDA;
%% Execute the MDA
% Immediately before MDA begins the absolute clock must be started...
SuperMDA.configure_clock_absolute;
%%
% Start the MDA
SuperMDA.mda_clock_pointer = 1;
timer_mda = timer('TimerFcn',@execute_SuperMDA);
while SuperMDA.mda_clock_pointer <= length(SuperMDA.mda_clock_absolute)
    if strcmp(timer_mda.Running,'off') && now < SuperMDA.mda_clock_absolute(SuperMDA.mda_clock_pointer)
        startat(timer_mda,SuperMDA.mda_clock_absolute(SuperMDA.mda_clock_pointer));
    elseif strcmp(timer_mda.Running,'off') && now > SuperMDA.mda_clock_absolute(SuperMDA.mda_clock_pointer)
        % This loop ensures the order of the timepoints is preserved
        % instead of dropping timepoints to catch up to the next scheduled
        % timepoint yet to be executed. This loop should activate for the
        % first timepoint and then only if the run time of the SuperMDA is
        % longer the time between executions.
        execute_SuperMDA;
    else
        %%
        % Here is the code block where the while loop runs in between
        % execution of the MDA
        
    end
end

%% Save a history of the MDA execution and the images created to a CSV file
%
export(SuperMDA.database,'file',fullfile(SuperMDA.output_directory,'SuperMDA.bsv'),'Delimiter','bar');
%% Nested Functions
%
%% execute_SuperMDA
%
    function execute_SuperMDA(~,~) %time functions automatically input two variables that are not needed.
        SuperMDA.runtime_index(1) = SuperMDA.mda_clock_pointer;
        for i2 = 1:SuperMDA.my_length
            SuperMDA.runtime_index(2) = i2;
            mmhandle = SuperMDA.group(i2).group_function_before_handle(mmhandle,SuperMDA);
            for j2 = 1:SuperMDA.group(i2).my_length
                SuperMDA.runtime_index(3) = j2;
                mmhandle = SuperMDA.group(i2).position(j2).position_function_before_handle(mmhandle,SuperMDA);
                for k2 = 1:SuperMDA.group(i2).position(j2).my_length
                    SuperMDA.runtime_index(4) = k2;
                    if SuperMDA.group(i2).position(j2).settings(k2).timepoints(SuperMDA.mda_clock_pointer) == true
                        %% Execute the function that will snap and save an image
                        %
                        mmhandle = SuperMDA.group(i2).position(j2).settings(k2).settings_function_handle(mmhandle,SuperMDA);
                        export(SuperMDA.database,'file',fullfile(SuperMDA.output_directory,'SuperMDA.bsv'),'Delimiter','bar');
                    end
                end
                mmhandle = SuperMDA.group(i2).position(j2).position_function_after_handle(mmhandle,SuperMDA);
            end
            mmhandle = SuperMDA.group(i2).group_function_after_handle(mmhandle,SuperMDA);
        end
        SuperMDA.mda_clock_pointer = SuperMDA.mda_clock_pointer + 1;
    end
end