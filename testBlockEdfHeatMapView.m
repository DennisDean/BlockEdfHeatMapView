function testBlockEdfHeatMapView
%testEdfHeatMapView test functionality for testBlockEdfHeatMapView
%   Test functionality and input variations.
%
%   A heatmap can be created for each signal in an EDF or for selected
%   signals. Alternatively, a panel of heatmaps can be created.
%   Heatmap's x axis can be selected from preset durations that
%   correspond to values often used in sleep and circadian research.
%   The HeatMap function is designed to provide a way to quickly review
%   the contents of large number of sleep studies.
%
%   Test cases assume a directory (./edfTest/) exists and contains test edf
%   files
%
%
% Links to additional resources
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
%
% Version: 0.1.10
%
% ---------------------------------------------
% Dennis A. Dean, II, Ph.D
%
% Program for Sleep and Cardiovascular Medicine
% Brigam and Women's Hospital
% Harvard Medical School
% 221 Longwood Ave
% Boston, MA  02149
%
% File created: October 25, 2012
% Last updated: April 29, 2014 
%    
% Copyright © [2012] The Brigham and Women's Hospital, Inc. THE BRIGHAM AND 
% WOMEN'S HOSPITAL, INC. AND ITS AGENTS RETAIN ALL RIGHTS TO THIS SOFTWARE 
% AND ARE MAKING THE SOFTWARE AVAILABLE ONLY FOR SCIENTIFIC RESEARCH 
% PURPOSES. THE SOFTWARE SHALL NOT BE USED FOR ANY OTHER PURPOSES, AND IS
% BEING MADE AVAILABLE WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, 
% INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY AND 
% FITNESS FOR A PARTICULAR PURPOSE. THE BRIGHAM AND WOMEN'S HOSPITAL, INC. 
% AND ITS AGENTS SHALL NOT BE LIABLE FOR ANY CLAIMS, LIABILITIES, OR LOSSES 
% RELATING TO OR ARISING FROM ANY USE OF THIS SOFTWARE.
%

% Test File
edf_fn = './testEdf/200002.edf';
        
% Test Flags
%----------------------- MESA tests
TEST_1  = 0; % Specify edf as a file
TEST_2  = 1; % Specify heatmaps to generate
TEST_3  = 0; % Pass in EDF data structure
TEST_4  = 0; % Change Default Figure Options to a 5 minute windows
TEST_5  = 0; % Test heatmap resolution (2, 32, and 128)
TEST_6  = 1; % Create panel
TEST_7  = 0; % Summarize folder of EDFs by creating a pandel for each EDF 
             % and saving the figures in a power point file.      

%------------------------------------------------------------------- Test 1
if TEST_1 == 1
    % Test Description
    test_id = 1;
    test_txt = 'Specify edf as a file';
    fprintf('Test %.0f. %s: %s\n', test_id, test_txt, edf_fn);

    % Close open figures
    close all;
    
    % Create figures
    hmObj = BlockEdfHeatMapView(edf_fn);
    hmObj.subjectId = '200002';
    hmObj = hmObj.CreateHeatMapView;
    
    % Create quickViewEdf Object 
    num_signals = hmObj.num_signals;
    edf_signals_labels = hmObj.edf_signals_labels;
    fig_ids = hmObj.fig_ids;
    
    % Write selected object information to consol
    fprintf('\nNumber of signals = %0.f\n', num_signals);
    fprintf('\nSignal labels: ');
    printStrList(edf_signals_labels); fprintf('\n');
    fprintf('\nFigure IDs: : ');
    printIntegerList(fig_ids); fprintf('\n');
end
%------------------------------------------------------------------- Test 2
if TEST_2 == 1
    % Test Description
    test_id = 2;
    test_txt = 'Specify edf as a file';
    fprintf('Test %.0f. %s: %s\n', test_id, test_txt, edf_fn);

    % Close open figures
    close all;
    
    % Create figures
    signalLabels = {'EEG', 'ECG', 'AIRFLOW'};
    hmObj = BlockEdfHeatMapView(edf_fn, signalLabels);
    hmObj.subjectId = '200002';
    hmObj = hmObj.CreateHeatMapView;
    
    
    % Create BlockEdfHeatMapView information 
    num_signals = hmObj.num_signals;
    edf_signals_labels = hmObj.edf_signals_labels;
    fig_ids = hmObj.fig_ids;
    
    % Write selected object information to consol
    fprintf('\nNumber of signals = %0.f\n', num_signals);
    fprintf('\nSignal labels: ');
    printStrList(edf_signals_labels); fprintf('\n');
    fprintf('\nFigure IDs: : ');
    printIntegerList(fig_ids); fprintf('\n');
end
%------------------------------------------------------------------- Test 3
if TEST_3 == 1
    % Test Description
    test_id = 3;
    edf_fn = '20621.edf';
    test_txt = 'Specify edf as a structure';
    fprintf('Test %.0f. %s: %s\n', test_id, test_txt, edf_fn);
    
    % Close open figures 
    
    % Load Data
    signalLabels = {'ECG', 'AIRFLOW'};
    hmObj = BlockEdfHeatMapView(edf_fn, signalLabels);
    
    % Create Figures
    hmObj = hmObj.CreateHeatMapView; 
        
    % Create quickViewEdf Object 
    num_signals = hmObj.num_signals;
    edf_signals_labels = hmObj.edf_signals_labels;
    fig_ids = hmObj.fig_ids;
    
    % Write selected object information to consol
    fprintf('\nNumber of signals = %0.f\n', num_signals);
    fprintf('\nSignal labels: ');
    printStrList(edf_signals_labels); fprintf('\n');
    fprintf('\nFigure IDs: : ');
    printIntegerList(fig_ids); fprintf('\n\n');
end
%------------------------------------------------------------------- Test 4
if TEST_4 == 1
    % Test Description
    test_id = 4;
    test_txt = 'Change Default Figure Options to a 5 minute windows';
    fprintf('Test %.0f. %s: %s\n', test_id, test_txt, edf_fn);

    % Create quickViewEdf Object   
    signalLabels = {'ECG', 'AIRFLOW'};
    hmObj = BlockEdfHeatMapView(edf_fn, signalLabels);
    
    % Change default figure display options
    hmObj.xAxisDurationIndex = 11; % five minute dirations for HV analysis
    hmObj.figPosition = [296   -61   591   855];
    
    % Create Figures
    hmObj = hmObj.CreateHeatMapView;
end
%------------------------------------------------------------------- Test 5
if TEST_5 == 1
    % Test Description
    test_id = 5;
    test_txt = 'Test heatmap resolution (2, 32, and 128)';
    fprintf('Test %.0f. %s: %s\n', test_id, test_txt, edf_fn);
    
    % Create EDF object
   

    % Create quickViewEdf Object   
    signals =  { 'ECG'};
    hmObj = BlockEdfHeatMapView(edf_fn, signals);
    
    % Change default figure display options
    hmObj.figPosition = [296   -61   591   855];
    
    % Create Figures
    hmObj.num_heatmap_values = 2;
    hmObj = hmObj.CreateHeatMapView;
    
    % Create Figures
    hmObj.num_heatmap_values = 32;
    hmObj = hmObj.CreateHeatMapView;
    
        % Create Figures
    hmObj.num_heatmap_values = 128;
    hmObj = hmObj.CreateHeatMapView;
    
end
%------------------------------------------------------------------- Test 6
if TEST_6 == 1
    % Test Description
    test_id = 6;
    test_txt = 'Test signal Pannel creation';
    fprintf('Test %.0f. %s: %s\n', test_id, test_txt, edf_fn);
    
    % Create EDF object
    signals =  {  'EEG',   'ECG',  'AIRFLOW',   'EOG(L)', 'EMG' };

    % Create quickViewEdf Object    
    hmObj = BlockEdfHeatMapView(edf_fn, signals);
    hmObj.figPosition = [];
    hmObj.panelTitle = '200002';  
    hmObj = hmObj.CreatePanel;
end
%------------------------------------------------------------------- Test 7
if TEST_7 == 1
    % High memory usage
    close all;
    
    % Test Description
    test_id = 7;
    test_txt = 'Summarize EDF''s in a folder';
    fprintf('Test %.0f. %s\n\n', test_id, test_txt);   
    
    
    % Folder path
    edfPath = '.\testEdf\';
    
    % Add EDF filter to path
    if (edfPath == '\')
        edfPath = strcat(edfPath,'\');
    end
    edfPathSearch = strcat(edfPath,'\', '*.edf');    
    
    % Get directory information
    dirStruct = dir(edfPathSearch);
    numEdfFiles = length(dirStruct);
    
    if numEdfFiles > 0
        % Signal list to include in panel
        signalList = { 'ECG', 'AIRFLOW', 'EEG', 'EOG(L)'};
               
        % Save figure to ppt
        pptFn = 'test_heatmap.ppt';
        titleStr = 'Test Data';
        imageResolution = 100;
        
        % Open PPT
        ppt = saveppt2(pptFn,'init', 'res', imageResolution); 
        saveppt2('ppt', ppt, 'f', 0,'text', titleStr);
       
        % Turn off warning, incase figure is drawn off screen
        warning off
        
        % Create each figure
        figIds = [];
        for f = 1:numEdfFiles
            % Update Console
            fprintf('%.0f. Create panel for %s\n', f, dirStruct(f).name);
            
            % Create file name
            edfFn = strcat(edfPath,dirStruct(f).name);
            
            % Create edfHeatMapView Object     
            hmObj = BlockEdfHeatMapView(edfFn, signalList);
            
            % Set figure parameters
            hmObj.figPosition = [1, 1, 1600, 824];
            hmObj.signals_to_plot = signalList;
            hmObj.num_heatmap_values = 128;
            
            % Create Panels
            hmObj.panelTitle = dirStruct(f).name;  
            hmObj = hmObj.CreatePanel;
            
            % Add figure to ppt
            saveppt2('ppt', ppt );
                        
            % Record figure id 
            close(gcf);     
        end

        % PPT
        saveppt2(pptFn,'ppt',ppt,'close');
    end
end

%----------------------------------------------------- End Testing Function
end
%-------------------------------------------------------- Support Functions
%---------------------------------------------------------------- CreatePPT
function CreatePPT(figs, pptFn, titleStr, imageResolution)
    % Create Power Point From Created Figures
    if ~isempty(figs)
        % Identifying Information

        ppt = saveppt2(pptFn,'init', 'res', imageResolution); 
        saveppt2('ppt', ppt, 'f', 0,'text', titleStr);
        for f = 1:length(figs)
            figure(figs(f));
            saveppt2('ppt', ppt );
        end
        saveppt2(pptFn,'ppt',ppt,'close');
    end       
end
%--------------------------------------------------------- printIntegerList
function printIntegerList(integerList)
    % Print an array of numbers
    numPerLine = 10;
    fprintf('\n%5.0f', integerList(1));
    for p = 2:length(integerList)
        if mod(p,numPerLine) ~= 1
            fprintf(', ');
        end
        fprintf('%5.0f', integerList(p));
        if mod(p,numPerLine) == 0
            fprintf('\n');
        end
    end
end
%------------------------------------------------------------- printStrList
function printStrList(strList)
    % Print an array of numbers
    numPerLine = 5;
    fprintf('\n%20s', strList{1});
    for p = 2:length(strList)
        if mod(p,numPerLine) ~= 1
            fprintf(', ');
        end
        fprintf('%20s', strList{p});
        if mod(p,numPerLine) == 0
            fprintf('\n');
        end
    end
end
  

