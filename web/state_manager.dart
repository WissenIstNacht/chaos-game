import 'dart:html';

import 'algorithm_renderer.dart';
import 'animation_loop.dart';
import 'state.dart';

/// This class implements a state machine that manages the page's state.
///
/// The machine manages 3 states: idle, running and pausing. The next state is determined
/// as a function of the user's press of a button and the current state.
class StateManager {
  num framerate = 3.0;
  AnimationLoop loop;

  Map<State, Map<String, State>> graph;
  IdleState idle_state;
  RunningState running_state;
  PausingState pausing_state;
  State _curr_state;
  ChaosGameRenderer chaos_game = ChaosGameRenderer.FixedStart();

  final ButtonElement _run = querySelector('#b_run');
  final ButtonElement _reset = querySelector('#b_reset');
  final SelectElement _mode = querySelector('#dd_mode');
  final RangeInputElement _speed = querySelector('#r_speed');

  StateManager() {
    loop = AnimationLoop(_speed.valueAsNumber);
    _run.onClick.listen((_) => changeState('run'));
    _reset.onClick.listen((_) => changeState('reset'));
    _speed.onClick.listen((_) => loop.framerate = _speed.valueAsNumber);

    idle_state = IdleState(chaos_game, loop, _run);
    running_state = RunningState(chaos_game, loop, _run);
    pausing_state = PausingState(chaos_game, loop, _run);
    _curr_state = idle_state;

    graph = <State, Map<String, State>>{
      idle_state: <String, State>{'run': running_state},
      running_state: <String, State>{'reset': idle_state, 'run': pausing_state},
      pausing_state: <String, State>{'reset': idle_state, 'run': running_state}
    };
  }

  void changeState(String event) {
    var children = graph[_curr_state];
    _curr_state = children[event];
    _curr_state.update();
  }
}
