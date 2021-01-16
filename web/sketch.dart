import 'dart:html';

import 'dart:math';

import 'stateManager.dart';

class Sketch {
  num _lastTimeStamp = 0;
  num GAME_SPEED;
  CanvasElement canvas;
  CanvasRenderingContext2D ctx;

  List<Point> triangle;
  Point curr_loc, prev_loc, rand_vertex;

  Random rand = Random();

  AnimationPhase animation_phase = AnimationPhase.curr_location;

  StateManager s = StateManager();

  Sketch(double framerate, this.canvas) {
    GAME_SPEED = 1000 / framerate;

    ctx = canvas.getContext('2d');
    canvas.height = 400;
    canvas.width = 600;

    //draw background
    ctx
      ..scale(1, -1)
      ..translate(0, -canvas.height);

    //Define triangle vertices
    var m = Point(canvas.width / 2, canvas.height / 2);

    var h_offset = sin(pi / 3) * canvas.height / 3;
    var v_offset = cos(pi / 3) * canvas.height / 3;

    triangle = [
      Point(m.x, m.y + canvas.height / 3),
      Point(m.x - h_offset, m.y - v_offset),
      Point(m.x + h_offset, m.y - v_offset)
    ];

    //Draw triangle vertices
    ctx.setFillColorRgb(0, 0, 0);
    triangle.forEach((Point p) {
      ctx
        ..beginPath()
        ..arc(p.x, p.y, 2, 0, 2 * pi)
        ..closePath()
        ..fill();
    });

    curr_loc = m;
    prev_loc = Point(-100, -100); //instantiate to location outside canvas.
  }

  Future run() async {
    update(await window.animationFrame);
  }

  void update(num delta) {
    final diff = delta - _lastTimeStamp;

    if (diff > GAME_SPEED) {
      _lastTimeStamp = delta;
      if (s.is_running) drawFrame();
      if (s.is_resetting) _clearCanvas();
    }
    run();
  }

  void drawFrame() {
    switch (animation_phase) {
      case AnimationPhase.curr_location:
        //triangle vertices black, prev location black, current location blue
        ctx.setFillColorRgb(0, 0, 0);

        triangle.forEach((Point p) {
          ctx
            ..beginPath()
            ..arc(p.x, p.y, 4, 0, 2 * pi)
            ..closePath()
            ..fill();
        });
        ctx
          ..beginPath()
          ..arc(prev_loc.x, prev_loc.y, 2, 0, 2 * pi)
          ..closePath()
          ..fill();
        ctx
          ..setFillColorRgb(50, 50, 255)
          ..beginPath()
          ..arc(curr_loc.x, curr_loc.y, 2, 0, 2 * pi)
          ..closePath()
          ..fill();
        animation_phase = AnimationPhase.random_vertex;
        break;
      case AnimationPhase.random_vertex:
        //selected vertex green
        rand_vertex = triangle[rand.nextInt(3)];
        ctx
          ..fillStyle = 'forestGreen'
          ..beginPath()
          ..arc(rand_vertex.x, rand_vertex.y, 4, 0, 2 * pi)
          ..closePath()
          ..fill();
        animation_phase = AnimationPhase.new_location;
        break;
      case AnimationPhase.new_location:
        //new location red
        prev_loc = curr_loc;
        var average_x = (rand_vertex.x + curr_loc.x) / 2;
        var average_y = (rand_vertex.y + curr_loc.y) / 2;
        curr_loc = Point(average_x, average_y);
        ctx
          ..fillStyle = '#8B2222'
          ..beginPath()
          ..arc(curr_loc.x, curr_loc.y, 2, 0, 2 * pi)
          ..closePath()
          ..fill();
        animation_phase = AnimationPhase.curr_location;
        break;
      default:
    }
  }

  void _clearCanvas() {
    ctx
      ..lineWidth = 2
      ..setFillColorRgb(220, 220, 220)
      ..fillRect(0, 0, canvas.width, canvas.height)
      ..strokeRect(0, 0, canvas.width, canvas.height);
  }
}

enum AnimationPhase { curr_location, random_vertex, new_location }
