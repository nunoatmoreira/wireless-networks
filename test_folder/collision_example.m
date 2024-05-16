
earthRadius = 6371e3; % radius of Earth in meters
satelliteRadius = 200e3; % radius of satellite in meters (for visualization)

initialPosition = [7000e3; 0]; % initial position in meters from Earth's center
initialVelocity = [0; 7.545946840144430e3]; % initial velocity in meters per second


% Initial conditions
initialConditions = [initialPosition; initialVelocity];

% Time span
tspan = [0:0.1:5.8286e+03]; % simulate for one day

% Solve the system of differential equations
[T, Y] = ode45(@(t, y) orbitalDynamics(t, y), tspan, initialConditions);

Y_MAX = 36;

% Plot the orbit in 3D
offset = 55;
fig1 = figure;
plot(Y(:,1), Y(:,2), 'r');
grid on;

hold on;
% Constants
radius_earth = 6371e3; % Radius of the Earth in meters

% Create a theta array for angles
theta = linspace(0, 2*pi, 1000);

% Calculate x and y coordinates of the circle
x = radius_earth * cos(theta);
y = radius_earth * sin(theta);

% Plot the circle
plot_1 = plot(x, y, 'b');
legend(["Satellite Orbit" "Earth"]);


radius = 100000;
pos_0 = [initialPosition(2)- radius, initialPosition(1)-radius, radius*2, radius*2];

[y_sat2,x_sat2] = pol2cart(pi/5,7000e3);
pos_2 = [x_sat2- radius, y_sat2-radius, radius*2, radius*2];

distance_2d(initialPosition, [y_sat2 x_sat2])

rect = rectangle( 'Position',pos_0,...
                  'curvature',[1,1],...
                  'lineWidth',1 );
rect = rectangle( 'Position',pos_2,...
                  'curvature',[1,1],...
                  'lineWidth',1 );


line([initialPosition(2) x_sat2], [initialPosition(1) y_sat2]);
title('Max distance without Earth surface interference');

% Function to compute the derivatives
function dydt = orbitalDynamics(t, y)
    % Constants
G = 6.67430e-11; % gravitational constant in m^3 kg^-1 s^-2
M = 5.972e24; % mass of Earth in kg

    r = sqrt(y(1)^2 + y(2)^2);
    dydt = zeros(4,1);
    dydt(1) = y(3);
    dydt(2) = y(4);
    dydt(3) = -G * M * y(1) / r^3;
    dydt(4) = -G * M * y(2) / r^3;
end

function dist = distance_2d(point1, point2)
    % point1 and point2 are 2-element vectors representing the (x, y) coordinates of the points
    
    % Extract x and y coordinates of the points
    x1 = point1(1);
    y1 = point1(2);
    x2 = point2(1);
    y2 = point2(2);
    
    % Calculate the Euclidean distance between the points
    dist = sqrt((x2 - x1)^2 + (y2 - y1)^2);
end
