function plotTapeStationHistogram(excelFile)
%% Function written by Eleni Christoforidou in MATLAB R2023b.

% This function reads TapeStation data from a specified Excel file and plots 
% two histograms to visualise the distribution of peak sizes and peak sizes 
% with electronic ladder (EL) that represent miRNA- or piRNA-sized peaks 
% among different library samples. The function 
% assumes that the peak sizes are stored in the second column and the peak 
% sizes with EL are in the third column of the Excel file, both expressed in 
% base pairs (bp). The two histograms are superimposed in the same figure for 
% easy comparison, with each histogram represented in a different colour and 
% semi-transparent to view overlapping areas. The histogram is saved as an 
% SVG file.
%
% Parameters:
%   excelFile: A string specifying the path to the Excel file containing
%              TapeStation peak size data. The peak sizes should be in the
%              second column and the peak sizes with EL in the third column, 
%              both in base pairs (bp).
%
% Output:
%   A combined histogram is displayed showing the distribution of TapeStation 
%   miRNA- or piRNA-sized peak sizes with and without electronic ladder. The histogram 
%   is saved as an SVG file named 'TapeStationPeakSizeHistogram.svg'.
%
% Example:
%   plotTapeStationHistogram('path/to/excelFile.xlsx')

    % Read the Excel file
    dataTable = readtable(excelFile);

    % Extract peak sizes
    peakSizes = dataTable{:, 2}; % Assuming peak sizes are in the second column (in bp).
    peakSizesEL = dataTable{:, 3}; % Assuming peak sizes with electronic ladder are in the third column (in bp).

    % Create a figure
    fig = figure('WindowStyle', 'normal', 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
    tcl = tiledlayout(1,1);

    % Create the first histogram
    nexttile(tcl)
    h1 = histogram(peakSizes, 'FaceColor', 'b', 'FaceAlpha', 0.5, 'Normalization', 'probability');
    % Update axis after plotting to adjust y-scale to percentage
    ax = gca; % Get current axis
    ax.YTick = 0:0.05:1; % Define Y-axis ticks from 0 to 1 (0% to 100%)
    ax.YTickLabel = arrayfun(@(x) sprintf('%.0f', x*100), ax.YTick, 'UniformOutput', false); % Convert to percentage labels
    hold on; % Hold on to plot on the same figure

    % Create the second histogram
    h2 = histogram(peakSizesEL, 'FaceColor', 'r', 'FaceAlpha', 0.5, 'Normalization', 'probability');
    % Update axis after plotting to adjust y-scale to percentage
    ax = gca; % Get current axis
    ax.YTick = 0:0.05:1; % Define Y-axis ticks from 0 to 1 (0% to 100%)
    ax.YTickLabel = arrayfun(@(x) sprintf('%.0f', x*100), ax.YTick, 'UniformOutput', false); % Convert to percentage labels
    grid on

    % Add labels and title
    xlabel('TapeStation dsDNA peak size (bp)');
    ylabel('Percentage of Libraries (%)');
    title(textwrap("Distribution of TapeStation peaks likely representing miRNA or piRNA libraries", 40));

    h1.FaceColor=[0 .447 .741]; %change bar fill colour.
    h1.EdgeColor=[0 .447 .741]; %change bar outline colour.
    h2.FaceColor=[.85, .325, .098];
    h2.EdgeColor=[.85, .325, .098];

    % Add a legend
    hL = legend([h1, h2], {'Peak sizes with physical ladder', 'Peak sizes with electronic ladder'});
    hL.Layout.Tile = 'North';

    % Save the figure as SVG
    svgFileName = 'TapeStationPeakSizeHistogram.svg';
    saveas(fig, svgFileName, 'svg');
    close(fig);
end
