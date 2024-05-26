function plotTapeStationAreaHistogram(excelFile)
%% Function written by Eleni Christoforidou in MATLAB R2023b.

% This function reads TapeStation peak area data (expressed as a percentage of 
% integrated area of the miRNA-sized peak) from a specified Excel file and plots 
% a histogram to visualise the distribution of these percentages across different 
% library samples. The function assumes that the integrated areas are stored in 
% the fourth column of the Excel file. The histogram is saved as an SVG file 
% with a transparent background.
%
% Parameters:
%   excelFile: A string specifying the path to the Excel file containing
%              TapeStation peak area data. The integrated areas should be in the
%              fourth column of the Excel file and should be expressed as a
%              percentage (%).
%
% Output:
%   A histogram is displayed showing the distribution of the integrated areas 
%   of TapeStation miRNA-sized peaks. The histogram is saved as an SVG file 
%   named 'TapeStationIntegratedAreasHistogram.svg'.
%
% Example:
%   plotTapeStationAreaHistogram('path/to/excelFile.xlsx')

    % Read the Excel file
    dataTable = readtable(excelFile);

    % Extract Qubit concentrations
    integratedAreas = dataTable{:, 4}; % Assuming areas are in the fourth column (in %).

    % Create a figure
    fig = figure('WindowStyle', 'normal', 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);

    % Create the histogram
    h = histogram(integratedAreas, 'BinWidth', 1, 'Normalization', 'probability');
    % Update axis after plotting to adjust y-scale to percentage
    ax = gca; % Get current axis
    ax.XTick = 0:5:100;
    ax.YTick = 0:0.05:1; % Define Y-axis ticks from 0 to 1 (0% to 100%)
    ax.YTickLabel = arrayfun(@(x) sprintf('%.0f', x*100), ax.YTick, 'UniformOutput', false); % Convert to percentage labels
    xlabel('% of library made up of a miRNA- or piRNA-sized peak');
    ylabel('Percentage of Libraries (%)');
    grid on

    % Save the figure as SVG with a transparent background
    svgFileName = 'TapeStationIntegratedAreasHistogram.svg';
    saveas(fig, svgFileName, 'svg');
    close(fig);
end
