import 'package:flutter/material.dart';

class PlayerWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon icon;

  const PlayerWidget({
    this.onPressed,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final size = (icon.size ?? iconTheme.size)!+5;
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      child: SizedBox(
        height: size,
        width: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            icon,
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onPressed,
              ),
            )
          ],
        )
      ),
    );
  }
}
