# 基于三分之一倍频程谱分析的振动信号特征提取研究
# Vibration Signal Feature Extraction Based on One-Third Octave Band Spectral Analysis

[![MATLAB](https://img.shields.io/badge/MATLAB-R2022b+-blue.svg)](https://www.mathworks.com/products/matlab.html)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📌 项目简介
本项目为**烟台大学工学学士毕业设计**，研究主题为机械设备振动信号特征提取。针对传统 FFT 在非平稳信号处理中频率分辨率不足、易丢失早期故障特征等问题，采用**三分之一倍频程谱分析**技术，结合信号预处理与频域能量量化方法，实现复杂工况下振动信号的精细化特征提取。

项目配套开发 MATLAB 可视化交互界面，支持一键式数据处理、结果可视化与报告导出，为机械设备早期故障诊断提供高效、可靠的技术工具。

## 🎯 核心功能
1. **振动信号预处理**
   - 最小二乘法：消除基线漂移/趋势项
   - 五点三次平滑法：抑制随机噪声、提升信号平滑度
   - FIR 低通滤波（Hamming 窗）：滤除高频干扰，保留线性相位特性

2. **三分之一倍频程谱分析**
   - 遵循 ISO/IEC 标准：划分 43 个标准中心频率（1Hz~20kHz）
   - 频域带通滤波：精准提取各频段信号分量
   - RMS 能量量化：计算各频段有效值，表征能量分布
   - 支持实测数据与仿真信号双重验证

3. **可视化交互界面（MATLAB App Designer）**
   - 数据导入：支持 Excel 格式振动数据读取
   - 多维度可视化：时域波形、频域特征、离散柱状谱、连续谱图、3D 时频图
   - 参数计算：自动输出峰值、峰峰值、有效值、均值等关键指标
   - 结果导出：支持图谱保存、数据报告生成、独立 APP 打包

## 🛠️ 技术栈
- **开发环境**：MATLAB R2022b+（含 Signal Processing Toolbox、App Designer）
- **核心算法**：FFT/IFFT、最小二乘法、FIR 滤波、三分之一倍频程带通滤波
- **标准规范**：ISO 266、IEC 61260 倍频程划分标准
- **验证工具**：OSA 倍频程仿真软件（结果对标验证）

## 📂 项目结构
vibration-octave-analysis/
├── docs/ # 毕业设计相关文档
│ └── 基于三分之一倍频程谱分析的振动信号特征提取研究_许佳萌.pdf
├── code/ # MATLAB 核心代码
│ ├── main_analysis.m # 信号预处理 + 倍频程分析主程序
│ ├── preprocessing.m # 预处理函数（去趋势 / 平滑 / 滤波）
│ ├── octave_band_analysis.m # 三分之一倍频程分析函数
│ └── visualization_app.mlapp # App Designer 可视化界面源码
├── app/ # 打包独立应用
│ └── vibration_analysis.exe # Windows 独立运行程序
├── data/ # 测试数据
│ ├── measured_data.xlsx # 实测振动数据
│ └── simulated_data.mat # 仿真信号（10Hz/500Hz/800Hz）
├── results/ # 分析结果
│ ├── spectrum_plots/ # 频谱图、时频图
│ └── feature_report.txt # 特征参数报告
├── README.md # 项目说明文档
└── LICENSE # 开源协议
作者信息
姓名：许佳萌
院校：烟台大学 物理与电子信息学院
专业：集成电路设计与集成系统
指导老师：姜佩贺（副教授）、刘华平（正高级）
