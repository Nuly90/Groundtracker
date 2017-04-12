% AE 313 Project Part 3
% Written by Mark Foreman
% Modifications by Jason Koch

function azel = r2azel(lat,long,gst,r_ijk)

Re=6378; %km

r_site=Re*[cos(lat)*cos(long+gst) cos(lat)*sin(long+gst) sin(lat)];
position_vector_ijk=(r_ijk-r_site)';

%Transformation Matrix
K=[0 0 1];
Z=r_site/(r_site(1)^2+r_site(2)^2+r_site(3)^2)^.5;
E=cross(K,Z);
S=cross(E,Z);

Mijk_to_sez=[S; E; Z];

Position_vector_SEZ=Mijk_to_sez*position_vector_ijk;

position_vector_mag=norm(Position_vector);

%Calculate Elevation and Azimuth
El=asin(Position_vector_SEZ(3)/position_vector_mag);
Az=acos(-Position_vector_SEZ(1)/position_vector_mag*cos(El));

if sin(Az)< 0
    Az=360-Az;
end

azel = [Az, El];

end