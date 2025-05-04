import 'package:flutter/material.dart';
import 'package:os_project/thinking.dart';

class PhilosopherProvider with ChangeNotifier {
  int numberOfPhilosophers = 5;
  List<String> philosopherStates = [];
  static const List<String> solutions = <String>[
    'Any Available',
    'Start with Left',
    'Start with Right',
    'Limit number of Philosophers',
    'Pick Both Forks (Critical Section)',
    'Asymmetric Solution',
  ];
  List<bool> forkStates = [];
  List<int?> forkUsers = [];

  bool isDeadlock = false;
  String selectedSolution = 'Any Available';

  PhilosopherProvider() {
    selectedSolution = 'Any Available';
    _initialize();
  }
  void reSet() {
    _initialize();
    notifyListeners();
  }

  void _initialize() {
    isDeadlock = false;
    philosopherStates = List.generate(numberOfPhilosophers, (index) => 'Thinking');
    forkStates = List.generate(numberOfPhilosophers, (index) => false);
    forkUsers = List.generate(numberOfPhilosophers, (_) => null);
  }

  void onSolutionChanged(String? newValue) {
    _initialize();
    selectedSolution = newValue!;
    notifyListeners();
  }

  void updateNumberOfPhilosophers(int newValue) {
    numberOfPhilosophers = newValue;
    _initialize();
    notifyListeners();
  }

  bool checkForDeadlock(int numberOfPhilosophers) {
    for (int i = 0; i < numberOfPhilosophers; i++) {
      if (philosopherStates[i] != "Waiting") {
        isDeadlock = false;
        return false;
      }
    }
    isDeadlock = true;
    return true;
  }

  void handlePhilosopherTap(int philosopherIndex) {
    final int leftForkIndex = philosopherIndex;
    final int rightForkIndex = (philosopherIndex + 1) % numberOfPhilosophers;
    String currentState = philosopherStates[philosopherIndex];

    if (currentState == "Thinking") {
      handleThinkingPhilosopher(philosopherIndex, leftForkIndex, rightForkIndex, forkStates, forkUsers, philosopherStates, selectedSolution);
    } else if (currentState == "Eating") {
      _handleEatingPhilosopher(philosopherIndex, leftForkIndex, rightForkIndex);
    } else if (currentState == "Waiting") {
      _handleWaitingWithNoSolution(philosopherIndex, leftForkIndex, rightForkIndex);
    }

    checkForDeadlock(numberOfPhilosophers);
    notifyListeners();
  }

  void _handleEatingPhilosopher(int philosopherIndex, int leftForkIndex, int rightForkIndex) {
    forkStates[leftForkIndex] = false;
    forkStates[rightForkIndex] = false;
    forkUsers[leftForkIndex] = null;
    forkUsers[rightForkIndex] = null;
    philosopherStates[philosopherIndex] = "Thinking";
  }

  //افلت
  void _handleWaitingWithNoSolution(int philosopherIndex, int leftForkIndex, int rightForkIndex) {
    // كلهما متاحات
    if (!forkStates[leftForkIndex] && !forkStates[rightForkIndex]) {
      forkStates[leftForkIndex] = true;
      forkUsers[leftForkIndex] = philosopherIndex + 1;
      forkStates[rightForkIndex] = true;
      forkUsers[rightForkIndex] = philosopherIndex + 1;
      philosopherStates[philosopherIndex] = "Eating";
    }
    // الشوكة اليسرى متاحة فقط
    else if (!forkStates[leftForkIndex]) {
      if (forkUsers[rightForkIndex] == philosopherIndex + 1) {
        forkStates[leftForkIndex] = true;
        forkUsers[leftForkIndex] = philosopherIndex + 1;
        philosopherStates[philosopherIndex] = "Eating";
      } else {
        philosopherStates[philosopherIndex] = "Thinking";
      }
    }
    // الشوكة اليمنى متاحة فقط
    else if (!forkStates[rightForkIndex]) {
      if (forkUsers[leftForkIndex] == philosopherIndex + 1) {
        forkStates[rightForkIndex] = true;
        forkUsers[rightForkIndex] = philosopherIndex + 1;
        philosopherStates[philosopherIndex] = "Eating";
      } else {
        philosopherStates[philosopherIndex] = "Thinking";
      }
    }
  }
}
