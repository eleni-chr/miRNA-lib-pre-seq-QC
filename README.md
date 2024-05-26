# miRNA-lib-pre-seq-QC
Pre-sequencing quality control of miRNA-seq libraries.

*Functions written by Eleni Christoforidou in MATLAB R2024a for a specific project. These functions may require adaptation for different dataset structures.*

This repository contains MATLAB functions designed to assist in the pre-sequencing quality control of miRNA-seq libraries prepared using the QIASeq miRNA UDI library kit from Qiagen for sequencing with Illumina platforms. The tools utilise data predominantly from the TapeStation HSD1000 assay and the Qubit HS dsDNA assay.

**Disclaimer:** The code provided in this repository has not been peer-reviewed and is subject to errors. Users are encouraged to thoroughly test the code and verify its accuracy for their specific use cases. The author of this code is not responsible for any errors or inaccuracies in the results obtained from using these functions. Additionally, the code may be subject to updates or modifications, and users should keep an eye out for future releases to ensure the most accurate and up-to-date functionality.

## Project Specifics
These functions were developed for a project where each patient's samples are grouped in sets of three, representing three timepoints (e.g., initial, mid, and final). Each function expects sample IDs in the format "P1-1, P1-2, P1-3, ..., P23-1, P23-2, P23-3", where "P" denotes the patient ID and the number following the dash indicates the timepoint. Functions that sort or group data by patient or timepoint are specifically tailored to this structure. **Users with different sample groupings or ID formats will need to modify the code to suit their specific data organisation.**

## Dependencies
- MATLAB (R2021a or later recommended)
- Statistics and Machine Learning Toolbox (for some functions)

## Installation
Clone this repository or download it as a ZIP file. No additional installation steps are required, aside from ensuring MATLAB is properly installed on your system.

## Usage
To use these functions, navigate to the downloaded repository's directory in MATLAB and include the functions in your MATLAB path.

## Function Descriptions

Below is a list of all functions included in this repository along with a brief description of their purpose and usage. **Functions are independent and can be run in any order.**

### A. Funtcions to assess batch effects

#### 1. plotLibraryConcVsRNABatch.m

##### Description
This function generates a box plot overlaid with scatter points to visualize the concentrations of miRNA-seq libraries against RNA extraction batch numbers. Each RNA batch number represents libraries made from RNA extracted simultaneously, aiding in the assessment of batch effects on library concentration. The function reads data from a specified Excel file which should include sample IDs, library concentrations in nM, and RNA batch numbers. The resulting plot is saved in SVG format.

##### Inputs
- excelFile: A string specifying the path to the Excel file. The file must have:
  - Sample IDs in column A
  - Concentrations in nM in column B
  - RNA batch numbers in column F

##### Outputs
An SVG file named LibraryConcVsRNABatch.svg containing the plot.

##### Usage

```plotLibraryConcVsRNABatch('path/to/excelFile.xlsx');```

##### Plot Features
- X-axis: RNA extraction batch number.
- Y-axis: Library concentration in nM.
- Visualisation: Box plots with notches indicate the median and variability within batches, with individual library concentrations shown as scatter points.

#### 2. plotLibraryConcVsLibBatch.m

##### Description
This function plots library concentrations versus library batch numbers to assess batch effects on library preparation. It creates a box plot with overlaid scatter points, where the x-axis represents library batch numbers—indicating that libraries with the same number were prepared simultaneously—and the y-axis shows the library concentrations in nM. The plot is saved as an SVG file. It requires data from an Excel file that includes sample IDs, library concentrations, and batch numbers.

##### Inputs
- excelFile: A string specifying the path to the Excel file containing the necessary data. The Excel file should have:
  - Sample IDs in column A
  - Library concentrations in nM in column B
  - Library batch numbers in column E

##### Outputs
An SVG file named LibraryConcVsLibraryBatch.svg containing the plot.

##### Usage

```plotLibraryConcVsLibBatch('path/to/excelFile.xlsx');```

##### Plot Features
- X-axis: Library Batch Number.
- Y-axis: Library Concentration (nM).
- Visualisation: Box plots with notches indicate the median and variability within batches, with individual library concentrations shown as scatter points.

### B. Functions to assess library size (TapeStation HSD1000 assay data)

#### 1. plotElectropherograms.m

##### Description
This function superimposes electropherograms from TapeStation data into a line graph, which is useful for visualising sample quality and consistency across multiple runs. It automatically processes all .csv files in the current directory, plotting the size in base pairs (bp) on the x-axis against the intensity in normalised fluorescence units (FU) on the y-axis. Each .csv file should contain columns for the electronic ladder, physical ladder, and sample data. The function is designed to run in the directory containing the .csv files and saves the resulting graph as an SVG file.

##### Requirements
The function should be run from a directory containing the .csv files exported by TapeStation software. The first column in each file must represent the electronic ladder, the second column the physical ladder, and subsequent columns the sample data.

##### Outputs
An SVG file named Electropherograms.svg containing the superimposed electropherograms.

##### Usage

```plotElectropherograms;```
(Run this command from the directory containing the .csv files.)

##### Plot Features
- X-axis: dsDNA size (bp) calibrated using the electronic ladder.
- Y-axis: Fluorescence Intensity (normalised FU).
- Visualisation: Multiple sample electropherograms are plotted on the same graph, with the electronic ladder used to calibrate and annotate peak sizes (ladder is not plotted).
- Additional Details: The function identifies and labels the top expected ladder peaks (there should be 10), and adjusts x-tick labels accordingly. A warning is issued if fewer than ten peaks are detected.

#### 2. plotLibrarySizeHeatmap.m

##### Description
This function generates a heatmap to display the library sizes across patients and timepoints based on data from an Excel file. It organises the library sizes, expressed in base pairs (bp), and sorts the heatmap by the average library size per patient to facilitate comparison and trend analysis. The resulting heatmap is saved as an SVG file, providing a visual summary of the library size distribution within and across patient samples.

##### Inputs
- excelFile: A string specifying the path to the Excel file. The file should contain:
  - SampleID: Identifiers for each sample, which should include patient number and timepoint.
  - miRNA_or_piRNA_Peak_sizeEL: Library sizes in bp.

##### Outputs
An SVG file named LibrarySizeHeatmap.svg containing the heatmap of library sizes.

##### Usage
```plotLibrarySizeHeatmap('path/to/excelFile.xlsx');```

##### Plot Features
- Visualisation: The heatmap represents library sizes, using a colour gradient to indicate the size range.
- X-axis: Timepoint (derived from SampleID).
- Y-axis: Patient ID (derived from SampleID).
- Colour: The jet colormap is used to represent library sizes, with white used for missing data.

#### 3. plotTapeStationPredominantPeakHistogram.m

##### Description
This function analyses TapeStation data to compare the distribution of predominant peak sizes with and without the use of an electronic ladder (EL). It reads peak size data from an Excel file and plots two superimposed histograms in one figure, allowing for direct comparison between the peak sizes measured with a physical ladder and those adjusted with an electronic ladder. Both histograms are displayed with semi-transparency to highlight overlapping areas, facilitating a visual comparison of peak size distributions across library samples. The peaks are assumed to be the ones with the largest integrated area percentage among the samples. The combined histogram is saved as an SVG file.

##### Inputs
- excelFile: A string specifying the path to the Excel file. The file should have:
  - Predominant peak sizes in the fifth column (in base pairs, bp).
  - Predominant peak sizes adjusted with electronic ladder in the sixth column (in bp).

##### Outputs
An SVG file named TapeStationPredominantPeakSizeHistogram.svg displaying the combined histogram of TapeStation predominant peak sizes.

##### Usage
```plotTapeStationPredominantPeakHistogram('path/to/excelFile.xlsx');```

##### Plot Features
- Visualisation: Two histograms are plotted in the same figure:
  - Blue bars represent peak sizes without electronic ladder adjustment.
  - Red bars represent peak sizes with electronic ladder adjustment.
- X-axis: dsDNA size of predominant TapeStation assay peak (in base pairs).
- Y-axis: Percentage of Libraries (%), with the scale adjusted to show percentages for easier interpretation.
- Interactivity: Includes a legend distinguishing the histograms by colour, corresponding to peak measurements with physical and electronic ladders.

#### 4. plotTapeStationHistogram.m

##### Description
This function generates two superimposed histograms to visualise the distribution of peak sizes from TapeStation data, focusing on peaks that likely represent miRNA- or piRNA-sized libraries. It reads peak size data directly from an Excel file, plotting peak sizes from the second column and peak sizes adjusted with an electronic ladder from the third column. Each histogram is depicted in a different colour and is semi-transparent to allow for overlap visualisation. This combined histogram helps in comparing the distribution of peak sizes with and without electronic ladder adjustments, facilitating the analysis of sizing consistency across samples. The output is saved as an SVG file.

##### Inputs
excelFile: A string specifying the path to the Excel file containing TapeStation peak size data. The peak sizes should be in the second column and the peak sizes with electronic ladder in the third column, both expressed in base pairs (bp).

##### Outputs
An SVG file named TapeStationPeakSizeHistogram.svg displaying the combined histogram of miRNA- or piRNA-sized TapeStation peaks.

##### Usage
```plotTapeStationHistogram('path/to/excelFile.xlsx');```

##### Plot Features
- Visualisation: Two histograms are plotted in the same figure:
  - Blue bars represent peak sizes without electronic ladder adjustment.
  - Red bars represent peak sizes with electronic ladder adjustment.
- X-axis: TapeStation dsDNA peak size (in base pairs).
- Y-axis: Percentage of Libraries (%), with the scale adjusted to show percentages for easier interpretation.
- Interactivity: Includes a legend distinguishing the histograms by colour, corresponding to peak measurements with physical and electronic ladders.

#### 5. plotTapeStationAreaHistogram.m

##### Description
This function creates a histogram to visualise the distribution of integrated areas of miRNA-sized peaks as a percentage of total peak area, using TapeStation data. It reads this data from an Excel file, where the integrated areas are expected to be in the fourth column and expressed as percentages. The histogram allows for an analysis of the proportion of library components that are miRNA- or piRNA-sized, providing insights into library quality and consistency. The histogram is displayed with percentage scales and saved as an SVG file with a transparent background.

##### Inputs
excelFile: A string specifying the path to the Excel file containing TapeStation peak area data. The integrated areas should be in the fourth column of the Excel file and expressed as a percentage.

##### Outputs
An SVG file named TapeStationIntegratedAreasHistogram.svg showing the histogram of integrated areas of miRNA-sized peaks.

##### Usage
```plotTapeStationAreaHistogram('path/to/excelFile.xlsx');```

##### Plot Features
- Visualisation: A histogram showing the percentage of the library made up of miRNA- or piRNA-sized peaks, with bin width set to 1% for detailed distribution analysis.
- X-axis: Percentage of the library made up of a miRNA- or piRNA-sized peak.
- Y-axis: Percentage of Libraries (%), formatted to show percentage values for clarity.

### C. Functions to assess library concentration (Qubit HS dsDNA assay data)

#### 1. plotLibraryConcHeatmap.m

##### Description
This function creates a heatmap to visualise library concentrations across different patients and timepoints, facilitating the analysis of concentration trends and variability. It reads library concentration data from a specified Excel file and sorts the heatmap by the average library concentration per patient. Concentrations should be provided in nM within the Excel file. The heatmap is saved as an SVG file.

##### Inputs
- excelFile: A string specifying the path to the Excel file that should contain at least two columns:
  - SampleID: Identifiers for each sample, expected to include patient number and timepoint.
  - Conc_nM: Library concentrations in nM.

##### Outputs
An SVG file named LibraryConcHeatmap.svg showing the heatmap of library concentrations, sorted by average library concentration.

##### Usage
```plotLibraryConcHeatmap('path/to/excelFile.xlsx');```

##### Plot Features
- Visualisation: The heatmap displays library concentrations across patients and timepoints, with patients sorted by their average library concentration.
- X-axis: Timepoint (derived from SampleID).
- Y-axis: Patient ID (derived from SampleID).
- Colour: Uses the jet colormap to represent concentration levels, with white indicating missing data.

#### 2. plotLibraryConcHistogram.m

##### Description
This function generates a histogram to visualise the distribution of library concentrations from miRNA-seq data, aiding in the assessment of the overall quality and consistency of library preparations. The histogram plots the frequency of various concentration ranges, providing insights into the typical concentration spans and any outliers. The concentrations are read from an Excel file, assumed to be in the second column and expressed in nanomolar (nM). The final histogram is saved as an SVG file.

##### Inputs
excelFile: A string specifying the path to the Excel file. The file must have library concentrations in the second column in nanomolar (nM).

##### Outputs
An SVG file named LibraryConcentrationsHistogram.svg showing the histogram of library concentrations.

##### Usage
```plotLibraryConcHistogram('path/to/excelFile.xlsx');```

##### Plot Features
- Visualisation: The histogram is normalised to show the probability of each concentration range, allowing for comparison across datasets of varying sizes.
- X-axis: Library Concentration (nM), with adjustable bin edges to refine the visualisation.
- Y-axis: Percentage of Libraries (%), with ticks formatted to display percentage values.

#### 3. plotLibConcByPatient.m

##### Description
This function reads library concentration data from a specified Excel file and creates a detailed box plot visualising the concentrations by patient and timepoint. It allows for an in-depth analysis of concentration variability across patients and the temporal stability of library preparations. Each patient is represented with a box plot displaying the interquartile range and median of library concentrations, while individual data points for each timepoint are overlaid on the plots. The plots are colour-coded to distinguish between different timepoints, enhancing clarity and facilitating quick visual assessments. The final plot is saved as an SVG file.

##### Inputs
excelFile: A string specifying the path to the Excel file containing library concentration data. The concentrations should be in nanomolar (nM) and identified by sample IDs that include patient identifiers and timepoints.

##### Outputs
An SVG file named LibraryConcentrationByPatient.svg showing the box plot of library concentrations by patient and timepoint.

##### Usage
```plotLibConcByPatient('path/to/excelFile.xlsx');```

##### Plot Features
- Visualisation: Box plots for each patient with individual data points for each timepoint overlaid.
- X-axis: Patient ID.
- Y-axis: Library Concentration (nM).
Colours: Each timepoint is represented by a distinct color (Blue for T1, Orange for T2, Pink for T3), which helps in distinguishing the data visually.
