import 'package:draggable_menu/draggable_menu.dart';
import 'package:draggable_menu/src/default/colors.dart';
import 'package:draggable_menu/src/draggable_menu/menu/widgets/default_bar_item.dart';
import 'package:flutter/material.dart';

class ModularDraggableMenu extends CustomDraggableMenu {
  /// Adds a items inside the Draggable Menu's UI.
  ///
  /// Items will be placed under the child widget's module.
  ///
  /// Each item will be seperated with modules.
  final List<Widget> items;

  /// Specifies the gap between modules.
  final double gap;

  /// Overrides the Default Bar Item of the UI.
  final Widget? barItem;

  /// Specifies the Bar Item color of the UI.
  final Color? accentColor;

  /// Specifies the Background color of the UI.
  final Color? color;

  /// Specifies the radius of the UI.
  final double? radius;

  const ModularDraggableMenu({
    this.gap = 16,
    this.barItem,
    this.accentColor,
    this.color,
    this.radius,
    required this.items,
  });

  @override
  Widget buildUi(
    BuildContext context,
    Widget child,
    DraggableMenuStatus status,
    int level,
    double menuValue,
    double? raw,
    double levelValue,
    Duration animationDuration,
    Curve curve,
  ) {
    final List<Widget> children = [child, ...items];
    return Column(
      children: [
        for (int i = 0; i < children.length; i++)
          _modul(
            child: children[i],
            style: i == 0
                ? _ModulStyle.first
                : i == children.length - 1
                    ? _ModulStyle.last
                    : _ModulStyle.normal,
            expandable: i == 0,
          ),
      ],
    );
  }

  Widget _modul({
    required Widget child,
    _ModulStyle style = _ModulStyle.normal,
    bool expandable = false,
  }) {
    return Expanded(
      flex: expandable ? 1 : 0,
      child: Padding(
        padding: style == _ModulStyle.first
            ? EdgeInsets.fromLTRB(16, 16, 16, gap / 2)
            : style == _ModulStyle.last
                ? EdgeInsets.fromLTRB(16, gap / 2, 16, 16)
                : EdgeInsets.fromLTRB(16, gap / 2, 16, gap / 2),
        child: Material(
          animationDuration: Duration.zero,
          borderRadius: BorderRadius.circular(radius ?? 16),
          color: color ?? DefaultColors.primaryBackground,
          clipBehavior: Clip.hardEdge,
          child: style == _ModulStyle.first
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: barItem ?? DefaultBarItem(color: accentColor),
                    ),
                    Flexible(child: child),
                  ],
                )
              : Align(
                  alignment: Alignment.topLeft,
                  child: child,
                ),
        ),
      ),
    );
  }
}

enum _ModulStyle {
  first,
  normal,
  last,
}
