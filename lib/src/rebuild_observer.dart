import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

mixin StatelessRebuildObserver on StatelessWidget {
  @override
  StatelessElement createElement() => _RebuildObserverStatelessElement(
        this,
        Logger(runtimeType.toString()),
      );
}

mixin StatefulRebuildObserver on StatefulWidget {
  @override
  StatefulElement createElement() => _RebuildObserverStatefulElement(
        this,
        Logger(runtimeType.toString()),
      );
}

mixin _RebuildObserverComponentElement<W extends Widget> on ComponentElement {
  Logger get log;

  String trigger = '';
  int counter = 0;

  @override
  Widget build() {
    log.finer('build');
    final currentTrigger = trigger;
    trigger = '';
    counter++;
    final color = Colors.accents[counter % Colors.accents.length];
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        super.build(),
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: color,
                  width: 2.0,
                ),
              ),
              child: Text(
                'build count: $counter, triggered by $currentTrigger',
                style: TextStyle(
                  inherit: false,
                  color: color,
                  backgroundColor: Colors.white,
                  fontSize: 10.0,
                  fontStyle: FontStyle.normal,
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void rebuild() {
    log.finer('rebuild');
    super.rebuild();
  }

  @override
  void reassemble() {
    log.finer('reassemble');
    trigger = 'reassemble';
    super.reassemble();
  }

  @override
  void update(W newWidget) {
    log.finer('update');
    trigger = 'update';
    super.update(newWidget);
  }

  @override
  void activate() {
    log.finer('activate');
    super.activate();
  }

  @override
  void deactivate() {
    log.finer('deactivate');
    super.deactivate();
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    log.finer('mount');
    trigger = 'mount';
    super.mount(parent, newSlot);
  }

  @override
  void unmount() {
    log.finer('unmount');
    super.unmount();
  }

  @override
  InheritedWidget dependOnInheritedElement(
    Element ancestor, {
    Object? aspect,
  }) {
    log.finer('dependOnInheritedElement');
    return super
        .dependOnInheritedElement(ancestor as InheritedElement, aspect: aspect);
  }

  @override
  void didChangeDependencies() {
    log.finer('didChangeDependencies');
    trigger = 'didChangeDependencies';
    super.didChangeDependencies();
  }

  @override
  void markNeedsBuild() {
    log.finer('markNeedsBuild');
    if (trigger == '') {
      trigger = 'internal markNeedsBuild';
    }
    super.markNeedsBuild();
  }

  @override
  void performRebuild() {
    log.finer('performRebuild');
    super.performRebuild();
  }
}

class _RebuildObserverStatefulElement extends StatefulElement
    with _RebuildObserverComponentElement<StatefulWidget> {
  _RebuildObserverStatefulElement(StatefulWidget widget, this.log)
      : super(widget) {
    log.finer('constructor');
  }

  @override
  final Logger log;
}

class _RebuildObserverStatelessElement extends StatelessElement
    with _RebuildObserverComponentElement<StatelessWidget> {
  _RebuildObserverStatelessElement(StatelessWidget widget, this.log)
      : super(widget) {
    log.finer('constructor');
  }

  @override
  final Logger log;
}
