import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ToggleButton extends StatefulWidget {
  int? initialIndex;
  final List<String> choices;
  final void Function(int index) onToggled;
  final double height;
  final EdgeInsetsGeometry margin;
  ToggleButton({
    required this.choices,
    required this.onToggled,
    this.initialIndex,
    this.height = 30,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

const double startAlign = -1;
const double endAlign = 1;
const Color selectedColor = Colors.black;
const Color normalColor = Colors.black54;

class _ToggleButtonState extends State<ToggleButton> {
  late double xLength;
  late double xAlign;
  late Color loginColor;
  late Color signInColor;

  @override
  void initState() {
    super.initState();
    xAlign = startAlign;
    loginColor = selectedColor;
    signInColor = normalColor;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.choices.length > 1) {
      xLength = (endAlign - startAlign) / (widget.choices.length - 1);
    } else {
      xLength = 0;
    }
    if (widget.initialIndex != null) {
      xAlign = startAlign + widget.initialIndex! * xLength;
    }
    return Container(
      margin: widget.margin,
      height: widget.height,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: const Duration(milliseconds: 300),
            child: FractionallySizedBox(
              heightFactor: 1,
              widthFactor: 1 / widget.choices.length,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: List.generate(
              widget.choices.length,
              (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (widget.choices.length > 1) {
                        widget.onToggled(index);
                      }
                      setState(() {
                        widget.initialIndex = index;
                        xAlign = startAlign + (widget.initialIndex ?? index) * xLength;
                        loginColor = selectedColor;
                        signInColor = normalColor;
                      });
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        // width: widget.width / widget.choice.length,
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Text(
                          widget.choices[index],
                          style: TextStyle(
                            color: loginColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
