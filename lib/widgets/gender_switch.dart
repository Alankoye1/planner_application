import 'package:flutter/material.dart';

class GenderSwitch extends StatelessWidget {
  const GenderSwitch({
    super.key,
    required this.isMale,
    required this.onGenderChanged,
  });

  final bool isMale;
  final ValueChanged<bool> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isMale) {
          onGenderChanged(false);
        } else {
          onGenderChanged(true);
        }
      },
      child: Row(
        children: [
          Icon(
            Icons.man_rounded,
            color: isMale ? Colors.blueAccent : Colors.grey,
            size: 50,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
          ),
          Icon(
            Icons.woman_rounded,
            color: isMale ? Colors.grey : Colors.pink,
            size: 50,
          ),
        ],
      ),
    );
  }
}
