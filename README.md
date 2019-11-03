# lite_rolling_switch

Full customable rolling switch widget for flutter apps based on Pedro Massango's 'crazy-switch' widget https://github.com/pedromassango/crazy-switch

## About 

Custom Switch button with attractive animation,
made to allow you to customize colors, icons and other cosmetic content. Manage the widget states in the same way you do with the classical material's switch widget.

> **NOTE**: Currently, you cannot directly change the widget width and height properties. This feature will be available soon.


## Previews

![Image preview](https://media.giphy.com/media/hTx1jlMxasyVejHa6U/giphy.gif)

![Image preview 2](https://media.giphy.com/media/TKSIVzM5RUDxnjucTf/giphy.gif)

## Basic Implementation

``` dart
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

LiteRollingSwitch(
    //initial value
    value: true,
    textOn: 'disponible',
    textOff: 'ocupado',
    colorOn: Colors.greenAccent[700],
    colorOff: Colors.redAccent[700],
    iconOn: Icons.done,
    iconOff: Icons.remove_circle_outline,
    textSize: 16.0,
    onChanged: (bool state) {
      //Use it to manage the different states
      print('Current State of SWITCH IS: $state');
    },
),

```

## Other

[](https://pub.dev/packages/lite_rolling_switch#-installing-tab-)
