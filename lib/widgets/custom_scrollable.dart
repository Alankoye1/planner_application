import 'package:flutter/material.dart';

class CustomScrollable extends StatefulWidget {
  const CustomScrollable({
    super.key,
    required this.labelText,
    required this.controller,
    required this.minValue,
    required this.maxValue,
    required this.initialValue,
    this.step = 1,
  });

  final String labelText;
  final TextEditingController controller;
  final int minValue;
  final int maxValue;
  final int initialValue;
  final int step;

  @override
  State<CustomScrollable> createState() => _CustomScrollableState();
}

class _CustomScrollableState extends State<CustomScrollable>
    with TickerProviderStateMixin {
  late FixedExtentScrollController scrollController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late int currentValue;
  late List<int> values;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Generate values list based on min, max, and step
    values = [];
    for (int i = widget.minValue; i <= widget.maxValue; i += widget.step) {
      values.add(i);
    }

    // Find initial index
    currentValue = widget.initialValue;
    selectedIndex = values.indexOf(currentValue);
    if (selectedIndex == -1) {
      selectedIndex = 0;
      currentValue = values[0];
    }

    scrollController = FixedExtentScrollController(initialItem: selectedIndex);
    widget.controller.text = currentValue.toString();

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String get _unit {
    switch (widget.labelText.toLowerCase()) {
      case 'height':
        return 'cm';
      case 'weight':
        return 'kg';
      case 'age':
        return 'years';
      default:
        return '';
    }
  }

  IconData get _icon {
    switch (widget.labelText.toLowerCase()) {
      case 'height':
        return Icons.height;
      case 'weight':
        return Icons.monitor_weight;
      case 'age':
        return Icons.cake;
      default:
        return Icons.straighten;
    }
  }

  Color _getPrimaryColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (widget.labelText.toLowerCase()) {
      case 'height':
        return colorScheme.primary;
      case 'weight':
        return colorScheme.secondary;
      case 'age':
        return colorScheme.tertiary;
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = _getPrimaryColor(context);
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    primaryColor.withValues(alpha: 0.8),
                    primaryColor.withValues(alpha: 0.6),
                    primaryColor.withValues(alpha: 0.4),
                    primaryColor.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header with icon and label
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _icon,
                            color: colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.labelText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (widget.labelText == 'Height' ||
                            widget.labelText == 'Weight')
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Row(
                                    children: [
                                      Icon(_icon, color: primaryColor),
                                      const SizedBox(width: 8),
                                      const Text('Info'),
                                    ],
                                  ),
                                  content: Text(
                                    'Set your ${widget.labelText.toLowerCase()} in $_unit.',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: TextButton.styleFrom(
                                        foregroundColor: primaryColor,
                                      ),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.info_outline,
                                color: primaryColor,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Current value display
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentValue.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (_unit.isNotEmpty) ...[
                            const SizedBox(width: 4),
                            Text(
                              _unit,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Scrollable picker
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          children: [
                            ListWheelScrollView(
                              controller: scrollController,
                              itemExtent: 40,
                              perspective: 0.003,
                              diameterRatio: 1.5,
                              physics: const FixedExtentScrollPhysics(),
                              squeeze: 1.2,
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  selectedIndex = index;
                                  currentValue = values[index];
                                  widget.controller.text = currentValue
                                      .toString();
                                });
                              },
                              children: values.asMap().entries.map((entry) {
                                final int index = entry.key;
                                final int value = entry.value;
                                final bool isSelected = selectedIndex == index;

                                return Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: TextStyle(
                                      fontSize: isSelected ? 20 : 16,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? primaryColor
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                    child: Text(value.toString()),
                                  ),
                                );
                              }).toList(),
                            ),

                            // Selection indicator
                            Positioned.fill(
                              child: IgnorePointer(
                                child: Center(
                                  child: Container(
                                    height: 40,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: primaryColor.withValues(
                                        alpha: 0.1,
                                      ),
                                      border: Border.all(
                                        color: primaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
