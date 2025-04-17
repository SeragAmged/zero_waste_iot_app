import 'package:flutter/material.dart';


class DefaultDialog extends StatelessWidget {
  const DefaultDialog({
    super.key,
    required this.title,
    required this.buttons,
    this.prediction,
  });

  final String? prediction;
  final List<Widget> buttons;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(100),
        decoration: ShapeDecoration(
          color: const Color(0xFFFFFDE7).withOpacity(.75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextStyle(
                style: const TextStyle(
                  color: Color(0xFF437028),
                  fontSize: 40,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w800,
                  height: 0.01,
                  letterSpacing: 1.2,
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              if (prediction != null)
                DefaultTextStyle(
                  style: TextStyle(
                    color: prediction == "plastic"
                        ? Colors.red
                        : prediction == "paper"
                            ? Colors.amber
                            : Colors.green,
                    fontSize: 50,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w800,
                    height: 0.01,
                    letterSpacing: 8,
                  ),
                  child: Text(
                    prediction!.toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buttons,
              )
            ],
          ),
        ),
      ),
    );
  }
}
