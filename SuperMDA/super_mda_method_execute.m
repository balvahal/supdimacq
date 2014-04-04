%%
%
function [smdaPilot] = super_mda_method_execute(smdaPilot)
smdaPilot.runtime_index(1) = smdaPilot.mda_clock_pointer;
for i2 = smdaPilot.itinerary.group_order
    smdaPilot.runtime_index(2) = i2;
    smdaPilot.itinerary.group(i2).group_function_before_handle(smdaPilot);
    for j2 = smdaPilot.itinerary.group(i2).position_order
        smdaPilot.runtime_index(3) = j2;
        smdaPilot.itinerary.group(i2).position(j2).position_function_before_handle(smdaPilot);
        for k2 = smdaPilot.itinerary.group(i2).position(j2).settings_order
            smdaPilot.runtime_index(4) = k2;
            if smdaPilot.itinerary.group(i2).position(j2).settings(k2).timepoints(smdaPilot.mda_clock_pointer) == true
                %% Execute the function that will snap and save an image
                %
                smdaPilot.itinerary.group(i2).position(j2).settings(k2).settings_function_handle(smdaPilot);
            end
        end
        smdaPilot.itinerary.group(i2).position(j2).position_function_after_handle(smdaPilot);
    end
    smdaPilot.itinerary.group(i2).group_function_after_handle(smdaPilot);
end
smdaPilot.mda_clock_pointer = smdaPilot.mda_clock_pointer + 1;
if smdaPilot.mda_clock_pointer > smdaPilot.itinerary.number_of_timepoints
    SuperMDAtable = cell2table(smdaPilot.itinerary.database,'VariableNames',{'channel_name','filename','group_label','position_label','binning','channel_number','continuous_focus_offset','continuous_focus_bool','exposure','group_number','group_order','matlab_serial_date_number','position_number','position_order','settings_number','settings_order','timepoint','x','y','z','z_order','image_description'});
    writetable(SuperMDAtable,fullfile(smdaPilot.itinerary.output_directory,'smda_database_redundant.txt'),'Delimiter','\t');
    smdaPilot.stop_acquisition;
end