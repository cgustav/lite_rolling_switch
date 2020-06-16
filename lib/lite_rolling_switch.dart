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
                Transform.translate(
                  offset: Offset(_margin.toInt() * animation.value, 0), //original
                  child: FadeTransition(
                    opacity: animationOpacityOut,
                    child: _TextRight(
                      margin: _margin,
                      size: widget.innerSize,
                      text: widget.textOff,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: animationController,
                  child: _TextLeft(
                    size: widget.innerSize,
                    margin: _margin,
                    text: widget.textOn,
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
                    angle: lerpDouble(0, 2 * pi, animationController.value),
                    child: _CircularContainer(
                      size: widget.innerSize,
                      child: Stack(
                        children: <Widget>[
                          _IconWidget(
                            animationOpacity: animationOpacityOut,
                            iconData: widget.iconOff,
                            size: widget.innerSize / 2,
                            colorValue: animationColor.value,
                          ),
                          _IconWidget(
                            animationOpacity: animationOpacityIn,
                            iconData: widget.iconOn,
                            size: widget.innerSize / 2,
                            colorValue: animationColor.value,
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

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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

    animationColor = ColorTween(begin: widget.colorOff, end: widget.colorOn).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  _action() {
    turnState = !turnState;
    (turnState) ? animationController.forward() : animationController.reverse();

    widget.onChanged(turnState);
    /*setState(() {
    
    });*/
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: child,
    );
  }
}

class _IconWidget extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Animation<double> animationOpacity;
  final Color colorValue;

  const _IconWidget({
    Key key,
    @required this.animationOpacity,
    @required this.iconData,
    @required this.size,
    @required this.colorValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: animationOpacity,
        child: Icon(
          iconData,
          size: size,
          color: colorValue,
        ),
      ),
    );
  }
}
