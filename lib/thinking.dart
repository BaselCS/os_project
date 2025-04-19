void handleThinkingPhilosopher(
  int philosopherIndex,
  int leftForkIndex,
  int rightForkIndex,
  List<bool> forkStates,
  List<int?> forkUsers,
  List<String> philosopherStates,
  String selectedSolution,
) {
  if (selectedSolution == 'None') {
    _applyNoSolution(philosopherIndex, leftForkIndex, rightForkIndex, forkStates, forkUsers, philosopherStates);
  } else if (selectedSolution == 'Pick Both Forks (Critical Section)') {
    _applyCriticalSectionSolution(philosopherIndex, leftForkIndex, rightForkIndex, forkStates, forkUsers, philosopherStates);
  } else if (selectedSolution == 'Asymmetric Solution') {
    _applyAsymmetricSolution(philosopherIndex, forkStates, forkUsers, philosopherStates);
  }
}

void _applyNoSolution(
  int philosopherIndex,
  int leftForkIndex,
  int rightForkIndex,
  List<bool> forkStates,
  List<int?> forkUsers,
  List<String> philosopherStates,
) {
  if (!forkStates[leftForkIndex] && !forkStates[rightForkIndex]) {
    forkStates[leftForkIndex] = true;
    forkUsers[leftForkIndex] = philosopherIndex + 1;
    forkStates[rightForkIndex] = true;
    forkUsers[rightForkIndex] = philosopherIndex + 1;
    philosopherStates[philosopherIndex] = "Eating";
    // أمسك الشوكة اليسرى فقط
  } else if (!forkStates[leftForkIndex]) {
    forkStates[leftForkIndex] = true;
    forkUsers[leftForkIndex] = philosopherIndex + 1;
    philosopherStates[philosopherIndex] = "Waiting";
    // أمسك الشوكة اليمنى فقط
  } else if (!forkStates[rightForkIndex]) {
    forkStates[rightForkIndex] = true;
    forkUsers[rightForkIndex] = philosopherIndex + 1;
    philosopherStates[philosopherIndex] = "Waiting";
  }
}

void _applyCriticalSectionSolution(
  int philosopherIndex,
  int leftForkIndex,
  int rightForkIndex,
  List<bool> forkStates,
  List<int?> forkUsers,
  List<String> philosopherStates,
) {
  if (!forkStates[leftForkIndex] && !forkStates[rightForkIndex]) {
    forkStates[leftForkIndex] = true;
    forkStates[rightForkIndex] = true;
    forkUsers[leftForkIndex] = philosopherIndex + 1;
    forkUsers[rightForkIndex] = philosopherIndex + 1;
    philosopherStates[philosopherIndex] = "Eating";
  }
}

void _applyAsymmetricSolution(int philosopherIndex, List<bool> forkStates, List<int?> forkUsers, List<String> philosopherStates) {
  if (philosopherIndex % 2 == 0) {
    // Even philosopher
    if (!forkStates[philosopherIndex]) {
      forkStates[philosopherIndex] = true;
      forkUsers[philosopherIndex] = philosopherIndex + 1;

      if (!forkStates[(philosopherIndex + 1) % forkStates.length]) {
        forkStates[(philosopherIndex + 1) % forkStates.length] = true;
        forkUsers[(philosopherIndex + 1) % forkStates.length] = philosopherIndex + 1;
        philosopherStates[philosopherIndex] = "Eating";
      } else {
        philosopherStates[philosopherIndex] = "Waiting";
      }
    }
  } else {
    // Odd philosopher
    if (!forkStates[(philosopherIndex + 1) % forkStates.length]) {
      forkStates[(philosopherIndex + 1) % forkStates.length] = true;
      forkUsers[(philosopherIndex + 1) % forkStates.length] = philosopherIndex + 1;

      if (!forkStates[philosopherIndex]) {
        forkStates[philosopherIndex] = true;
        forkUsers[philosopherIndex] = philosopherIndex + 1;
        philosopherStates[philosopherIndex] = "Eating";
      } else {
        philosopherStates[philosopherIndex] = "Waiting";
      }
    }
  }
}
