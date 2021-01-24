import 'package:flutter/material.dart';
import 'package:wru_fe/widgets/animation_fade_in.widget.dart';

class HomeTestScreen extends StatefulWidget {
  static const routeName = './home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeTestScreen>
    with SingleTickerProviderStateMixin {
  double position = 0.0;
  void handleXChange(double deltaX) {
    setState(() {
      position = deltaX / MediaQuery.of(context).size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Text(position.toString()),
            DragArea(
              handleXChange: handleXChange,
            ),
          ],
        ));
  }
}

class DragArea extends StatefulWidget {
  const DragArea({Key key, @required this.handleXChange}) : super(key: key);

  final void Function(double newX) handleXChange;

  @override
  _DragAreaState createState() => _DragAreaState();
}

class _DragAreaState extends State<DragArea> {
  double initX;
  double deltaTmp = 0;

  void onPanStart(DragStartDetails details) {
    initX = details.globalPosition.dx;
  }

  void onPanUpdate(DragUpdateDetails details) {
    var x = details.globalPosition.dx;
    var deltaX = x - initX;
    widget.handleXChange(deltaX);
    setState(() {
      deltaTmp = deltaX / MediaQuery.of(context).size.width;
      print(deltaTmp);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blueAccent,
          ),
        ),
        child: Center(
            child: (deltaTmp > 0.59) ? AnimationFadeIn() : Text("Không")),
      ),
    );
  }
}
