<!--
 * @Creator: Odd
 * @Date: 2022-04-10 21:01:33
 * @LastEditTime: 2022-05-20 00:13:17
 * @FilePath: \flutter_easymusic\README.md
-->
# EasyMusic 简单音乐 （目前仍在更新中...）

- 项目是个[flutter](https://flutter.dev) 开发的音乐播放器
- 目前是个:poop:山，第一次做比较大的开发，还在不断填坑中，见谅~
- Flutter NetEase（Flutter版网易云音乐）
- 目前仅在移动Android端做适配，暂无其他平台适配计划

# 项目进度

## 目前已经完成

- [x] 登录
- [x] 获取登录用户的歌单
- [x] 播放音乐
- [x] 通知栏小组件
- [x] UI重构
- [x] 支持上一首，下一首播放
- [x] 调整部分UI，避免遮挡
- [x] 歌词页面

## 正在进行中

- 歌词页面
- ~~UI重构~~
- ~~添加对sqlite的支持，减少网络延迟~~

## 计划实现（优先级从上往下递减）

- [ ] 支持随机播放，列表循环，单曲循环
- [ ] 使用screenUtil提高屏幕的兼容性
- [ ] 对于不能播放的歌曲使用其他源播放
- [ ] 图片背景支持修改
- [ ] 添加黑屏音量键切歌功能

## 已知问题

1. ~~后台不稳定，有概率被杀（好像建立一个通知栏组件就能解决？！）~~ (已解决)
2. ~~部分UI背景遮挡文字~~（已解决）

## 如何减少安装包大小？

- 分别打包可以尽可能减少安装包大小  
`flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi`
- 混淆可以增加逆向难度同时减少安装包大小  
`flutter build apk --obfuscate --split-debug-info=xx`
- 两个一起食用  
`flutter build apk --obfuscate --split-debug-info=debugInfo --target-platform android-arm,android-arm64,android-x64 --split-per-abi`

# 项目支持

## 界面设计来源

- [Lokanaka](https://dribbble.com/shots/16270622-Music-Streaming-Mobile-App)

## 网易云API

- [NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi)

## 开发使用的插件

- cupertino_icons: ^1.0.2
- audio_service: ^0.18.4 # 系统通知栏提醒
- audio_session: ^0.1.6+1 # 定义音频的含义，音效/音乐/提醒...
- just_audio: ^0.9.20 # 音乐播放器
- get: ^4.6.1 # 神器！包括：路由管理、状态管理、依赖注入
- dio: ^4.0.4 # 网络请求
- get_storage: ^2.0.3 # 持久化
- audio_video_progress_bar: ^0.5.0
- sliding_up_panel: ^2.0.0+1 # 上滑面板
- shimmer: ^2.0.0 # 占位图
