import 'package:draggable_menu/draggable_menu.dart';
import 'package:example/widgets/modular_menu_example_item.dart';
import 'package:flutter/material.dart';

class StatusDraggableMenu extends StatefulWidget {
  final bool enableExpandedScroll;
  final bool fastDrag;
  final bool minimizeBeforeFastDrag;
  final Type ui;
  final DraggableMenuController? controller;

  const StatusDraggableMenu({
    super.key,
    required this.enableExpandedScroll,
    required this.fastDrag,
    required this.minimizeBeforeFastDrag,
    required this.ui,
    this.controller,
  });

  @override
  State<StatusDraggableMenu> createState() => _StatusDraggableMenuState();
}

class _StatusDraggableMenuState extends State<StatusDraggableMenu> {
  Color _color = Colors.amber;
  String _text = "";
  double _value = 0;
  double _raw = 0;
  double _levelValue = 0;

  @override
  Widget build(BuildContext context) {
    return DraggableMenu(
      controller: widget.controller,
      addStatusListener: (status, level) {
        setState(() {
          if (status == DraggableMenuStatus.canceling) {
            _color = Colors.blue;
            _text = "Canceling";
          }
          if (status == DraggableMenuStatus.closing) {
            _color = Colors.red;
            _text = "Closing";
          }
          if (status == DraggableMenuStatus.expanded) {
            _color = Colors.amber;
            _text = "Expanded (At Level $level)";
          }
          if (status == DraggableMenuStatus.expanding) {
            _color = Colors.blue;
            _text = "Expanding";
          }
          if (status == DraggableMenuStatus.mayClose) {
            _color = Colors.green;
            _text = "May Close";
          }
          if (status == DraggableMenuStatus.willClose) {
            _color = Colors.purple;
            _text = "Will Close";
          }
          if (status == DraggableMenuStatus.willExpand) {
            _color = Colors.purple;
            _text = "Will Expand";
          }
          if (status == DraggableMenuStatus.willMinimize) {
            _color = Colors.purple;
            _text = "Will Minimize";
          }
          if (status == DraggableMenuStatus.mayExpand) {
            _color = Colors.green;
            _text = "May Expand";
          }
          if (status == DraggableMenuStatus.mayMinimize) {
            _color = Colors.green;
            _text = "May Minimize";
          }
          if (status == DraggableMenuStatus.minimized) {
            _color = Colors.amber;
            _text = "Minimized (At Level $level)";
          }
          if (status == DraggableMenuStatus.minimizing) {
            _color = Colors.blue;
            _text = "Minimizing";
          }
        });
      },
      ui: widget.ui == ModernDraggableMenu
          ? ModernDraggableMenu(color: _color)
          : widget.ui == SoftModernDraggableMenu
              ? SoftModernDraggableMenu(color: _color)
              : widget.ui == ModularDraggableMenu
                  ? ModularDraggableMenu(
                      color: _color,
                      items: [
                        const ModularMenuExampleItem(),
                      ],
                    )
                  : ClassicDraggableMenu(color: _color),
      levels: [
        DraggableMenuLevel.ratio(ratio: 1 / 3),
        DraggableMenuLevel.ratio(ratio: 2 / 3),
        DraggableMenuLevel.ratio(ratio: 1),
      ],
      animationDuration: const Duration(seconds: 1),
      fastDrag: widget.fastDrag,
      minimizeBeforeFastDrag: widget.minimizeBeforeFastDrag,
      addValueListener: (value, raw, levelValue) {
        setState(() {
          _value = value;
          _raw = raw;
          _levelValue = levelValue;
        });
      },
      child: _child,
    );
  }

  Widget get _child => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              children: [
                Text(
                  _text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Menu Value: ${_value.toStringAsFixed(3)}\nRaw Value: ${_raw.toStringAsFixed(3)}\nLevel Value: ${_levelValue.toStringAsFixed(3)}\nUI Type: ${widget.ui == ModernDraggableMenu ? "Modern" : widget.ui == SoftModernDraggableMenu ? "Soft Modern" : widget.ui == ModularDraggableMenu ? "Modular" : "Classic"}\nExpanded Scroll: ${widget.enableExpandedScroll ? "True" : "False"}\nFast Drag: ${widget.fastDrag ? "True" : "False"}\nMinimize Before Fast Drag: ${widget.minimizeBeforeFastDrag ? "True" : "False"}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
