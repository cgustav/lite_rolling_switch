library lite_rolling_switch;

import 'dart:ffi';

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
  final double innerSize;
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
    this.innerSize = 40.0,
    this.textOff,
    this.textOn,
    this.colorOn = Colors.green,
    this.colorOff = Colors.red,
    this.iconOff = Icons.flag,
    this.iconOn = Icons.check,
    this.animationDuration = const Duration(milliseconds: 600),
    this.onTap,
    this.onDoubleTap,
    this.onSwipe,
    this.onChanged,
  })  : assert(initialState != null && onChanged != null),
        assert(height >= 50.0 && innerSize >= 40.0);

  @override
  _RollingSwitchState createState() => _RollingSwitchState();
}

class _RollingSwitchState extends State<LiteRollingSwitch> with SingleTickerProviderStateMixin {
  final double _margin = 10.0;
  double maxWidthRotation = 0.0;
  double value = 0.0;

  final _colorNotifier = ValueNotifier<double>(0.0);

  AnimationController animationController;
  Animation<double> animation;
  Animation<double> animationOpacityOut;
  Animation<double> animationOpacityIn;
  Animation<Color> animationColor;

  bool turnState = true;

  @override
  void initState() {
    super.initState();
    maxWidthRotation = (widget.width - widget.innerSize - _margin);

    animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
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
    //Color transitionColor = Color.lerp(widget.colorOff, widget.colorOn, animation.value);

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
          padding: EdgeInsets.all(5),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: animationColor.value,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Stack(
              children: <Widget>[
                AnimatedBuilder(
                  animation: animationController,
                  child: Container(
                    padding: EdgeInsets.only(right: _margin),
                    alignment: Alignment.centerRight,
                    height: widget.innerSize,
                    child: widget.textOff,
                  ),
                  builder: (_, child) => Transform.translate(
                    offset: Offset(_margin.toInt() * animation.value, 0), //original
                    child: FadeTransition(
                      opacity: animationOpacityOut,
                      child: child,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: animationController,
                  child: Container(
                    padding: EdgeInsets.only(left: _margin),
                    alignment: Alignment.centerLeft,
                    height: widget.innerSize,
                    child: widget.textOn,
                  ),
                  builder: (_, child) => Transform.translate(
                    offset: Offset(_margin.toInt() * (1 - animation.value), 0), //original
                    child: FadeTransition(
                      opacity: animationOpacityIn,
                      child: child,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: animationController,
                  child: Transform.rotate(
                    angle: lerpDouble(0, 2 * pi, animation.value),
                    child: Container(
                      height: widget.innerSize,
                      width: widget.innerSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: AnimatedBuilder(
                              animation: animationController,
                              builder: (context, child) => FadeTransition(
                                opacity: animationOpacityOut,
                                child: Icon(
                                  widget.iconOff,
                                  size: widget.innerSize / 2,
                                  color: animationColor.value,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: AnimatedBuilder(
                              animation: animationController,
                              builder: (context, child) => FadeTransition(
                                opacity: animationOpacityIn,
                                child: Icon(
                                  widget.iconOn,
                                  size: widget.innerSize / 2,
                                  color: animationColor.value,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  builder: (_, child) => Transform.translate(
                    offset: Offset(maxWidthRotation * animation.value, 0),
                    child: child,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initAllAnimation() {
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

    animationColor = ColorTween(begin: widget.colorOn, end: widget.colorOff).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    /*animationColor = TweenSequence<Color>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: widget.colorOff,
            end: widget.colorOn,
          ),
        ),
      ],
    );*/

    animationController.addListener(() {
      _colorNotifier.value = animationController.value;
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    _colorNotifier.dispose();
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
