If[$CharacterEncoding =!= "UTF-8",
	$CharacterEncoding = "UTF-8";
	Echo[Style["$CharacterEncoding has been changed to UTF-8 to avoid problems.", Red], "Warning: \n"];
	st = OpenAppend[FindFile["init.m"]];
	WriteString[st, "$CharacterEncoding=\"UTF-8\";"];
	Close[st];
];
Get["WaifuSR`WaifuSR`"];