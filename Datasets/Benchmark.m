(* ::Package:: *)
(* ::Title:: *)
(*BenchmarkLoader(BenchmarkLoader)*)
(* ::Subchapter:: *)
(*程序包介绍*)
(* ::Text:: *)
(*Mathematica Package*)
(*Created by Mathematica Plugin for IntelliJ IDEA*)
(*Establish from GalAster's template(v1.3)*)
(**)
(* ::Text:: *)
(*Author:Aster*)
(*Creation Date:2018-08-21*)
(*Copyright: Mozilla Public License Version 2.0*)
(* ::Program:: *)
(*1.软件产品再发布时包含一份原始许可声明和版权声明。*)
(*2.提供快速的专利授权。*)
(*3.不得使用其原始商标。*)
(*4.如果修改了源代码，包含一份代码修改说明。*)
(**)
(* ::Text:: *)
(*这里应该填这个函数的介绍*)
BeginPackage["Waifu`"];
(* ::Section:: *)
(*函数说明*)
WaifuNearset::usage = "";
WaifuLinear::usage = "";
WaifuCubic::usage = "";
WaifuOMOMS::usage = "";
LapSRN::usage = "";
WaifuLapSRN::usage = "";
WaifuLapSRN2::usage = "";
RED30::usage = "";
WaifuRED30::usage = "";
VDSR::usage = "";
WaifuVDSR::usage = "";
ByNet::usage = "";
WaifuByNet::usage = "";
VGGSR::usage = "";
WaifuVGGSR::usage = "";
SESR::usage = "";
WaifuSESR::usage = "";
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
Begin["`BenchmarkLoader`"];
Version$BenchmarkLoader = "V1.0";
Updated$BenchmarkLoader = "2018-08-21";
(* ::Subsection:: *)
(*主体代码*)
(* ::Subsubsection::Closed:: *)
(*$WaifuSR*)
WaifuNearset = ImageResize[#, {512, 512}, Resampling -> "Nearest"] &;
WaifuLinear = ImageResize[#, {512, 512}, Resampling -> "Linear"] &;
WaifuCubic = ImageResize[#, {512, 512}, Resampling -> "Cubic"] &;
WaifuOMOMS = ImageResize[#, {512, 512}, Resampling -> {"OMOMS", 7}] &;
$models = FileNameJoin[{DirectoryName[$InputFileName, 2], "Models"}];
rgbMatrix = {{0.257, 0.504, 0.098}, {-0.148, -0.291, 0.439}, {0.439, -0.368, -0.071}};
rgbMatrixT = {{1.164, 0., 1.596}, {1.164, -0.392, -0.813}, {1.164, 2.017, 0.}};
(* ::Subsubsection::Closed:: *)
(*LapSRN*)
LapSRN = Import@FileNameJoin[{$models, "Waifu-LapSRN2x.WMLF"}];
WaifuLapSRN[img_, zoom_ : 2, device_ : "GPU"] := Block[
	{render},
	render[channel_] := Image[NetReplacePart[LapSRN, {
		"Input" -> NetEncoder[{"Image", ImageDimensions@img, ColorSpace -> "Grayscale"}]
	}][channel, TargetDevice -> device]];
	ColorCombine[render /@ ColorSeparate[img]]
];
LapSRN2 = Import@FileNameJoin[{$models, "Waifu-LapSRN4x.WMLF"}];
WaifuLapSRN2[img_, zoom_ : 2, device_ : "GPU"] := Block[
	{render},
	render[channel_] := Image[NetReplacePart[LapSRN2, {
		"Input" -> NetEncoder[{"Image", ImageDimensions@img, ColorSpace -> "Grayscale"}]
	}][channel, TargetDevice -> device]];
	ColorCombine[render /@ ColorSeparate[img]]
];
(* ::Subsubsection::Closed:: *)
(*RED30*)
RED30 = Import@FileNameJoin[{$models, "Waifu-RED30.WMLF"}];
WaifuRED30[img_, zoom_ : 2, device_ : "GPU"] := Block[
	{upsample, ycbcr, channels, netResize, adjust},
	upsample = ImageResize[img, Scaled[zoom], Resampling -> "Cubic"];
	ycbcr = ImageApply[rgbMatrix.# + {0.063, 0.502, 0.502}&, upsample];
	netResize = NetReplacePart[RED30,
		"Input" -> NetEncoder[{"Image", ImageDimensions@upsample, ColorSpace -> "Grayscale"}]
	];
	adjust = ColorCombine[{#1 + Image@netResize[#1, TargetDevice -> device], #2, #3}]&;
	ImageApply[rgbMatrixT.# + {-0.874, 0.532, -1.086}&, adjust @@ ColorSeparate[ycbcr]]
];
(* ::Subsubsection::Closed:: *)
(*VDSR*)
VDSR = Import@FileNameJoin[{$models, "Waifu-VDSR.WMLF"}];
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
(* ::Subsubsection::Closed:: *)
(*ByNet+*)
ByNet = Import@FileNameJoin[{$models, "Waifu-ByNet9.WMLF"}];
WaifuByNet[img_, zoom_ : 2, device_ : "GPU"] := Block[
	{upsample, ycbcr, channels, netResize, adjust},
	upsample = ImageResize[img, Scaled[zoom], Resampling -> "Cubic"];
	ycbcr = ImageApply[rgbMatrix.# + {0.063, 0.502, 0.502}&, upsample];
	netResize = NetReplacePart[ByNet,
		"Input" -> NetEncoder[{"Image", ImageDimensions@upsample, ColorSpace -> "Grayscale"}]
	];
	adjust = ColorCombine[{#1 + Image@netResize[#1, TargetDevice -> device], #2, #3}]&;
	ImageApply[rgbMatrixT.# + {-0.874, 0.532, -1.086}&, adjust @@ ColorSeparate[ycbcr]]
];
(* ::Subsubsection::Closed:: *)
(*VGGSR*)
VGGSR = Import@FileNameJoin[{$models, "Waifu-VGGSR.WMLF"}];
WaifuVGGSR[img_, device_ : "GPU"] := Module[
	{covImg, covNet, x, y},
	{x, y} = ImageDimensions[img];
	covImg = ColorCombine[Reverse@ColorSeparate[ImageResize[img, {x + 14, y + 14}]]];
	covNet = NetReplacePart[VGGSR, "Input" -> NetEncoder[{"Image", ImageDimensions@covImg}]];
	covNet[covImg, TargetDevice -> device]
];

(* ::Subsubsection::Closed:: *)
(*SESR*)
SESR = Import@FileNameJoin[{$models, "Waifu-SESR.WMLF"}];
WaifuSESR[img_, device_ : "GPU"] := Block[
	{upsample, ycbcr, netResize, adjust},
	upsample = ImageResize[img, Scaled[2], Resampling -> "Cubic"];
	ycbcr = ImageApply[rgbMatrix.# + {0.063, 0.502, 0.502}&, upsample];
	netResize = NetReplacePart[SESR, {
		"Input" -> NetEncoder[{"Image", ImageDimensions@img, ColorSpace -> "Grayscale"}]
	}];
	adjust = ColorCombine[{Image@netResize[#1, TargetDevice -> device], #2, #3}]&;
	ImageApply[rgbMatrixT.# + {-0.874, 0.532, -1.086}&, adjust @@ ColorSeparate[ycbcr]]
];

(* ::Subsection::Closed:: *)
(*附加设置*)
End[];
SetAttributes[
	{ },
	{Protected, ReadProtected}
];
EndPackage[]