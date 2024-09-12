import 'package:flutter/material.dart';

class WindowWidget extends StatefulWidget {
  final String title;
  final Widget content;
  final VoidCallback onClose;
  final VoidCallback onMinimize;
  final VoidCallback onMaximize;
  final VoidCallback onTap;
  final bool maximized;

  WindowWidget({
    required this.title,
    required this.content,
    required this.onClose,
    required this.onMinimize,
    required this.onMaximize,
    required this.onTap,
    this.maximized = false,
  });

  @override
  _WindowWidgetState createState() => _WindowWidgetState();
}

class _WindowWidgetState extends State<WindowWidget> {
  Offset position = Offset(100, 100); // Initial position
  late Size windowSize;
  late Offset dragStart;
  late Size dragStartSize;
  final double resizeMargin = 16.0;

  @override
  void initState() {
    super.initState();
    windowSize = Size(300, 300); // Default window size
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (widget.maximized) return; // Disable dragging when maximized

    final screenSize = MediaQuery.of(context).size;
    final newPosition = Offset(
      position.dx + details.delta.dx,
      position.dy + details.delta.dy,
    );

    setState(() {
      position = Offset(
        newPosition.dx.clamp(0.0, screenSize.width - windowSize.width),
        newPosition.dy.clamp(0.0,
            screenSize.height - windowSize.height - 50), // Taskbar height = 50
      );
    });
  }

  void _handleResizeUpdate(DragUpdateDetails details) {
    setState(() {
      windowSize = Size(
        (windowSize.width + details.delta.dx).clamp(100.0, 800.0),
        (windowSize.height + details.delta.dy).clamp(100.0, 800.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.maximized ? 0 : position.dx,
      top: widget.maximized ? 0 : position.dy,
      child: MouseRegion(
        cursor: _getCursor(),
        child: GestureDetector(
          onTap: widget.onTap,
          onPanUpdate: _handlePanUpdate,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 50),
                width: widget.maximized
                    ? MediaQuery.of(context).size.width
                    : windowSize.width,
                height: widget.maximized
                    ? MediaQuery.of(context).size.height - 50
                    : windowSize.height, // Adjust for taskbar
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    // Window title bar
                    Container(
                      height: 30,
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.title,
                                style: TextStyle(color: Colors.white)),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.minimize,
                                    size: 16, color: Colors.white),
                                onPressed: widget.onMinimize,
                              ),
                              IconButton(
                                icon: Icon(
                                  widget.maximized
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                onPressed: widget.onMaximize,
                              ),
                              IconButton(
                                icon: Icon(Icons.close,
                                    size: 16, color: Colors.white),
                                onPressed: widget.onClose,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Window content area
                    Expanded(child: widget.content),
                  ],
                ),
              ),
              // Resizable edges
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onPanUpdate: _handleResizeUpdate,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeDown,
                    child: Container(
                      width: resizeMargin,
                      height: resizeMargin,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Determine cursor based on mouse position relative to window edges
  MouseCursor _getCursor() {
    final cursorPosition = Offset(
      (windowSize.width - resizeMargin) < resizeMargin
          ? resizeMargin
          : windowSize.width,
      (windowSize.height - resizeMargin) < resizeMargin
          ? resizeMargin
          : windowSize.height,
    );

    if (position.dx <= resizeMargin || position.dy <= resizeMargin) {
      return SystemMouseCursors.resizeColumn;
    } else if (position.dx >= (windowSize.width - resizeMargin) &&
        position.dy >= (windowSize.height - resizeMargin)) {
      return SystemMouseCursors.resizeColumn;
    } else if (position.dx <= resizeMargin &&
        position.dy >= (windowSize.height - resizeMargin)) {
      return SystemMouseCursors.resizeColumn;
    } else if (position.dx >= (windowSize.width - resizeMargin) &&
        position.dy <= resizeMargin) {
      return SystemMouseCursors.resizeColumn;
    }
    return SystemMouseCursors.basic;
  }
}
