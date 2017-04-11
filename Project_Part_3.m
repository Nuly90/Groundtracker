% AE 313 Project Part 3
clear all, clc

lat=input('Enter Latitude:');
long=input('Enter Longitude:');
gst=input('Enter gst:');

rx=input('Enter X Component of Position Vector(Rx):');
ry=input('Enter Y Component of Position Vector(Ry):');
rz=input('Enter Z Component of Position Vector(Rz):');

r_ijk=[rx ry rz]

Re=6378; %km

r_site=Re*[cos(lat)*cos(long+gst) cos(lat)*sin(long+gst) sin(lat)]
position_vector_ijk=(r_ijk-r_site)'

%Transformation Matrix
K=[0 0 1];
Z=r_site/(r_site(1)^2+r_site(2)^2+r_site(3)^2)^.5
E=cross(K,Z)
S=cross(E,Z)

Mijk_to_sez=[S; E; Z]

Position_vector_SEZ=Mijk_to_sez*position_vector_ijk

position_vector_mag=(Position_vector_SEZ(1)^2+Position_vector_SEZ(2)^2+Position_vector_SEZ(3)^2)^.5

%Calculate Elevation and Azimuth
El=asin(Position_vector_SEZ(3)/position_vector_mag)
Az=acos(-Position_vector_SEZ(1)/position_vector_mag*cos(El))

if sin(Az)< 0
    Az=360-Az
end

