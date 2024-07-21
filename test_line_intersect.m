% test line segment intersection
% runtests('test_line_intersect')
ABSTOL = 1e-10;
assert_tol = @(x, y) assert(all(abs(x-y)<ABSTOL));


%% Test 1: Lines crossing at 45 deg angle
xa = [0, 1];
ya = [0, 1];
xb = [0, 1];
yb = [1, 0];
[xi, yi] = line_intersect(xa, ya, xb, yb);
assert_tol(xi, 0.5);
assert_tol(yi, 0.5);

%% Test 2: One vertical line
xa = [0, 1];
ya = [0.5, 0.5];
xb = [0.5, 0.5];
yb = [1, 0];
[xi, yi] = line_intersect(xa, ya, xb, yb);
assert_tol(xi, 0.5);
assert_tol(yi, 0.5);

%% Test 3: Parallel lines
xa = [0, 1];
ya = [0, 1];
xb = xa+0.1;
yb = ya+0.1;
[xi, yi] = line_intersect(xa, ya, xb, yb);
assert(isnan(xi));
assert(isnan(yi));

%% Test 4: Identical lines
xa = [0, 1];
ya = [0, 1];
xb = xa;
yb = ya;
[xi, yi] = line_intersect(xa, ya, xb, yb);
assert(isnan(xi));
assert(isnan(yi));

%% Test 4.1: Colinear segments
xa = [0, 1];
ya = [0, 1];
xb = [0.5, 1];
yb = [0.5, 1];
[xi, yi] = line_intersect(xa, ya, xb, yb);
assert(isnan(xi));
assert(isnan(yi));


%% Test 5: Multiple lines for set B
xa = [0, 1];
ya = [0, 1];
xb = [0.0, 0.0, 0.5, 0.0; ...
      1.0, 1.0, 0.5, 1.0];
yb = [1.0, 0.5, 0.0, 1.0; ... 
      0.0, 0.5, 1.0, 2.0];
[xi, yi] = line_intersect(xa, ya, xb, yb);
assert_tol(xi(1:3), [0.5, 0.5, 0.5]);
assert_tol(yi(1:3), [0.5, 0.5, 0.5]);
assert(isnan(xi(4)));
assert(isnan(yi(4)));

%% Test 6: Multiple lines for set A
xb = [0, 1];
yb = [0, 1];
xa = [0.0, 0.0, 0.5, 0.0; ...
      1.0, 1.0, 0.5, 1.0];
ya = [1.0, 0.5, 0.0, 1.0; ... 
      0.0, 0.5, 1.0, 2.0];
[xi, yi] = line_intersect(xa, ya, xb, yb);
assert_tol(xi(1:3), [0.5; 0.5; 0.5]);
assert_tol(yi(1:3), [0.5; 0.5; 0.5]);
assert(isnan(xi(4)));
assert(isnan(yi(4)));
