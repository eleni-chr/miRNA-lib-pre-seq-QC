function plotElectropherograms
%% Function written by Eleni Christoforidou in MATLAB R2024a.

% This function superimposes electropherograms (from TapeStation) into a
% line graph, showing the size (in bp) on the horizontal axis and the
% intensity (in normalised FU) on the vertical axis. The function uses all
% .csv files in the current directory to plot the figure. The .csv files
% were exported by the TapeStation software. They contain the raw data for
% plotting the electropherograms. The first column of each file contains 
% the data for the electronic ladder. The second column of each file 
% contains the data for the physical ladder. The rest of the columns
% contain the data for each sample that was ran on the TapeStation.
% Sample from multiple files are plotted onto the same graph.

% Run this function from inside the folder containing the .csv files.

%%
    % Get a list of all CSV files in the current directory
    files = dir('*.csv');
    numFiles = length(files);
    
    % Create a figure for plotting
    fig = figure('WindowStyle', 'normal', 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
    hold on;
    
    % Define the labels for the top 10 expected ladder peaks
    ladderLabels = {'25 bp (Lower marker)', '50 bp', '100 bp', '200 bp', '300 bp', '400 bp', '500 bp', '700 bp', '1000 bp', '1500 bp (Upper marker)'};
    
    % Initialize a flag to ensure the electronic ladder is plotted only once
    plottedElectronicLadder = false;

    % Loop through each file
    for i = 1:numFiles
        filePath = fullfile(files(i).folder, files(i).name);
        data = readtable(filePath, 'PreserveVariableNames', true);
        
        % Check number of columns and plot each sample
        numSamples = width(data) - 2; % Exclude the first two columns (electronic and physical ladder)
        
        % Extract and process electronic ladder only once from the first file for x-tick labels
        if ~plottedElectronicLadder
            electronicLadder = data{:, 1};
            % Detect peaks in the electronic ladder
            [pks, locs] = findpeaks(electronicLadder, 'MinPeakProminence', 0.1); % Adjust sensitivity as needed
            
            % Sort peaks by intensity and select the top 10
            [sortedPks, sortIdx] = sort(pks, 'descend');
            topPks = sortedPks(1:min(10, length(sortedPks)));
            topLocs = locs(sortIdx(1:min(10, length(sortedPks))));
            
            % Sort topLocs to ensure they are in increasing order
            [topLocs, idxOrder] = sort(topLocs);
            topPks = topPks(idxOrder);
            
            % Set custom x-ticks and labels at detected peak locations
            xticks(topLocs);
            if length(topLocs) >= length(ladderLabels)
                xticklabels(ladderLabels(1:length(topLocs)));
            else
                warning('Detected fewer than 10 peaks. Some labels will be missing.');
            end
            
            plottedElectronicLadder = true; % Set flag to true after processing
        end
        
        % Loop to plot each sample
        for j = 1:numSamples
            sampleData = data{:, j + 2}; % Offset by 2 to skip the first two columns
            plot(sampleData, 'DisplayName', ['Sample ' num2str(j)]);
        end
    end

    % Set axes properties
    set(gca, 'Layer', 'top');  % This line puts the x-ticks and grid lines on top of the data

    xlabel('dsDNA size (bp) calibrated using the electronic ladder');
    ylabel('Fluorescence Intensity (normalised FU)');
    title('Superimposed Electropherograms from TapeStation (NB: Some libraries are diluted up to 1:20)');
    hold off;

    svgFileName = 'Electropherograms.svg';
    saveas(fig, svgFileName, 'svg');
    close(fig);
end
