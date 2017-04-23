figh = figure();

Earth3D(figh);

r = [7000 0 0];
v = [0 6 6];

mue = 398600;
opts = odeset('MaxStep',10);
orbit = ode45(@(t,s)([s(4) s(5) s(6) (-mue/norm([s(1) s(2) s(3)])^3*[s(1) s(2) s(3)])]'),[0 80000],[r v]',opts);
orbit_handle = findobj('Tag','EarthOrbit');
addpoints(orbit_handle,orbit.y(1,:)*1000,orbit.y(2,:)*1000,orbit.y(3,:)*1000);