import 'package:flutter/material.dart';

class HelpingBox extends StatelessWidget {
  const HelpingBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(border: Border.all(width: 2)),
        child: FittedBox(
          child: Text(
            """
   
   Blue : Thinking    
   Red : Hungry   
   Green : Eating   
   Gray : Terminated
   Brown circle : Fork (Available)  
   Red circle : Fork (In Use)  
            """,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
