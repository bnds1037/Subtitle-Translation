# Subtitle Translation

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2017.0%2B-blue.svg" alt="Platform: iOS 17.0+">
  <img src="https://img.shields.io/badge/Swift-5.10-orange.svg" alt="Swift 5.10">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT">
</p>

## 📖 简介

Subtitle Translation is 
“100% Offline & Privacy Focused”（100% 离线，专注隐私保护）。

*Subtitle Translation* 是一款功能强大的 iOS 应用，旨在通过先进的 API 接口，实现实时音频流的采集、识别，并将其瞬间翻译为用户所需的语言，以浮窗字幕的形式展示。无论是在跨国会议、线上课程还是观看无字幕外语视频时，都能为您提供流畅的交流和理解体验。

## ✨ 功能特性

* ✅ **实时语音识别**: 准确采集并识别本地或麦克风输入的音频流。
* ✅ **多语言翻译**: 支持 (例如: 英语、中文、日语、韩语等 XX 种) 语言之间的互译。
* ✅ **低延迟展示**: 翻译结果以接近实时的速度在屏幕上展示为字幕。

## 📸 应用截图

| 核心界面 | 实时翻译界面 | 设置界面 |
| :--- | :--- | :--- |
| <img src="Screenshots/main_screen.png" width="250" alt="Main Screen"> | <img src="Screenshots/translation_screen.png" width="250" alt="Translation Screen"> | <img src="Screenshots/settings_screen.png" width="250" alt="Settings Screen"> |

## 🚀 快速开始

### 开发环境要求

* **Xcode**: (例如: 15.3+)
* **iOS**: (例如: 17.0+)
* **Swift**: (例如: 5.10+)

### API 密钥配置 (关键)

本项目使用第三方服务进行语音识别和翻译。在运行项目之前，你需要：

1.  从 (例如: Azure Cognitive Services / Google Cloud Speech-to-Text / DeepL API 等) 获取 API 密钥。
2.  在 Xcode 项目中找到配置文件 (例如: `Config.swift` 或 `Secrets.xcconfig`)。
3.  将你的 API 密钥填入对应的变量中:
    ```swift
    // Example:
    static let apiKey = "YOUR_API_KEY_HERE"
    ```
    > **⚠️ 安全提醒:** 请确保你已将包含真实密钥的文件添加到了 `.gitignore` 中，防止其被公开。本项目提供了一个名为 `Config.example.swift` 的模板文件供参考。

### 安装与运行

1.  克隆本仓库:
    ```bash
    git clone [https://github.com/(你的用户名)/(你的仓库名).git](https://github.com/(你的用户名)/(你的仓库名).git)
    ```
2.  (可选) 如果使用了 CocoaPods 或 Swift Package Manager:
    ```bash
    cd (项目目录)
    # 如果是 CocoaPods
    pod install
    ```
3.  双击打开 `(项目名).xcodeproj` (或 `(项目名).xcworkspace`)。
4.  在 Xcode 中选择你的模拟器或真机。
5.  点击运行按钮 (或按下 `Cmd + R`)。

## 🛠️ 技术栈

* **语言**: Swift
* **UI 框架**: (例如: SwiftUI / UIKit)
* **核心技术**:
    * (例如: `AVFoundation` 进行音频采集)
    * (例如: `Speech` 框架或 `WebSockets` 与云端 API 交互)
* **第三方库**: (例如: `Alamofire` 网络请求, `SwiftyJSON` 解析数据)

## 👤 作者

* **(你的名字)** - (例如: iOS Developer / Student)
* GitHub: [@(你的用户名)](https://github.com/bnds1037))
* Email: (例如: bnds.hust.1037@gmail.com - 可选)

## 📄 许可证

本项目采用 MIT 许可证 - 详情请参阅 [LICENSE](LICENSE) 文件。
