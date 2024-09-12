import 'package:flutter/material.dart';
import 'desktop.dart';
import 'window_config.dart';

class Taskbar extends StatelessWidget {
  final List<WindowConfig> openWindows;
  final bool startMenuVisible;
  final VoidCallback toggleStartMenu;
  final Function(int index) onWindowSelected;

  Taskbar({
    required this.openWindows,
    required this.startMenuVisible,
    required this.toggleStartMenu,
    required this.onWindowSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[850],
        child: Row(
          children: [
            // Start Button
            GestureDetector(
              onTap: toggleStartMenu,
              child: Container(
                color: startMenuVisible ? Colors.grey[700] : Colors.grey[800],
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.menu, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Start', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),

            // Minimized Windows
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: openWindows.asMap().entries.map((entry) {
                  int index = entry.key;
                  WindowConfig windowConfig = entry.value;

                  return GestureDetector(
                    onTap: () => onWindowSelected(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      margin: EdgeInsets.all(4),
                      color: windowConfig.minimized ? Colors.grey[700] : Colors.grey[600],
                      child: Row(
                        children: [
                          Icon(Icons.window, color: Colors.white),
                          SizedBox(width: 4),
                          Text(windowConfig.title, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Clock (static for now)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '12:00 PM',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
