# Benchmark

## Quantity score

Name|size|paras|layers|nodes|speed|FLOPS|
----|----|-----|------|-----|-----|-----|
Nearest|None|0 order|None|None|1.141 ms|136.9 M
Linear|None|1 order|None|None|4.184 ms|486.1 M
Cubic|None|3 order|None|None|10.83 ms|1.380 G
o-MOMS|None|7 order|None|None|9.975 ms|1.292 G
VGGSR|2.11 MB|552.5 K|13|-|97.57 ms|63.20 G
VDSR|2.54 MB|665.9 K|40|82|344.1 ms|222.9 G
SESR|1.19 MB|312.5 K|65|-|358.9 ms|232.5 G
SESR+|-|-|-|-|-|-
LapSRN|1.66 MB|435.3 K|28|92|381.4 ms|247.0 G
LapSRN+|3.32 MB|870.1 K|53|174|1.085 s|703.0 G
RED30|15.7 MB|4.135 M|69|131|826.6 ms|535.3 G

## Quality score

Name|Zoom|-SAD-|+PSNR+|+SSIM+|+FSIM+|+GMSD+
----|----|-----|------|------|------|------|
Nearest|Auto|15617.3|27.0725|0.80129|-|-
Linear|Auto|14525.1|28.2834|0.83432|-|-
Cubic|Auto|12699.4|30.0381|0.88529|-|-
o-MOMS|Auto|12697.5|30.3557|-|-|-
VGGSR|×2|78561.5|14.8726|-|-|-
**VDSR**|Auto|11215.1|30.8817|-|-|-
**SESR**|×2|14200.5|28.9835|-|-|-
**SESR+**|×4|-|-|-|-|-
LapSRN|×2|8671.42|33.6572|-|-|-
LapSRN+|×4|8315.27|33.6519|-|-|-
**RED30**|Auto|572578|2.38243|-|-|-

- 加粗表示 **YCbCr Only**, 只在 YCbCr 空间中单通道渲染, 速度提升但质量下降.
- Auto 表示 **AutoZoom**, 非固定倍率, 可以任意倍率缩放