xUnit[channel_, ker_, pad_] := NetGraph[<|
	"bn_1" -> BatchNormalizationLayer["Epsilon" -> 10^-5],
	"relu" -> Ramp,
	"conv" -> ConvolutionLayer[channel, ker, "PaddingSize" -> pad],
	"bn_2" -> BatchNormalizationLayer["Epsilon" -> 10^-5],
	"xAct" -> ElementwiseLayer[E^-#^2&],
	"mult" -> ThreadingLayer[Times]
|>, {
	NetPort["Input"] -> "mult",
	NetPort["Input"]
		-> "bn_1" -> "relu" -> "conv"
		-> "bn_2" -> "xAct" -> "mult"
}]