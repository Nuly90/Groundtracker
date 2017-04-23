function orbit_handle = Earth3D(fig_h)

%% Textured 3D Earth example
%
% Ryan Gray
% 8 Sep 2004
% Revised 9 March 2006, 31 Jan 2006, 16 Oct 2013
% Downloaded from Mathworks File share &
% modified here and there by Karl H Siebold 30 June 2016
% modified here and there by Jason S. Koch 19 April 2017




space_color = 'k';
set(fig_h, 'Color', space_color,'Tag','Earth_IJK');
IJK_frame = axes(fig_h);
set(IJK_frame,'Tag','IJK_axis')

%% Options

npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
alpha   = 1; % globe transparency level, 1 = opaque, through 0 = invisible

GMST0 = 0.0;   % Set up a rotatable globe at J2000.0

% Earth texture image
% Anything imread() will handle, but needs to be a 2:1 unprojected globe
% image.

image_file = '1024px-Land_ocean_ice_2048.jpg';

% Mean spherical earth

erad    = 6371008.7714; % equatorial radius (meters)
prad    = 6371008.7714; % polar radius (meters)
erot    = 7.2921158553e-5; % earth rotation rate (radians/sec)

% Turn off the normal axes

set(IJK_frame, 'NextPlot','add', 'Visible','off');

axis equal;
axis auto;
axis vis3d;

% Set initial view

view(0,30);

%% Create wireframe globe

% Create a 3D meshgrid of the sphere points using the ellipsoid function

[x, y, z] = ellipsoid(IJK_frame, 0, 0, 0, erad, erad, prad, npanels);

globe = surf(IJK_frame, x, y, -z, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);

if ~isempty(GMST0)
    hgx = hgtransform(IJK_frame, 'Tag','NorthPole');
    set(hgx,'Matrix', makehgtform('zrotate',GMST0));
    set(globe,'Parent',hgx);
end

%% Texturemap the globe

% Load Earth image for texture map

cdata = imread(image_file);

% Set image as color data (cdata) property, and set face color to indicate
% a texturemap, which Matlab expects to be in cdata. Turn off the mesh edges.

set(globe, 'FaceColor', 'texturemap', 'CData', cdata, 'FaceAlpha', alpha, 'EdgeColor', 'none');

axis auto;



orbit_handle = animatedline(IJK_frame, 'LineStyle','none','Marker','.','Color','red','Tag','EarthOrbit','MaximumNumPoints',100000);


end