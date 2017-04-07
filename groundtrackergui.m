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

% Add edit boxes for COE
coelabels = {'Semi-Major Axis', 'Eccentricity', 'Inclination', 'Argument of Perigee', 'RAAN', 'True Anomaly'}; 
for i = 1:6
    COEbox(i) = uicontrol(mainfig, 'style', 'edit', 'units', 'normalized', 'position', [.15,.97-.07*i,.05,.05]);
    uicontrol(mainfig, 'style', 'text', 'units', 'normalized', 'position', [.04,.97-.07*i,.1,.05], 'string', coelabels{i}, 'horizontalalignment', 'right');
end

% Add edit boxes for inertial 3d
rvlabels = {'rI', 'rJ', 'rK', 'vI', 'vJ', 'vK'}; 
for i = 1:6
    RVbox(i) = uicontrol(mainfig, 'style', 'edit', 'units', 'normalized', 'position', [.3,.97-.07*i,.05,.05]);
    uicontrol(mainfig, 'style', 'text', 'units', 'normalized', 'position', [.24,.97-.07*i,.05,.05], 'string', rvlabels{i}, 'horizontalalignment', 'right');
end

% Add edit box for Greenwich hour angle
gwbox = uicontrol(mainfig, 'style', 'edit', 'units', 'normalized', 'position', [.6,.07,.05,.05]);
uicontrol(mainfig, 'style', 'text', 'units', 'normalized', 'position', [.44,.07,.15,.05], 'string', 'Greenwich Hour Angle', 'horizontalalignment', 'right');

end