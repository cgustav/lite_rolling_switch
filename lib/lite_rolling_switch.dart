library lite_rolling_switch;

import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';

class LiteRollingSwitch extends StatefulWidget {
  @required
  final bool initialState;
  @required
  final Function(bool) onChanged;
  final double width;
  final double height;
  final Text textOff;
  final Text textOn;
  final Color colorOn;
  final Color colorOff;
  final Duration animationDuration;
  final IconData iconOn;
  final IconData iconOff;
  final Function onTap;
  final Function onDoubleTap;
  final Function onSwipe;

  LiteRollingSwitch({
    this.initialState = false,
    this.width = 130.0,
    this.height = 50.0,
    this.textOff,
    this.textOn,
    this.colorOn = Colors.green,
    this.colorOff = Colors.red,
    this.iconOff = Icons.flag,
    this.iconOn = Icons.check,
    this.animationDuration = const Duration(milliseconds: 2600),
    this.onTap,
    this.onDoubleTap,
    this.onSwipe,
    this.onChanged,
  })  : assert(initialState != null && onChanged != null),
        assert(height >= 50);

  @override
  _RollingSwitchState createState() => _RollingSwitchState();
}

class _RollingSwitchState extends State<LiteRollingSwitch> with SingleTickerProviderStateMixin {
  double maxWidthRotation = 0.0;
  double innerSize = 0.0;
  final int _margin = 10;

  AnimationController animationController;
  Animation<double> animation;
  Animation<double> animationOpacityOut;
  Animation<double> animationOpacityIn;
  double value = 0.0;

  bool turnState;

  @override
  void initState() {
    super.initState();
    innerSize = widget.height - _margin;
    maxWidthRotation = (widget.width - innerSize - _margin);

    animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: widget.animationDuration,
    );
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    animationOpacityOut = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    animationOpacityIn = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.45, 1.0, curve: Curves.easeInOut),
      ),
    );

    animationController.addListener(() {
      setState(() {
        value = animation.value;
      });
    });
    turnState = widget.initialState;
    _determine();
  }

  @override
  Widget build(BuildContext context) {
    Color transitionColor = Color.lerp(widget.colorOff, widget.colorOn, value);
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
      child: Container(
        padding: EdgeInsets.all(5),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: transitionColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: Offset(10 * value, 0), //original
              child: FadeTransition(
                opacity: animationOpacityOut,
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  height: 40,
                  child: widget.textOff,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(10 * (1 - value), 0), //original
              child: FadeTransition(
                opacity: animationOpacityIn,
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 5),
                  alignment: Alignment.centerLeft,
                  height: 40,
                  child: widget.textOn,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(maxWidthRotation * value, 0),
              child: Transform.rotate(
                angle: lerpDouble(0, 2 * pi, value),
                child: Container(
                  height: innerSize,
                  width: innerSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: FadeTransition(
                          opacity: animationOpacityOut,
                          child: Icon(
                            widget.iconOff,
                            size: innerSize / 2,
                            color: transitionColor,
                          ),
                        ),
                      ),
                      Center(
                        child: FadeTransition(
                          opacity: animationOpacityIn,
                          child: Icon(
                            widget.iconOn,
                            size: innerSize / 2,
                            color: transitionColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  _action() {
    _determine(changeState: true);
  }

  _determine({bool changeState = false}) {
    setState(() {
      if (changeState) turnState = !turnState;
      (turnState) ? animationController.forward() : animationController.reverse();

      widget.onChanged(turnState);
    });
  }
}
