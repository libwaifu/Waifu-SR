Waifu`Loaded`WaifuSR = True;
WaifuSR::usage = "放大你的 Waifu 照片!!";
NetModelLoader::usage = "Waifu 系列模型加载器";
Begin["`WaifuSR`"];
Options[WaifuSR] = {Method -> "VDSR", TargetDevice -> "GPU"};
WaifuSR::noThis = "算法 `1` 未定义!";
WaifuSR::less1 = "放大倍数需要大于 1 !";
WaifuSR[img_, zoom_ : 2, OptionsPattern[]] := Block[
	{},
	If[!TrueQ[zoom >= 1], Message[WaifuSR::less1];Return[Null]];
	Switch[OptionValue[Method],
		"VDSR", Waifu`VDSR`WaifuVDSR[img, zoom, TargetDevice -> OptionValue[TargetDevice]],
		_, Message[WaifuSR::noThis, OptionValue[Method]];Return[Null]
	]
];
If[!ListQ[Waifu`WaifuModels], Waifu`WaifuModels = {}];
NetModelLoader[name_] := NetModelLoader[name] = Block[
	{keys = Association @@ Waifu`WaifuModels},
	If[!FileExistsQ[keys[name, "Local"]],
		Echo[Text["模型不存在, 开始下载......"], "Waring: "],
		URLDownload[keys[name, "Remote"], keys[name, "Local"]]
	];
	Import[keys[name, "Local"]]
];
SetAttributes[
	{WaifuSR, NetModelLoader},
	{ReadProtected}
];
End[]