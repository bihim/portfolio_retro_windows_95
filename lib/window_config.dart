import 'package:flutter/material.dart';

class WindowConfig {
  final String title;      // The title of the window
  final Widget content;   // The content of the window
  bool minimized;         // Whether the window is minimized
  bool maximized;        // Whether the window is maximized

  WindowConfig({
    required this.title,
    required this.content,
    this.minimized = false,
    this.maximized = false,
  });
}
