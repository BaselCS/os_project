import 'package:flutter/material.dart';
import 'package:os_project/main.dart';

class PhilosopherCircle extends StatelessWidget {
  const PhilosopherCircle(this.width, this.height, this.x, this.y, this.i, this.numberOfPhilosophers, this.state, this.isDeadlock, {super.key});

  final double width;
  final double x;
  final double height;
  final double y;
  final int i;
  final int numberOfPhilosophers;
  final bool isDeadlock;
  final String state;

  @override
  Widget build(BuildContext context) {
    Color circleColor;
    switch (state) {
      case 'Thinking':
        circleColor = Colors.blue;
        break;
      case 'Hungry':
        circleColor = Colors.red;
        break;
      case 'Eating':
        circleColor = Colors.green;
        break;
      case "Terminated":
        circleColor = Colors.black.withAlpha(255 ~/ 3);
        break;
      default:
        circleColor = Colors.grey;
    }
    return Positioned(
      left: width ~/ 4 + x,
      top: height ~/ 2 + y,
      child: InkWell(
        onTap: () => provider.handlePhilosopherTap(i),
        child: Container(
          width: numberOfPhilosophers < 20 ? 60 : (40 - numberOfPhilosophers + 35) + 0,
          height: numberOfPhilosophers < 20 ? 60 : (40 - numberOfPhilosophers + 35) + 0,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle, border: isDeadlock ? Border.all(color: Colors.red, width: 3) : null),
          child: Center(child: Text((i + 1).toString(), style: const TextStyle(color: Colors.white, fontSize: 18))),
        ),
      ),
    );
  }
}
