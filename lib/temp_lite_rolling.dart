import 'package:flutter/material.dart';

class LiteRolling2Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                child: Container(
                  child: Center(
                    child: Text(
                      'text',
                      style: TextStyle(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
