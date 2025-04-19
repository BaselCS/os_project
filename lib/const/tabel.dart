import 'package:flutter/material.dart';

class InfoTable extends StatelessWidget {
  const InfoTable(this.numberOfPhilosophers, this.forkStates, this.forkUsers, {super.key});

  final int numberOfPhilosophers;
  final List<bool> forkStates;
  final List<int?> forkUsers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: const [DataColumn(label: Text('Fork')), DataColumn(label: Text('Status')), DataColumn(label: Text('Used by'))],
        rows: List<DataRow>.generate(numberOfPhilosophers, (index) {
          final int forkId = index + 1;
          final bool isInUse = forkStates[index];

          String owner = 'None';
          if (isInUse && forkUsers[index] != null) {
            owner = 'Philosopher ${forkUsers[index]}';
          }

          final String status = isInUse ? 'In Use' : 'Available';
          return DataRow(
            cells: [DataCell(FittedBox(child: Text(forkId.toString()))), DataCell(FittedBox(child: Text(status))), DataCell(FittedBox(child: Text(owner)))],
          );
        }),
      ),
    );
  }
}
