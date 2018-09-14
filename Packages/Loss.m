(* ::Package:: *)
(* ::Title:: *)
(*Loss(Loss)*)
(* ::Subchapter:: *)
(*程序包介绍*)
(* ::Text:: *)
(*Mathematica Package*)
(*Created by Mathematica Plugin for IntelliJ IDEA*)
(*Establish from GalAster's template(v1.3)*)
(**)
(* ::Text:: *)
(*Author:Aster*)
(*Creation Date:2018-09-19*)
(*Copyright: Mozilla Public License Version 2.0*)
(* ::Program:: *)
(*1.软件产品再发布时包含一份原始许可声明和版权声明。*)
(*2.提供快速的专利授权。*)
(*3.不得使用其原始商标。*)
(*4.如果修改了源代码，包含一份代码修改说明。*)
(**)
(* ::Text:: *)
(*这里应该填这个函数的介绍*)
(* ::Section:: *)
(*函数说明*)
ExampleFunction::usage = "这里应该填这个函数的说明,如果要换行用\"\\r\"\r就像这样";
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
ExNumber::usage = "程序包的说明,这里抄一遍";
Begin["`Loss`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
Version$Loss = "V1.0";
Updated$Loss = "2018-09-19";
(* ::Subsubsection:: *)
(*功能块 1*)

SAD[{i1_, i2_}] := Total[Abs@ImageData[i1 - i2], Infinity];
PSNR[{i1_, i2_}] := 10 * Log[10, 1 / Mean@Flatten@ImageData[(i1 - i2)^2]];








(* ::Subsubsection:: *)
(*功能块 2*)
Options[SSIM] = {
	"C1" -> 0.01^2, "C2" -> 0.03^2,
	"Window" -> GaussianMatrix[{{(11 - 1) / 2, (11 - 1) / 2}, 1.5}, Method -> "Gaussian"]
};
SSIM[img1_Image, img2_Image, OptionsPattern[]] := Module[
	{c1, c2, window, mx, my, vx, vy, cov, r},
	{c1, c2, window} = OptionValue[{"C1", "C2", "Window"}];
	mx = ImageCorrelate[img1, window, Padding -> None];
	my = ImageCorrelate[img2, window, Padding -> None];
	vx = ImageCorrelate[img1^2, window, Padding -> None] - mx^2;
	vy = ImageCorrelate[img2^2, window, Padding -> None] - my^2;
	cov = ImageCorrelate[img1 * img2, window, Padding -> None] - mx * my;
	r = (2mx * my + c1) / (mx^2 + my^2 + c1) * (2cov + c2) / (vx + vy + c2);
	Mean@ImageMeasurements[r, "Mean"]
];






(* ::Subsection::Closed:: *)
(*附加设置*)
SetAttributes[
	{ },
	{Protected, ReadProtected}
];
End[]