import 'dart:math';
import 'package:flutter/material.dart';
import 'package:os_project/const/fork.dart';

/*
ملف قديم
*/

List<int?> forkUsers = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SafeArea(child: DiningPhilosophersScreen()));
  }
}

class DiningPhilosophersScreen extends StatefulWidget {
  const DiningPhilosophersScreen({super.key});

  @override
  DiningPhilosophersScreenState createState() => DiningPhilosophersScreenState();
}

class DiningPhilosophersScreenState extends State<DiningPhilosophersScreen> {
  int numberOfPhilosophers = 5;
  double sliderValue = 5;
  bool isDeadlock = true;
  String selectedSolution = 'None';
  List<String> solutions = <String>['None', 'Limit number of Philosophers', 'Pick Both Forks (Critical Section)', 'Asymmetric Solution'];
  List<String> philosopherStates = <String>[];
  List<bool> forkStates = <bool>[];

  double miniumNumberNumberOfPhilosophers = 3;
  double maximumNumberNumberOfPhilosophers = 30;

  @override
  void initState() {
    super.initState();
    philosopherStates = List.generate(numberOfPhilosophers, (index) => 'Thinking');
    forkStates = List.generate(numberOfPhilosophers, (index) => false);
    isDeadlock = checkForDeadlock(numberOfPhilosophers);
  }

  bool checkForDeadlock(int numberOfPhilosophers) {
    if (selectedSolution == 'None' && numberOfPhilosophers % 2 != 0) return true;

    return false;
  }

  void update(double newValue, {bool isTerminated = false}) {
    setState(() {
      sliderValue = newValue;
      numberOfPhilosophers = newValue.toInt();

      philosopherStates = List<String>.generate(numberOfPhilosophers, (index) => 'Thinking');
      forkStates = List<bool>.generate(numberOfPhilosophers, (index) => false);
      forkUsers = List.generate(numberOfPhilosophers, (_) => null);
      isDeadlock = checkForDeadlock(numberOfPhilosophers);
    });
  }

  void onSolutionChanged(String? newValue) {
    setState(() {
      selectedSolution = newValue!;
      isDeadlock = checkForDeadlock(numberOfPhilosophers);

      if (selectedSolution == 'Limit number of Philosophers' && numberOfPhilosophers % 2 != 0) {
        update(numberOfPhilosophers - 1, isTerminated: true);
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dining Philosophers Problem')),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: CircularTable(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                numberOfPhilosophers: numberOfPhilosophers,
                isDeadlock: isDeadlock,
                selectedSolution: selectedSolution,
                philosopherStates: philosopherStates,
                forkStates: forkStates,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Text('Number of Philosophers: $numberOfPhilosophers', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Slider(
                  activeColor: Colors.blue,
                  value: sliderValue,
                  min: miniumNumberNumberOfPhilosophers,
                  max: maximumNumberNumberOfPhilosophers,
                  divisions: (maximumNumberNumberOfPhilosophers - miniumNumberNumberOfPhilosophers).toInt(),
                  label: numberOfPhilosophers.toString(),
                  onChanged: (newValue) {
                    update(newValue);
                  },
                ),
                const SizedBox(height: 16),
                const Text('Select a Solution:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedSolution,
                  onChanged: onSolutionChanged,
                  items:
                      solutions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(value: value, child: Text(value));
                      }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  isDeadlock ? 'Deadlock Detected!' : 'No Deadlock',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDeadlock ? Colors.red : Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircularTable extends StatefulWidget {
  final double height;
  final double width;
  final int numberOfPhilosophers;
  final bool isDeadlock;
  final String selectedSolution;
  final List<String> philosopherStates;
  final List<bool> forkStates;
  const CircularTable({
    super.key,
    required this.height,
    required this.width,
    required this.numberOfPhilosophers,
    required this.isDeadlock,
    required this.selectedSolution,
    required this.philosopherStates,
    required this.forkStates,
  });
  @override
  State<CircularTable> createState() => _CircularTableState();
}

class _CircularTableState extends State<CircularTable> {
  @override
  void initState() {
    super.initState();

    forkUsers = List.generate(widget.numberOfPhilosophers, (_) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: widget.width / 3,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: const <DataColumn>[DataColumn(label: Text('Fork')), DataColumn(label: Text('Status')), DataColumn(label: Text('Used by'))],
              rows: List<DataRow>.generate(widget.numberOfPhilosophers, (index) {
                final int forkId = index + 1;
                final bool isInUse = widget.forkStates[index];

                String owner = 'None';
                if (isInUse && forkUsers[index] != null) {
                  owner = 'Philosopher ${forkUsers[index]}';
                }

                final String status = isInUse ? 'In Use' : 'Available';
                return DataRow(
                  cells: [
                    DataCell(FittedBox(child: Text(forkId.toString()))),
                    DataCell(FittedBox(child: Text(status))),
                    DataCell(FittedBox(child: Text(owner))),
                  ],
                );
              }),
            ),
          ),
        ),
        Expanded(child: Padding(padding: EdgeInsets.all(40), child: Stack(children: [..._buildForks(), ..._buildPhilosophers()]))),
      ],
    );
  }

  List<Widget> _buildPhilosophers() {
    List<Widget> philosophers = [];
    double radius = min(225, max(150, 15 * widget.numberOfPhilosophers + 0));
    double angle = 2 * 3.14159 / widget.numberOfPhilosophers;

    if (!widget.forkStates.contains(true)) {
      _initializeLastPhilosopherState();
    }

    for (int i = 0; i < widget.numberOfPhilosophers; i++) {
      double x = radius * cos(angle * i);
      double y = radius * sin(angle * i);
      philosophers.add(
        Positioned(
          left: widget.width ~/ 4 + x,
          top: widget.height ~/ 2 + y,
          child: InkWell(
            onTap: () => _handlePhilosopherTap(i),
            // child: PhilosopherCircle(
            //   id: (i + 1).toString(),
            //   state: widget.philosopherStates[i],
            //   isDeadlock: widget.isDeadlock,
            //   selectedSolution: widget.selectedSolution,
            //   philosopherNumber: i + 1,
            //   radius: widget.numberOfPhilosophers < 20 ? 60 : (40 - widget.numberOfPhilosophers + 35) + 0,
            // ),
          ),
        ),
      );
    }
    return philosophers;
  }

  void _initializeLastPhilosopherState() {
    final int lastIndex = widget.philosopherStates.length - 1;

    if (widget.philosopherStates.length % 2 == 1 && widget.selectedSolution == 'Limit number of Philosophers') {
      widget.philosopherStates[lastIndex] = "Terminated";
    } else if (widget.philosopherStates[lastIndex] == "Terminated") {
      widget.philosopherStates[lastIndex] = "Thinking";
    }
  }
  // Fix for the _handlePhilosopherTap method

  void _handlePhilosopherTap(int philosopherIndex) {
    setState(() {
      final int leftForkIndex = philosopherIndex;
      final int rightForkIndex = (philosopherIndex + 1) % widget.numberOfPhilosophers;
      final int philosopherId = philosopherIndex + 1;

      String currentState = widget.philosopherStates[philosopherIndex];

      bool isLastPhilosopherInLimitSolution =
          (philosopherIndex == widget.numberOfPhilosophers - 1 &&
              widget.selectedSolution == 'Limit number of Philosophers' &&
              widget.numberOfPhilosophers % 2 == 1);

      if (isLastPhilosopherInLimitSolution && currentState == "Terminated") {
        return;
      }

      if (currentState == "Thinking") {
        _handleThinkingPhilosopher(philosopherIndex, leftForkIndex, rightForkIndex, philosopherId);
      } else if (currentState == "Eating") {
        _handleEatingPhilosopher(philosopherIndex, leftForkIndex, rightForkIndex, isLastPhilosopherInLimitSolution);
      } else if (currentState == "Waiting") {
        _handleWaitingPhilosopher(philosopherIndex, leftForkIndex, rightForkIndex, philosopherId);
      }
    });
  }

  // Fix for the individual handler methods
  void _handleThinkingPhilosopher(int philosopherIndex, int leftForkIndex, int rightForkIndex, int philosopherId) {
    if (widget.selectedSolution == 'None') {
      _applyNoSolution(philosopherIndex, leftForkIndex, rightForkIndex, philosopherId);
    } else if (widget.selectedSolution == 'Limit number of Philosophers') {
      _applyLimitPhilosophersSolution(philosopherIndex, leftForkIndex, rightForkIndex, philosopherId);
    } else if (widget.selectedSolution == 'Pick Both Forks (Critical Section)') {
      _applyCriticalSectionSolution(philosopherIndex, leftForkIndex, rightForkIndex, philosopherId);
    } else if (widget.selectedSolution == 'Asymmetric Solution') {
      _applyAsymmetricSolution(philosopherIndex, leftForkIndex, rightForkIndex, philosopherId);
    }
  }

  void _applyNoSolution(int philosopherIndex, int leftForkIndex, int rightForkIndex, int philosopherId) {
    if (!widget.forkStates[leftForkIndex]) {
      widget.forkStates[leftForkIndex] = true;
      forkUsers[leftForkIndex] = philosopherId;

      if (!widget.forkStates[rightForkIndex]) {
        widget.forkStates[rightForkIndex] = true;
        forkUsers[rightForkIndex] = philosopherId;
        widget.philosopherStates[philosopherIndex] = "Eating";
      } else {
        widget.philosopherStates[philosopherIndex] = "Waiting";
      }
    }
    // في حال فك شي يفكه غصب حتى لو كان غيره ماسكه
    else if (!widget.forkStates[rightForkIndex]) {
      widget.forkStates[rightForkIndex] = true;
      forkUsers[rightForkIndex] = philosopherId;

      if (!widget.forkStates[leftForkIndex]) {
        widget.forkStates[leftForkIndex] = true;
        forkUsers[leftForkIndex] = philosopherId;
        widget.philosopherStates[philosopherIndex] = "Eating";
      } else {
        widget.philosopherStates[philosopherIndex] = "Waiting";
      }
    }
  }

  void _applyLimitPhilosophersSolution(int philosopherIndex, int leftForkIndex, int rightForkIndex, int philosopherId) {
    int eatingCount = widget.philosopherStates.where((state) => state == "Eating").length;
    if (eatingCount >= widget.numberOfPhilosophers ~/ 2) {
      return;
    }

    if (!widget.forkStates[leftForkIndex] && !widget.forkStates[rightForkIndex]) {
      widget.forkStates[leftForkIndex] = true;
      widget.forkStates[rightForkIndex] = true;
      forkUsers[leftForkIndex] = philosopherId;
      forkUsers[rightForkIndex] = philosopherId;
      widget.philosopherStates[philosopherIndex] = "Eating";
    }
  }

  void _applyCriticalSectionSolution(int philosopherIndex, int leftForkIndex, int rightForkIndex, int philosopherId) {
    if (!widget.forkStates[leftForkIndex] && !widget.forkStates[rightForkIndex]) {
      widget.forkStates[leftForkIndex] = true;
      widget.forkStates[rightForkIndex] = true;
      forkUsers[leftForkIndex] = philosopherId;
      forkUsers[rightForkIndex] = philosopherId;
      widget.philosopherStates[philosopherIndex] = "Eating";
    }
  }

  void _applyAsymmetricSolution(int philosopherIndex, int leftForkIndex, int rightForkIndex, int philosopherId) {
    if (philosopherId % 2 == 1) {
      _handleOddPhilosopher(philosopherIndex, leftForkIndex, rightForkIndex, philosopherId);
    } else {
      _handleEvenPhilosopher(philosopherIndex, leftForkIndex, rightForkIndex, philosopherId);
    }
  }

  void _handleOddPhilosopher(int philosopherIndex, int leftForkIndex, int rightForkIndex, int philosopherId) {
    if (!widget.forkStates[leftForkIndex]) {
      widget.forkStates[leftForkIndex] = true;
      forkUsers[leftForkIndex] = philosopherId;

      if (!widget.forkStates[rightForkIndex]) {
        widget.forkStates[rightForkIndex] = true;
        forkUsers[rightForkIndex] = philosopherId;
        widget.philosopherStates[philosopherIndex] = "Eating";
      } else {
        widget.philosopherStates[philosopherIndex] = "Waiting";
      }
    }
  }

  void _handleEvenPhilosopher(int philosopherIndex, int leftForkIndex, int rightForkIndex, int philosopherId) {
    if (!widget.forkStates[rightForkIndex]) {
      widget.forkStates[rightForkIndex] = true;
      forkUsers[rightForkIndex] = philosopherId;

      if (!widget.forkStates[leftForkIndex]) {
        widget.forkStates[leftForkIndex] = true;
        forkUsers[leftForkIndex] = philosopherId;
        widget.philosopherStates[philosopherIndex] = "Eating";
      } else {
        widget.philosopherStates[philosopherIndex] = "Waiting";
      }
    }
  }

  void _handleEatingPhilosopher(int philosopherIndex, int leftForkIndex, int rightForkIndex, bool isLastPhilosopherInLimitSolution) {
    widget.forkStates[leftForkIndex] = false;
    widget.forkStates[rightForkIndex] = false;
    forkUsers[leftForkIndex] = null;
    forkUsers[rightForkIndex] = null;

    if (isLastPhilosopherInLimitSolution) {
      widget.philosopherStates[philosopherIndex] = "Terminated";
    } else {
      widget.philosopherStates[philosopherIndex] = "Thinking";
    }
  }

  void _handleWaitingPhilosopher(int philosopherIndex, int leftForkIndex, int rightForkIndex, int philosopherId) {
    if (widget.selectedSolution == 'None') {
      _handleWaitingWithNoSolution(philosopherIndex, philosopherId, rightForkIndex, leftForkIndex);
    } else if (widget.selectedSolution == 'Asymmetric Solution') {
      _handleWaitingWithAsymmetricSolution(philosopherIndex, philosopherId, rightForkIndex, leftForkIndex);
    }
  }

  void _handleWaitingWithNoSolution(int philosopherIndex, int philosopherId, int rightForkIndex, int leftForkIndex) {
    if (!widget.forkStates[rightForkIndex]) {
      widget.forkStates[rightForkIndex] = true;
      forkUsers[rightForkIndex] = philosopherId;
      widget.philosopherStates[philosopherIndex] = "Eating";
    } else {
      widget.forkStates[leftForkIndex] = false;
      forkUsers[leftForkIndex] = null;
      widget.philosopherStates[philosopherIndex] = "Thinking";
    }
  }

  void _handleWaitingWithAsymmetricSolution(int philosopherIndex, int philosopherId, int rightForkIndex, int leftForkIndex) {
    if (philosopherId % 2 == 1) {
      if (!widget.forkStates[rightForkIndex]) {
        widget.forkStates[rightForkIndex] = true;
        forkUsers[rightForkIndex] = philosopherId;
        widget.philosopherStates[philosopherIndex] = "Eating";
      } else {
        widget.forkStates[leftForkIndex] = false;
        forkUsers[leftForkIndex] = null;
        widget.philosopherStates[philosopherIndex] = "Thinking";
      }
    } else {
      if (!widget.forkStates[leftForkIndex]) {
        widget.forkStates[leftForkIndex] = true;
        forkUsers[leftForkIndex] = philosopherId;
        widget.philosopherStates[philosopherIndex] = "Eating";
      } else {
        widget.forkStates[rightForkIndex] = false;
        forkUsers[rightForkIndex] = null;
        widget.philosopherStates[philosopherIndex] = "Thinking";
      }
    }
  }

  List<Widget> _buildForks() {
    List<Widget> forks = [];
    double tableRadius = min(225, max(90, 15 * widget.numberOfPhilosophers + 0));
    double angle = 2 * 3.14159 / widget.numberOfPhilosophers;
    double centerX = widget.width / 4;
    double centerY = widget.height / 2;
    double forkRadius = widget.numberOfPhilosophers < 20 ? 25 : 20;

    for (int i = 0; i < widget.numberOfPhilosophers; i++) {
      double x1 = tableRadius * cos(angle * i);
      double y1 = tableRadius * sin(angle * i);

      int nextPhil = 0;
      if (widget.numberOfPhilosophers > 18) {
        nextPhil = (i - 2) % widget.numberOfPhilosophers;
      } else {
        nextPhil = (i - 1) % widget.numberOfPhilosophers;
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
              Fork(id: (i + 1).toString(), isInUse: widget.forkStates[i], forkSize: forkRadius / 2),
            ],
          ),
        ),
      );
    }

    return forks;
  }
}
