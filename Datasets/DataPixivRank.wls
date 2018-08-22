GetRank[date_] := Block[
	{xml, new, url = "https://www.pixiv.net/ranking.php?mode=daily&content=illust&date=" <> date},
	xml = Quiet@Import[url, {"XHTML", "XMLObject"}];
	new = Cases[xml, XMLElement["img", {"class" -> "_thumbnail ui-scroll-view", data___}, {}] :> {data}, Infinity];
	{"data-id", "data-user-id", "data-src"} /. new
]
range = DateRange[DateObject[{2017, 1, 1}], DateObject[{2017, 12, 31}]];
dates = DateString[#, {"Year", "Month", "Day"}]& /@ range;
ans = Sort@DeleteDuplicatesBy[Join @@ Map[GetRank, dates], First]; // TT
Export["ans.csv", ans, "TableHeadings" -> {"ID", "Author", "Thumbnail"}]