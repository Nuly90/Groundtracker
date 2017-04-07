% Groundtracker GUI

function groundtrackergui()

% Allows for input of COE or intertial coordinate data while the simulation
% is paused. Allows the user to vary simulation speed, or backtrack the
% simulation. Allows user to clear the current groundtrack trail on the
% display.

% Create the frame
mainfig = figure('position', [200,200,1000,500], 'menubar', 'none');
set(mainfig, 'numbertitle', 'off', 'Name', 'MATLAB Groundtracker')

% Add an axes for the ground track and an axes for the azimuth/elevation
gtrack = axes(mainfig, 'units', 'normalized', 'position', [.5,.2,.45,.5]);
set(gtrack, 'xlim', [-180, 180], 'ylim', [-90, 90], 'xgrid', 'on', 'ygrid', 'on')
set(gtrack,'XTick',-180:30:180, 'Ytick',-90:30:90, 'Layer','top','Color','black','gridcolor','w')
azel = azelaxes(mainfig, [.05,.1,.4,.4]);

% Add background for ground track
[flat_map,color_map] = imread('LE640.gif');
colormap(gtrack, color_map)
hold(gtrack, 'on')
earth_proj = image(gtrack,[-180 180],[90 -90],flat_map);

end