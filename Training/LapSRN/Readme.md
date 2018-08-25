## LapSRN

## LapSRN-2X

```Mathematica
leakyReLU[alpha_] := ElementwiseLayer[Ramp[#] - alpha * Ramp[-#]&]
GetConvolution[i_] := {
	("convo_" <> i) -> ConvolutionLayer[64, 3, "PaddingSize" -> {1, 1}, "Biases" -> None],
	("leaky_" <> i) -> leakyReLU[0.2]
};
mainCNN = NetChain[{
	Table[GetConvolution[ToString@i], {i, 0, 10}],
	"decon_11" -> DeconvolutionLayer[64, 4, "Biases" -> None, "PaddingSize" -> 1, "Stride" -> 2],
	"leaky_11" -> leakyReLU[0.2],
	"convo_12" -> ConvolutionLayer[1, 3, "Biases" -> None, "PaddingSize" -> {1, 1}]
} // Flatten];
LapSRN = NetGraph[{
	"main" -> mainCNN,
	"res" -> DeconvolutionLayer[1, 4, "Biases" -> None, "PaddingSize" -> {1, 1}],
	"add" -> ThreadingLayer[Plus],
	"trans" -> TransposeLayer[{1<->3, 1<->2}]
}, {
	NetPort["Input"] -> "main",
	NetPort["Input"] -> "res",
	{"main", "res"} -> "add" -> "trans"
},
	"Input" -> {1, 640, 360}
] // NetInitialize
```

## LapSRN-4X