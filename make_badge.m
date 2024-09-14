% make_badge
% make a badge based on testing results
clear

% get a list of all files
files = dir("artifacts/*.json");

% badge will concatenate individual svg elements
badge = "<svg xmlns=""http://www.w3.org/2000/svg"" xmlns:xlink=""http://www.w3.org/1999/xlink"" role=""img"">";

% want shorter OS names
dOS = configureDictionary("string", "string");
dOS("ubuntu-latest") = "Lin";
dOS("win-latest") = "Win";
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

    badge = badge + tempBadge3 + spacer;
end
badge = badge + "</svg>";
writelines(badge, "./artifacts/badge.svg");
