import 'package:flutter/material.dart';

class TableCalory extends StatefulWidget {
  const TableCalory({
    super.key,
    required this.caloryTable,
    required this.result,
  });

  final Map<String, double>? caloryTable;
  final double result;

  @override
  State<TableCalory> createState() => _TableCaloryState();
}

class _TableCaloryState extends State<TableCalory> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _rowAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Create staggered animations for each row
    _rowAnimations = List.generate(5, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.15,
          0.6 + (index * 0.15),
          curve: Curves.easeOutCubic,
        ),
      ));
    });
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildCaloryRow({
    required String goal,
    required double calories,
    required Color color,
    required IconData icon,
    required int index,
  }) {
    return AnimatedBuilder(
      animation: _rowAnimations[index],
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _rowAnimations[index].value)),
          child: Opacity(
            opacity: _rowAnimations[index].value.clamp(0.0, 1.0),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.1),
                    color.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Weekly goal',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${calories.toStringAsFixed(0)} kcal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> caloryGoals = [
      {
        'goal': 'Lose 1 kg per week',
        'calories': widget.result - 1000,
        'color': Colors.red.shade400,
        'icon': Icons.trending_down,
      },
      {
        'goal': 'Lose 0.5 kg per week',
        'calories': widget.result - 500,
        'color': Colors.orange.shade400,
        'icon': Icons.remove_circle_outline,
      },
      {
        'goal': 'Maintain current weight',
        'calories': widget.result,
        'color': Colors.green.shade400,
        'icon': Icons.balance,
      },
      {
        'goal': 'Gain 0.5 kg per week',
        'calories': widget.result + 500,
        'color': Colors.blue.shade400,
        'icon': Icons.add_circle_outline,
      },
      {
        'goal': 'Gain 1 kg per week',
        'calories': widget.result + 1000,
        'color': Colors.purple.shade400,
        'icon': Icons.trending_up,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.table_chart,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Calorie Goals',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Calorie goals list
          ...caloryGoals.asMap().entries.map((entry) {
            final int index = entry.key;
            final Map<String, dynamic> goal = entry.value;
            
            return _buildCaloryRow(
              goal: goal['goal'],
              calories: goal['calories'],
              color: goal['color'],
              icon: goal['icon'],
              index: index,
            );
          }),
          
          const SizedBox(height: 16),
          
          // Footer note
          AnimatedBuilder(
            animation: _rowAnimations.last,
            builder: (context, child) {
              return Opacity(
                opacity: _rowAnimations.last.value.clamp(0.0, 1.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'These are general guidelines. Consult with a healthcare professional for personalized advice.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
