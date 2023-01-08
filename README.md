# splinestein-diffing-algorithm
A string similarity metric diffing algorithm invented by splinestein for chat bot use.

* Link to module: https://www.roblox.com/library/12088663460/StringDiff
* Open source and can be viewed here: https://github.com/splinestein/splinestein-diffing-algorithm/blob/main/stringdiff.lua

**How to use?**

1) Put the module into ReplicatedStorage.
2) In your script, require it with: `local sdiff = require(game:GetService("ReplicatedStorage"):FindFirstChild("StringDiff"))`
3) Run it with `ratio, _ = sdiff.compare("Hey is this working?, "Hey this is working?")`
4) First return value is the ratio from 0 - 100, second optional return value is the longest match.
5) `print(ratio)`

I've tested this for chat bot use and it's working nicely. Hope you enjoy. Feel free to suggest any changes.
