// ignore_for_file: invalid_override_of_non_virtual_member

import 'package:flutter/material.dart';

@immutable
class RebuildBoundary extends StatelessWidget {
  const RebuildBoundary({
    Key? key,
    required this.keys,
    required this.child,
  }) : super(key: key);

  final List<Object?> keys;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  int get hashCode =>
      keys.fold(0, (value, element) => value ^ element.hashCode);

  @override
  bool operator ==(Object other) {
    return other is RebuildBoundary && hashCode == other.hashCode;
  }
}
