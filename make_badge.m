% make_badge
% make a badge based on testing results
clear

% get a list of all files
files = dir("artifacts/*.json");

% badge will concatenate individual svg elements

% want shorter OS names
dOS = configureDictionary("string", "string");
dOS("ubuntu-latest") = "Linux";
dOS("windows-latest") = "Windows";
dOS("macos-latest") = "Mac";
dOS("macos-14") = "Mac14";
dOS("macos-13") = "Mac13";

% color per status
dStatus = configureDictionary("string", "string");
dStatus("pass") = "blue";
dStatus("fail") = "red";

spacer = "<svg width=""2"" height=""20""><text> </text></svg>";
% we'll get badges from shields.io
% concatenating into a single, nested svg element.
baseUrl = "https://img.shields.io/badge";
opts = weboptions(ContentType="text");
x = 0;
y = 0;
width = 0;
height = 0;
badge = "";
for i = 1:numel(files)
    f = fullfile(files(i).folder, files(i).name);
    temp = readstruct(f);
    tempUrl = sprintf("%s/%s:%s-%s-%s", baseUrl, dOS(temp.os), ...
        temp.version, temp.status, dStatus(temp.status));
    tempBadge = string(webread(tempUrl, opts));

    % need a unique url for clipping path
    tempId = "r" + i;
    tempBadge2 = strrep(tempBadge, "id=""r""", "id=""r"+i+"""");
    tempBadge3 = strrep(tempBadge2, "url(#r)", "url(#r"+i+")");
    tempBadge4 = strrep(tempBadge3, "aria-label", ...
        sprintf("x=""%.0f"" y=""%.0f"" aria-label", x, y));

    % get x for next offset
    widthStr = regexp(tempBadge, "width=""(\d+)""", "tokens", "once");
    heightStr = regexp(tempBadge, "height=""(\d+)""", "tokens", "once");
    x = x + double(widthStr) + 2;
    width = max([width, x]);
    if x > 400
        x = 0;
        y = y + double(heightStr) + 2;
    end
    height = y + double(heightStr);

    badge = badge + tempBadge4;
end
badge = sprintf("<svg xmlns=""http://www.w3.org/2000/svg"" " ...
    + "xmlns:xlink=""http://www.w3.org/1999/xlink"" role=""img"" " ...
    + "height=""%.0f"" width=""%.0f"">", ...
    height, width) + badge + "</svg>";
writelines(badge, "./artifacts/badge.svg");
