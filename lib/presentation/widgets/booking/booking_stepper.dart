import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';

class BookingStepper extends StatelessWidget {
  final int totalSteps;
  final int currentIndex;
  final String stepTitle;

  const BookingStepper({
    super.key,
    required this.totalSteps,
    required this.currentIndex,
    required this.stepTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          Stack(
            children: [
              // Lines layer
              Positioned(
                left: 0,
                right: 0,
                top: 12, // Half of circle height (24/2)
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.width - 40) /
                        (totalSteps * 2),
                  ),
                  child: Row(
                    children: List.generate(totalSteps - 1, (index) {
                      final isCompleted = index < currentIndex;
                      return Expanded(
                        child: Container(
                          height: 2,
                          color: isCompleted
                              ? AppColors.primary
                              : AppColors.grey200,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              // Circles layer
              Row(
                children: List.generate(totalSteps, (index) {
                  final isCompleted = index < currentIndex;
                  final isCurrent = index == currentIndex;

                  return Expanded(
                    child: Center(
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? AppColors.primary
                              : AppColors.grey200,
                          shape: BoxShape.circle,
                          border: isCurrent
                              ? Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 4,
                                )
                              : null,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check,
                                  size: 14, color: Colors.white)
                              : Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isCurrent
                                        ? Colors.white
                                        : AppColors.textSlate,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            stepTitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
