import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  const InfoText({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
          children: [
            TextSpan(text: 'This is a solution to the CPU scheduling problem known as the "Dining Philosophers".\n\n'),

            TextSpan(
              text:
                  'Each philosopher (large circle) represents a process. Each has a fork and food nearby.\nTo eat, a philosopher must pick up two forks (left and right). If both aren\'t available, they wait.\nIf all philosophers are waiting for a fork, deadlock occurs.\n\n',
            ),

            TextSpan(text: 'Deadlock happens when multiple processes are stuck waiting on each other for resources.\nIt requires these 4 conditions:\n\n'),

            TextSpan(text: '1. Mutual Exclusion – ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'Only one process can hold a resource at a time.\n'),

            TextSpan(text: '2. Hold and Wait – ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'A process holds a resource while waiting for others.\n'),

            TextSpan(text: '3. No Preemption – ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'Resources can’t be forcibly taken; they must be released voluntarily.\n'),

            TextSpan(text: '4. Circular Wait – ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'A cycle of processes, each waiting for the next to release a resource.\n\n'),

            TextSpan(text: 'Deadlock solutions:\n\n', style: TextStyle(fontWeight: FontWeight.bold)),

            TextSpan(text: '- Limit the number of philosophers: '),
            TextSpan(text: 'Allow fewer philosophers than forks to break mutual exclusion.\n'),

            TextSpan(text: '- Pick both forks at once (critical section): '),
            TextSpan(text: 'A philosopher only picks forks if both are available—breaks hold and wait.\n'),

            TextSpan(text: '- Asymmetric strategy: '),
            TextSpan(text: 'Odd philosophers pick left first, even ones pick right first—breaks circular wait.\n\n'),

            TextSpan(text: 'Other strategies:\n\n', style: TextStyle(fontWeight: FontWeight.bold)),

            TextSpan(text: '- Start with left: '),
            TextSpan(text: 'Always try to pick the left fork first, then right.\n'),

            TextSpan(text: '- Start with right: '),
            TextSpan(text: 'Opposite of the above.\n'),

            TextSpan(text: '- Any available: '),
            TextSpan(text: 'Pick whichever fork is free, then try for the other.\n'),
          ],
        ),
      ),
    );
  }
}
