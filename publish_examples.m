function publish_examples(filename)
% publish_md create markdown with light/dark figures for github.
% careful, this script fiddles with graphics defaults and doesn't reset
% them.0

if nargin < 1
    allfiles = dir("*.mlx");
    try %#ok<TRYNC>
        % for whatever reason, the helvetica font gets changed when
        % printing to svg files.  Both of these seem to work fine.
        set(groot, "FixedWidthFontName", "Consolas");
        set(groot, "FixedWidthFontName", "Cascadia Code");
    end
    for i = 1:length(allfiles)
        fprintf("Publishing: %s to markdown\n", allfiles(i).name)
        publish_examples(allfiles(i).name);
    end
    return;
end

% create markdown file
mdname = export(filename, Format="markdown", ...
        IncludeOutputs=true, ...
        Run=true);

% remove images, we'll make our own
[~, fileNoExt, ~] = fileparts(filename);
fileNoExt = string(fileNoExt);
mediaDir = fileNoExt + "_media";
rmdir(mediaDir, "s");

% create m file
scriptname = "temp_example.m";
export(filename, scriptname, Format="m");

% run to create light images
close all;
set_light_opts();
run(scriptname)

if ~exist("resources", "dir")
    mkdir("resources");
end
% save opaque images and light images
hf = findobj("Type", "Figure");
for i = 1:length(hf)
    % write opaque image
    figname = sprintf("%s_%d_opaque.svg", fileNoExt, hf(i).Number-1);
    fignamefull = fullfile("resources", figname);
    print(hf(i), fignamefull, "-dsvg");

    % read in svg, and make transparent
    linesOpaque = readlines(fignamefull);
    linesLight = regexprep(linesOpaque, "fill:white", "fill:none");

    % write out light file
    figname = sprintf("%s_%d_light.svg", fileNoExt, hf(i).Number-1);
    fignamefull = fullfile("resources", figname);
    writelines(linesLight, fignamefull);
end

% run to create dark images
close all;
set_dark_opts();
run(scriptname);

% save transparent dark imageshf = findobj("Type", "Figure");
hf = findobj("Type", "Figure");
for i = 1:length(hf)
    % write opaque image
    figname = sprintf("%s_%d_dark.svg", fileNoExt, hf(i).Number-1);
    fignamefull = fullfile("resources", figname);
    print(hf(i), fignamefull, "-dsvg");

    % read in svg, and make transparent
    linesOpaque = readlines(fignamefull);
    linesDark = regexprep(linesOpaque, "fill:black", "fill:none");

    % write out light file
    writelines(linesDark, fignamefull);
end

% edit markdown to use new images    
mdtext = readlines(mdname);
mdtext2 = regexprep(mdtext, ...
    "!\[figure_\d+\.png\]\(\w+\/figure_(\d+).png\)", ...
    "<picture>\r\n" + ...
    "  <source media\=""\(prefers-color-scheme: dark\)"" srcset\=""resources\/" + fileNoExt +"_$1_dark.svg"">\r\n" + ...
    "  <source media\=""\(prefers-color-scheme: light\)"" srcset\=""resources\/" + fileNoExt +"_$1_light.svg"">\r\n" + ...
    "  <img alt\=""figure_$1"" src\=""resources\/" + fileNoExt +"_$1_light.svg"">\r\n" + ...
    "<\/picture>\r\n");
writelines(mdtext2, mdname);

% remove script
delete(scriptname);

end

function set_light_opts()
lightOpts = { ...
    "defaultFigureColor", "w", ...
    "defaultAxesColor", "w", ...
    "defaultAxesXColor", [1,1,1].*38/255, ...
    "defaultAxesYColor", [1,1,1].*38/255, ...
    "defaultAxesGridColor", [1,1,1].*38/255, ...
    "defaultAxesXGrid", "on", ...
    "defaultAxesYGrid", "on", ...
    "defaultAxesBox", "on", ...
    "defaultTextColor", [1,1,1].*38/255, ...
    "defaultErrorBarLineWidth", 1.5, ...
    "defaultLineLineWidth", 1.5, ...
    "defaultLineMarkerFaceColor", [1,1,1].*254/255, ...
    "defaultErrorBarMarkerFaceColor", [1,1,1].*254/255, ...
    "defaultAxesLineWidth", 1.5, ...
    "defaultAxesGridLineWidth", 1.0, ...
    "defaultAxesGridAlpha", 0.3, ...
    "defaultTextFontName", "FixedWidth", ...
    "defaultAxesFontName", "FixedWidth", ...
    "defaultFigureInvertHardcopy", "off", ...
    "defaultFigureUnits", "pixels", ...
    "defaultFigurePosition", [100, 100, 800, 500], ...
    "defaultBarFaceAlpha", 0.7, ...
    "defaultBarEdgeColor", [1,1,1].*38/255};
set(groot, lightOpts{:});
end

function set_dark_opts()
darkOpts = { ...
    "defaultFigureColor", [0, 0, 0], ...
    "defaultAxesColor", [0, 0, 0], ...
    "defaultAxesXColor", [1,1,1].*230/255, ...
    "defaultAxesYColor", [1,1,1].*230/255, ...
    "defaultAxesGridColor", [1,1,1].*230/255, ...
    "defaultAxesXGrid", "on", ...
    "defaultAxesYGrid", "on", ...
    "defaultAxesBox", "on", ...
    "defaultTextColor", [1,1,1].*230/255, ...
    "defaultErrorBarLineWidth", 1.5, ...
    "defaultLineLineWidth", 1.5, ...
    "defaultLineMarkerFaceColor", [1,1,1].*20/255, ...
    "defaultErrorBarMarkerFaceColor", [1,1,1].*20/255, ...
    "defaultAxesLineWidth", 1.5, ...
    "defaultAxesGridLineWidth", 1.0, ...
    "defaultAxesGridAlpha", 0.3, ...
    "defaultTextFontName", "FixedWidth", ...
    "defaultAxesFontName", "FixedWidth", ...
    "defaultFigureInvertHardcopy", "off", ...
    "defaultFigureUnits", "pixels", ...
    "defaultFigurePosition", [100, 100, 800, 500], ...
    "defaultBarFaceAlpha", 0.7, ...
    "defaultBarEdgeColor", [1,1,1].*230/255};
set(groot, darkOpts{:});
end