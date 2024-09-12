import 'package:flutter/material.dart';
import 'package:portfolio_retro/window_config.dart';
import 'window_widget.dart';
import 'taskbar.dart';

class Desktop extends StatefulWidget {
  @override
  _DesktopState createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  List<WindowConfig> openWindows = [];
  bool startMenuVisible = false;

  // Open a new window
  void openNewWindow(String windowTitle, Widget content) {
    setState(() {
      if (!openWindows.any((win) => win.title == windowTitle)) {
        openWindows.add(WindowConfig(title: windowTitle, content: content));
      }
    });
  }

  // Close an open window
  void closeWindow(int index) {
    setState(() {
      openWindows.removeAt(index);
    });
  }

  // Minimize an open window
  void minimizeWindow(int index) {
    setState(() {
      openWindows[index].minimized = !openWindows[index].minimized;
    });
  }

  // Maximize or Restore an open window
  void maximizeWindow(int index) {
    setState(() {
      openWindows[index].maximized = !openWindows[index].maximized;
    });
  }

  // Bring a window to the front
  void bringWindowToFront(int index) {
    setState(() {
      final window = openWindows.removeAt(index);
      openWindows.add(window);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Desktop background
        Container(
          color: Color(0xFF008080), // Windows 95 default background color
          child: Stack(
            children: [
              // Desktop Icons
              _buildDesktopIcon('About Me', Icons.person, () {
                openNewWindow('About Me', Center(child: Text('About Me Content')));
              }),
              _buildDesktopIcon('Projects', Icons.work, () {
                openNewWindow('Projects', Center(child: Text('Projects Content')));
              }),
              _buildDesktopIcon('Experience', Icons.history, () {
                openNewWindow('Experience', Center(child: Text('Experience Content')));
              }),
            ],
          ),
        ),

        // Open Windows
        ...openWindows.asMap().entries.map((entry) {
          int index = entry.key;
          WindowConfig windowConfig = entry.value;

          return windowConfig.minimized
              ? SizedBox.shrink() // Don't show minimized windows
              : WindowWidget(
                  title: windowConfig.title,
                  content: windowConfig.content,
                  onClose: () => closeWindow(index),
                  onMinimize: () => minimizeWindow(index),
                  onMaximize: () => maximizeWindow(index),
                  onTap: () => bringWindowToFront(index),
                  maximized: windowConfig.maximized,
                );
        }).toList(),

        // Taskbar with Start Menu and minimized windows
        Taskbar(
          openWindows: openWindows,
          startMenuVisible: startMenuVisible,
          toggleStartMenu: () {
            setState(() {
              startMenuVisible = !startMenuVisible;
            });
          },
          onWindowSelected: (index) {
            setState(() {
              openWindows[index].minimized = false;
              bringWindowToFront(index);
            });
          },
        ),

        // Start Menu
        if (startMenuVisible)
          Positioned(
            left: 0,
            bottom: 50,
            child: _buildStartMenu(),
          ),
      ],
    );
  }

  // Desktop Icon Builder
  Widget _buildDesktopIcon(String title, IconData icon, VoidCallback onOpen) {
    return Positioned(
      left: 20,
      top: title == 'About Me'
          ? 20
          : title == 'Projects'
              ? 100
              : 180, // Offset different icons vertically
      child: GestureDetector(
        onDoubleTap: onOpen,
        child: Column(
          children: [
            Icon(icon, size: 50, color: Colors.white),
            Text(title, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // Start Menu Builder
  Widget _buildStartMenu() {
    return Container(
      width: 200,
      height: 250,
      color: Colors.grey[800],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.folder, color: Colors.white),
            title: Text('Programs', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Open Programs
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text('About Me', style: TextStyle(color: Colors.white)),
            onTap: () {
              openNewWindow('About Me', Center(child: Text('About Me Content')));
            },
          ),
          ListTile(
            leading: Icon(Icons.work, color: Colors.white),
            title: Text('Projects', style: TextStyle(color: Colors.white)),
            onTap: () {
              openNewWindow('Projects', Center(child: Text('Projects Content')));
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: Colors.white),
            title: Text('Experience', style: TextStyle(color: Colors.white)),
            onTap: () {
              openNewWindow('Experience', Center(child: Text('Experience Content')));
            },
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new, color: Colors.white),
            title: Text('Shut Down', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Shut Down the App
            },
          ),
        ],
      ),
    );
  }
}
