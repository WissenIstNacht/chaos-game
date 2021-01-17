import 'dart:html';

/// This class implements a state machine that manages the page's state.
///
/// The machine manages 3 states: idle, running and pausing. The next state is determined
/// as a function of the user's press of a button and the current state.
class StateManager {
  bool is_running = false;
  bool is_resetting = true;

  num framerate = 3.0;
  num sketch_speed;
  State _state = State.idle;

  final ButtonElement _b_run = querySelector('#b_run');
  final ButtonElement _b_reset = querySelector('#b_reset');
  final SelectElement _dd_mode = querySelector('#dd_mode');
  final RangeInputElement _r_speed = querySelector('#r_speed');

  StateManager() {
    sketch_speed = 1000 / framerate;
    _b_run.onClick.listen((event) => {pressedRun()});
    _b_reset.onClick.listen((event) => {pressedReset()});
    _r_speed.onChange.listen((event) => {changedRange()});
  }

  /// Modifies the page's to reflec state changes.
  void idle2run() {
    var start_config = _dd_mode.value;
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
    _b_reset.disabled = false;
    is_running = true;
    is_resetting = false;
    _b_run.text = 'Pause';
  }

  /// Modifies the page's to reflec state changes.
  void run2pause() {
    _state = State.pause;
    is_running = false;
    _b_run.text = 'Continue';
  }

  /// Modifies the page's to reflec state changes.
  void pause2run() {
    _state = State.run;
    is_running = true;
    _b_run.text = 'Pause';
  }

  /// Modifies the page's to reflec state changes.
  void any2idle() {
    _state = State.idle;
    is_running = false;
    is_resetting = true;
    _b_reset.disabled;
    _b_run.text = 'Run';
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
  void pressedReset() {
    any2idle();
  }

  changedRange() {
    framerate = _r_speed.valueAsNumber;
    sketch_speed = 1000 / framerate;
  }
}

enum State { idle, run, pause }
