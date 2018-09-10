(* ::Package:: *)
(* ::Title:: *)
(*NetReport(NetReport)*)
(* ::Subchapter:: *)
(*程序包介绍*)
(* ::Text:: *)
(*Mathematica Package*)
(*Created by Mathematica Plugin for IntelliJ IDEA*)
(*Establish from GalAster's template(v1.3)*)
(**)
(* ::Text:: *)
(*Author:Aster*)
(*Creation Date:2018-09-10*)
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
NetModelPlot::usage = "";
GetReport::usage = "";
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
ExNumber::usage = "程序包的说明,这里抄一遍";
Begin["`NetReport`"];
(* ::Subsection::Closed:: *)
(*主体代码*)
Version$NetReport = "V1.0";
Updated$NetReport = "2018-09-10";
(* ::Subsubsection:: *)
(*功能块 1*)
Options[NetModelPlot] = {
	Magnify->1.5,
	"ShowTensors" -> True,
	"VertexLabels" -> Placed["ID", Above],
	"VertexOrder" -> Automatic,
	"EdgeBundling" -> False,
	"OutputTensors" -> None,
	"InternalDimensions" -> None,
	Rotate -> False,
	GraphLayout -> "LayeredDigraphDrawing"
};
NetModelPlot[file_File, OptionsPattern[]] := Block[
	{
		showTensors, vertexLabels, vertexOrder, edgeBundling, outputTensors, plot,
		internalDimensions, nodes, argNodes, heads, $oldIds, nameStrings, typeStrings,
		edges, nodeOps, longRange, opTypes, opNames, nullType, blank, maxIndex,
		name, nodeDims, edgeTooltips, nops, opStyles, opSizes, vertexTypeData, labels, infoGrids, nNodes
	},
	{
		showTensors, vertexLabels, vertexOrder, edgeBundling, outputTensors, internalDimensions
	} = OptionValue @ {
		"ShowTensors", "VertexLabels", "VertexOrder", "EdgeBundling", "OutputTensors", "InternalDimensions"
	};
	expr = MXNetLink`MXSymbolToJSON@MXNetLink`MXSymbolFromJSON@file;
	{nodes, argNodes, heads} = Lookup[expr, {"nodes", "arg_nodes", "heads"}, GeneralUtilities`Panic[]];
	$oldIds = If[ListQ[vertexOrder],
		Map[Function[GeneralUtilities`IndexOf[vertexOrder, #name] - 1], nodes],
		Range[Length[nodes]] - 1
	];
	nodes = Map[Append[#, "inputs1" -> (Part[#inputs, All, 1] + 1)]&, nodes];
	nameStrings = Map[MXNetLink`Visualization`PackagePrivate`toVertexLabelString[#name]&, nodes];
	typeStrings = Map[MXNetLink`Visualization`PackagePrivate`toVertexTypeString[#op]&, nodes];
	AddTo[argNodes, 1];
	AddTo[heads, 1];
	edges = Apply[Join,
		MapIndexed[
			If[
				SameQ[#op, "null"],
				Nothing,
				If[showTensors,
					Thread @ Prepend[#2, #inputs1],
					Thread @ Prepend[#2, Complement[#inputs1, argNodes]]
				]
			]&,
			nodes
		]
	];
	edges = DeleteDuplicates @ edges;
	nodeOps = nodes[[All, "op"]];
	If[And[edgeBundling, !FreeQ[nodeOps, "Concat" | "SliceChannel"]],
		longRange = MXNetLink`Visualization`PackagePrivate`pickLongRangeEdges[edges, nodes],
		longRange = None;
	];
	{opTypes, opNames} = GeneralUtilities`Labelling @ nodeOps;
	nullType = GeneralUtilities`IndexOf[opNames, "null"];
	nodes = MapIndexed[Function[Append[#, "id" -> (First[#2] - 1)]],
		nodes
	];
	If[showTensors && ListQ[outputTensors],
		opTypes = Join[opTypes, ConstantArray[nullType, Length @ outputTensors]];
		argNodes = Join[argNodes, Range[Length[outputTensors]] + Max[edges]];
		nameStrings = Join[nameStrings, outputTensors];
		blank = ConstantArray["", Length @ outputTensors];
		$oldIds = Join[$oldIds, blank];
		typeStrings = Join[typeStrings, blank];
		nodes = Join[nodes, blank];
		maxIndex = Max @ edges;
		MapIndexed[AppendTo[edges, {First @ #, First[#2] + maxIndex}]&, heads]
	];
	edgeTooltips = If[
		SameQ[internalDimensions, None],
		None,
		nodeDims = Table[
			name = Internal`UnsafeQuietCheck[nodes[[i, "name"]], None];
			MXNetLink`Visualization`PackagePrivate`toDimLabel @ Lookup[
				internalDimensions, name, If[StringQ[name],
					Lookup[internalDimensions, StringJoin[name, "_output"], None],
					None
				]
			],
			{i, Length @ nodes}
		];
		((Part[nodeDims, #]&) @@@ edges) /. BatchSize -> "b"
	];
	nops = Length @ opNames;
	opStyles = Map[MXNetLink`Visualization`PackagePrivate`opColor, opNames];
	opSizes = ReplacePart[ConstantArray[6, nops], nullType -> 4];
	opStyles = ReplacePart[opStyles, nullType -> Gray];
	opNames = opNames /. "null" -> "Tensor";
	vertexTypeData = <|"VertexStyles" -> opStyles|>;
	If[showTensors,
		vertexTypeData = Join[vertexTypeData, <|"VertexSizes" -> opSizes|>]
	];
	labels = ReplaceAll[vertexLabels,
		{"Name" :> nameStrings, "ID" :> $oldIds, "Type" :> typeStrings}
	];
	infoGrids = Map[MXNetLink`Visualization`PackagePrivate`nodeInfoGrid, nodes];
	nNodes = Length @ nodes;
	plot = LayerPlot[edges,
		"VertexLabels" -> labels, "HiddenVertices" -> If[showTensors, None, argNodes],
		"VertexTypeData" -> vertexTypeData, "VertexTypeLabels" -> opNames, "MaximumImageSize" -> None,
		"VertexSizes" -> 4, "EdgeTooltips" -> edgeTooltips,
		"BaseLabelStyle" -> {FontSize -> 7}, "LayoutMethod" -> OptionValue[GraphLayout],
		"DuplicateInputVertices" -> True, If[showTensors, "VertexTypes" -> opTypes, "VertexStyles" -> opTypes],
		"LongRangeEdges" -> longRange, "Rotated" -> OptionValue[Rotate], "ArrowShape" -> "Chevron", "LegendLabelStyle" -> 8
	];
	Magnify[plot, OptionValue[Magnify]]
];







GetReport[results_] := Block[
	{
		gpu = ToAssociations[SystemInformation["Devices"]]["GraphicsDevices", "OpenGL", "OnScreen"],
		gpu1 = ToAssociations@OpenCLInformation[1, 1],
		gpu2 = ToAssociations@OpenCLInformation[1, 2]
	},
	<|
		"Quality" -> (<|# -> results[#]|>& /@ {
			"FinalRoundErrorRate",
			"FinalRoundLoss",
			"FinalValidationErrorRate",
			"FinalValidationLoss",
			"LowestValidationErrorRate",
			"LowestValidationLoss",
			"LowestValidationRound"
		}),
		"Quantity" -> (<|# -> results[#]|>& /@ {
			"TotalTrainingTime",
			"TotalBatches",
			"TotalInputs",
			"TotalRounds",
			"MeanBatchesPerSecond",
			"MeanInputsPerSecond"
		}),
		"Method" -> (<|# -> results[#]|>& /@ {
			"OptimizationMethod",
			"InitialLearningRate",
			"FinalLearningRate",
			"BatchSize",
			"VersionNumber"
		}),
		"Platform" -> <|
			"Mathematica" -> ToAssociations[SystemInformation["Kernel"]]["Version"],
			"GPU" -> gpu["Renderer"],
			"CUDA" -> gpu["Version"]
		|>
	|>
];


(* ::Subsection::Closed:: *)
(*附加设置*)
SetAttributes[
	{ },
	{Protected, ReadProtected}
];
End[]