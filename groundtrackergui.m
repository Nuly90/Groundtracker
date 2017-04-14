% Groundtracker GUI

function groundtrackergui()

close all

% Allows for input of COE or intertial coordinate data while the simulation
% is paused. Allows the user to vary simulation speed, or backtrack the
% simulation. Allows user to clear the current groundtrack trail on the
% display.

% Create the frames
inputfig = figure('position', [200,450,300,350], 'menubar', 'none');
set(inputfig, 'numbertitle', 'off', 'Name', 'MATLAB Groundtracker')
orbit3dfig = figure('position', [600,100,500,300], 'menubar', 'none');
set(orbit3dfig, 'numbertitle', 'off', 'Name', 'MATLAB Groundtracker')
gtrackfig = figure('position', [600,450,500,350], 'menubar', 'none');
set(gtrackfig, 'numbertitle', 'off', 'Name', 'MATLAB Groundtracker')
azelfig = figure('position', [200,100,300,300], 'menubar', 'none');
set(azelfig, 'numbertitle', 'off', 'Name', 'MATLAB Groundtracker')

% Add an axes for the ground track and an axes for the azimuth/elevation
gtrack = axes(gtrackfig, 'units', 'normalized', 'position', [.1,.2,.8,.6]);
set(gtrack, 'xlim', [-180, 180], 'ylim', [-90, 90], 'xgrid', 'on', 'ygrid', 'on')
set(gtrack,'XTick',-180:30:180, 'Ytick',-90:30:90, 'Layer','top','Color','black','gridcolor','w')
azel = azelaxes(azelfig, [.15,.3,.7,.6]);

% Add background for ground track
[flat_map,color_map] = imread('LE640.gif');
colormap(gtrack, color_map)
hold(gtrack, 'on')
earth_proj = image(gtrack,[-180 180],[90 -90],flat_map);

% Add edit boxes for COE
coelabels = {'Semi-Major Axis', 'Eccentricity', 'Inclination', 'Argument of Perigee', 'RAAN', 'True Anomaly'}; 
for i = 1:6
    COEbox(i) = uicontrol(inputfig, 'style', 'edit', 'units', 'normalized', 'position', [.4,.97-.09*i,.2,.07]);
    uicontrol(inputfig, 'style', 'text', 'units', 'normalized', 'position', [.05,.97-.09*i,.34,.07], 'string', coelabels{i}, 'horizontalalignment', 'right');
end

% Add edit boxes for inertial 3d
rvlabels = {'rI', 'rJ', 'rK', 'vI', 'vJ', 'vK'}; 
for i = 1:6
    RVbox(i) = uicontrol(inputfig, 'style', 'edit', 'units', 'normalized', 'position', [.7,.97-.09*i,.2,.07]);
    uicontrol(inputfig, 'style', 'text', 'units', 'normalized', 'position', [.61,.97-.09*i,.08,.07], 'string', rvlabels{i}, 'horizontalalignment', 'right');
end

% Add edit box for Greenwich hour angle
gwbox = uicontrol(inputfig, 'style', 'edit', 'units', 'normalized', 'position', [.55,.07,.2,.07]);
uicontrol(inputfig, 'style', 'text', 'units', 'normalized', 'position', [.19,.07,.35,.07], 'string', 'Greenwich Hour Angle', 'horizontalalignment', 'right');

% Add edit boxes for lat/long of observing station
latbox = uicontrol(azelfig, 'style', 'edit', 'units', 'normalized', 'position', [.75,.12,.2,.07]);
longbox = uicontrol(azelfig, 'style', 'edit', 'units', 'normalized', 'position', [.75,.04,.2,.07]);
uicontrol(azelfig, 'style', 'text', 'units', 'normalized', 'position', [.55,.12,.19,.07], 'string', 'Latitude', 'horizontalalignment', 'right');
uicontrol(azelfig, 'style', 'text', 'units', 'normalized', 'position', [.55,.04,.19,.07], 'string', 'Longitude', 'horizontalalignment', 'right');

% Add drop-down menu for common stations
stations = {'Station 1', 'Station 2', 'Station 3'};
uicontrol(azelfig, 'style', 'text', 'units', 'normalized', 'position', [.05,.12,.3,.07], 'string', 'Observing Station');
stationbox = uicontrol(azelfig, 'style', 'popupmenu', 'units', 'normalized', 'position', [.05,.04,.3,.07], 'string', stations);

% Add button to set lat/long from selected station
fillstation = uicontrol(azelfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.37,.05,.16,.13], 'string', 'Fill');

% Add button to reset trail
resettrail = uicontrol(gtrackfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.3,.05,.4,.05], 'string', 'Reset Trail');

% Add buttons to set rv based on COE and COE based on rv
COE2rvbutton = uicontrol(inputfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.3,.3,.4,.1], 'string', 'Use COE');
rv2COEbutton = uicontrol(inputfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.3,.17,.4,.1], 'string', 'Use rv');
set(COE2rvbutton, 'callback', {@coe2rvcallback, COEbox, RVbox})
set(rv2COEbutton, 'callback', {@rv2coecallback, COEbox, RVbox})

% Add button to pause simulation
pausebutton = uicontrol(gtrackfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.4,.85,.06,.08]);

% Add button to increase simulation speed
speedupbutton = uicontrol(gtrackfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.5,.85,.06,.08]);

% Add button to decrease simulation speed
slowdownbutton = uicontrol(gtrackfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.3,.85,.06,.08]);

% Add check box for J2
J2box = uicontrol(gtrackfig, 'style', 'checkbox', 'units', 'normalized', 'position', [.8,.85,.15,.08], 'string', 'J2');

end

function coe2rvcallback(hObject, Eventdata, COEbox, RVbox)

a = str2num(get(COEbox(1), 'string')); % Ignore MATLAB yelling at these.
e = str2num(get(COEbox(2), 'string')); % str2num is used because these can be floats.
inc = str2num(get(COEbox(3), 'string'));
ap = str2num(get(COEbox(4), 'string'));
raan = str2num(get(COEbox(5), 'string'));
f = str2num(get(COEbox(6), 'string'));

% Validate input from COE boxes here

% Convert and fill

end

function rv2coecallback(hObject, Eventdata, COEbox, RVbox)

r = [str2num(get(RVbox(1), 'string')),str2num(get(RVbox(2), 'string')),str2num(get(RVbox(3), 'string'))];
v = [str2num(get(RVbox(4), 'string')),str2num(get(RVbox(5), 'string')),str2num(get(RVbox(6), 'string'))];

% Validate input from RV boxes here

% Convert and fill
COE = rv2coe(398600, r, v);

for i = 1:6
    set(COEbox(i), 'string', sprintf('%f', COE(i)))
end

end