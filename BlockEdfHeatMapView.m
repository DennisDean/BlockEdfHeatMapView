classdef BlockEdfHeatMapView
    %BlockEdfHeatMapView Create HeatMap from EDF signals
    %   A heatmap can be created for each signal in an EDF or for selected
    %   signals. Alternatively, a panel of heatmaps can be created.
    %   Heatmap's x axis can be selected from preset durations that
    %   correspond to values often used in sleep and circadian research.
    %   The HeatMap function is designed to provide a way to quickly review
    %   the contents of large number of sleep studies.
    %
    % Getting started:
    %     The fastest way to get started is to run tests in the
    %  associated test file. Public properties contain the most common
    %  parameters for configuring HeatMaps.  More advance users may want
    %  to review private properties before modifying.
    %
    % Setting x axis duration:
    %     The x axis duration is set by indexing a private duration array.
    %   The sequential values of the array are:
    %
    %     1, 2, 5, 10, 15, 20, 30 seconds
    %     1, 2, 3, 5, 10, 15, 20, 30, 40, 45 minutes
    %     1, 2, 3, 4, 6, 8, 12 hours
    %
    %   example obj.xAxisDurationIndex = 7, sets the x axis duration to 30
    %   seconds
    %
    % Setting figure size:
    %      It is sometimes helpful to preset the figure size.  Use the
    %   command get(figure_id, 'Position') to get the values for a displayed 
    %   MATLAB figure appropriately scaled on your screen. Then set 
    %   obj.figPosition to the values.
    %
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
    % External References:
    %
    %    BlockEdfLoad.m
    %    http://www.mathworks.com/matlabcentral/fileexchange/42784-blockedfload
    %
    %    Panel.m
    %    http://www.mathworks.com/matlabcentral/fileexchange/20003-panel
    % 
    % Test functions uses:
    %
    %    saveppt2.m
    %    http://www.mathworks.com/matlabcentral/fileexchange/19322-saveppt2
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

    %---------------------------------------------------- Public Properties
    properties
        % Input Variables
        edf_fn = '';                       % EDF file name with path
        signals_to_plot = {};              % Cell array of EDF signal labels
        
        % Optional parameters
        subjectId = ''                     % Add to signal title if set
        
        % Figure parameters
        percentile_range = [10 90];        % Data scale range [min max]
        show_contour_legend = 0;           % Add legend to plot           
        xAxisDurationIndex = 7;            % X value index
        figPosition = [520, -38, 360, 855]; % scale figure
        num_heatmap_values = 32;           % Black/white resolutions
        
        % Panel parameters
        panelFontSize = 8;                 % Panel parameter size                 
        panelTitle = '';                   % Parameter title
        titleFontSize = 20;                % Title font size
        
    end
    %--------------------------------------------------- Private Properties
    properties (Dependent)
        % Input Propertied
        num_signals              % Number of signals in EDF
        edf_signals_labels       % signal lables for EDF
        opt                      % Option structure
        
        % Output Properties
        fig_ids                  % Figure IDs for generated figures
        window_epochs            % Array of allowable window epochs            
    end
    %--------------------------------------------------- Private Properties
    properties (GetAccess = private)
        
        % Input Properteis
        arg1                     % First argument
        num_args                 % Number of arguments for 
        signal_list              % Signals to create figures for
        signalIndexes            % Indexes of signals to display
        userOpt = [];            % User defined options 
        
        % EDF Properties
        edf_header               % EDF header structure from blockEdfLoad
        edf_signal_header        % EDF signal header structure
        edf_signal_cell_arrray   % EDF signal cell array
        
        %output properties
        window_epochs_private = ...
            [1, 2, 5, 10, 15, 20, ...
             30, 60, 2*60, 3*60, 5*60, 10*60, 15*60, 20*60, 30*60, 40*60, ...
             45*60, 60*60, 2*60*60, 3*60*60,  4*60*60, 6*60*60, 8*60*60, ...
             12*60*60, 12*60*60];
        window_epochs_ticks = ...
            {[0 0.25 0.5 0.75 1]; ... 
             [0 0.5 1 1.5 2]; ... 
             [0 1 2 3 4 5]; ... 
             [0 2 4 6 8 10]; ... 
             [0 3 6 9 12 15];...
             [0 5 10 15 20];...
             [0 10 20 30];...
             [0 15 30 45 60];... 
             [0  0.5 1 1.5 2.0];... % starts minutes
             [0 1 2 3];
             [0 1 2 3 4 5];
             [0 2 4 6 8 10];
             [0 3 6 9 12 15];
             [0 5 10 15 20];
             [0 10 20 30];...
             [0 10 20 40];...
             [0 15 30 45];...
             [0 15 30 45 60];... 
             [0 15 30 45 60];...  % start hours
             [0 0.5 1 1.5 2]; ... 
             [0 1 2 3];
             [0 1 2 3 4];
             [0 2 4 6];
             [0 2 4 6 8];
             [0 3 6 9 12];
             [0  6 12 18 24]};
        window_axis_label = ...
            {'Time (sec.)'; ... 
             'Time (sec.)'; ... 
             'Time (sec.)'; ... 
             'Time (sec.)'; ... 
             'Time (sec.)';...
             'Time (sec.)';...
             'Time (sec.)';...
             'Time (sec.)';... 
             'Time (min.)';... % starts minutes
             'Time (min.)';
             'Time (min.)';
             'Time (min.)';
             'Time (min.)';
             'Time (min.)';
             'Time (min.)';...
             'Time (min.)';...
             'Time (min.)';...
             'Time (min.)';... 
             'Time (hr.)';...  % start hours
             'Time (hr.)'; ... 
             'Time (hr.)';
             'Time (hr.)';
             'Time (hr.)';
             'Time (hr.)';
             'Time (hr.)';
             'Time (hr.)'};
        fig_ids_private = [];    % Private figure ids
        maxSignalsPerPannel = 10;
        
        
        % Figure Properties
        xTitleFudgeFactor = 0.97;
        
    end
    %------------------------------------------------------- Public Methods
    methods
     function obj = BlockEdfHeatMapView(varargin)
         % Constructor 
         
         % Store number of input arguments
         obj.num_args = nargin;
         
         % Process input arguments
         if nargin == 1
             % Get argument
             obj.arg1 = varargin{1};   
         elseif nargin == 2
             obj.arg1 = varargin{1};
             obj.signal_list = varargin{2};   
         elseif nargin == 3
             obj.arg1 = varargin{1};
             obj.signal_list = varargin{2};   
             obj.userOpt = varargin{3}; 
         else
            % function prototype not supported
            fprintf('quickViewEdfSignals(fn|edfStruct)\n');
            fprintf('quickViewEdfSignals(fn|edfStruct, varList)\n');
            fprintf('quickViewEdfSignals(fn|edfStruct, varList, opt)\n');
            return
         end
         
         % Process first argument
         if ischar(obj.arg1)
             % First argument is a file name
             obj.edf_fn = obj.arg1;
         
             % Load Data
             [header signalHeader signalCell] = blockEdfLoad(obj.edf_fn);

             % Record EDF components
             obj.edf_header = header;
             obj.edf_signal_header = signalHeader;
             obj.edf_signal_cell_arrray = signalCell;    
         else
              % Record EDF components
             obj.edf_header = obj.arg1.header;
             obj.edf_signal_header = obj.arg1.signalHeader;
             obj.edf_signal_cell_arrray = obj.arg1.signalCell;            
         end
         
         % Specify signals to display
         if nargin == 1
             obj.signal_list = obj.edf_signals_labels;
         elseif nargin == 2 | nargin == 3 
             % set signal list to complete if not set by calling function
             if isempty(obj.signal_list)
                 % Signal list is empty, set default
                 obj.signal_list = obj.edf_signals_labels;
             end        
         end  
     
         % Get signal indexes
         obj.signalIndexes = obj.GetModelIndexes...
                  (obj.edf_signals_labels, obj.signal_list);  
              
         % Set user provided options
         if nargin == 3
            obj.percentile_range = obj.userOpt.percentile_range;
            obj.show_contour_legend = obj.userOpt.show_contour_legend;
            obj.xAxisDurationIndex = obj.userOpt.xAxisDurationIndex;
            obj.figPosition = obj.userOpt.figPosition;
            obj.num_heatmap_values = obj.userOpt.num_heatmap_values;     
         end
     end
     %------------------------------------------------------- CreateFigures
     function obj = CreateHeatMapView(obj)
         % Create figures specified by user
         
         % Get indexes of signals to process
         signalIndexes = obj.signalIndexes;
         numSignals = length(signalIndexes);
         
         % Get information to display figure
         num_data_records = obj.edf_header.num_data_records;
         getSignalSamplesF = @(x)obj.edf_signal_header(x).samples_in_record;
         signalSamplesPerRecord = ...
             arrayfun(getSignalSamplesF,[1:obj.num_signals]);
         data_record_duration = obj.edf_header.data_record_duration;

         % Create each figure
         for f = 1:numSignals;
             % Get signal index for current figure
             s = signalIndexes(f);
             
            % Create a plot for each signal
            signalSize = double(signalSamplesPerRecord(s)*num_data_records);

            % Define preset widths in second
            w = obj.window_epochs_private()'*signalSamplesPerRecord(s);
            widthIndex = obj.xAxisDurationIndex;  % widthIndex(1); Fixed to 30 seonds
            w = obj.window_epochs_private(widthIndex)'*signalSamplesPerRecord(s);
            widthDuration = w/signalSamplesPerRecord(s);

            % Compute Image size
            ptWidth = w/data_record_duration;
            ptHeight = ceil(signalSize/ptWidth);
            signalImage = zeros(ptHeight, ptWidth);

            % Move point into image
            signal = obj.edf_signal_cell_arrray{s};
            goodRange = prctile(signal, obj.percentile_range);
            lowIndexes = find(signal<goodRange(1));
            highIndexes = find(signal>goodRange(2));
            signal(lowIndexes) = goodRange(1);
            signal(highIndexes) = goodRange(2);

            % Move data into array
            signalImage(1:ptHeight-1,1:ptWidth) =  ...
                   reshape(signal(1:(ptHeight-1)*ptWidth), ptWidth, ptHeight-1)';
            r = ptHeight;
            numRemainingPts = signalSize - (ptHeight-1)*ptWidth;
            strIndex = 1+(r-1)*ptWidth;
            signalImage(r,1:numRemainingPts) = signal(strIndex:end);

            % Create Figure
            fid = figure('InvertHardcopy','off','Color',[1 1 1]);clf;
            image(signalImage,'CDataMapping','scaled');
            colormap(bone(obj.num_heatmap_values));
            
            % Show contour color bar if requested
            if obj.show_contour_legend == 1
                colorbar; 
            end

            % Annotate figure            
            titleStr = sprintf('%s',...
                obj.edf_signal_header(s).signal_labels);
            if ~isempty(obj.subjectId)
                titleStr = sprintf('%s - %s',...
                    obj.subjectId, obj.edf_signal_header(s).signal_labels);
            end
            title(titleStr,'FontWeight','bold','FontSize',14, ...
                'Interpreter', 'None');
            durI = obj.xAxisDurationIndex;
            normalizeTickInc = 1/(length(obj.window_epochs_ticks{durI})-1);
            xticks = [0:normalizeTickInc:1]*size(signalImage,2);
            xticks(1) = 1;  
            set(gca,'XTick', xticks);
            x_tick_labels = cellfun(@num2str, ...
                num2cell(obj.window_epochs_ticks{durI}),...
                'UniformOutput', false);
            set(gca,'XTickLabel', x_tick_labels);
            xlabel(obj.window_axis_label{durI},...
                'FontWeight','bold','FontSize',12);

            % Create yazis labels
            vertHourInc = 60*60/widthDuration;
            yaxisHourlyTicks = [1:vertHourInc:ptHeight];
            yTickLabels = {};
            for h = 1:length(yaxisHourlyTicks)
                yTickLabels{h}= num2str(h-1);
            end
            set(gca,'YTick',yaxisHourlyTicks);
            set(gca,'YTickLabel',yTickLabels);  
            ylabel('Time(Hours)', 'FontWeight','bold','FontSize',12);

            % Set axis attributes
            set(gca, 'LineWidth', 2);
            set(gca, 'FontSize', 10);
            
            % Figure page size
            %set(fid, 'PaperSize', [7 3]);
            figPos = get(fid, 'Position');
            if ~isempty(obj.figPosition)
                set(fid, 'Position',obj.figPosition);
            end
            
            % Record figure ids
            obj.fig_ids_private(end+1) = fid;
         end
     end
     %--------------------------------------------------------- CreatePanel
     function obj = CreatePanel(obj)
         % Create figures specified by user
         
         % Get indexes of signals to process
         signalIndexes = obj.signalIndexes;
         numSignals = length(signalIndexes);
         
         % Get information to display figure
         num_data_records = obj.edf_header.num_data_records;
         getSignalSamplesF = @(x)obj.edf_signal_header(x).samples_in_record;
         signalSamplesPerRecord = ...
             arrayfun(getSignalSamplesF,[1:obj.num_signals]);
         data_record_duration = obj.edf_header.data_record_duration;
         
         % Create Figure 
         fid = figure('InvertHardcopy','off','Color',[1 1 1]);clf;
         
         % Define Panel
         p = panel('defer');
         p.pack('v', [1/20 -1])
         p(2).pack('h',numSignals);
         % p.de.margin = 4;
         
         % Label Plot in top panel
         p(1).select();
         v = axis();
         text(obj.xTitleFudgeFactor*mean(v(1:2)), ...
             mean(v(3:4)), obj.panelTitle,...
                'FontSize', obj.titleFontSize,'FontWeight', 'bold');
         axis off
         
         
         % Create each figure
         for f = 1:numSignals
             % Select panel
             p(2, f).select();
             p.de.margin = 10;
             p(2,f).margintop = 30;
             p(2,f).marginbottom = 4;
             p(2,f).marginleft = 4;
             p(2,f).marginright = 4;
             p(2,f).fontsize = obj.panelFontSize;
             p(2,f).fontweight = 'bold';
             
             % Get signal index for current figure
             s = signalIndexes(f);
             
            % Create a plot for each signal
            signalSize = double(signalSamplesPerRecord(s)*num_data_records);

            % Define preset widths in second
            w = obj.window_epochs_private()'*signalSamplesPerRecord(s);
            widthIndex = obj.xAxisDurationIndex;  % widthIndex(1); Fixed to 30 seonds
            w = obj.window_epochs_private(widthIndex)'*signalSamplesPerRecord(s);
            widthDuration = w/signalSamplesPerRecord(s);

            % Compute Image size
            ptWidth = w/data_record_duration;
            ptHeight = ceil(signalSize/ptWidth);
            signalImage = zeros(ptHeight, ptWidth);

            % Move point into image
            signal = obj.edf_signal_cell_arrray{s};
            goodRange = prctile(signal, obj.percentile_range);
            lowIndexes = find(signal<goodRange(1));
            highIndexes = find(signal>goodRange(2));
            signal(lowIndexes) = goodRange(1);
            signal(highIndexes) = goodRange(2);

            % Move data into array
            signalImage(1:ptHeight-1,1:ptWidth) =  ...
                   reshape(signal(1:(ptHeight-1)*ptWidth), ptWidth, ptHeight-1)';
            r = ptHeight;
            numRemainingPts = signalSize - (ptHeight-1)*ptWidth;
            strIndex = 1+(r-1)*ptWidth;
            signalImage(r,1:numRemainingPts) = signal(strIndex:end);

            % Create Figure
            % fid = figure('InvertHardcopy','off','Color',[1 1 1]);clf;
            image(signalImage,'CDataMapping','scaled');
            colormap(bone(obj.num_heatmap_values));
            
            % Show contour color bar if requested
            if obj.show_contour_legend == 1
                colorbar; 
            end

            % Annotate figure            
            titleStr = sprintf('%s',...
                obj.edf_signal_header(s).signal_labels);
            title(titleStr,'FontWeight','bold','FontSize',14,...
                'Interpreter', 'None');
            durI = obj.xAxisDurationIndex;
            normalizeTickInc = 1/(length(obj.window_epochs_ticks{durI})-1);
            xticks = [0:normalizeTickInc:1]*size(signalImage,2);
            xticks(1) = 1;  
            set(gca,'XTick', xticks);
            x_tick_labels = cellfun(@num2str, ...
                num2cell(obj.window_epochs_ticks{durI}),...
                'UniformOutput', false);
            set(gca,'XTickLabel', x_tick_labels);
             p(2,f).xlabel(obj.window_axis_label{durI});
               

            % Create yazis labels
            vertHourInc = 60*60/widthDuration;
            yaxisHourlyTicks = [1:vertHourInc:ptHeight];
            yTickLabels = {};
            for h = 1:length(yaxisHourlyTicks)
                yTickLabels{h}= num2str(h-1);
            end
            set(gca,'YTick',yaxisHourlyTicks);
            set(gca,'YTickLabel',yTickLabels); 
            if f == 1
                set(gca,'YTick',yaxisHourlyTicks);
                set(gca,'YTickLabel',yTickLabels);                 
                 p(2,f).ylabel('Time(Hours)');%, 'FontWeight','bold','FontSize',12);
            else
                set(gca,'YTick',[]);
            end
            
            % Set axis attributes
            set(gca, 'YDir','reverse');
            set(gca, 'LineWidth', 2);
            set(gca, 'FontSize', 10);
            %set(gca, 'ylim', 2);
            %set(gca, 'xlim', 10);
            
            
            % Set axis limits to image size
            v = axis;
            v(2) = size(signalImage,2);
            v(4) = size(signalImage,1);
            axis(v);
            
            % Figure page size
            %set(fid, 'PaperSize', [7 3]);
            figPos = get(fid, 'Position');
            %set(fid, 'Position',obj.figPosition);
         end
         
         % Commit panel changes
         p.select('all');
         p.refresh();
         
         % figure position
         if ~isempty(obj.figPosition)
            set(fid, 'Position',obj.figPosition);
         end
         
         % Record figure ids
         obj.fig_ids_private(end+1) = fid;
     end
    end
    %------------------------------------------------------ Private Methods
    methods (Access = private)
        
    end
    %---------------------------------------------------- Dependent Methods
    methods
        %------------------------------------------------------- figure ids
        function value = get.fig_ids(obj)
            value = obj.fig_ids_private;
        end
        %------------------------------------------------------ num_signals 
        function value = get.num_signals(obj)
            value = obj.edf_header.num_signals;
        end
        %----------------------------------------------- edf_signals_labels
        function value = get.edf_signals_labels(obj)
            sigLabelF = @(x)obj.edf_signal_header(x).signal_labels;
            value = cellfun(sigLabelF, num2cell([1:obj.num_signals]), ...
                    'UniformOutput', false);
        end
        %----------------------------------------------- edf_signals_labels
        function value = get.window_epochs(obj)
            value = obj.window_epochs_private;
        end
        %---------------------------------------------------------- Options
        function value = get.opt(obj)
            % Return structure with current figure options
            value.percentile_range = obj.percentile_range;
            value.show_contour_legend = obj.show_contour_legend;
            value.xAxisDurationIndex = obj.xAxisDurationIndex;
            value.figPosition = obj.figPosition;
            value.num_heatmap_values = obj.num_heatmap_values;
        end
    end
    %------------------------------------------------------- Static Methods
    methods (Static)
      %-------------------------------------------------- Get model indexes
        function indexes = GetModelIndexes(varList, varListSubset)
            % Function identifies the modelVariables indexes from the
            % signal lists
            numVars = length(varListSubset);
            indexes = zeros(numVars,1);
            for v = 1:numVars
                curVar = varListSubset{v};
                TF = strcmp(curVar,varList);
                temp = find(TF);
                if isempty(temp)
                    curVar
                end
                indexes(v)= temp(1);
            end
        end  
    end
end

