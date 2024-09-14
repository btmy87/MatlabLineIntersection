### make_badge.py
### generate a combined svg file from all workflows

import glob
import json
import re
import urllib.request

BASE_URL = "https://img.shields.io/badge/"
OS = {"ubuntu-latest": "Linux",
      "windows-latest": "Windows",
      "macos-latest": "Mac", 
      "macos-14": "Mac14",
      "macos-13": "Mac13" }
STATUS = {"pass": "blue", 
          "fail": "red"}
OFFSETX = 2
OFFSETY = 2
MAX_WIDTH = 400

badge = ""
x = 0
y = 0
width = 0
height = 0
for i, file in enumerate(glob.glob("./artifacts/*.json")):
    print(f"reading file {i}: {file}")
    with open(file, "r", encoding="utf-8") as fid:
        res = json.load(fid)

    # Get badge from shields.io
    url = BASE_URL + f'{OS[res["os"]]}:{res["version"]}-{res["status"]}-{STATUS[res["status"]]}'
    print(f"Getting badge from url: {url}")

    req = urllib.request.Request(url)
    req.add_header("Content-Type", "text/plain")
    req.add_header("User-Agent", "MyBadge/1.0")
    with urllib.request.urlopen(req) as fid:
        tempBadge = fid.read().decode("utf-8")

    # Each badge needs a unique url for clipping path
    tempBadge2 = tempBadge.replace('id="r"', f'id="r{i}"')
    tempBadge3 = tempBadge2.replace('url(#r)', f'url(#r{i})')

    # need x and y offset for each badge
    idx = tempBadge3.index("aria-label")
    tempBadge4 = (tempBadge3[:idx]
                  + f' x="{x}" y="{y}" '
                  + tempBadge3[idx:])

    # Get offset and width data
    m = re.search(r'width="(\d+)"', tempBadge4)
    widthStr = m.groups(0)[0]
    m = re.search(r'height="(\d+)"', tempBadge4)
    heightStr = m.groups(0)[0]

    # update height, width, and offsets
    x = x + int(widthStr) + OFFSETX
    width = max(width, x)
    if x > MAX_WIDTH:
        x = 0
        y = y + int(heightStr) + OFFSETY

    height = y + int(heightStr)

    # accumulate badge
    badge += tempBadge4

# make combined badge
badge = ('<svg xmlns="http://www.w3.org/2000/svg"'
         + ' xmlns:xlink="http://www.w3.org/1999/xlink" role="img"'
         + f' height="{height}" width="{width}">'
         + badge
         + '</svg>')

with open("./artifacts/badge.svg", "w+", encoding="utf-8") as fid:
    fid.write(badge)

