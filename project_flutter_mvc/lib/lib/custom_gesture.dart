import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class CustomGesture extends StatelessWidget{
  CustomGesture({Key key, this.child, this.onTap}):super(key: key);

  final Widget child;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) => RawGestureDetector(
    behavior: HitTestBehavior.opaque,
    gestures: {
      AllowMultipleTapsGestureRecognizer: GestureRecognizerFactoryWithHandlers<AllowMultipleTapsGestureRecognizer>(
            () => AllowMultipleTapsGestureRecognizer(),
            (AllowMultipleTapsGestureRecognizer instance) => instance.onTap = this.onTap,
      ),
    },
    child: this.child,
  );
}

class AllowMultipleTapsGestureRecognizer extends TapGestureRecognizer
{
  @override
  void acceptGesture(int pointer) {
    super.acceptGesture(pointer);
  }

  @override
  void rejectGesture(int pointer) {
    this.acceptGesture(pointer);
    //super.rejectGesture(pointer);
  }
}