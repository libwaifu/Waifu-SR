BeginPackage["Waifu`"];
$WaifuSRDirectory::usage = "WaifuSR的安装目录";
$WaifuSRDirectory = DirectoryName[$InputFileName];
Block[
	{$WaifuLoader = If[!TrueQ[#1], Get[FileNameJoin[{$WaifuSRDirectory, "Packages", #2}]]]&},
	$WaifuLoader[Waifu`Loaded`WaifuSR, "Core.m"];
	$WaifuLoader[Waifu`Loaded`VDSR, "VDSR.m"];
];
EndPackage[]