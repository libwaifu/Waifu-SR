PersistentValue["LapSRN2x", "Notebook"] = Import["Waifu-LapSRN2x.WMLF"];
PersistentValue["LapSRN4x", "Notebook"] = Import["Waifu-LapSRN4x.WMLF"];
InitializationValue["WaifuLoader", "Notebook"] = Hold[
	LapSRN := LapSRN = PersistentValue["LapSRN2x", "Notebook"];
	WaifuLapSRN[img_, device_ : "GPU"] := Block[
		{render},
		render[channel_] := Image[NetReplacePart[LapSRN, {
			"Input" -> NetEncoder[{"Image", ImageDimensions@img, ColorSpace -> "Grayscale"}]
		}][channel, TargetDevice -> device]];
		ColorCombine[render /@ ColorSeparate[img]]
	];
	LapSRN2 := LapSRN2 = PersistentValue["LapSRN4x", "Notebook"];
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
	SetAttributes[{WaifuSR}, {Protected, ReadProtected}];
]
(*Sort@Flatten@{"Waifu`WaifuSR`"<>ToString[#]&/@{LapSRN,WaifuLapSRN,LapSRN2,WaifuLapSRN2},"WaifuSR"}*)
(*DumpSave["WaifuSR.mx", {Waifu`WaifuSR, Waifu`WaifuSR`LapSRN, Waifu`WaifuSR`LapSRN2, Waifu`WaifuSR`WaifuLapSRN, Waifu`WaifuSR`WaifuLapSRN2}]*)