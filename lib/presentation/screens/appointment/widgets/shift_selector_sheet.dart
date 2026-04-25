import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_cubit.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_state.dart';

class ShiftSelectorSheet extends StatelessWidget {
  const ShiftSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        final availableShifts = state.shifts.where((shift) {
          return state.availableDateSlots.any(
            (slot) => slot.shiftId == shift.id && slot.isAvailable == true,
          );
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Chọn Ca Khám",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeader,
                ),
              ),
              const SizedBox(height: 16),
              if (state.isLoadingDateSlots)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (availableShifts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy_rounded,
                        color: Colors.grey,
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Không có ca khám nào còn trống trong ngày này",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSlate),
                      ),
                    ],
                  ),
                )
              else
                ...availableShifts.map(
                  (shift) => ListTile(
                    onTap: () {
                      context.read<BookAppointmentCubit>().selectShift(shift);
                      Navigator.pop(context);
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      shift.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${shift.startTime} - ${shift.endTime}"),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
