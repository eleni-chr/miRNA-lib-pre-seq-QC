function plotLibraryConcVsLibBatch(excelFile)
%% Function written by Eleni Christoforidou in MATLAB R2024a.

% This function reads data from a specified Excel file and creates
% a box plot with overlaid scatter points. The X-axis represents the library
% batch numbers (libraries with the same number were created at the same time),
% and the Y-axis represents the concentrations of the libraries.
% It assumes that the Excel file has sample IDs in column A, library concentrations (in nM) in 
% column B, and library batch numbers in column E. The box plot is saved as
% SVG.

% Parameters:
%   excelFile: A string specifying the path to the Excel file containing
%              the data.

% Example:
%   plotLibraryConcVsLibBatch('path/to/excelFile.xlsx')

%%
    % Read the Excel file
    dataTable = readtable(excelFile);

    % Extract the data
    concentrations = dataTable{:, 2}; % Concentrations
    libraryBatch = dataTable{:, 5}; % Library batch numbers as categorical

    % Create categorical array for library batches
    libraryBatchCats = categorical(libraryBatch);
    
    % Create a figure
    fig = figure('WindowStyle', 'normal', 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
    
    % Create a box plot
    boxplot(concentrations, libraryBatchCats, 'Notch', 'on', 'Colors', 'b');
    hold on;
    
    % Overlay scatter points
    % Find the positions of the boxes to align the scatter points
    [groupNum, groupNames] = grp2idx(libraryBatchCats); % This will give us numeric indices for groups
    positions = linspace(1, length(unique(groupNames)), length(unique(groupNames))); % Positions for each group
    scatter(groupNum, concentrations, 'ko');

    % Format the plot
    xlabel('Library Batch Number');
    ylabel('Library Concentration (nM)');
    title(textwrap("Library Concentration by Library Batch (libraries were made in batches of 6 or 12 with all 3 timepoints per patient processed together)",40));
    grid on;
    
    % Save the figure as SVG
    saveas(fig, 'LibraryConcVsLibraryBatch.svg');
    close(fig);
end