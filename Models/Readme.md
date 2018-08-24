# Benchmark

## Quantity score

Name|size|paras|layers|time|FLOPS|
----|----|-----|------|----|-----|
Nearest|None|None|None|1.141 ms|136.9 M
Linear|None|None|None|4.184 ms|486.1 M
Cubic|None|None|None|10.83 ms|1.380 G
Gaussian|None|None|None|4.195 ms|511.5 M
VGGSR|2.11 MB|539.5 K|13|97.57 ms|63.20 G
**VDSR**|2.54 MB|650.3 K|40|344.1 ms|222.9 G
**SESR**|1.19 MB|305.1 K|65|358.9 ms|232.5 G
**SESR+**|-|-|-|-|-
**LapSRN**|1.66 MB|425.1 K|28|299.3 ms|193.8 G
**LapSRN+**|-|-|-|-|-
**RED30**|15.7 MB|4037 K|69|826.6 ms| 535.3 G

- 加粗表示 **YCbCr only**, 只在 YCbCr 空间中单通道渲染, 速度提升但质量下降.

## Quality score

Name|Zoom|-SAD-|+PSNR+|+SSIM+|+FSIM+|+GMSD+
----|----|-----|------|------|------|------|
**Nearest**|Auto|15617.3|27.0725|0.80129|-|-
**Linear**|Auto|14525.1|28.2834|0.83432|-|-
**Cubic**|Auto|12699.4|30.0381|0.88529|-|-
**Gaussian**|Auto|15440.1|27.7336|0.81401|-|-
VGGSR|×2|78561.5|14.8726|-|-|-
**VDSR**|Auto|11215.1|30.8817|-|-|-
SESR|×2|14200.5|28.9835|-|-|-
SESR+|×4|-|-|-|-|-
**LapSRN**|Auto|17527.1|28.1325|-|-|-
**LapSRN+**|Auto|-|-|-|-|-
**RED30**|Auto|572578|2.38243|-|-|-

- 加粗表示 **YCbCr only**, 只在 YCbCr 空间中单通道渲染, 速度提升但质量下降.
- Auto 表示 **AutoZoom**, 表示非固定倍率, 可以任意倍率缩放