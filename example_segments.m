%% example_segments
% demonstrate use of segments to find intersections with polyline
% In this example, we show two polylines.  But it could be used where only
% one set is a polyline.

% make our input curves
xa = linspace(0, 10, 101);
ya = sin(xa) + 0.5*xa;

xb = linspace(0, 12, 101);
yb = cos(2*xb) + 0.5*xb;

% find our intersections
[xv, yv] = line_intersect(segments(xa), segments(ya), ...
                          segments(xb), segments(yb));

% xv and yv are large matrices, but mostly nan.  might want to clean up
idx = ~isnan(xv(:));
xv1 = xv(idx);
yv1 = yv(idx);

% plot
figure;
axes;hold on;
xlabel("x"); ylabel("y");
title("Example: segments");
plot(xa, ya);
plot(xb, yb);
plot(xv1(:), yv1(:), "o")