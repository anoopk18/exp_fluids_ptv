%Question 3, parts a and b, fluid 1
%import the mat matrix
%based on Eva's reference for allocation array [x position , y position, time (s), trajectory number]

folderPath = 'R:\ENG_Breuer_Shared\group\Eva\experimental_fluids_PTV\fluid1pix\';
fileName = 'trajectories_x_y_time_trajectorynumber.mat';  % Change 'your_data_file.mat' to the actual file name
fullFilePath = fullfile(folderPath, fileName);
loadedData = load(fullFilePath)
data = loadedData.good_tr;
x = loadedData.good_tr(:, 1); y = loadedData.good_tr(:, 2); 
time = loadedData.good_tr(:, 3); trackID = loadedData.good_tr(:, 4);
% Sort data by trajectory number and then by time within each trajectory
data = sortrows(data, [4, 3]);  %using sortrows to sort based on trackID first and then time
maxTimeLag = max(data(:,3)) - min(data(:,3));  % maximum possible time lag
numTracks = max(data(:,4));  % number of unique tracks
MSDs = [];
STDs = [];
lags = [];
%iterating o'er possible time lags
for j = 1:maxTimeLag  
    deltaRsq = [];  % initializing to collect displacements for this lag
    for trackID = 1:numTracks
        %extracting data for this particular track assignment
        trackData = data(data(:,4) == trackID, :);  
        maxIndexval = size(trackData, 1) - j;  % maximum index for the start of a displacement
        for i = 1:maxIndexval
            %%% calculation part %%%
            % squared displacement calculation
            dx = trackData(i + j, 1) - trackData(i, 1);
            dy = trackData(i + j, 2) - trackData(i, 2);
            deltaRsq = [deltaRsq; dx^2 + dy^2];
        end
    end
    if ~isempty(deltaRsq)
        % mean and std dev calc
        meanDisp = mean(deltaRsq);
        stdDisp = sqrt(abs(meanDisp.^2 - mean(deltaRsq.^2)));
        MSDs = [MSDs;meanDisp];
        STDs = [STDs;stdDisp];
        lags = [lags;j];
    end
end

%plotting 
figure(1)
errorbar(lags, MSDs, STDs);
xlabel('Time Lag (s)');
ylabel('MSD Fluid 1(nm^2)');
title('Mean Squared Displacement vs Time Lag')