%% example_line_intersect
% demonstrate usage of line_intersect
close all
clear
clc

%% Create lines
% first the 'a' set, we'll use a set of parallel lines
n = 10;
xa = [0; 1] - linspace(-0.5, 0.5, n);
ya = [0; 1] + linspace(-0.5, 0.5, n);

% now the 'b' set, random segments
rng("default"); % want a repeatable result
xb = (rand(2, n) - 0.5)*2;
yb = (rand(2, n) - 0.5)*2;

tic
[xi, yi] = line_intersect(xa, ya, xb, yb);
toc

if n > 1000
    return;
end

figure; 
ha = axes; hold on;
xlabel("x"); ylabel("y");
title("Example: line_intersect", Interpreter="none");
h1 = plot(xa, ya, "-", DisplayName="Set `a`", Color=ha.ColorOrder(1, :));
h2 = plot(xb, yb, "-", DisplayName="Set `b`", Color=ha.ColorOrder(2, :));
h3 = plot(xi, yi, "o", DisplayName="Intersections", Color=ha.ColorOrder(3, :), MarkerFaceColor=ha.Color);
legend([h1(1), h2(1), h3(1)], Location="best");