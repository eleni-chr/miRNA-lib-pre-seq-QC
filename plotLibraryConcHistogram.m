function plotLibraryConcHistogram(excelFile)
%% Function written by Eleni Christoforidou in MATLAB R2023b.

% This function reads library concentration data from a specified Excel file
% and plots a histogram to visualise the distribution of these concentrations.
% The function assumes that the library concentrations are stored in the second
% column of the Excel file. The histogram is saved as an SVG file.
%
% Parameters:
%   excelFile: A string specifying the path to the Excel file containing
%              library concentration data. The concentrations should be in the
%              second column of the Excel file and should be in nanomolar (nM).
%
% Output:
%   A histogram is displayed showing the distribution of library concentrations.
%   The histogram is also saved as an SVG file named 'LibraryConcentrationsHistogram.svg'.
%
% Example:
%   plotLibraryConcHistogram('path/to/excelFile.xlsx')

    % Read the Excel file
    dataTable = readtable(excelFile);

    % Extract Qubit concentrations
    qubitConcentrations = dataTable{:, 2}; % Assuming concentrations are in the second column (in nM).

    % Create a figure
    fig = figure('WindowStyle', 'normal', 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);

    % Create the histogram
    binEdges = 0:1:max(qubitConcentrations); % Adjust step size to your desired bin step
    h = histogram(qubitConcentrations, 'Normalization', 'probability', 'BinEdges', binEdges);
    % Update axis after plotting to adjust y-scale to percentage
    ax = gca; % Get current axis
    ax.XTick = 0:5:200; % Define X-axis ticks
    ax.YTick = 0:0.01:1; % Define Y-axis ticks from 0 to 1 (0% to 100%)
    ax.YTickLabel = arrayfun(@(x) sprintf('%.0f', x*100), ax.YTick, 'UniformOutput', false); % Convert to percentage labels
    xlabel('Library Concentration (nM)');
    ylabel('Percentage of Libraries (%)');
    title('Distribution of Library Concentrations');
    grid on

    % Save the figure as SVG
    svgFileName = 'LibraryConcentrationsHistogram.svg';
    saveas(fig, svgFileName, 'svg');
    close(fig);
end
