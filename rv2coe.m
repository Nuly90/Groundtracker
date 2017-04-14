function coe = rv2coe(mue,r,v)

% Find important vectors and scalars
r2d = 180/pi;
vmag = norm(v);
rmag = norm(r);
energy = vmag^2 / 2 - mue / rmag;
a = -mue / 2 / energy;
h = cross(r, v);
evector = (cross(v, h) - mue * (r/rmag)) / mue;
e = norm(evector);
hmag = norm(h);
n = cross([0,0,1], h)/hmag;

% Find inclination, raan, and ap
inc = acos(h(3)/hmag);
raan = acos(n(1));
if n(2) < 0
    raan = 2*pi() - raan;
end

ap = acos(dot(evector,n)/e);
if evector(3) < 0
    ap = 2*pi() - ap;
end

% Find theta
theta = acos((((a * (1 - e^2)) / rmag) - 1) / e);
if dot(r, v) < 0
    theta = 2*pi() - theta;
end

% Return Classical Orbital Elements
coe = [a,e,inc*r2d,raan*r2d,ap*r2d,theta*r2d];

end