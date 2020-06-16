library lite_rolling_switch;

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// Customable and attractive Switch button.
///
/// As well as the classical Switch Widget
/// from flutter material, the following
/// arguments are required:
///
/// * [value] determines whether this switch is on or off.
/// * [onChanged] is called when the user toggles the switch on or off.
///
/// If you don't set these arguments you would
/// experiment errors related to animationController
/// states or any other undesirable behavior, please
/// don't forget to set them.
class LiteRollingSwitch extends StatefulWidget {
  @required
  final bool initialState;
  @required
  final Function(bool) onChanged;
  final double width;
  final double height;
  final double innerSize;
  final Text textOff;
  final Text textOn;
  final Color colorOn;
  final Color colorOff;
  final Duration animationDuration;
  final IconData iconOn;
  final IconData iconOff;
  final Color colorIconOn;
  final Color colorIconOff;
  final Function onTap;
  final Function onDoubleTap;
  final Function onSwipe;

  const LiteRollingSwitch({
    this.initialState = false,
    this.width = 130.0,
    this.height = 50.0,
    this.innerSize = 40.0,
    this.textOff,
    this.textOn,
    this.colorOn = Colors.green,
    this.colorOff = Colors.red,
    this.iconOff = Icons.flag,
    this.iconOn = Icons.check,
    this.animationDuration = const Duration(milliseconds: 600),
    this.colorIconOn,
    this.colorIconOff,
    this.onTap,
    this.onDoubleTap,
    this.onSwipe,
    @required this.onChanged,
  })  : assert(initialState != null && onChanged != null),
        assert(height >= 50.0 && innerSize >= 40.0);

  @override
  _RollingSwitchState createState() => _RollingSwitchState();
}

class _RollingSwitchState extends State<LiteRollingSwitch> with SingleTickerProviderStateMixin {
  final double _margin = 10.0;
  double maxWidthRotation = 0.0;
  double value = 0.0;

  AnimationController animationController;
  Animation<double> animation;
  Animation<double> animationOpacityOff;
  Animation<double> animationOpacityOn;
  Animation<Color> animationColor;

  bool turnState = true;

  @override
  void initState() {
    super.initState();
    maxWidthRotation = widget.width - widget.innerSize - _margin;

    animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    initAllAnimation();

    turnState = widget.initialState;
    if (turnState) {
      animationController.value = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        _action();
        if (widget.onDoubleTap != null) widget.onDoubleTap();
      },
      onTap: () {
        _action();
        if (widget.onTap != null) widget.onTap();
      },
      onPanEnd: (details) {
        _action();
        if (widget.onSwipe != null) widget.onSwipe();
        //widget.onSwipe();
      },
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) => Container(
          padding: const EdgeInsets.all(5),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: animationColor.value,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(_margin.toInt() * animation.value, 0), //original
                  child: FadeTransition(
                    opacity: animationOpacityOff,
                    child: _TextRight(
                      margin: _margin,
                      size: widget.innerSize,
                      text: widget.textOff,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(_margin.toInt() * (1 - animation.value), 0), //original
                    child: FadeTransition(
                      opacity: animationOpacityOn,
                      child: child,
                    ),
                  ),
                  child: _TextLeft(
                    size: widget.innerSize,
                    margin: _margin,
                    text: widget.textOn,
                  ),
                ),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (_, child) => Transform.translate(
                    offset: Offset(maxWidthRotation * animation.value, 0),
                    child: child,
                  ),
                  child: Transform.rotate(
                    angle: lerpDouble(0, 2 * math.pi, animationController.value),
                    child: _CircularContainer(
                      size: widget.innerSize,
                      child: Stack(
                        children: <Widget>[
                          _IconWidget(
                            animationOpacity: animationOpacityOff,
                            iconData: widget.iconOff,
                            size: widget.innerSize / 2,
                            colorValue: animationColor.value,
                            iconColor: widget.colorIconOff,
                          ),
                          _IconWidget(
                            animationOpacity: animationOpacityOn,
                            iconData: widget.iconOn,
                            size: widget.innerSize / 2,
                            colorValue: animationColor.value,
                            iconColor: widget.colorIconOn,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void initAllAnimation() {
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    animationOpacityOff = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    animationOpacityOn = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.45, 1.0, curve: Curves.easeInOut),
      ),
    );

    animationColor = ColorTween(begin: widget.colorOff, end: widget.colorOn).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  void _action() {
    turnState = !turnState;
    turnState ? animationController.forward() : animationController.reverse();
    widget.onChanged(turnState);
  }
}

class _TextRight extends StatelessWidget {
  final double margin;
  final double size;
  final Text text;

  const _TextRight({Key key, this.margin, this.size, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: margin),
      alignment: Alignment.centerRight,
      height: size,
      child: text,
    );
  }
}

class _TextLeft extends StatelessWidget {
  final double margin;
  final double size;
  final Text text;

  const _TextLeft({Key key, this.margin, this.size, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: margin),
      alignment: Alignment.centerLeft,
      height: size,
      child: text,
    );
  }
}

class _CircularContainer extends StatelessWidget {
  final double size;
  final Widget child;

  const _CircularContainer({
    Key key,
    this.size,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: child,
    );
  }
}

class _IconWidget extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final double size;
  final Animation<double> animationOpacity;
  final Color colorValue;

  const _IconWidget({
    Key key,
    @required this.animationOpacity,
    @required this.iconData,
    @required this.size,
    @required this.colorValue,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: animationOpacity,
        child: Icon(
          iconData,
          size: size,
          color: (iconColor != null) ? iconColor : colorValue,
        ),
      ),
    );
  }
}
