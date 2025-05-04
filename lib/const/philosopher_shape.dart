import 'package:flutter/material.dart';
import 'package:os_project/main.dart';

class PhilosopherCircle extends StatelessWidget {
  const PhilosopherCircle(this.width, this.height, this.x, this.y, this.philosopherIndex, this.numberOfPhilosophers, this.state, this.isDeadlock, {super.key});

  final double width;
  final double x;
  final double height;
  final double y;
  final int philosopherIndex;
  final int numberOfPhilosophers;
  final bool isDeadlock;
  final String state;

  String usedForkIndex(int philosopherIndex) {
    final int leftForkIndex = philosopherIndex;
    final int rightForkIndex = (philosopherIndex + 1) % numberOfPhilosophers;
    String msg = "";
    print(provider.forkUsers);
    if (provider.forkStates[leftForkIndex] && provider.forkUsers[leftForkIndex] != (philosopherIndex + 1)) {
      msg = "Fork ${leftForkIndex + 1} used \n";
    }
    if (provider.forkStates[rightForkIndex] && provider.forkUsers[rightForkIndex] != (philosopherIndex + 1)) {
      msg = "$msg Fork ${rightForkIndex + 1} used";
    }

    return msg.trim();
  }

  @override
  Widget build(BuildContext context) {
    Color circleColor;
    switch (state) {
      case 'Thinking':
        circleColor = Colors.blue;
        break;
      case 'Eating':
        circleColor = Colors.green;
        break;
      case "Terminated":
        circleColor = Colors.black.withAlpha(255 ~/ 3);
        break;
      case "Not Available":
        circleColor = Colors.black;
        break;
      case "Waiting":
        circleColor = Colors.grey;
      default:
        circleColor = Colors.white;
        break;
    }
    return Positioned(
      left: width ~/ 4 + x,
      top: height ~/ 2 + y,
      child: Tooltip(
        message: circleColor == Colors.grey ? usedForkIndex(philosopherIndex) : state,
        showDuration: const Duration(seconds: 2),
        waitDuration: const Duration(milliseconds: 500),
        verticalOffset: 30,
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(color: Colors.white),
        child: InkWell(
          onTap: () => provider.handlePhilosopherTap(philosopherIndex),

          child: Container(
            width: numberOfPhilosophers < 20 ? 60 : (40 - numberOfPhilosophers + 35) + 0,
            height: numberOfPhilosophers < 20 ? 60 : (40 - numberOfPhilosophers + 35) + 0,
            decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle, border: isDeadlock ? Border.all(color: Colors.red, width: 3) : null),
            child: Center(child: Text((philosopherIndex + 1).toString(), style: const TextStyle(color: Colors.white, fontSize: 18))),
          ),
        ),
      ),
    );
  }
}
