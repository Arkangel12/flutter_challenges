import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class GravityItems extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (BuildContext context) => GravityItems(),
    );
  }

  @override
  _GravityItemsState createState() => _GravityItemsState();
}

class _GravityItemsState extends State<GravityItems> {
  Timer timerOne, timerTwo, timerThree;
  final List<Item> initialLayerOne = [];
  final List<Item> initialLayerTwo = [];
  final List<Item> initialLayerThree = [];

  @override
  void initState() {
    super.initState();
    createItem();
  }

  @override
  void dispose() {
    initialLayerOne.clear();
    initialLayerTwo.clear();
    initialLayerThree.clear();
    timerOne?.cancel();
    timerTwo?.cancel();
    timerThree?.cancel();
    super.dispose();
  }

  createItem() {
    timerOne = Timer.periodic(Duration(milliseconds: 1450), (_) {
      Item item = Item(
        duration: math.Random().nextInt(5) + 5,
        posWidth: math.Random().nextInt(100),
      );
      if (mounted) setState(() => initialLayerOne.add(item));
    });

    timerTwo = Timer.periodic(Duration(milliseconds: 1500), (_) {
      Item item = Item(
          duration: math.Random().nextInt(5) + 10,
          posWidth: math.Random().nextInt(100),
          itemSelection: math.Random().nextInt(4));
      if (mounted) setState(() => initialLayerTwo.add(item));
    });

    timerThree = Timer.periodic(Duration(milliseconds: 1550), (_) {
      Item item = Item(
        duration: math.Random().nextInt(5) + 5,
        posWidth: math.Random().nextInt(100),
      );
      if (mounted) setState(() => initialLayerThree.add(item));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1735),
      body: Stack(
        children: <Widget>[
          for (Item item in initialLayerOne) Hearts(item: item),
          for (Item item in initialLayerTwo) Balloons(item: item),
          Center(child: FlutterLogo(size: 300)),
          for (Item item in initialLayerThree) Nerds(item: item),
        ],
      ),
    );
  }
}

class Hearts extends StatefulWidget {
  final Item item;

  const Hearts({Key key, this.item}) : super(key: key);

  @override
  _HeartsState createState() => _HeartsState();
}

class _HeartsState extends State<Hearts> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool _start = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) _controller.reverse();
            if (status == AnimationStatus.dismissed) _controller.forward();
          });
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() => _start = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(seconds: 2 + widget.item.duration),
      top: _start ? MediaQuery.of(context).size.height + 100 : -40,
      left: MediaQuery.of(context).size.width * (widget.item.posWidth / 100),
      child: FadeTransition(
        opacity: _controller,
        child: Text(
          '❤️',
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}

class Balloons extends StatefulWidget {
  final Item item;

  const Balloons({Key key, this.item}) : super(key: key);

  @override
  _BalloonsState createState() => _BalloonsState();
}

class _BalloonsState extends State<Balloons> {
  bool _start = false;
  List<String> _balloons = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() => _start = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(seconds: 2 + widget.item.duration),
      bottom: _start ? MediaQuery.of(context).size.height + 100 : -200,
      left: MediaQuery.of(context).size.width * (widget.item.posWidth / 100),
      child: Image.asset(
        _balloons[widget.item.itemSelection],
        width: 80,
      ),
    );
  }
}

class Nerds extends StatefulWidget {
  final Item item;

  const Nerds({Key key, this.item}) : super(key: key);

  @override
  _NerdsState createState() => _NerdsState();
}

class _NerdsState extends State<Nerds> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  bool _start = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward()
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) _controller.reverse();
            if (status == AnimationStatus.dismissed) _controller.forward();
          });

    _animation = Tween(begin: 0.0, end: 2 * math.pi).animate(_controller);
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() => _start = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(seconds: 2 + widget.item.duration),
      top: _start ? MediaQuery.of(context).size.height + 100 : -40,
      left: MediaQuery.of(context).size.width * (widget.item.posWidth / 100),
      child: AnimatedBuilder(
        animation: _animation,
        child: Text(
          '🤓️',
          style: TextStyle(fontSize: 32),
        ),
        builder: (_, child) => Transform(
            transform: Matrix4.rotationX(_animation.value), child: child),
      ),
    );
  }
}

class Item {
  int duration;
  int posWidth;
  int itemSelection;
  int size;
  Color color;

  Item({
    this.duration,
    this.posWidth,
    this.itemSelection,
    this.size,
    this.color,
  });
}
