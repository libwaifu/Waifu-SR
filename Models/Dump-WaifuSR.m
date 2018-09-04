BeginPackage["Waifu`"];
WaifuSR::usage = "动漫超分辨率重建";
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
VDSR = Import["Waifu-VDSR.WMLF"];
rgbMatrix = {{0.257, 0.504, 0.098}, {-0.148, -0.291, 0.439}, {0.439, -0.368, -0.071}};
rgbMatrixT = {{1.164, 0., 1.596}, {1.164, -0.392, -0.813}, {1.164, 2.017, 0.}};
WaifuVDSR[img_, zoom_ : 2, device_ : "GPU"] := Block[
	{upsample, ycbcr, channels, netResize, adjust},
	upsample = ImageResize[img, Scaled[zoom], Resampling -> "Cubic"];
	ycbcr = ImageApply[rgbMatrix.# + {0.063, 0.502, 0.502}&, upsample];
	netResize = NetReplacePart[VDSR,
		"Input" -> NetEncoder[{"Image", ImageDimensions@upsample, ColorSpace -> "Grayscale"}]
	];
	adjust = ColorCombine[{#1 + Image@netResize[#1, TargetDevice -> device], #2, #3}]&;
	ImageApply[rgbMatrixT.# + {-0.874, 0.532, -1.086}&, adjust @@ ColorSeparate[ycbcr]]
];
WaifuSR[i_Image, zoom_ : 2, gpu_ : True] := Block[
	{
		device = If[TrueQ@gpu, "GPU", "CPU"],
		img = ColorConvert[RemoveAlphaChannel@i, "RGB"]
	},
	Piecewise[{
		{Return[$Failed], zoom <= 1},
		{ImageResize[WaifuLapSRN[img, device], zoom ImageDimensions[i]], 1 < zoom <= 2},
		{ImageResize[WaifuLapSRN2[img, device], zoom ImageDimensions[i]], 2 < zoom <= 4},
		{WaifuVDSR[img, zoom, device], 4 < zoom}
	}]
];
End[];
SetAttributes[{WaifuSR}, {Protected, ReadProtected}];
EndPackage[];
(*Sort@Flatten@{"Waifu`WaifuSR`"<>ToString[#]&/@{LapSRN,WaifuLapSRN,LapSRN2,WaifuLapSRN2,VDSR,rgbMatrix,rgbMatrixT,WaifuVDSR},"WaifuSR"}*)
DumpSave["WaifuSR.mx", {WaifuSR, Waifu`WaifuSR`LapSRN, Waifu`WaifuSR`LapSRN2, Waifu`WaifuSR`rgbMatrix, Waifu`WaifuSR`rgbMatrixT, Waifu`WaifuSR`VDSR, Waifu`WaifuSR`WaifuLapSRN, Waifu`WaifuSR`WaifuLapSRN2, Waifu`WaifuSR`WaifuVDSR}]