function plotLibraryConcVsRNABatch(excelFile)
%% Function written by Eleni Christoforidou in MATLAB R2024a.

% This function reads data from a specified Excel file and creates
% a box plot with overlaid scatter points. The X-axis represents the RNA batch numbers
% (libraries with the same number were made from RNA that was extracted at the same time),
% and the Y-axis represents the concentrations of the libraries.
% It assumes that the Excel file has sample IDs in column A, concentrations (in nM) in 
% column B, and RNA batch numbers in column F.The box plot is saved as SVG.

% Parameters:
%   excelFile: A string specifying the path to the Excel file containing
%              the data.

% Example:
%   plotLibraryConcVsRNABatch('path/to/excelFile.xlsx')

%%
    % Read the Excel file
    dataTable = readtable(excelFile);

    % Extract the data
    concentrations = dataTable{:, 2}; % Concentrations
    RNABatch = dataTable{:, 6}; % RNA batch numbers as categorical

    % Create categorical array for RNA batches
    RNABatchCats = categorical(RNABatch);
    
    % Create a figure
    fig = figure('WindowStyle', 'normal', 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
    
    % Create a box plot
    boxplot(concentrations, RNABatchCats, 'Notch', 'on', 'Colors', 'b');
    hold on;
    
    % Overlay scatter points
    % Find the positions of the boxes to align the scatter points
    [groupNum, groupNames] = grp2idx(RNABatchCats); % This will give us numeric indices for groups
    positions = linspace(1, length(unique(groupNames)), length(unique(groupNames))); % Positions for each group
    scatter(groupNum, concentrations, 'ko');

    % Format the plot
    xlabel('RNA extraction batch number');
    ylabel('Library Concentration (nM)');
    title('Library Concentration by RNA Batch (RNA for libraries was extraced in batches of 6 with all 3 timepoints per patient processed together');
    grid on;
    
    % Save the figure as SVG
    saveas(fig, 'LibraryConcVsRNABatch.svg');
    close(fig);
end