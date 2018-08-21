# Benchmark

## Quantity score

Name|size|paras|layers|time|FLOPS|
----|----|-----|------|----|-----|
Nearest[^A]|None|None|None|1.141 ms|136.9 M
Linear[^A]|None|None|None|4.184 ms|486.1 M
Cubic[^A]|None|None|None|10.83 ms|1.380 G
Gaussian[^A]|None|None|None|4.195 ms|511.5 M
LapSRN[^Y]|1.66 MB|425.1 K|28|299.3 ms|193.8 G
LapSRN+[^A][^Y]|-|-|-|-|-
RED30[^A][^Y]|15.7 MB|4037 K|69|-|-
VDSR[^A][^Y]|2.54 MB|650.3 K|40|344.1 ms|222.9 G
VGGSR|2.11 MB|539.5 K|13|-|-

[^A]: Automatic, 可以以任意倍率缩放
[^Y]: YCbCr, 只在 YCbCr 空间中单通道渲染

## Quality score

Name|Size|SAD|PSNR|SSIM|FSIM|
----|----|---|-----|------|-----|
Nearest|256×256|15617.3|27.0725|-|-
Linear|256×256|14525.1|28.2834|-|-
Cubic|256×256|12699.4|30.0381|-|-
Gaussian|256×256|15440.1|27.7336|-|-
LapSRN|256×256|17527.1|28.1325|-|-
RED30|256×256|-|-|-|-
VDSR|256×256|11215.1|30.8817|-|-
VGGSR|256×256|-|-|-|-

