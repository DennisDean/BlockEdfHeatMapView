BlockEdfHeatMapView
===================


A heatmap can be created for each signal in an EDF or for selected signals. Alternatively, a panel of heatmaps can be created. Heatmap's x axis can be selected from preset durations that correspond to values often used in sleep and circadian research. The HeatMap function is designed to provide a way to quickly review the contents of large number of sleep studies.


## Getting started:
The fastest way to get started is to run tests in the associated test file. Public properties contain the most common parameters for configuring HeatMaps.  More advance users may want to review private properties before modifying.

### Examples included in test file
TEST_1: Specify edf as a file
TEST_2: Specify signals to heatmaps to generate
TEST_3: Specify EDF data as a structure
TEST_4: Change default figure options to a 5 minute window
TEST_5  Test heatmap resolution (2, 32, and 128)
TEST_6  Create panel
TEST_7  Summarize folder of EDFs by creating a pandel for each EDF and saving the figures in a power point file.      
             
## Most common changes from default settings

### Setting x axis duration:
The x axis duration is set by indexing a private duration array. The sequential values of the array are:
  
         1, 2, 5, 10, 15, 20, 30 seconds
         1, 2, 3, 5, 10, 15, 20, 30, 40, 45 minutes
         1, 2, 3, 4, 6, 8, 12 hours
    
       example obj.xAxisDurationIndex = 7, sets the x axis duration to 30
       seconds
    
### Setting figure size:
It is sometimes helpful to preset the figure size.  Use the command get (figure_id, 'Position') to get the values for a displayed MATLAB figure appropriately scaled on your screen. Then set obj.figPosition to the values.

    % Constructors:
    %
    %    edfHeatMapView(fn|edfStruct)
    %          Create seperate figure for each EDF signal
    %    edfHeatMapView(fn|edfStruct, varList)
    %          Specify which signals to generate
    %    edfHeatMapView(fn|edfStruct, varList, opt)
    %          Use option structure to set parameters
    %
    % Function Prototypes:
    %    obj.CreateHeatMapView
    %          Generate one or more figures as defined in varList
    %    obj.CreatePanel
    %          Create a panel  
    %
    %
    % Public Properties:
    %                 edf_fn :  EDF file name with path
    %        signals_to_plot :  Cell array of EDF signal labels 
    %                           { 'lab1', 'lab2,' ...}
    %              subjectId :  If set, add to signal title string 
    %       percentile_range :  HeatMap data scale range [min max]
    %    show_contour_legend :  Add legend to plot           
    %     xAxisDurationIndex :  X value index
    %            figPosition :  Set figure position and size
    %     num_heatmap_values :  Gray scale resolution
    %          panelFontSize :  Panel parameter size                 
    %             panelTitle :  Parameter title
    %          titleFontSize :  Title font size
    %

## External References:

    %
    %    BlockEdfLoad.m
    %    http://www.mathworks.com/matlabcentral/fileexchange/42784-blockedfload
    %
    %    Panel.m
    %    http://www.mathworks.com/matlabcentral/fileexchange/20003-panel
    %
    
## Test functions uses:
    %
    %    saveppt2.m
    %    http://www.mathworks.com/matlabcentral/fileexchange/19322-saveppt2
    %
    
## Links to additional resources
    %    
    %    National Sleep Research Resource
    %    https://sleepdata.org/
    %
    %    Test files, updated source code, sample output and release information
    %    https://github.com/DennisDean/BlockEdfHeatMapView
    %
    %    Original release website
    %    http://sleep.partners.org/edf/
    % 
