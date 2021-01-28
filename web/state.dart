import 'dart:html';

import 'package:animation_loop/animation_loop.dart';

import 'algorithm_renderer.dart';

abstract class State {
  ChaosGameRenderer sketch;
  AnimationLoop loop;

  void update();
}

class IdleState extends State {
  final ButtonElement _run;

  IdleState(ChaosGameRenderer sketch, AnimationLoop loop, this._run) {
    super.loop = loop;
    super.sketch = sketch;
  }

  @override
  void update() {
    loop.stop();
    sketch.clearCanvas();
    _run.text = 'Run';
  }
}

class RunningState extends State {
  ButtonElement _run;

  RunningState(ChaosGameRenderer sketch, AnimationLoop loop, this._run) {
    super.loop = loop;
    super.sketch = sketch;
  }

  @override
  void update() {
    loop.run(sketch.step);
    _run.text = 'Pause';
  }
}

class PausingState extends State {
  final ButtonElement _run;

  PausingState(ChaosGameRenderer sketch, AnimationLoop loop, this._run) {
    super.sketch = sketch;
    super.loop = loop;
  }

  @override
  void update() {
    loop.stop();
    _run.text = 'Continue';
  }
}
