function circle_propagation(Length, width,xPos,yPos, spldB,absorb,tmax,nPoints)
    % line_propagation simulates the 1D propagation of sound waves along a line
    %   line_propagation(Length, drivingFrequency, sourcePosition, spldB)
    %
    %   Inputs:
    %       Length          - Length of the room (in meters)
    %       width           - Width of the room (in meters)
    %       xPos  - Source position
    %       spldB           - Sound pressure level (in dB SPL) at 1 meter
    %       abs             - Absorption coefficient
    %       tmax            - Length of animation (time)
    %       nPoints         - Number of points to model
    %
    %   Outputs:
    %       None
    %

    % Constants
    c = 343; % Speed of sound in air (m/s)
    dt = tmax/100; % Time step based on Courant condition
    Dx = c*dt; % Spatial step size (meters)
    pref = 20*10^(-6);
    reflection =  1-absorb;
    [x0,y0] = generate_circle(nPoints);
    x0 = x0+xPos;
    y0 = y0+yPos;
    start = [xPos,yPos];
    % Time vector
    t = 0:dt:tmax;
    % Create figure
    figure;
    xlabel('X Position');
    ylabel('Y Position');
    hold on;
    reflected = zeros(length(x0));
    num_ref = zeros(length(x0));
    x=x0;
    y=y0;
    ref_dir = zeros(length(x0),2);
    plot([0, Length], [width, width], 'k'); % Top boundary
    plot([0, Length], [0, 0], 'k'); % Bottom boundary
    plot([0, 0], [0, width], 'k'); % Left boundary
    plot([Length, Length], [0, width], 'k'); % Right boundary
    % Main simulation loop
    for i = 1:length(t)
        dx = Dx;
        % Current time
        ti = t(i);
        
        % Calculate the distance from the source to all points along the line
       
        for j=1:length(x0)
            if num_ref(j)>1
                continue
            end
            if ~reflected(j)
                [x(j),y(j)] = increment_point(xPos,yPos,.5,x(j),y(j),dx);
            end
            if reflected(j)
                x(j) = x(j)+dx*ref_dir(j,1);
                y(j) = y(j)+dx*ref_dir(j,2);
            end
            if x(j)>=Length || x(j)<=0
                reflected(j) = 1;
                ref_dir(j,1:2)= unit_vec(start,[x(j),y(j)]);
                ref_dir(j,1)= -ref_dir(j,1);
                num_ref(j)=num_ref(j)+1;
            end
            if y(j)>=width || y(j)<=0
                reflected(j) = 1;
                ref_dir(j,1:2)= unit_vec(start,[x(j),y(j)]);
                ref_dir(j,2)= -ref_dir(j,2);
                num_ref(j)=num_ref(j)+1;
            end
            if num_ref(j)>1
                x(j)=Length+50;
                y(j)=width+50;
            
            end
            r = Dx*i;
            % Adjust SPL for the current propagation distance (inverse square law)
            spl = spldB - 20 * log10(r/1);
            if reflected(j)
                p = pref*10^(spl/20);
                p = reflection*p;
                spl = 20*log10(p/pref);
            end
            for k = 1:length(t)
                if spl >= 100
                    color = [1, 0, 0]; % Red for SPL >= 100 dB
                elseif spl >= 90
                    color = [1, 0.5, 0]; % Orange for 90 <= SPL < 100 dB
                elseif spl >= 80
                    color = [.9, .9, .1]; % Yellow for 80 <= SPL < 90 dB
                elseif spl >= 70
                    color = [0, 1, 0]; % Green for 70 <= SPL < 80 dB
                elseif spl >= 60
                    color = [0, 1, 1]; % Light blue for 60 <= SPL < 70 dB
                else
                    color = [0, 0, 1]; % Dark blue for SPL < 60 dB
                end
            end
        end
        % Plot the SPL along the line
        scatter(x, y,'MarkerFaceColor', color);
        
        % Update plot properties
        title(['Sound Propagation at t = ', num2str(ti, '%.3f'), ' seconds']);
        xlim([0 max(width,Length)]);
        ylim([0 max(width,Length)]);
        drawnow; % Update the figure window
        
        pause(0.01);
        cla
        
        % Clear figure for next frame
        if i < length(t)
            cla;
            xlabel('Distance (m)');
            
            ylabel('Y Position');
            plot([0, Length], [width, width], 'k'); % Top boundary
            plot([0, Length], [0, 0], 'k'); % Bottom boundary
            plot([0, 0], [0, width], 'k'); % Left boundary
            plot([Length, Length], [0, width], 'k'); % Right boundary
            hold on;
        end
    end
end
