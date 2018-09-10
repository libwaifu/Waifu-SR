WaifuSR::usage = "";
Begin["`Private`"];
PackageLoadPacletDependency["NeuralNetworks`"];
PackageLoadPacletDependency["MXNetLink`"];
PackageExtendContextPath[
	{
		"Developer`",
		"MXNetLink`",
		"NeuralNetworks`",
		"GeneralUtilities`"
	}
];
SetAttributes[
	{ },
	{Protected, ReadProtected}
];
End[]