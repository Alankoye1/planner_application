import 'package:flutter/material.dart';

class GenderSwitch extends StatefulWidget {
  const GenderSwitch({
    super.key,
    required this.isMale,
    required this.onGenderChanged,
  });

  final bool isMale;
  final ValueChanged<bool> onGenderChanged;

  @override
  State<GenderSwitch> createState() => _GenderSwitchState();
}

class _GenderSwitchState extends State<GenderSwitch> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    if (!widget.isMale) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(GenderSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMale != oldWidget.isMale) {
      if (widget.isMale) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade50,
            Colors.pink.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Male option
            Flexible(
              child: GestureDetector(
                onTap: () {
                  if (!widget.isMale) {
                    widget.onGenderChanged(true);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: widget.isMale
                        ? LinearGradient(
                            colors: [Colors.blue.shade400, Colors.blue.shade600],
                          )
                        : null,
                    color: widget.isMale ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: widget.isMale
                        ? [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.man_rounded,
                        color: widget.isMale ? Colors.white : Colors.blue.shade400,
                        size: 24,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Male',
                        style: TextStyle(
                          color: widget.isMale ? Colors.white : Colors.blue.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Divider
            Container(
              width: 2,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.shade300,
                    Colors.grey.shade200,
                    Colors.grey.shade300,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Female option
            Flexible(
              child: GestureDetector(
                onTap: () {
                  if (widget.isMale) {
                    widget.onGenderChanged(false);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: !widget.isMale
                        ? LinearGradient(
                            colors: [Colors.pink.shade400, Colors.pink.shade600],
                        )
                      : null,
                  color: !widget.isMale ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: !widget.isMale
                      ? [
                          BoxShadow(
                            color: Colors.pink.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.woman_rounded,
                      color: !widget.isMale ? Colors.white : Colors.pink.shade400,
                      size: 24,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Female',
                      style: TextStyle(
                        color: !widget.isMale ? Colors.white : Colors.pink.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),)
          ],
        ),
      ),
    );
  }
}
