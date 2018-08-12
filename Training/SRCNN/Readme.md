


## SRCNN

```
net = NetChain[{
	ResizeLayer[{Scaled[2], Scaled[2]}]
	ConvolutionLayer[32, {3, 3}], ElementwiseLayer[Ramp],
	ConvolutionLayer[32, {3, 3}], ElementwiseLayer[Ramp],
	ConvolutionLayer[3, {3, 3}]
},
	"Input" -> {3, Automatic, Automatic},
	"Output" -> NetDecoder["Image"]
] // NetInitialize
```


## VGG-SR

SRCNN 的变种, Waifu2X 作者所选择的网络

```
leakyReLU[alpha_] := ElementwiseLayer[Ramp[#] - alpha * Ramp[-#]&]
chain = NetChain[{
	ResizeLayer[{256 + 14, 256 + 14}],
	ConvolutionLayer[32, {3, 3}], leakyReLU[0.1],
	ConvolutionLayer[32, {3, 3}], leakyReLU[0.1],
	ConvolutionLayer[64, {3, 3}], leakyReLU[0.1],
	ConvolutionLayer[64, {3, 3}], leakyReLU[0.1],
	ConvolutionLayer[128, {3, 3}], leakyReLU[0.1],
	ConvolutionLayer[128, {3, 3}], leakyReLU[0.1],
	ConvolutionLayer[3, {3, 3}]
},
	"Input" -> NetEncoder[{"Image", 32}],
	"Output" -> NetDecoder["Image"]
] // NetInitialize
``