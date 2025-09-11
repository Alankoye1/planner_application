import 'package:flutter/material.dart';
import 'package:planner/screens/excersice_screen.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({
    super.key,
    required this.categoryId,
    required this.categoryImage,
    required this.categoryTitle,
    required this.categoryexcerciseCount,
    this.delay = 0,
  });
  final String categoryId;
  final String categoryImage;
  final String categoryTitle;
  final String categoryexcerciseCount;
  final int delay;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _tapController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600 + widget.delay),
      vsync: this,
    );
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  void _handleTapDown() {
    _tapController.forward();
  }

  void _handleTapUp() {
    _tapController.reverse();
  }

  void _handleTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Excercisescreen(categoryTitle: widget.categoryTitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Generate gradient colors based on category
    List<Color> getGradientColors() {
      switch (widget.categoryId.toLowerCase()) {
        case 'c1':
          return [Colors.blue.shade400, Colors.blue.shade600];
        case 'c2':
          return [Colors.green.shade400, Colors.green.shade600];
        case 'c3':
          return [Colors.orange.shade400, Colors.orange.shade600];
        case 'c4':
          return [Colors.purple.shade400, Colors.purple.shade600];
        case 'c5':
          return [Colors.red.shade400, Colors.red.shade600];
        default:
          return [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)];
      }
    }

    final gradientColors = getGradientColors();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value.clamp(0.0, 1.0),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _handleTap,
                    onTapDown: (_) => _handleTapDown(),
                    onTapUp: (_) => _handleTapUp(),
                    onTapCancel: () => _handleTapUp(),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Image Container
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                widget.categoryImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.categoryTitle,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.fitness_center,
                                      color: Colors.white.withValues(alpha: 0.8),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      widget.categoryexcerciseCount,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withValues(alpha: 0.9),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Arrow Icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
