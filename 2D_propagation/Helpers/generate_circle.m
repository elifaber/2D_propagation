function [x, y] = generate_circle(nPoints)
    % generate_circle_points generates points on a circle of radius 1
    %   [x, y] = generate_circle_points(nPoints)
    %
    %   Inputs:
    %       nPoints - Number of points to generate along the circle's circumference
    %
    %   Outputs:
    %       x, y - Arrays of x and y coordinates of the points on the circle
    
    % Radius of the circle
    radius =.5;
    
    % Generate nPoints equally spaced angles between 0 and 2*pi
    theta = linspace(0, 2*pi, nPoints);
    
    % Calculate the x and y coordinates of the points
    x = radius * cos(theta);
    y = radius * sin(theta);
end