import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_cubit.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_state.dart';

class SlotSelectorSheet extends StatelessWidget {
  const SlotSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
      builder: (context, state) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.8,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
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
                    "Chọn Khung Giờ Khám",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeader,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (state.isLoadingSlots)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.slots.isEmpty)
                    const Expanded(
                      child: Center(child: Text("Không có khung giờ khả dụng")),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        controller: scrollController,
                        itemCount: state.slots.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final slot = state.slots[index];
                          final isAvailable = slot.isAvailable;
                          final isSelected = state.selectedSlot?.id == slot.id;

                          final date = state.appointmentDate ?? DateTime.now();
                          final weekday = DateFormat(
                            "EEEE",
                            "vi_VN",
                          ).format(date);
                          final dateStr = DateFormat("dd/MM/yyyy").format(date);

                          return InkWell(
                            onTap: isAvailable
                                ? () {
                                    context
                                        .read<BookAppointmentCubit>()
                                        .selectSlot(slot);
                                    Navigator.pop(ctx);
                                  }
                                : null,
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: !isAvailable
                                    ? Colors.grey[50]
                                    : isSelected
                                    ? AppColors.primary.withValues(alpha: 0.05)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: !isAvailable
                                      ? AppColors.border.withValues(alpha: 0.5)
                                      : isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Opacity(
                                opacity: isAvailable ? 1.0 : 0.5,
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          weekday.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.textHeader,
                                          ),
                                        ),
                                        Text(
                                          dateStr,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSlate,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    if (!isAvailable)
                                      Container(
                                        margin: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Text(
                                          "Hết chỗ",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: !isAvailable
                                            ? Colors.grey[300]
                                            : isSelected
                                            ? AppColors.primary
                                            : AppColors.primary.withValues(
                                                alpha: 0.1,
                                              ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "${slot.startTime.substring(0, 5)} - ${slot.endTime.substring(0, 5)}",
                                        style: TextStyle(
                                          color: !isAvailable
                                              ? Colors.grey[600]
                                              : isSelected
                                              ? Colors.white
                                              : AppColors.primary,
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
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
