function plotLibrarySizeHeatmap(excelFile)
%% Function written by Eleni Christoforidou in MATLAB R2024a.

% This function reads library size data from a specified Excel
% file and creates a sorted heatmap of library sizes across 
% patients and timepoints. The plot is saved as an SVG file.
%
% Parameters:
%   excelFile: A string specifying the path to the Excel file containing
%              library size data. The sizes should be in bp.
%
% Output:
%   A figure is displayed showing a heatmap, sorted by average library
%   concentration. The figure is also saved as an SVG file named 
%   'LibrarySizeHeatmap.svg'.
%
% Example:
%   plotLibrarySizeHeatmap('path/to/excelFile.xlsx')

%%

    % Load data from Excel file
    data = readtable(excelFile);
    
    % Extract sample IDs and library sizes
    sampleIDs = data.SampleID;
    librarySizes = data.miRNA_or_piRNA_Peak_sizeEL;
    
    % Parse out patient numbers and timepoints
    patientNumbers = cellfun(@(x) str2double(regexp(x, 'P(\d+)-', 'tokens', 'once')), sampleIDs);
    timepoints = cellfun(@(x) str2double(regexp(x, '-(\d+)', 'tokens', 'once')), sampleIDs);
    
    % Find unique patients and timepoints
    uniquePatients = unique(patientNumbers);
    uniqueTimepoints = unique(timepoints);
    
    % Initialize matrix for heatmap data
    heatmapData = NaN(length(uniquePatients), length(uniqueTimepoints)); % Use NaN for missing data
    
    % Populate the heatmap data matrix
    for i = 1:length(sampleIDs)
        patientIndex = find(uniquePatients == patientNumbers(i));
        timepointIndex = find(uniqueTimepoints == timepoints(i));
        heatmapData(patientIndex, timepointIndex) = librarySizes(i);
    end
    
    % Sort patients by average library size
    [~, sortIdx] = sort(nanmean(heatmapData, 2), 'descend');
    heatmapDataSorted = heatmapData(sortIdx, :);
    sortedPatients = uniquePatients(sortIdx);

    % Create a figure
    fig = figure('WindowStyle', 'normal', 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);

    % Create heatmap
    h = heatmap(uniqueTimepoints, sortedPatients, heatmapDataSorted, ...
        'Colormap', jet, ...
        'ColorbarVisible', 'on', ...
        'CellLabelColor', 'none', ...
        'MissingDataColor', [1 1 1]); % White for missing data
    title('Heatmap of library sizes (bp) sorted by average (across timepoints) library size per patient');
    xlabel('Timepoint');
    ylabel('Patient ID');

    % Save the figure as SVG
    svgFileName = 'LibrarySizeHeatmap.svg';
    saveas(fig, svgFileName, 'svg');
    close(fig);
end