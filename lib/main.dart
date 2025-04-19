import 'dart:math';

import 'package:flutter/material.dart';
import 'package:os_project/const/fork.dart';
import 'package:os_project/const/philosopher_shape.dart';
import 'package:os_project/provider.dart';
import 'package:os_project/const/tabel.dart';
import 'package:provider/provider.dart';

late PhilosopherProvider provider;
void main() {
  runApp(ChangeNotifierProvider(create: (context) => PhilosopherProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SafeArea(child: DiningPhilosophersScreen()));
  }
}

class DiningPhilosophersScreen extends StatelessWidget {
  const DiningPhilosophersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<PhilosopherProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: CircularTable(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                numberOfPhilosophers: provider.numberOfPhilosophers,
                isDeadlock: provider.isDeadlock,
                selectedSolution: provider.selectedSolution,
                philosopherStates: provider.philosopherStates,
                forkStates: provider.forkStates,
                forkTested: provider.forkTested,
                forkUsers: provider.forkUsers,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text('Number of Philosophers: ${provider.numberOfPhilosophers}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Slider(
                  activeColor: Colors.blue,
                  value: provider.numberOfPhilosophers.toDouble(),
                  min: 3,
                  max: 30,
                  divisions: 27,
                  label: provider.numberOfPhilosophers.toString(),
                  onChanged: (newValue) {
                    provider.updateNumberOfPhilosophers(newValue.toInt());
                  },
                ),
                const SizedBox(height: 16),
                const Text('Select a Solution:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: provider.selectedSolution,
                  onChanged: provider.onSolutionChanged,
                  items:
                      PhilosopherProvider.solutions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  provider.isDeadlock ? 'Deadlock Detected!' : 'No Deadlock',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: provider.isDeadlock ? Colors.red : Colors.green),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircularTable extends StatelessWidget {
  final double height;
  final double width;
  final int numberOfPhilosophers;
  final bool isDeadlock;
  final String selectedSolution;
  final List<String> philosopherStates;
  final List<bool> forkStates;
  final List<bool> forkTested;
  final List<int?> forkUsers;

  const CircularTable({
    super.key,
    required this.height,
    required this.width,
    required this.numberOfPhilosophers,
    required this.isDeadlock,
    required this.selectedSolution,
    required this.philosopherStates,
    required this.forkStates,
    required this.forkTested,
    required this.forkUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: width / 3, child: InfoTable(numberOfPhilosophers, forkStates, forkUsers)),
        Expanded(child: Padding(padding: const EdgeInsets.all(40), child: Stack(children: [..._buildForks(), ..._buildPhilosophers()]))),
      ],
    );
  }

  List<Widget> _buildForks() {
    List<Widget> forks = [];
    double tableRadius = min(225, max(90, 15 * numberOfPhilosophers + 0));
    double angle = 2 * 3.14159 / numberOfPhilosophers;
    double centerX = width / 4;
    double centerY = height / 2;
    double forkRadius = numberOfPhilosophers < 20 ? 25 : 20;

    for (int i = 0; i < numberOfPhilosophers; i++) {
      double x1 = tableRadius * cos(angle * i);
      double y1 = tableRadius * sin(angle * i);

      int nextPhil = 0;
      if (numberOfPhilosophers > 18) {
        nextPhil = (i - 2) % numberOfPhilosophers;
      } else {
        nextPhil = (i - 1) % numberOfPhilosophers;
      }

      double x2 = tableRadius * cos(angle * nextPhil);
      double y2 = tableRadius * sin(angle * nextPhil);

      double forkX = (x1 + x2) / 2;
      double forkY = (y1 + y2) / 2;

      double scaleFactor = 0.7;
      forkX *= scaleFactor;
      forkY *= scaleFactor;

      forks.add(
        Positioned(
          left: centerX + forkX - forkRadius / 2 + 25,
          top: centerY + forkY - forkRadius / 2 + 30,
          child: Row(
            children: [
              Container(
                width: forkRadius,
                height: forkRadius,
                decoration: BoxDecoration(color: Colors.brown.shade700, shape: BoxShape.circle),
                child: Center(child: Text((i + 1).toString(), style: TextStyle(color: Colors.white, fontSize: 15))),
              ),
              Fork(id: (i + 1).toString(), isInUse: forkStates[i], isTested: forkTested[i], forkSize: forkRadius / 2),
            ],
          ),
        ),
      );
    }

    return forks;
  }

  List<Widget> _buildPhilosophers() {
    List<Widget> philosophers = [];
    double radius = min(225, max(150, 15 * numberOfPhilosophers + 0));
    double angle = 2 * 3.14159 / numberOfPhilosophers;

    for (int i = 0; i < numberOfPhilosophers; i++) {
      double x = radius * cos(angle * i);
      double y = radius * sin(angle * i);

      philosophers.add(PhilosopherCircle(width, height, x, y, i, numberOfPhilosophers, philosopherStates[i], isDeadlock));
    }
    return philosophers;
  }
}
