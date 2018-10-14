## SRCNN

```Mathematica
net = NetChain[{
	ResizeLayer[{Scaled[2], Scaled[2]}]
	ConvolutionLayer[32, {3, 3}], ElementwiseLayer[Ramp],
	ConvolutionLayer[32, {3, 3}], ElementwiseLayer[Ramp],
	ConvolutionLayer[3, {3, 3}]
},
	"Input" -> {3, 640, 360}
] // NetInitialize
```

![SRCNN](https://i.loli.net/2018/08/14/5b729c4034283.png)

## VGG-SR-7

SRCNN 的变种, Waifu2X 作者所选择的网络

```Mathematica
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
	"Input" -> {3, 640, 360}
] // NetInitialize
```

![VGG-SR-7](https://i.loli.net/2018/08/14/5b729c403f339.png)