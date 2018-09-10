# Waifu::SuperResolution

[![Mathematica](https://img.shields.io/badge/Mathematica-%3E%3D11.3.5-brightgreen.svg)](https://www.wolfram.com/mathematica/)
[![Release Vision](https://img.shields.io/badge/release-v1.7.x-ff69b4.svg)](https://github.com/Moe-Net/Waifu-SR/releases)
[![Repo Size](https://img.shields.io/github/repo-size/Moe-Net/Waifu-SR.svg)](https://github.com/Moe-Net/Waifu-SR.git)
[![Code Size](https://img.shields.io/github/languages/code-size/Moe-Net/Waifu-SR.svg)](https://github.com/Moe-Net/Waifu-SR.git)

Image Super-Resolution for Anime-style art

One-click experience package: https://github.com/Moe-Net/Waifu-SR/releases/download/v1.0.0/WaifuSR.zip

## Attention!

Here is the development branch of the project.

You don't need to clone this project unless you are interested in super-resolution reconstruction.

If you have any problems when **using**, go to https://github.com/Moe-Net/Waifu-X.

## Fast tests

```Mathematica
test=Import["https://i.loli.net/2018/09/09/5b94b9b6e2574.png"];
WaifuSR[test,2]
WaifuSR[test,4]
```

#### Raw:

![sr0.png](https://i.loli.net/2018/09/09/5b94b9b6e2574.png)

#### WaifuSR:

![sr1.png](https://i.loli.net/2018/09/09/5b94b9b7b9c1c.png)
![sr3.png](https://i.loli.net/2018/09/09/5b94b9b9d1b00.png)

## Benchmark

Now we have 8 kinds of algorithms!

See: https://github.com/Moe-Net/Waifu-SR/tree/master/Models

## License

> ©Copyright by **Creative Commons — Attribution 4.0 International — BY+NA+NC**.