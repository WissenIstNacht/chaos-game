import 'dart:html';

/// This class implements a state machine that manages the page's state.
///
/// The machine manages 3 states: idle, running and pausing. The next state is determined
/// as a function of the user's press of a button and the current state.
class StateManager {
  bool is_running = false;
  bool is_resetting = true;

  State _state = State.idle;
  final ButtonElement _b_run = querySelector('#b_run');
  final ButtonElement _b_reset = querySelector('#b_reset');
  // final SelectElement _dd_form = querySelector('#dd_form');

  StateManager() {
    _b_run.onClick.listen((event) => {pressedRun()});
    _b_reset.onClick.listen((event) => {pressedReset()});
  }

  /// Modifies the page's to reflec state changes.
  void idle2run() {
    // TODO add dropdown selector back in.
    // var start_config = _dd_form.value;
    var start_config = 'fixed';
    switch (start_config) {
      case 'fixed':
        print('works?');
        break;
      case 'insertionSort':
        break;
      default:
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
}

enum State { idle, run, pause }
