import 'package:draggable_menu/src/draggable_menu/menu/ui.dart';
import 'package:draggable_menu/src/draggable_menu/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DraggableMenu extends StatefulWidget {
  final Widget? child;
  final Color? accentColor;
  final Color? color;
  final Duration? animationDuration;
  final double? maxHeight;

  const DraggableMenu(
      {super.key,
      this.child,
      this.accentColor,
      this.color,
      this.animationDuration,
      this.maxHeight});

  static Future<T?>? open<T extends Object?>(
          BuildContext context, Widget draggableMenu,
          {Duration? animationDuration}) =>
      Navigator.maybeOf(context)?.push<T>(
        MenuRoute<T>(
          child: draggableMenu,
          duration: animationDuration,
        ),
      );

  @override
  State<DraggableMenu> createState() => _DraggableMenuState();
}

class _DraggableMenuState extends State<DraggableMenu>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  double _value = 0;
  double _valueStart = 0;
  double? _yAxisStart;
  double _yAxisChange = 0;
  late Ticker _ticker;
  final _widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? const Duration(milliseconds: 320),
    );
    _ticker = createTicker((elapsed) {
      setState(() {
        if (_value > 0) {
          _value = 0;
          _valueStart = 0;
        }
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final double? widgetHeight = _widgetKey.currentContext?.size?.height;
        if (widgetHeight == null) return;
        if (details.globalPosition.dy <
            MediaQuery.of(context).size.height - widgetHeight) {
          Navigator.pop(context);
        }
      },
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: (details) {
        if (_controller.isAnimating) _controller.stop();
        _yAxisStart = details.globalPosition.dy;
      },
      onHorizontalDragUpdate: (details) {
        if (_yAxisStart == null) return;
        if (_value == 0 && _yAxisStart! - details.globalPosition.dy > 0) {
          if (details.globalPosition.dy < _valueStart) return;
          _yAxisStart = details.globalPosition.dy - _valueStart;
        } else {
          _yAxisChange = _yAxisStart! - details.globalPosition.dy;
          _value = _valueStart + _yAxisChange;
        }
      },
      onHorizontalDragEnd: (details) {
        final double? widgetHeight = _widgetKey.currentContext?.size?.height;
        if (widgetHeight == null) return;
        if (-_value / widgetHeight > 0.5) {
          Navigator.pop(context);
        } else {
          Animation<double> animation =
              Tween<double>(begin: _value, end: 0).animate(
            _controller.drive(
              CurveTween(curve: Curves.ease),
            ),
          );
          animation.addListener(() {
            setState(() {
              _value = animation.value;
              _valueStart = _value;
            });
          });
          _controller.reset();
          _controller.forward();
        }
      },
      child: Stack(
        children: [
          Positioned(
            key: _widgetKey,
            bottom: _value,
            child: DraggableMenuUi(
              color: widget.color,
              accentColor: widget.accentColor,
              maxHeight: widget.maxHeight,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
