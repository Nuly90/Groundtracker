function Result = COEadv(COE, Greenwich, step, J2)

% Orbit Advancing Tool
% Written by Jason Koch
%
% Inputs should be a vector containing the orbit's Classical Orbital
% Elements in the order of [Semi-Major Axis, Eccentricity, Inclination, AP,
% RAAN, True Anomaly (Degrees)], the Greenwich Hour Angle, the desired time
% step, and a 1 or 0 to toggle J2 perturbation.
%
% This program outputs the new COE and Greenwich Hour Angle.


% Set constants
mue = 398600; % Earth's gravitational parameter (km^3/s^2)
j2 = 0.00108263;
Earthspin = 2 * pi() / 86164; % Angular velocity of Earth (Rad/s)
dtr = pi() / 180; % Conversion factor between degrees and radians
Earthrad = 6378; % Radius of Earth (km)

% Split COE for legibility (See doc for full names)
a = COE(1);
e = COE(2);
i = COE(3);
ap = COE(4);
raan = COE(5);
f = COE(6);

% Calculate mean motion (Rad/s)
n = sqrt(mue/(a^3));

% Calculate mean anomaly
E = 2 * atand(sqrt((1-e)/(1+e))*tand(f/2));
M = E - e*sind(E);

% Calculate new true anomaly
M = M + n / dtr * step;
E = MtoE(M, e);
f = 2 * atand(sqrt((1+e)/(1-e))*tand(E/2));

% Calculate new Greenwich Hour Angle
Greenwich = Greenwich + Earthspin * step / dtr;

% Calculate change in AP and RAAN if J2 is toggled
if J2
    P = a * (1 - e^2); % Semi-Latus Rectum (km)
    apdot = (1.5*n*j2*Earthrad^2/P^2) * (4 - 5*(sind(i)^2));
    raandot = (1.5*n*j2*Earthrad^2/P^2) * cosd(i);
    ap = ap + apdot * step;
    raan = raan + raandot * step;
end

% Return values
COE = [a, e, i, ap, raan, f];
Result = [COE, Greenwich];

end