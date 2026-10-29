# Vela 60F · 视频日记

Flutter 横屏记录页（首页），基于 Figma 874 × 402 设计稿实现。

## 当前范围

- **取景区**：使用 `camera` 库实时预览，支持前后摄像头切换；无可用相机时显示占位。
- **机械仪表盘**：10 分钟鼓轮刻度、圆柱投影、基准红线、最后一分钟红色端区。
- **录制键**：目前只驱动 10 分钟倒计时，不实际录制；停止后鼓轮会以缓出动画倒带回 10:00。
- **拍照 / 相册**：仅完成 UI，功能待接入。

## 目录结构

```
lib/
├── main.dart                # 入口：锁横屏、沉浸式
├── app.dart                 # MaterialApp 与主题
├── common/
│   └── widgets/             # 跨 feature 复用的通用控件（InnerShadow）
└── features/
    └── record/              # 记录页 feature
        ├── record_page.dart
        ├── recording_controller.dart    # 录制状态、10 分钟倒计时与倒带
        ├── camera_feed_controller.dart  # camera 会话封装
        ├── record_visuals.dart          # 设计稿颜色 / 尺寸 token
        └── widgets/                     # 该 feature 专用的界面部件
```

`test/` 镜像 `lib/` 的路径，`docs/images/` 放文档配图。新增 feature 时在 `lib/features/<name>/` 下平铺页面与 controller，跨 feature 复用的件放到 `lib/common/`。

## 运行

```bash
flutter pub get
flutter run -d <device>
```

应用锁定横屏；相册缩略图当前为设计稿占位图，接入相册后替换。
