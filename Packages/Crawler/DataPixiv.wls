(* ::Text:: *)
(*获取排行榜作品 ID*)
GetRank[date_] := Block[
	{xml, new, url = "https://www.pixiv.net/ranking.php?mode=monthly&content=illust&date=" <> date},
	xml = Quiet@Import[url, {"XHTML", "XMLObject"}];
	new = Cases[xml, XMLElement["img", {"class" -> "_thumbnail ui-scroll-view", data___}, {}] :> {data}, Infinity];
	{"data-id", "data-user-id", "data-src"} /. new
];
range = DateRange[DateObject[{2017, 1, 1}], DateObject[{2018, 1, 31}]];
dates = DateString[#, {"Year", "Month", "Day"}] & /@ range;
ans = Sort@DeleteDuplicatesBy[Join @@ Map[GetRank, dates], First]; // TT
fmt = { #1, #2, StringRiffle[StringSplit[#3, "/"][[8 ;; -2]], "/"]}& @@@ ans ;
Export["Pixiv2017.csv", Select[fmt, StringTake[#[[3]], 4] === "2017" &], "TableHeadings" -> {"ID", "Author", "Path"}]


(* ::Text:: *)
(*下载作品*)
timeLeft[start_, frac_] := With[{past = AbsoluteTime[] - start}, If[frac == 0 || past < 1, "-", Floor[past / frac - past]]];
AbortableMap[func_, list_, ker_ : $KernelCount] := DynamicModule[
	{len, bag, size, lastResults, startTime, n, results, t},
	len = Length[list]; size = 0; startTime = AbsoluteTime[];
	results = {}; SetSharedVariable[results, size];
	Monitor[
		t = Table[ParallelSubmit[{i},
			With[
				{r = func[list[[i]]]},
				size += ByteCount[r];
				AppendTo[results, {i, r}]
			]
		], {i, Range[len]}];
		CheckAbort[WaitAll[t], AbortKernels[]];
		SortBy[results, First],
		Dynamic@Refresh[Panel @ Column[{
			ProgressIndicator[Length[results] / len, ImageSize -> 350],
			Row[{Button["Abort", Abort[]],
				Grid[{{"Tasks", "Memory (kB)", "Time left (s)"},
					{StringForm["``/``", Length[results], len],
						ToString @ NumberForm[size / 2.^10, {3, 2}],
						ToString @ timeLeft[startTime, Length[results] / len]}
				}, Spacings -> {1, 1}, ItemSize -> {10, 1}, Dividers -> Center
				]}, Spacer[5]]
		}], UpdateInterval -> 1, TrackedSymbols -> {}
		]
	]
];
data = Normal@Import["Pixiv2017.csv", {"CSV", "Dataset"}, "HeaderLines" -> 1]
api = StringTemplate["https://i.pximg.net/img-original/img/`path`/`id`_p0.png"];
down[asc_] := Block[
	{name, req, id = ToString[asc["ID"]]},
	name = "D:\\MyDrivers\\Download\\" <> id <> ".png";
	If[FileExistsQ@name, Return[Nothing]];
	req = HTTPRequest[
		api[<|"id" -> id, "path" -> asc["Path"]|>],
		<|"Headers" -> {"Referer" -> "https://www.pixiv.net/member_illust.php?mode=medium&illust_id=" <> id}|>
	];
	URLDownloadSubmit[req, CreateFile[name]]
]





(* ::Text:: *)
(*数据集比例, 剔除异常数据*)
aps = # -> Divide @@ Import[#, "ImageSize"]& /@ files;
hgm = Histogram[Last /@ aps, Automatic, "Probability", PerformanceGoal -> "Quality",
	ChartElementFunction -> ChartElementDataFunction["SegmentScaleRectangle", "Segments" -> 10, "ColorScheme" -> "BrownCyanTones"]
]
Export["aps.png", hgm, Background -> None, ImageSize -> 640]
mv = First /@ Select[aps, !(1 / E < Last@# < E)&];
CopyFile @@@ Transpose[{mv, StringReplace[#, "\\PNG\\" -> "\\Remove\\"]& /@ mv}]


(* ::Text:: *)
(*数据集大小*)
files = Join[FileNames["*", "D:\\MyDrivers\\PNG\\"], FileNames["*", "D:\\MyDrivers\\Remove\\"]];
size = First@UnitConvert[#, "Kilobytes"]& /@ (FileSize /@ files);
hgm = Histogram[size, {0, 7000, 200}, "Probability", ChartStyle -> "Pastel", PerformanceGoal -> "Quality"]
Export["size.png", hgm, Background -> None, ImageSize -> 640]



