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

% Add 3d Earth
orbit3d = Earth3D(orbit3dfig);

gtrackfig = figure('position', [600,450,500,350], 'menubar', 'none');
set(gtrackfig, 'numbertitle', 'off', 'Name', 'MATLAB Groundtracker')
azelfig = figure('position', [200,100,300,300], 'menubar', 'none');
set(azelfig, 'numbertitle', 'off', 'Name', 'MATLAB Groundtracker')

% Add an axes for the ground track and an axes for the azimuth/elevation
gtrack = axes(gtrackfig, 'units', 'normalized', 'position', [.1,.2,.8,.6]);
set(gtrack, 'xlim', [-180, 180], 'ylim', [-90, 90], 'xgrid', 'on', 'ygrid', 'on')
set(gtrack,'XTick',-180:30:180, 'Ytick',-90:30:90, 'Layer','top','Color','black','gridcolor','w')
azel = azelaxes(azelfig, [.15,.3,.7,.6]);
azelline = animatedline(azel,'LineStyle','none','Marker','.','Color','red');

% Add background for ground track
[flat_map,color_map] = imread('LE640.gif');
colormap(gtrack, color_map)
hold(gtrack, 'on')
earth_proj = image(gtrack,[-180 180],[90 -90],flat_map);
trackhandle = animatedline(gtrack,'LineStyle','none','Marker','.','Color','red');
stationmark = animatedline(gtrack,'LineStyle','none','Marker','+','Color','white');

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
gwbox = uicontrol(inputfig, 'style', 'edit', 'units', 'normalized', 'position', [.55,.07,.2,.07], 'string', '0');
uicontrol(inputfig, 'style', 'text', 'units', 'normalized', 'position', [.19,.07,.35,.07], 'string', 'Greenwich Hour Angle', 'horizontalalignment', 'right');

% Add text boxes for lat/long of observing station
latbox = uicontrol(azelfig, 'style', 'text', 'units', 'normalized', 'position', [.75,.12,.2,.07]);
longbox = uicontrol(azelfig, 'style', 'text', 'units', 'normalized', 'position', [.75,.04,.2,.07]);
uicontrol(azelfig, 'style', 'text', 'units', 'normalized', 'position', [.55,.12,.19,.07], 'string', 'Latitude', 'horizontalalignment', 'right');
uicontrol(azelfig, 'style', 'text', 'units', 'normalized', 'position', [.55,.04,.19,.07], 'string', 'Longitude', 'horizontalalignment', 'right');

% Add drop-down menu for common stations
stations = {'Munich', 'Daytona Beach', 'Jackpot, NV'};
uicontrol(azelfig, 'style', 'text', 'units', 'normalized', 'position', [.05,.12,.3,.07], 'string', 'Observing Station');
stationbox = uicontrol(azelfig, 'style', 'popupmenu', 'units', 'normalized', 'position', [.05,.04,.3,.07], 'string', stations);

% Add button to set lat/long from selected station
fillstation = uicontrol(azelfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.37,.05,.16,.13], 'string', 'Fill');
set(fillstation, 'callback', {@fillstationcb, stationbox, latbox, longbox, stationmark})
fillstationcb(1,1, stationbox, latbox, longbox, stationmark)

% Add button to reset trail
resettrail = uicontrol(gtrackfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.3,.05,.4,.05], 'string', 'Reset Trail');
set(resettrail, 'callback', {@resettrailcb, trackhandle, orbit3d, azelline})

% Add button to pause simulation
pausebutton = uicontrol(gtrackfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.4,.85,.06,.08]);
pausepic = imread('Pause.png');
pausepic = imresize(pausepic, [25,20]);
set(pausebutton, 'userdata', 0, 'callback', {@pausecb, gtrack}, 'cdata', pausepic, 'backgroundcolor', [0,0,0])

% Add button to increase simulation speed
speedupbutton = uicontrol(gtrackfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.5,.85,.06,.08]);
forwardpic = imread('Forward.png');
forwardpic = imresize(forwardpic, [25,20]);
set(speedupbutton, 'callback', {@speedcb, pausebutton}, 'cdata', forwardpic, 'backgroundcolor', [0,0,0])

% Add button to decrease simulation speed
slowdownbutton = uicontrol(gtrackfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.3,.85,.06,.08]);
revpic = imread('Backward.png');
revpic = imresize(revpic, [25,20]);
set(slowdownbutton, 'callback', {@slowcb, pausebutton}, 'cdata', revpic, 'backgroundcolor', [0,0,0])

% Add check box for J2
J2box = uicontrol(gtrackfig, 'style', 'checkbox', 'units', 'normalized', 'position', [.8,.85,.15,.08], 'string', 'J2');

% Add buttons to set rv based on COE and COE based on rv
COE2rvbutton = uicontrol(inputfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.3,.3,.4,.1], 'string', 'Use COE');
rv2COEbutton = uicontrol(inputfig, 'style', 'pushbutton', 'units', 'normalized', 'position', [.3,.17,.4,.1], 'string', 'Use rv');
set(COE2rvbutton, 'callback', {@coe2rvcallback, COEbox, RVbox, pausebutton, gwbox, J2box, gtrack, trackhandle, orbit3d, azelline, latbox, longbox})
set(rv2COEbutton, 'callback', {@rv2coecallback, COEbox, RVbox, pausebutton, gwbox, J2box, gtrack, trackhandle, orbit3d, azelline, latbox, longbox})

end

function fillstationcb(hObject, Eventdata, stationbox, latbox, longbox, stationmark)
stationcoords = [48.1351, 11.5820; 29.2108, -81.0228; 41.9841, -114.6724];
station = get(stationbox, 'value');
set(latbox, 'string', sprintf('%.4f',stationcoords(station, 1)))
set(longbox, 'string', sprintf('%.4f',stationcoords(station, 2)))
clearpoints(stationmark)
addpoints(stationmark, stationcoords(station, 2), stationcoords(station, 1))

end

function resettrailcb(hObject, EventData, trackhandle, orbit3d, azelline)
clearpoints(trackhandle)
clearpoints(orbit3d)
clearpoints(azelline)
end

function pausecb(pbobj, eventdata, gtrack)
set(pbobj, 'userdata', 0)
set(gtrack, 'userdata', 0)
end

function speedcb(suobj, eventdata, pauseobj)
step = get(pauseobj, 'userdata');
set(pauseobj, 'userdata', step^1.1+10)
end

function slowcb(suobj, eventdata, pauseobj)
step = get(pauseobj, 'userdata');
set(pauseobj, 'userdata', (step-10)^(1/1.1))
end

function advancetime(COEbox, RVbox, pausebutton, COE, Greenwich, J2box, gtrack, gwbox, trackhandle, orbit3d, azelline, latbox, longbox)
run = 1;
M = -500;
while run
    timestep = get(pausebutton, 'userdata');
    if timestep ~= 0
        J2 = get(J2box, 'value');
        COEG = COEadv(COE, M, Greenwich, timestep, J2);
        COE = COEG(1:6);
        Greenwich = COEG(7);
        M = COEG(8);
        set(gwbox, 'string', sprintf('%.1f', Greenwich))
        
        for i = 1:6
            set(COEbox(i), 'string', sprintf('%.1f', COE(i)))
        end
        
        a = COE(1);
        e = COE(2);
        inc = COE(3);
        ap = COE(4);
        raan = COE(5);
        f = COE(6);
        
        % Convert and fill
        rpqw = a*(1-e^2)/(1+e*cosd(f));
        P = rpqw*cosd(f);
        Q = rpqw*sind(f);
        pqw = [P; Q; 0];
        T = pqw2ijk(raan, inc, ap);
        b = a*sqrt(1-e^2);
        
        if Q > 0
            vdir = [-1; (b/a)^2*(P+a*e)/sqrt(b^2-(b/a)^2*(P+a*e)^2); 0];
        else
            vdir = [1; (b/a)^2*(P+a*e)/sqrt(b^2-(b/a)^2*(P+a*e)^2); 0];
        end
        
        vdir = vdir/norm(vdir);
        for i = 1:3
            if isnan(vdir(i))
                vdir(i) = 1;
            end
        end
        vmag = sqrt(2*(398600/rpqw - 398600/(2*a)));
        vpqw = vmag*vdir;
        r = T*pqw;
        v = T*vpqw;
        rv = [r;v];
        for i = 1:3
            set(RVbox(i), 'string', sprintf('%.1f', rv(i)))
        end
        for i = 4:6
            set(RVbox(i), 'string', sprintf('%.3f', rv(i)))
        end
        
        % Calculate lat/long
        lat = asind(r(3)/norm(r));
        Tlong = [cosd(Greenwich),sind(Greenwich),0;-sind(Greenwich),cosd(Greenwich),0;0,0,1];
        rlong = Tlong*r;
        long = atan2d(rlong(2),rlong(1));
        
        % Calculate azimuth and elevation
        obslat = str2num(get(latbox, 'string'));
        obslong = str2num(get(longbox, 'string'));
        azandel = r2azel(obslat,obslong,Greenwich,r);
        az = azandel(1);
        el = azandel(2);
        azelx = (90-el)*sind(az);
        azely = (90-el)*cosd(az);
        
        % Plot
        addpoints(trackhandle,long,lat)
        addpoints(orbit3d, 1000*r(1), 1000*r(2), 1000*r(3))
        if el > 10
            addpoints(azelline, azelx, azely)
        end
        drawnow
        
    end
    
    pause(.1)
    
    run = get(gtrack, 'userdata');
end

end

function coe2rvcallback(hObject, Eventdata, COEbox, RVbox, pausebutton, gwbox, J2box, gtrack, trackhandle, orbit3d, azelline, latbox, longbox)

a = str2num(get(COEbox(1), 'string')); % Ignore MATLAB yelling at these.
e = str2num(get(COEbox(2), 'string')); % str2num is used because these can be floats.
inc = str2num(get(COEbox(3), 'string'));
ap = str2num(get(COEbox(4), 'string'));
raan = str2num(get(COEbox(5), 'string'));
f = str2num(get(COEbox(6), 'string'));

% Validate input from COE boxes here

if 2*pi*sqrt(a^3 / 398600) * 7.2921159*10^-5 < 0.3927
    warning('Warning: Orbit Semi Major Axis must be increased')
end
if ~isa(a,'numeric')
    warning('Warning: Semi Major axis must be a numeric value')
end
if e < 0
    warning('Warning: Eccentricity must be a valid input. (e must be greater than or equal to zero)')
end
if isa(e,'numeric') ~= 1
    warning('Warning: ccentricity must be a numeric value greater than or equal to zero')
end

% Convert and fill
rpqw = a*(1-e^2)/(1+e*cosd(f));
P = rpqw*cosd(f);
Q = rpqw*sind(f);
pqw = [P; Q; 0];
T = pqw2ijk(raan, inc, ap);
b = a*sqrt(1-e^2);

if Q > 0
    vdir = [-1; (b/a)^2*(P+a*e)/sqrt(abs(b^2-(b/a)^2*(P+a*e)^2)); 0]; % Matlab was experiencing truncation errors that broke it. abs fixes it.
else
    vdir = [1; (b/a)^2*(P+a*e)/sqrt(abs(b^2-(b/a)^2*(P+a*e)^2)); 0];
end

vdir = vdir/norm(vdir);
for i = 1:3
    if isnan(vdir(i))
        vdir(i) = 1;
    end
end
vmag = sqrt(2*(398600/rpqw - 398600/(2*a)));
vpqw = vmag*vdir;
r = T*pqw;
v = T*vpqw;
rv = [r;v];
for i = 1:3
    set(RVbox(i), 'string', sprintf('%.1f', rv(i)))
end
for i = 4:6
    set(RVbox(i), 'string', sprintf('%.3f', rv(i)))
end

% Set run condition to true
set(gtrack, 'userdata', 1)
COE = [a,e,inc,ap,raan,f];
Greenwich = str2num(get(gwbox, 'string'));
advancetime(COEbox, RVbox, pausebutton, COE, Greenwich, J2box, gtrack, gwbox, trackhandle, orbit3d, azelline, latbox, longbox)

end

function rv2coecallback(hObject, Eventdata, COEbox, RVbox, pausebutton, gwbox, J2box, gtrack, trackhandle, orbit3d, azelline, latbox, longbox)

r = [str2num(get(RVbox(1), 'string')),str2num(get(RVbox(2), 'string')),str2num(get(RVbox(3), 'string'))];
v = [str2num(get(RVbox(4), 'string')),str2num(get(RVbox(5), 'string')),str2num(get(RVbox(6), 'string'))];

% Validate input from RV boxes here
if abs(v) == 0
    warning('Warning: Orbit must originate with a non-zero velocity')
end
if isa(v,'numeric') ~= 1
    warning('Warning: velocity must be a numeric value greater than zero')
end
if abs(r) == 0
    warning('Warning: Orbit must originate with a non-zero radius greaer than 6538 km')
end
if isa(r,'numeric') ~= 1
    warning('Warning: radius must be a numeric value greater than zero')
end

% Convert and fill
COE = rv21coe([r, v]);

for i = 1:6
    set(COEbox(i), 'string', sprintf('%.1f', COE(i)))
end

% Set run condition to true
set(gtrack, 'userdata', 1)
Greenwich = str2num(get(gwbox, 'string'));
advancetime(COEbox, RVbox, pausebutton, COE, Greenwich, J2box, gtrack, gwbox, trackhandle, orbit3d, azelline, latbox, longbox)

end