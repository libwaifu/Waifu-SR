BeginPackage["Waifu`"];
WaifuSR::usage = "WaifuSR[ \!\(\*StyleBox[\"img\", \"TI\"], \*StyleBox[\"zoom\", \"TI\"]\) ] 将图片放大 \*StyleBox[\"zoom\", \"TI\"] 倍并用神经网络补充细节.";
Begin["`WaifuSR`"];
LapSRN = Import["Waifu-LapSRN2x.WMLF"];
WaifuLapSRN[img_, device_ : "GPU"] := Block[
	{render},
	render[channel_] := Image[NetReplacePart[LapSRN, {
		"Input" -> NetEncoder[{"Image", ImageDimensions@img, ColorSpace -> "Grayscale"}]
	}][channel, TargetDevice -> device]];
	ColorCombine[render /@ ColorSeparate[img]]
];
LapSRN2 = Import["Waifu-LapSRN4x.WMLF"];
WaifuLapSRN2[img_, device_ : "GPU"] := Block[
	{render},
	render[channel_] := Image[NetReplacePart[LapSRN2, {
		"Input" -> NetEncoder[{"Image", ImageDimensions@img, ColorSpace -> "Grayscale"}]
	}][channel, TargetDevice -> device]];
	ColorCombine[render /@ ColorSeparate[img]]
];
Options[WaifuSR] = {TargetDevice -> "GPU"};
WaifuSR[i_Image, zoom_ : 2, OptionsPattern[]] := Block[
	{
		device = OptionValue[TargetDevice],
		img = ColorConvert[RemoveAlphaChannel@i, "RGB"]
	},
	Piecewise[{
		{Return[$Failed], zoom <= 1},
		{ImageResize[WaifuLapSRN[img, device], zoom ImageDimensions[i]], 1 < zoom <= 2},
		{ImageResize[WaifuLapSRN2[img, device], zoom ImageDimensions[i]], 2 < zoom <= 4},
		{ImageResize[img, Scaled[zoom], Resampling -> {"OMOMS", 7}], 4 < zoom}
	}]
];
End[];
SetAttributes[{WaifuSR}, {Protected, ReadProtected}];
EndPackage[];
(*Sort@Flatten@{"Waifu`WaifuSR`"<>ToString[#]&/@{LapSRN,WaifuLapSRN,LapSRN2,WaifuLapSRN2},"WaifuSR"}*)
DumpSave["WaifuSR.mx", {Waifu`WaifuSR, Waifu`WaifuSR`LapSRN, Waifu`WaifuSR`LapSRN2, Waifu`WaifuSR`WaifuLapSRN, Waifu`WaifuSR`WaifuLapSRN2}]