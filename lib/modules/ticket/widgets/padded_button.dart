import 'package:flutter/material.dart';

class PaddedButton extends StatelessWidget {
  final void Function()? onTap;
  final Color color;
  final String text;
  final Icon icon;

  const PaddedButton(
      {Key? key, this.onTap, required this.color, required this.text, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: Center(
                child: Ink(
                  decoration: ShapeDecoration(
                    color: onTap == null ? Colors.grey.shade600 : color,
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    icon: icon,
                    disabledColor: Colors.white,
                    onPressed: null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              text.toUpperCase(),
              style: TextStyle(
                color: onTap == null ? Colors.grey.shade600 : color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
