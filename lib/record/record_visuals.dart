import 'package:flutter/material.dart';

/// 记录页的视觉常量，数值取自 Figma 画板（874 × 402，控制栏 90）。
abstract final class RecordColors {
  static const Color bar = Color(0xFF232323);
  static const Color dialFace = Color(0xFFF7F7F7);
  static const Color ink = Color(0xFF232323);
  static const Color tick = Color(0xFF454545);
  static const Color tickStrong = Color(0xFF282828);
  static const Color accent = Color(0xFFE5484D);
  static const Color record = Color(0xFFFF4A32);
  static const Color recordDeep = Color(0xFFEE2A16);
  static const Color icon = Color(0xFFE6E6E6);
  static const Color keyTop = Color(0xFF2A2A2A);
  static const Color keyUpper = Color(0xFF272727);
  static const Color keyLower = Color(0xFF252525);
  static const Color keyBottom = Color(0xFF222222);
}

/// 所有尺寸都相对 874 × 402 的设计稿，运行时按屏幕等比缩放。
abstract final class RecordMetrics {
  static const double designWidth = 874;
  static const double designHeight = 402;
  static const double barHeight = 90;
  static const double flipKeyWidth = 95;
  static const double keyWidth = 90;
  static const double albumSize = 74;
  static const double albumRadius = 18;
  static const double dialInset = 17.9;

  /// 设计稿相机压暗是 64px；真机上收短，让暗部更贴边。
  static const double stageVignette = 48;

  /// 鼓轮投影：x = 中心 + 振幅 × sin((分钟 - 当前分钟) / 曲率)。
  static const double dialCurve = 2.545;
  static const double dialAmplitude = 300.2;
}
