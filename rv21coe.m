function coe = rv21coe(s) % Title changed to avoid confusion with my own version

%% Transformation of the radius and velocity vector to classical orbital elements
% elements

%   AE313 Dr. Karl H. Siebold 
%   ERAU Daytona Beach, Florida 
%   Class code for rv to coe conversion

r = [s(1) s(2) s(3)];           % [km]       Radius vector
v = [s(4) s(5) s(6)];           % [km/s]     Velocity vector
h = cross(r,v);                 % [km^2/s]   Angular momentum vector

rmag  = norm(r);                % [km]       Radius
vmag  = norm(v);                % [km/s]     Velocity            
hmag  = norm(h);                % [km^2/s]   Angular momentum

mueEarth = 398600.0;            % [km^3/s^2] Earth gravitaltional parameter 

%% semi major axis
NRG = vmag^2/2 -mueEarth/rmag;  % Energy of the orbit
a   = - mueEarth/2/NRG;         

%% eccentricity
e    = (cross(v,h) - mueEarth*r/rmag)/mueEarth; % [1] Eccentricity vector 
emag = norm(e);                             % [1] Eccentricity

%% inclination
inc = acos(h(3)/hmag);

%% right ascension of the ascending node
I = [1 0 0];       % I-Earth Centered Inertial
K = [0 0 1];       % K-Earth Centered Inertial
n = cross(K,h);

raan = acos(dot(I,n)/norm(n));
if n(2) < 0
    raan = 2*pi-raan;   %  If J-component of node vector is negative raan > 180 deg
end

%% argument of perigee
ap = acos(dot(e,n)/norm(n)/emag);
if e(3) < 0
    ap = 2*pi - ap;     %  If K-component of eccentricity vector is negative ap > 180 deg
end

rtd = 180/pi; % Added by Jason Koch

%% true anomaly
theta = acos(dot(e,r)/emag/rmag);
if dot(r,v) < 0
    theta = 2*pi - theta; %  If angle between r and v is larger than 90 deg,  theta > 180 deg
end

coe = [a emag inc*rtd raan*rtd ap*rtd theta*rtd]; % Conversion by Jason Koch

% Deal with undefined quantities (Added by Jason Koch)
for i = 1:6
    if isnan(coe(i))
        coe(i) = 0;
    end
end
end


