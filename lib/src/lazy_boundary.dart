import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

abstract class LazyUntil {}

class LazyUntilTransitioned implements LazyUntil {
  const LazyUntilTransitioned();
}

@immutable
class LazyUntilNonNull implements LazyUntil {
  const LazyUntilNonNull(this.keys);

  final List<Object?> keys;

  @override
  int get hashCode => keys.fold(0, (acc, key) => acc ^ key.hashCode);

  @override
  bool operator ==(Object other) =>
      other is LazyUntilNonNull &&
      keys.length == other.keys.length &&
      keys.every((key) => other.keys.contains(key));
}

class LazyBoundary extends StatefulWidget {
  const LazyBoundary({
    Key? key,
    this.duration = _defaultDuration,
    this.until = const LazyUntilTransitioned(),
    this.placeholderBuilder = _defaultPlaceholderBuilder,
    required this.builder,
  })  : sliver = false,
        super(key: key);

  const LazyBoundary.sliver({
    Key? key,
    this.duration = _defaultDuration,
    this.until = const LazyUntilTransitioned(),
    this.placeholderBuilder = _defaultSliverPlaceholderBuilder,
    required this.builder,
  })  : sliver = true,
        super(key: key);

  final bool sliver;
  final Duration duration;
  final LazyUntil until;
  final WidgetBuilder placeholderBuilder;
  final WidgetBuilder builder;

  @override
  State<StatefulWidget> createState() => _LazyBoundaryState();
}

class _LazyBoundaryState extends State<LazyBoundary> {
  bool _lazy = true;
  ModalRoute? _route;

  @override
  void didUpdateWidget(covariant LazyBoundary oldWidget) {
    final until = widget.until;
    if (oldWidget.until == until) return;

    if (until is LazyUntilTransitioned) {
      _route = ModalRoute.of(context);

      if (_route?.animation != null) {
        _listener(_route!.animation!.status);

        if (_route!.isCurrent) {
          _route!.animation!.addStatusListener(_listener);
        }
      }
    }

    if (until is LazyUntilNonNull) {
      setState(() {
        if (until.keys.every((key) => key != null)) {
          _lazy = false;
        } else {
          _lazy = true;
        }
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _route?.animation!.removeStatusListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    final child =
        _lazy ? widget.placeholderBuilder(context) : widget.builder(context);

    if (widget.sliver) {
      return SliverAnimatedSwitcher(
        duration: widget.duration,
        child: child,
      );
    }

    return AnimatedSwitcher(
      duration: widget.duration,
      child: child,
    );
  }

  void _listener(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.dismissed:
      case AnimationStatus.completed:
        setState(() {
          _lazy = false;
        });
        break;
      default:
    }
  }
}

const _defaultDuration = Duration(milliseconds: 250);

Widget _defaultSliverPlaceholderBuilder(BuildContext _) =>
    const SliverToBoxAdapter(key: Key('empty'));
Widget _defaultPlaceholderBuilder(BuildContext _) =>
    const SizedBox.shrink(key: Key('empty'));
