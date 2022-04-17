import 'package:flutter/material.dart';

class PaddedButton extends StatelessWidget {
  final void Function()? onTap;
  final Color color;
  final String text;

  const PaddedButton({Key? key, this.onTap, required this.color, required this.text}) : super(key: key);

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
                    color: color,
                    shape: const CircleBorder(),
                  ),
                  child: const IconButton(
                    icon: Icon(Icons.qr_code),
                    disabledColor: Colors.white,
                    onPressed: null,
                  ),
                ),
              ),
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
