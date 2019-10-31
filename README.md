# lite_rolling_switch

Full customizable rolling switch widget for flutter apps based on Pedro Massango's 'crazy-switch' widget https://github.com/pedromassango/crazy-switch

## Preview

![Image preview](https://media.giphy.com/media/hTx1jlMxasyVejHa6U/giphy.gif)

## Example

``` dart

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
    mainAction: () {
      //it will work on onTap, onDoubleTap
      //& onDrag events.
      print('Something here!');
    },
    onChanged: (bool state) {
      //Use it to manage the different states
      print('Current State of SWITCH IS: $state');
    },
),

```