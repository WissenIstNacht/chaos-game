import 'dart:html';

import 'sketch.dart';

/// This class implements a state machine that manages the page's state.
///
/// The machine manages 3 states: idle, running and pausing. The next state is determined
/// as a function of the user's press of a button and the current state.
class StateManager {
  num framerate = 3.0;
  State _state = State.idle;
  Sketch sketch;

  final ButtonElement _run = querySelector('#b_run');
  final ButtonElement _reset = querySelector('#b_reset');
  final SelectElement _mode = querySelector('#dd_mode');
  final RangeInputElement _speed = querySelector('#r_speed');

  StateManager() {
    _run.onClick.listen((event) => {pressedRun()});
    _reset.onClick.listen((event) => {pressedReset()});
    _speed.onChange.listen((event) => {changedRange()});

    sketch = Sketch(_speed.valueAsNumber)..run();
  }

  /// Modifies the page's to reflec state changes.
  void idle2run() {
    var start_config = _mode.value;
    // var start_config = 'fixed';
    switch (start_config) {
      case 'fixed':
        print('fixed');
        break;
      case 'start':
        print('set triangle');
        break;
      case 'all':
        print('free');
        break;
      default:
        print('lel nope');
        break;
    }
    _state = State.run;
    _reset.disabled = false;
    sketch.is_running = true;
    sketch.is_resetting = false;
    _run.text = 'Pause';
  }

  /// Modifies the page's to reflec state changes.
  void run2pause() {
    _state = State.pause;
    sketch.is_running = false;
    _run.text = 'Continue';
  }

  /// Modifies the page's to reflec state changes.
  void pause2run() {
    _state = State.run;
    sketch.is_running = true;
    _run.text = 'Pause';
  }

  /// Modifies the page's to reflec state changes.
  void any2idle() {
    _state = State.idle;
    sketch.is_running = false;
    sketch.is_resetting = true;
    _reset.disabled;
    _run.text = 'Run';
  }

  /// Callback for clicked button.
  ///
  /// Determines the next state based the current state.
  void pressedRun() {
    switch (_state) {
      case State.idle:
        idle2run();
        break;
      case State.run:
        run2pause();
        break;
      case State.pause:
        pause2run();
        break;
      default:
        print('State machine in undefined state!');
        break;
    }
  }

  /// Callback for clicked button.
  ///
  /// Determines the next state based the current state.
  void pressedReset() => any2idle();

  /// Callback for cahnged range slider.
  ///
  /// Determines the sketch's animation speed.
  void changedRange() => sketch.framerate = _speed.valueAsNumber;
}

enum State { idle, run, pause }
