<!--
 * @Creator: Odd
 * @Date: 2022-02-05 03:56:00
 * @LastEditTime: 2022-02-28 16:58:47
 * @FilePath: \flutter_music_player\README.md
-->
# EasyMusic 简单音乐

- 项目是个[flutter](https://flutter.dev) 开发的音乐播放器
- 目前是个:poop:山，第一次做比较大的开发，还在不断填坑中，见谅~
- Flutter NetEase（Flutter版网易云音乐）
- 目前仅在移动Android端做适配，暂无其他平台适配计划

# 项目进度

## 目前已经完成

- [x] 登录
- [x] 获取歌单
- [x] 播放音乐

## 正在进行中

- 歌词页面
- 部分代码的重构
- ~~添加对sqlite的支持，减少网络延迟~~

## 计划实现（优先级从上往下递减）

- [ ] 歌词页面
- [ ] 通知栏小组件
- [ ] 支持上一首，下一首播放
- [ ] 支持随机播放，列表循环，单曲循环
- [ ] 调整部分UI，避免遮挡
- [ ] 使用screenUtil提高屏幕的兼容性
- [ ] 对于不能播放的歌曲使用其他源播放
- [ ] 图片背景支持修改
- [ ] 添加黑屏音量键切歌功能

## 已知问题

1. 后台不稳定，有概率被杀（好像建立一个通知栏组件就能解决？！）
2. ~~部分UI背景遮挡文字~~

## 如何减少安装包大小？

- 分别打包可以尽可能减少安装包大小  
`flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi`
- 混淆可以增加逆向难度同时减少安装包大小  
`flutter build apk --obfuscate --split-debug-info=xx`
- 两个一起食用  
`flutter build apk --obfuscate --split-debug-info=debugInfo --target-platform android-arm,android-arm64,android-x64 --split-per-abi`

# 项目支持

## 网易云API

- [NeteaseCloudMusicApi](https://github.com/Binaryify/NeteaseCloudMusicApi)

## 开发使用的插件

- audio_session: ^0.1.6+1 # 音频播放
- just_audio: ^0.9.19 # 音频播放
- dio: ^4.0.4 # 网络请求
- fluttertoast: ^8.0.8 # 弹窗
- flutter_easyloading: ^3.0.3 # loading
- provider: ^6.0.2 # 状态管理
- sp_util: ^2.0.3 # 持久化
- ~~flutter_screenutil: ^5.1.1 # 屏幕适配~~
- cached_network_image: ^3.2.0 # 图片缓存
