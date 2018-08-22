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
