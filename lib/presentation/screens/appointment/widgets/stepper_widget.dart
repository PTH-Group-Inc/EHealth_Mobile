import 'package:flutter/material.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_state.dart';

class StepperWidget extends StatelessWidget {
  final BookAppointmentState state;

  const StepperWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    int currentStep = 0;
    if (state.selectedSlot != null) {
      currentStep = 3;
    } else if (state.appointmentDate != null) {
      currentStep = 2;
    } else if (state.selectedService != null) {
      currentStep = 1;
    }

    final steps = ["Dịch vụ", "Ngày khám", "Giờ khám", "Xác nhận"];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              // Lines layer
              Positioned(
                left: 0,
                right: 0,
                top: 14, // Half of circle height (28/2)
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (MediaQuery.of(context).size.width - 40) /
                        (steps.length * 2),
                  ),
                  child: Row(
                    children: List.generate(steps.length - 1, (index) {
                      final isCompleted = index < currentStep;
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
                children: List.generate(steps.length, (index) {
                  final isCompleted = index < currentStep;
                  final isCurrent = index == currentStep;

                  return Expanded(
                    child: Center(
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? AppColors.primary
                              : AppColors.grey100,
                          shape: BoxShape.circle,
                          border: isCurrent
                              ? Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.2,
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
                                    fontSize: 12,
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
          // Labels layer
          Row(
            children: steps.map((s) {
              final index = steps.indexOf(s);
              final isCurrent = index == currentStep;
              return Expanded(
                child: Text(
                  s,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                    color: isCurrent ? AppColors.primary : AppColors.textSlate,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
