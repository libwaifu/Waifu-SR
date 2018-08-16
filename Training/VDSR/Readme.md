


## VDSR

```Mathematica
NetChain[
	Join[
		ConstantArray[{ConvolutionLayer[64, {3, 3}, "PaddingSize" -> 1], Ramp}, 19],
		{ConvolutionLayer[1, {3, 3}, "PaddingSize" -> 1], TransposeLayer[{1<->3, 1<->2}]}
	],
	"Input" -> {1, 255, 255}
] // NetInitialize
```


![VDSR](https://i.loli.net/2018/08/14/5b72a23d4e60b.png)