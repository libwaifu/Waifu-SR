BeginPackage["VDSR`"];
WaifuVDSR::usage = "";
Begin["`Private`"];
Options[WaifuVDSR] = {TargetDevice -> "GPU"};
WaifuVDSR[img_, zoom_ : 2, OptionsPattern[]] := Block[
	{net, upsample, ycbcr , channels, netResize, adjust},
	net = NetModelLoader["Waifu-VDSR"];
	upsample = ImageResize[img, Scaled[zoom], Resampling -> "Cubic"];
	ycbcr = ImageApply[{{0.257, 0.504, 0.098}, {-0.148, -0.291, 0.439}, {0.439, -0.368, -0.071}}.# + {0.063, 0.502, 0.502}&, upsample];
	netResize = NetReplacePart[net, "Input" -> NetEncoder[{"Image", ImageDimensions@upsample, ColorSpace -> "Grayscale"}]];
	adjust = ColorCombine[{#1 + Image@netResize[#1, TargetDevice -> OptionValue[TargetDevice]], #2, #3}]&;
	ImageApply[{{1.164, 0., 1.596}, {1.164, -0.392, -0.813}, {1.164, 2.017, 0.}}.# + {-0.874, 0.532, -1.086}&, adjust @@ ColorSeparate[ycbcr]]
];
End[];

EndPackage[]