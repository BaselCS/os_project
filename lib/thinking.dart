void handleThinkingPhilosopher(
  int philosopherIndex,
  int leftForkIndex,
  int rightForkIndex,
  List<bool> forkStates,
  List<int?> forkUsers,
  List<String> philosopherStates,
  String selectedSolution,
) {
  if (selectedSolution == 'Any Available') {
    _anyNoSolution(philosopherIndex, leftForkIndex, rightForkIndex, forkStates, forkUsers, philosopherStates);
  } else if (selectedSolution == 'Limit number of Philosophers') {
    _applyLimitedSelectionSolution(philosopherStates);
    _anyNoSolution(philosopherIndex, leftForkIndex, rightForkIndex, forkStates, forkUsers, philosopherStates);
  } else if (selectedSolution == 'Pick Both Forks (Critical Section)') {
    _applyCriticalSectionSolution(philosopherIndex, leftForkIndex, rightForkIndex, forkStates, forkUsers, philosopherStates);
  } else if (selectedSolution == 'Asymmetric Solution') {
    _applyAsymmetricSolution(philosopherIndex, forkStates, forkUsers, philosopherStates);
  } else if (selectedSolution == 'Start with Right') {
    _applyRightSolution(philosopherIndex, forkStates, forkUsers, philosopherStates);
  } else if (selectedSolution == 'Start with Left') {
    _applyLeftSolution(philosopherIndex, forkStates, forkUsers, philosopherStates);
  }
}

void _anyNoSolution(int philosopherIndex, int leftForkIndex, int rightForkIndex, List<bool> forkStates, List<int?> forkUsers, List<String> philosopherStates) {
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
  } else {
    if (!forkStates[leftForkIndex]) {}
    if (!forkStates[rightForkIndex]) {}
  }
}

void _applyAsymmetricSolution(int philosopherIndex, List<bool> forkStates, List<int?> forkUsers, List<String> philosopherStates) {
  if (philosopherIndex % 2 == 1) {
    // odd philosopher
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
    // even philosopher
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

void _applyRightSolution(int philosopherIndex, List<bool> forkStates, List<int?> forkUsers, List<String> philosopherStates) {
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
}

void _applyLeftSolution(int philosopherIndex, List<bool> forkStates, List<int?> forkUsers, List<String> philosopherStates) {
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

void _applyLimitedSelectionSolution(List<String> philosopherStates) {
  philosopherStates[philosopherStates.length - 1] = "Not Available";
}
