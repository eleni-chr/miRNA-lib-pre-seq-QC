function plotLibConcByPatient(excelFile)
%% Function written by Eleni Christoforidou in MATLAB R2024a.

% This function reads library concentration data from a specified Excel
% file and creates a box-plot to visualise the concentrations by patient 
% and timepoint. The plot is saved as an SVG file.
%
% Parameters:
%   concFile: A string specifying the path to the Excel file containing
%              library concentration data. The concentrations should be in
%              nM.
%
% Output:
%   A figure is displayed showing a box-plot for each patient. The
%   individual data points (representing timepoints) are also plotted over
%   the box-plots. The figure is also saved as an SVG file named 
%   'LibraryConcentrationByPatient.svg'.
%
% Example:
%   plotLibConcByPatient('path/to/excelFile.xlsx')

%%
    % Read data from Excel file
    opts = detectImportOptions(excelFile); % Automatically detect the data format
    data = readtable(excelFile, opts);

    % Extract sample IDs and concentrations
    sampleIDs = data.SampleID;
    concentrations = data.Conc_nM;

    % Initialize variables to hold patient data
    patients = unique(cellfun(@(x) x(1:find(x=='-', 1, 'last')-1), sampleIDs, 'UniformOutput', false));

    % Extract numbers from patient IDs for proper numerical sorting
    numericIDs = cellfun(@(x) str2double(regexp(x, '\d+', 'match')), patients);
    [~, sortIndex] = sort(numericIDs); % Sort numerically
    patients = patients(sortIndex); % Apply the sorted index to patient labels
    
    numPatients = numel(patients);
    groupedData = cell(numPatients, 1);

    % Define colors for each timepoint
    timepointColors = {'#0072B2', '#D55E00', '#CC79A7'}; % Blue, Orange, Pink for timepoints 1, 2, 3

    % Group data by patient and timepoint
    groupedData = cell(numel(patients), 1);
    allTimepoints = cell(numel(patients), 1);
    for i = 1:numel(patients)
        patientPattern = strcat(patients{i}, '-');
        patientMask = startsWith(sampleIDs, patientPattern);
        groupedData{i} = concentrations(patientMask);
        allTimepoints{i} = sampleIDs(patientMask);
    end

    % Create a figure
    fig = figure('WindowStyle', 'normal', 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
    %set(fig, 'Color', 'none', 'InvertHardcopy', 'off'); % Set figure background to transparent
  
    % Create box plot
    boxPlotHandle = boxplot(vertcat(groupedData{:}), ...
        repelem(patients, cellfun(@numel, groupedData)), 'GroupOrder', patients, ...
        'Colors', 'k');
    hold on;

    % Add individual points colored by timepoint
    for i = 1:numel(patients)
        for j = 1:numel(timepointColors)
            timepointMask = endsWith(allTimepoints{i}, ['-', num2str(j)]);
            scatter(repelem(i, sum(timepointMask)), groupedData{i}(timepointMask), ...
                'MarkerEdgeColor', timepointColors{j}, 'jitter', 'on', 'jitterAmount', 0.05);
        end
    end

    hold off;
    title('Library Concentration by Patient and Timepoint');
    xlabel('Patient ID');
    ylabel('Library Concentration (nM)');
    grid on;
    legend('Timepoint 1', 'Timepoint 2', 'Timepoint 3', 'Location', 'best'); % Add legend
    
    % Save the figure as SVG with a transparent background
    svgFileName = 'LibraryConcentrationByPatient.svg';
    saveas(fig, svgFileName, 'svg');

    % Close the figure
    close(fig);
end