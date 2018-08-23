# Datasets

## Pixiv2017

All the pictures which appears in Pixiv monthly Top40

### Training Set

爬虫总共获得了 7724 条记录, 其中 4394 张图片是 jpg.

鉴于某些研究表明有损压缩会使网络学坏, 所以剔除这部分避免 jpg 污染.

剩下的图片比例如下所示:

![ar.png](https://i.loli.net/2018/08/22/5b7d4606bd611.png)


我们去掉了比例不在 **1/e < Aspect Ratio < e** 中的图片.

剩余的图片大小分布如下所示:

![size.png](https://i.loli.net/2018/08/22/5b7d4606bc114.png)

以下情形手动去除

- 封面, 游戏场景, 真实照片, 作画教程
- 色彩失衡, 大片空白, 黑白漫画, 表情包
- R18, 大片裸露, hentai 内容
- 非 CC 授权, 不可转载

然后去掉最大的 100 张图作为测试集, 最终剩余 3059 张图.

### Testing Set

尺寸大, 细节多, 无黑框, 无分镜头