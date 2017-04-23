%% Read in map image and create an Earth's map
[flat_map,color_map] = imread('LE640.gif');
figure_handle = figure('Color','black','Position',[200 100 1040 560],'NumberTitle','off','Name','Orbit View Window');
axes_handle = axes;
colormap(color_map);
set(axes_handle,'XTick',-180:30:180,'XLim',[-180 180],'Ytick',-90:30:90,'YLim',[-90 90],'Layer','top','Color','black','XColor','w','YColor','w')
hold on
earth_proj = image([-180 180],[90 -90],flat_map);
grid;
%% Empty orbit data points
orbit1_handle    = animatedline('LineStyle','none','Marker','.','Color','red');

%%            START OF GROUNDTRACK PROJECT    
dtr = pi/180;              % Degrees to Radians
Re  = 6378.14;             % [km] Earth Radius
omega_earth = 2*pi/86164;  % [rad/s] Siderial Rotation Rate of the Earth
mue = 398600;              % [km^3/s^2] Earth's Gravitational Parameter


%% Observer
loc_long = 11.5820*dtr;   % [rad] Longitude
loc_lat  = 48.1351*dtr;   % [rad] Latitude

location         = plot(loc_long/dtr,loc_lat/dtr,'LineStyle','none','Marker','+','Color',[1 1 1]);
location_name    = text(loc_long/dtr,loc_lat/dtr,'  Munich',...
                        'FontSize',11,'FontWeight','bold',...
                        'Color',[1 1 1],...
                        'horizontalalignment','left',...
                        'handlevisibility','off');

% Set up propagation times
t_end   = 200000;                 % [s] Propagation time
t_step  = 60;                    % [s] Time step
t_start = 0.0;                   % [s] Start time

% Orbit & Earth data
sma = 30000;                % [km]  Semi Major Axis
inc = 63*dtr;              % [rad] Inclination
e   = 0.72;                % [1]   Eccentricity
omega = -80*dtr;            % [rad] Raan
w =  270*dtr;               % [rad] Argument of perigee
f0 = 0*dtr;               % [rad] Initial True Anomaly

gamma_0= 0.0;              % [rad] Initial Greenwich Angle

%INITIAL ANOMALIES
% [rad] Initial Eccentric Anomaly
% [rad] Initial Mean Anomaly (you need to update this one....)

% [rad/s] Mean Motion

    
    
    
    
    
%% Orbit Update (Kepler's problem)    
% Mean anomaly
% Put Mean Anomaly between 0 and 2*pi
% Iterate the eccentric anomaly (Kepler's problem)
% True anomaly (between -180<->+180)
    
%%  PQW 
%  Radius vector magnitude   
%  PQW coordinates  
%  Find the pqw_to_ijk transformation (Matrix)
%  Transformation of r from PQW to IJK

%% Earth's Position                          
% Update the Earth's Position

% IJK (ECI)  to XYZ (ECEF) transformation

% Transform into XYZ coordinates

%Latitude(ii)  Longitude(ii)

       

%% Output
   
addpoints(orbit1_handle,[-90:2:-70],[30:2:50]); % Add Long/Lat Poionts to the graph
