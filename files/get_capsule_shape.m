function cap = get_capsule_shape(p,R,radius,height,res)
%
% Get followin information
%
% cap.vertices = vertices;
% cap.faces = faces;
% cap.p = p;
% cap.R = R;
% cap.radius = radius;
% cap.height = height;
%

if nargin == 4
    res = 30;
end

X = cos(0:2*pi/res:2*pi);
Y = sin(0:2*pi/res:2*pi);
side_faces = zeros(3,4*res);
for i=1:res
    side_faces(:,(i-1)*4+1:i*4) = ...
        [radius*X(i:i+1) radius*X(i+1:-1:i); ...
        radius*Y(i:i+1) radius*Y(i+1:-1:i); ...
        height/2, height/2, -height/2, -height/2];
end
side_faces_rot = reshape(p,[3,1])*ones(1,4*res) + R*side_faces;
sides_X = reshape(side_faces_rot(1,:),[4,res]);
sides_Y = reshape(side_faces_rot(2,:),[4,res]);
sides_Z = reshape(side_faces_rot(3,:),[4,res]);
% Sphere parts
% upper half
res_half = round(res/2);
theta = 0:pi/res_half:2*pi;
phi = -pi/2:pi/res_half:pi/2;
c_th = cos(theta);
s_th = sin(theta);
c_phi = cos(phi);
s_phi = sin(phi);
x1 = radius*c_th(1:2*res_half);
x2 = radius*c_th(2:2*res_half+1);
y1 = radius*s_th(1:2*res_half);
y2 = radius*s_th(2:2*res_half+1);
faces = zeros(3,8*res_half*res_half);
for i=1:res_half
    z1 = radius*c_phi(i)*ones(1,2*res_half) + height/2;
    z2 = radius*c_phi(i+1)*ones(1,2*res_half) + height/2;
    faces(:,(i-1)*8*res_half+1:4:i*8*res_half) = [x1*s_phi(i);y1*s_phi(i);z1];
    faces(:,(i-1)*8*res_half+2:4:i*8*res_half) = [x2*s_phi(i);y2*s_phi(i);z1];
    faces(:,(i-1)*8*res_half+3:4:i*8*res_half) = [x2*s_phi(i+1);y2*s_phi(i+1);z2];
    faces(:,(i-1)*8*res_half+4:4:i*8*res_half) = [x1*s_phi(i+1);y1*s_phi(i+1);z2];
end
faces = reshape(p,[3,1])*ones(1,8*res_half*res_half) + R*faces;
faces_X1 = reshape(faces(1,:),[4 2*res_half*res_half]);
faces_Y1 = reshape(faces(2,:),[4 2*res_half*res_half]);
faces_Z1 = reshape(faces(3,:),[4 2*res_half*res_half]);

% lower half
theta = 0:pi/res_half:2*pi;
phi = -pi/2:-pi/res_half:-3*pi/2;
c_th = cos(theta);
s_th = sin(theta);
c_phi = cos(phi);
s_phi = sin(phi);
x1 = radius*c_th(1:2*res_half);
x2 = radius*c_th(2:2*res_half+1);
y1 = radius*s_th(1:2*res_half);
y2 = radius*s_th(2:2*res_half+1);
faces = zeros(3,8*res_half*res_half);
for i=1:res_half
    z1 = radius*c_phi(i)*ones(1,2*res_half) - height/2;
    z2 = radius*c_phi(i+1)*ones(1,2*res_half) - height/2;
    faces(:,(i-1)*8*res_half+1:4:i*8*res_half) = [x1*s_phi(i);y1*s_phi(i);z1];
    faces(:,(i-1)*8*res_half+2:4:i*8*res_half) = [x2*s_phi(i);y2*s_phi(i);z1];
    faces(:,(i-1)*8*res_half+3:4:i*8*res_half) = [x2*s_phi(i+1);y2*s_phi(i+1);z2];
    faces(:,(i-1)*8*res_half+4:4:i*8*res_half) = [x1*s_phi(i+1);y1*s_phi(i+1);z2];
end
faces = reshape(p,[3,1])*ones(1,8*res_half*res_half) + R*faces;
faces_X2 = reshape(faces(1,:),[4 2*res_half*res_half]);
faces_Y2 = reshape(faces(2,:),[4 2*res_half*res_half]);
faces_Z2 = reshape(faces(3,:),[4 2*res_half*res_half]);

% cap.sides_X = sides_X;
% cap.sides_Y = sides_Y;
% cap.sides_Z = sides_Z;
% cap.faces_X1 = faces_X1;
% cap.faces_Y1 = faces_Y1;
% cap.faces_Z1 = faces_Z1;
% cap.faces_X2 = faces_X2;
% cap.faces_Y2 = faces_Y2;
% cap.faces_Z2 = faces_Z2;

h = figure(100); % open an auxilarly figure
h1 = patch(sides_X,sides_Y,sides_Z,1,'Visible','off');
h2 = patch(faces_X1,faces_Y1,faces_Z1,1,'Visible','off');
h3 = patch(faces_X2,faces_Y2,faces_Z2,1,'Visible','off');
pointsA = h1.Vertices;
pointsB = h2.Vertices;
pointsC = h3.Vertices;
% get face lists
facesA = h1.Faces;
facesB = h2.Faces;
facesC = h3.Faces;
close(h); % and close

% update vertices list
V = vertcat(pointsA, pointsB, pointsC);

% update the face list
faceUpdate1 = facesB+max(max(facesA));
faceUpdate2 = facesC+max(max(facesA))+max(max(facesB));
F = vertcat(facesA, faceUpdate1, faceUpdate2);

% remove duplicate vertices
[vertices, faces]= patchslim(V, F);
cap.vertices = vertices;
cap.faces = faces;

% parse more infos
cap.p = p;
cap.R = R;
cap.radius = radius;
cap.height = height;

end