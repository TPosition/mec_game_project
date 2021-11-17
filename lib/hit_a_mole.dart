import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mec_game_project/main.dart';
import 'package:sa_v1_migration/sa_v1_migration.dart';
import 'package:animated_background/animated_background.dart';

class GameArea extends StatefulWidget {
  GameArea({Key? key, required this.chance, required this.marks})
      : super(key: key);

  final int chance;
  final int marks;

  @override
  State<GameArea> createState() => _GameAreaState();
}

class _GameAreaState extends State<GameArea> with TickerProviderStateMixin {
  int score = 0;

  updateMarks() {
    setState(() {
      score++;
    });
  }

  ParticleOptions particleOptions = ParticleOptions(
    image: Image.asset('assets/star_icon.png'),
    baseColor: Colors.blue,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.0,
    maxOpacity: 1.0,
    spawnMinSpeed: 30.0,
    spawnMaxSpeed: 70.0,
    spawnMinRadius: 7.0,
    spawnMaxRadius: 15.0,
    particleCount: 40,
  );

  var particlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: particleOptions,
          paint: particlePaint,
        ),
        vsync: this,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Counting(
              chance: widget.chance,
              marks: widget.marks + score,
            ),
            ...Iterable.generate(3).map((i) => rowWith2Moles(updateMarks)),
          ],
        ),
      ),
    );
  }

  Widget rowWith2Moles(final Function() notifyParent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Mole(notifyParent: notifyParent),
        Mole(notifyParent: notifyParent)
      ],
    );
  }
}

class Counting extends StatefulWidget {
  const Counting({
    required this.marks,
    required this.chance,
    Key? key,
  }) : super(key: key);
  final int marks;
  final int chance;

  @override
  State<Counting> createState() => _CountingState();
}

class _CountingState extends State<Counting> {
  late Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => App(
                          marks: widget.marks,
                          chance: widget.chance - 1,
                        )));
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "$_start",
          style: TextStyle(fontSize: 40),
        ),
        Text(widget.marks.toString(), style: TextStyle(fontSize: 20)),
      ],
    );
  }
}

class Mole extends StatefulWidget {
  const Mole({Key? key, required this.notifyParent}) : super(key: key);
  final Function() notifyParent;

  @override
  _MoleState createState() => _MoleState();
}

class _MoleState extends State<Mole> {
  final List<MoleParticle> particles = [];
  final List<NormalMoleParticle> normalParticles = [];

  bool _moleIsVisible = false;
  bool _normalMoleIsVisible = false;

  @override
  void initState() {
    _restartMole();
    _restartNormalMole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: _buildMole(),
    );
  }

  Rendering _buildMole() {
    return Rendering(
      onTick: (time) {
        return {
          _manageParticleLifecycle(time),
          _manageNormalParticleLifecycle(time)
        };
      },
      builder: (context, time) {
        return Stack(
          overflow: Overflow.visible,
          children: [
            if (_moleIsVisible)
              GestureDetector(onTap: () => _hitMole(time), child: _mole()),
            ...particles.map((it) => it.buildWidget(time)),
            if (_normalMoleIsVisible)
              GestureDetector(
                  onTap: () => _hitNormalMole(time), child: _normalMole()),
            ...normalParticles.map((it) => it.buildWidget(time))
          ],
        );
      },
    );
  }

  Widget _mole() {
    return Image.asset('assets/EasyBuyBye_logo.png');
  }

  Widget _normalMole() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.amber.shade900,
          borderRadius: BorderRadius.circular(50)),
    );
  }

  _hitMole(Duration time) {
    _setMoleVisible(false);
    widget.notifyParent();
    Iterable.generate(50).forEach((i) => particles.add(MoleParticle(time)));
  }

  _hitNormalMole(Duration time) {
    _setNormalMoleVisible(false);
    Iterable.generate(50)
        .forEach((i) => normalParticles.add(NormalMoleParticle(time)));
  }

  void _restartMole() async {
    var respawnTime = Duration(milliseconds: 2000 + Random().nextInt(8000));
    await Future.delayed(respawnTime);
    _setMoleVisible(true);

    var timeVisible = Duration(milliseconds: 500 + Random().nextInt(1500));
    await Future.delayed(timeVisible);
    _setMoleVisible(false);

    _restartMole();
  }

  void _restartNormalMole() async {
    var respawnTime = Duration(milliseconds: 2000 + Random().nextInt(8000));
    await Future.delayed(respawnTime);
    _setNormalMoleVisible(true);

    var timeVisible = Duration(milliseconds: 500 + Random().nextInt(1500));
    await Future.delayed(timeVisible);
    _setNormalMoleVisible(false);

    _restartNormalMole();
  }

  _manageParticleLifecycle(Duration time) {
    particles.removeWhere((particle) {
      return particle.progress.progress(time) == 1;
    });
  }

  _manageNormalParticleLifecycle(Duration time) {
    normalParticles.removeWhere((particle) {
      return particle.progress.progress(time) == 1;
    });
  }

  void _setMoleVisible(bool visible) {
    setState(() {
      _moleIsVisible = visible;
    });
  }

  void _setNormalMoleVisible(bool visible) {
    setState(() {
      _normalMoleIsVisible = visible;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class MoleParticle {
  late Animatable tween;
  late AnimationProgress progress;

  MoleParticle(Duration time) {
    final random = Random();
    final x = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);
    final y = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);

    tween = MultiTrackTween([
      Track("x").add(Duration(seconds: 1), Tween(begin: 0.0, end: x)),
      Track("y").add(Duration(seconds: 1), Tween(begin: 0.0, end: y)),
      Track("scale").add(Duration(seconds: 1), Tween(begin: 1.0, end: 0.0))
    ]);
    progress = AnimationProgress(
        startTime: time, duration: Duration(milliseconds: 600));
  }

  buildWidget(Duration time) {
    final animation = tween.transform(progress.progress(time));
    return Positioned(
      left: animation["x"],
      top: animation["y"],
      child: Transform.scale(
        scale: animation["scale"],
        child: SizedBox(
            height: 100,
            width: 100,
            child: Image.asset('assets/EasyBuyBye_logo.png')),
      ),
    );
  }
}

class NormalMoleParticle {
  late Animatable tween;
  late AnimationProgress progress;

  NormalMoleParticle(Duration time) {
    final random = Random();
    final x = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);
    final y = (100 + 200) * random.nextDouble() * (random.nextBool() ? 1 : -1);

    tween = MultiTrackTween([
      Track("x").add(Duration(seconds: 1), Tween(begin: 0.0, end: x)),
      Track("y").add(Duration(seconds: 1), Tween(begin: 0.0, end: y)),
      Track("scale").add(Duration(seconds: 1), Tween(begin: 1.0, end: 0.0))
    ]);
    progress = AnimationProgress(
        startTime: time, duration: Duration(milliseconds: 600));
  }

  buildWidget(Duration time) {
    final animation = tween.transform(progress.progress(time));
    return Positioned(
      left: animation["x"],
      top: animation["y"],
      child: Transform.scale(
        scale: animation["scale"],
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.amber.shade900,
              borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }
}
