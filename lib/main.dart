import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Scroll Animation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Scroll Animation Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final listViewKey = new GlobalKey();
  final listTotalItems = 125;
  final threshold = 0;
  final scrollHeightRatio = 0;
  var listItemKeys = [];
  var listItemRatio = [];
  var listItemScrollListeners = [];
  final scrollController = new ScrollController();

  void scrollListener(index) {
    RenderObject listViewObject =
        listViewKey.currentContext?.findRenderObject();
    RenderObject testObj =
        listItemKeys[index].currentContext?.findRenderObject();
    if (listViewObject == null || testObj == null) return;

    final listViewHeight = listViewObject.paintBounds.height;
    final testObjHeight = testObj.paintBounds.height;

    final testObjTop =
        testObj.getTransformTo(listViewObject).getTranslation().y;

    final a1 = [testObjTop + (testObjHeight / 3), 0].reduce(math.max);
    final a2 = [a1, listViewHeight].reduce(math.min);
    final tr = a2 / (listViewHeight / 2);
    final r = [tr > 1 ? 1 - (tr - 1) : tr, threshold].reduce(math.max);

    setState(() {
      listItemRatio[index] = r;
    });
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < listTotalItems; i++) {
      listItemKeys.add(new GlobalKey());
      listItemRatio.add(1.0);
      scrollController.addListener(() {
        scrollListener(i);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    for (var i = 0; i < listItemKeys.length; i++) {
      scrollController.removeListener(() {
        scrollListener(i);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: ListView.builder(
              key: listViewKey,
              itemCount: listTotalItems,
              controller: scrollController,
              itemBuilder: (context, index) {
                if (index < 25) {
                  return new CustContainer(
                      listItemRatio[index], index, listItemKeys[index]);
                } else if (index < 50) {
                  return new CustRotationYContainer(
                      listItemRatio[index], index, listItemKeys[index]);
                } else if (index < 75) {
                  return new CustRotationXContainer(
                      listItemRatio[index], index, listItemKeys[index]);
                } else if (index < 100) {
                  return new CustRotationXContainer(
                      listItemRatio[index], index, listItemKeys[index]);
                } else {
                  return new CustRotationContainer(
                      listItemRatio[index], index, listItemKeys[index]);
                }
              }),
        ),
      ),
    );
  }
}

class CustContainer extends StatelessWidget {
  CustContainer(this.ratio, this.index, this.parentKey);

  final GlobalKey parentKey;
  final double ratio;
  final int index;

  @override
  Widget build(BuildContext context) {
    return new Container(
      key: parentKey,
      height: 150,
      width: 150,
      child: new Container(
          color: Colors.amberAccent,
          child: Center(
              child: Text(
            '$index',
            style: new TextStyle(color: Colors.black, fontSize: 20 * ratio),
          ))),
    );
  }
}

class CustRotationYContainer extends StatelessWidget {
  CustRotationYContainer(this.ratio, this.index, this.parentKey);

  final GlobalKey parentKey;
  final double ratio;
  final int index;

  @override
  Widget build(BuildContext context) {
    final rotation = ((360 * ratio) / 180);
    return new Container(
      key: parentKey,
      height: 150,
      width: 150,
      child: new Container(
          transform: new Matrix4.rotationY(rotation),
          color: Colors.amberAccent,
          child: Center(
              child: Text(
            '$index',
            style: new TextStyle(color: Colors.black),
          ))),
    );
  }
}

class CustRotationXContainer extends StatelessWidget {
  CustRotationXContainer(this.ratio, this.index, this.parentKey);

  final GlobalKey parentKey;
  final double ratio;
  final int index;

  @override
  Widget build(BuildContext context) {
    final rotation = ((360 * ratio) / 360);
    return new Container(
      key: parentKey,
      height: 150,
      width: 150,
      child: new Container(
          transform: new Matrix4.rotationX(rotation),
          color: Colors.amberAccent,
          child: Center(
              child: Text(
            '$index',
            style: new TextStyle(color: Colors.black),
          ))),
    );
  }
}

class CustRotationZContainer extends StatelessWidget {
  CustRotationZContainer(this.ratio, this.index, this.parentKey);

  final GlobalKey parentKey;
  final double ratio;
  final int index;

  @override
  Widget build(BuildContext context) {
    final rotation = ((360 * ratio) / 360);
    return new Container(
      key: parentKey,
      height: 150,
      width: 150,
      child: new Container(
          transform: new Matrix4.rotationZ(rotation),
          color: Colors.amberAccent,
          child: Center(
              child: Text(
            '$index',
            style: new TextStyle(color: Colors.black),
          ))),
    );
  }
}

Matrix4 _pmat(num pv) {
  return new Matrix4(
    1.0,
    0.0,
    0.0,
    0.0,
    //
    0.0,
    1.0,
    0.0,
    0.0,
    //
    0.0,
    0.0,
    1.0,
    pv * 0.001,
    //
    0.0,
    0.0,
    0.0,
    1.0,
  );
}

Matrix4 perspective = _pmat(1.0);

class CustRotationContainer extends StatelessWidget {
  CustRotationContainer(this.ratio, this.index, this.parentKey);

  final GlobalKey parentKey;
  final double ratio;
  final int index;

  @override
  Widget build(BuildContext context) {
    final rotation = ((360 * ratio) / 360);
    return new Container(
      key: parentKey,
      height: 150,
      width: 150,
      child: new Container(
          transform: perspective.scaled(1.0, 1.0, 1.0)
            ..rotateX(rotation)
            ..rotateY(rotation)
            ..rotateZ(rotation),
          color: Colors.amberAccent,
          child: Center(
              child: Text(
            '$index',
            style: new TextStyle(color: Colors.black),
          ))),
    );
  }
}
