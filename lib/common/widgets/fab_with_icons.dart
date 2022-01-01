import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/46480221/flutter-floating-action-button-with-speed-dail
class FabWithIcons extends StatefulWidget {
  const FabWithIcons({
    Key? key,
    required this.icons,
    required this.onIconTapped,
  }) : super(key: key);
  final List<IconData> icons;
  final ValueChanged<int> onIconTapped;
  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.icons.length, _buildChild).toList()
        ..add(
          _buildFab(),
        ),
    );
  }

  Widget _buildChild(int index) {
    final backgroundColor = Theme.of(context).colorScheme.secondary;
    const foregroundColor = Colors.white;
    return Container(
      height: 70,
      width: 56,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0,
            1.0 - index / widget.icons.length / 2.0,
            curve: Curves.easeOut,
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: backgroundColor,
          onPressed: () => _onTapped(index),
          child: Icon(widget.icons[index], color: foregroundColor),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      elevation: 2,
      child: const Icon(Icons.wifi),
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}
