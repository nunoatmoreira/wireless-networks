[y,x] = pol2cart(0.00072,7000e3);

distance_2d(initialPosition, [y x])

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