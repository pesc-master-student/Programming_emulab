
%% PARSE DATA 
% 
%%
% Date: 26.08.2020
% Developer: Thomas Haugan, thomas.haugan@ntnu.no
% Department: NTNU-IEL-PESC
%
% MODIFICATION HISTORY:
% Ver  Who Date    Changes
% ---- --- -------- --------------------------------------------------
% 1.00 TSH 26/08/20 Original script tested and validated.
% 1.10 TSH 29/10/20 Improved console output text layout. Replaced
%                   str2double with str2num for speed improvement.
% 1.20 TSH 10.05.21 Added compatibility table. Updated the script so it       
%                   can handle data from VW v1.24.
%
% What: 
%   A MATLAB-script that translates logged data samples exported from 
%   WatchView into MATLAB-compatible data format.
%       
% Why: 
%   Windows application WatchView logs and exports data into an XML-file.
%   This script translates the data into a MATLAB-friendly data format,
%   enabling further post-processing in MATLAB/Simulink. Plotting the
%   data to MATLAB figure and .PDF is optionally possible.
%
% Requirements:
%   1) Add this .m-file into the MATLAB Path
%   2) Exporting data from WatchView results in a .gz-file (GNU Zip)
%   3) The .gz file must be in MATLAB Path or current MATLAB folder
% 
% How:  
%   The stored data from WatchViev is revealed upon unzipping the compressed
%   folder, where the data is stored in XML-format. This script is based on
%   a finite-state machine designed to flow through the specific structure
%   of the XML file. Any changes to the pre-defined structure might break 
%   the script. The script iterates over the data samples and collects meta
%   data such as signal names, and X/Y-axis limits. Output from the script
%   can be exported to a .PDF-file and MATLAB-file, or displayed in a
%   MATLAB figure.
%
% COMPATIBILITY TABLE
%   Plots data from Datalogger while Graph-data is not supported yet.
%   Parsing stored data from following WatchView version are confirmed:
%   - v1.3.0.3941      [Y]
%   - v1.4.0.4027      [Y]
%   - v1.11.0.4637     [Y]
%   - v1.14.0.4800     [N]
%   - v1.16.0.5103     [Y]
%   - v1.24.0.2.3133   [Y]
%
% Example:  
%   output = parse2MATLAB 'scope_data.gz' -p -f -s
%
%   -p   Prints data to PDF file
%   -f   Displays MATLAB figure
%   -s   Store data into .m file
% output Parse data can be stored in Workspace variable 'output'
%
% Exceptions: Parsing program throws errors when input file is badly
%             formatted. Check compatibility table.
%
%%

function out = parse(filename, varargin)
    
    function cleanFileSystem()
        if(isfolder(temp_folder) )
            try
                rmdir(temp_folder, 's');
            catch EMsg
                error("ERROR: Failed to remove temp-folder");
            end
        end
    end

    function line = peek()
        WatchVParserIndex = WatchVParserIndex + 1;
        line = XLMInput(WatchVParserIndex);
    end

    clc;
    format long;
    temp_folder = 'temp';
    fprintf("*** PARSe2MATLAB ***\n");
    
    persistent WatchVParserIndex;
    WatchVParserIndex = 0;

    ST_Start = 0;
    ST_Header = 1;
    ST_Config = 2;
    ST_Axes = 3;
    ST_PreSampl = 4;
    ST_Sampling = 5;
    
    ST_Finish = 90;
    ST_Error = 100;
    
    STATE = ST_Start;
  
    while (STATE ~= ST_Finish || STATE == ST_Error)
        switch STATE
           case ST_Start
               cleanFileSystem();
               [~, fname, fext] = fileparts(filename);

               if( ~strcmp(fext,'.gz') || (strlength(fname) == 0) )
                   error('ERROR: Wrong file name specification');
               end

               if( ~isfile(filename))
                   error('ERROR: File "%s" does not exist\n', filename);
               end

               try
                  gunzip(filename, temp_folder); 
               catch ExceptionMsg
                  error('ERROR: Failed to unzip GNU zip file "%s"\n', filename);
               end

               WatchVParserPath = strcat('temp/', fname);

               XLMInput = fileread(WatchVParserPath);
               XLMInput = string(XLMInput);
               XLMInput = splitlines(XLMInput);
    
               L = peek();
               if (contains(L, "<?xml") )
                  STATE = ST_Header;
               else
                  STATE = ST_Error;
               end
           case ST_Header
               L = peek();
               if (contains(L,"<!--Graph") || contains(L, "<root>") ||contains(L,"<FileType>") || contains(L, "<Title"))
                  STATE = ST_Header;
               elseif contains(L,"<Configuration")
                   STATE = ST_Config;
               else
                  STATE = ST_Error;
               end
           case ST_Config
               NumberOfViews = str2num( extractBetween(L, "NumberOfViews=""",""" MaxNumberOf" ) );  
               MaxNumberOfPoints = str2num( extractBetween(L, "MaxNumberOfPoints=""", """>") );

               fprintf("#SCOPES => %i\n", NumberOfViews);
               fprintf("#SAMPLES => %i\n", MaxNumberOfPoints);
               L = peek();
               if contains(L, "<Axes>")
                   nOfDataSets = sum(count(XLMInput, "<Serie Name="));
                   STATE = ST_Axes;
               else
                   STATE = ST_Error;
               end
           case ST_Axes
                L = peek();
                if contains(L, "<Axis")
                    for j = 0:NumberOfViews
                        scope(j+1).min = str2num(extractBetween(L, "Min=""",""""));
                        scope(j+1).max = str2num(extractBetween(L, "Max=""",""""));
                        fprintf("(min, max) = (%f, %f)\n", scope(j+1).min, scope(j+1).max);
                        L = peek();
                    end
                    L = peek();
                    STATE = ST_PreSampl;
                    signal.timestamp = zeros(MaxNumberOfPoints, 1);
                else
                    STATE = ST_ERROR;
                end         
           case ST_PreSampl
                NumberOfSignals = 0;
                L = peek();
                if contains(L, "<Serie")
                    STATE = ST_Sampling;
                    sig_id = 0;
                elseif contains(L, "<GraphWindow>")
                    while(true)
                        L = peek();  
                        if contains(L, "</GraphWindows>")
                           L = peek();
                           break;
                        end                  
                    end
                    L = peek();
                    sig_id = 0;
                    STATE = ST_Sampling;
                else
                    STATE = ST_Error;
                end
           case ST_Sampling
                if contains(L, "<Serie Name")   
                    sig_id = sig_id + 1;
                    NumberOfSignals = NumberOfSignals + 1;
                    signal(sig_id).identifier = extractBetween(L,".", """ ViewIndex" );
                    signal(sig_id).plotindex = str2num(extractBetween(L,"ViewIndex=""", """>" ));
                    signal(sig_id).samples = zeros(MaxNumberOfPoints, 1);
                    L = peek();
                    if contains(L, "<Points>")
                        for x=1:MaxNumberOfPoints
                            L = peek();
                            signal(sig_id).samples(x) = str2double(extractBetween(L,"Y=""", """") );
                            if (sig_id == 1)
                                signal.timestamp(x) = str2double(extractBetween(L,"<Point X=""", """") );
                            end 
                        end
                        L = peek();
                        L = peek();
                        L = peek();
                        STATE = ST_Sampling;
                    else
                        STATE = ST_Error;
                    end
                    fprintf("(%i/%i) Found data set: %s\n", NumberOfSignals, nOfDataSets, signal(sig_id).identifier);
                elseif contains(L, "</root>")
                    STATE = ST_Finish;
                else
                    STATE = ST_Error;
                end
                
           case ST_Finish
                disp('congrats!');
                
           case ST_Error
               error("PARSING FAILED: File content does not comply with pre-specified format.");
           otherwise
              error("ERROR: Finite state machine (FSM) failed.");
        end  % end switch 
    end % end big-while
    
    cleanFileSystem();
    close all; 
    
    for scopeNo = 1:NumberOfViews
        sp = subplot(NumberOfViews + 1, 1, scopeNo);
        hold on;
        for sigNo = 1:NumberOfSignals
            if (signal(sigNo).plotindex + 1 == scopeNo)  
                plot(signal(1).timestamp, signal(sigNo).samples, ...
                                'DisplayName', signal(sigNo).identifier);
            end
        end
        sp.YLim = [scope(scopeNo + 1).min scope(scopeNo + 1).max];
        sp.XLim = [signal(1).timestamp(1) signal(1).timestamp(end)];
        sp.Box = 'on';
        L = legend;
        L.Interpreter = 'none';
    end

    subplot(NumberOfViews + 1, 1, NumberOfViews + 1, 'Parent', gcf);
      
    textWindow = gca;
    textWindow.Visible = 'off';
    datetime.setDefaultFormats('default','dd.MM.yyyy_HH:mm:ss');
    timeDateNow = string(datetime);
    metaData = "*** SUMMARY - DATAPLOT WATCHVIEW ***";
    metaData(2) = "====================================";
    metaData(3) = sprintf("Date/time: %s", string(timeDateNow) );
    metaData(4) = sprintf("PC / User: %s / %s", getenv('COMPUTERNAME'), getenv('USERNAME') );
    metaData(5) = sprintf("Number of samples: %i", MaxNumberOfPoints);
    metaData(6) = sprintf("Duration [sec]: %i", signal(1).timestamp(end) - signal(1).timestamp(1) );
    metaData(7) = sprintf("Number of signals: %i", NumberOfSignals);
    
    t = text(0.50,0.50, metaData);
    t.FontSize = 7;
    t.Interpreter = 'none';
    t.BackgroundColor = [0.95 0.95 0.95];
    t.Position = [0 0 0];
    t.HorizontalAlignment = 'left';
  
    datetime.setDefaultFormats('default','dd-MM-yyyy HH-mm-ss');
    fname = string(fname) + "  " + string(datetime);
    figure = gcf;
    figure.Visible = 'off';
    
    for argument = 1:(nargin-1)
        flag = varargin{argument};
        switch flag
            case '-p'
                print(fname, '-dpdf', '-fillpage');
                fname = 'GENERATED PDF: "' + fname + '.pdf"';
                disp(fname);
            case '-s'
                 save(fname, 'signal');
                 
            case '-f'
                figure.Visible = 'on';
            otherwise
                % NOP
        end
    end
    out = signal;
end