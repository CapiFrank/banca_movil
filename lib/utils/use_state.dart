import 'package:flutter/material.dart';

class UseState<T> {
  T value;
  final void Function(VoidCallback fn) _setState;

  UseState(this.value, this._setState);

  void setValue(T newValue) {
    _setState(() {
      value = newValue;
    });
  }
}
mixin UseStateMixin<T extends StatefulWidget> on State<T> {
  UseState<V> useState<V>(V initialValue) {
    return UseState<V>(initialValue, setState);
  }
}
