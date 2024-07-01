function [x,y] = increment_point(xcenter, ycenter, radius, xstart, ystart, incrementDistance)
    % increment_point increments a point on a circle by a distance normal to its surface
    %
    %   Inputs:
    %       xcenter, ycenter - Center coordinates of the circle
    %       radius - Radius of the circle
    %       xstart, ystart - Coordinates of the starting point on the circle
    %       incrementDistance - Distance to increment along the normal direction
    %
    %   Output:
    %       x, y - Coordinates of the new point after incrementing
    
    % Vector from center to start point
    vec_start = [xstart - xcenter, ystart - ycenter];
    
    % Calculate unit normal vector (outward direction)
    normalVec = vec_start / norm(vec_start);
    
    % Incremented point along the normal direction
    x = xstart + incrementDistance * normalVec(1);
    y = ystart + incrementDistance * normalVec(2);
end
