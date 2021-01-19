import 'dart:html';

class AnimationLoop {
  num _lastTimeStamp = 0;
  num _animation_speed;

  bool is_running = true;

  AnimationLoop(num framerate) {
    _animation_speed = 1000 / framerate;
  }

  void run(void Function() update) async {
    is_running = true;
    while (is_running) {
      final delta = await window.animationFrame;
      final diff = delta - _lastTimeStamp;
      if (diff > _animation_speed) {
        _lastTimeStamp = delta;
        print('stepping');
        update();
      }
    }
  }

  void stop() => is_running = false;

  set framerate(num framerate) {
    // framerate internally represented as time interval of milliseconds.
    _animation_speed = 1000 / framerate;
  }
}
