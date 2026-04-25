import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_cubit.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_state.dart';

class CalendarSelectorSheet extends StatelessWidget {
  const CalendarSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
        builder: (context, state) {
          final cubit = context.read<BookAppointmentCubit>();
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          // TableCalendar uses a focusedDay to determine which month to show
          final focusedDay = DateTime(
            state.calendarYear != 0 ? state.calendarYear : now.year,
            state.calendarMonth != 0 ? state.calendarMonth : now.month,
            1,
          );

          return Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: TableCalendar(
                  locale: 'vi_VN',
                  firstDay: DateTime(now.year, now.month, 1),
                  lastDay: DateTime.now().add(const Duration(days: 365)),
                  focusedDay: focusedDay,
                  currentDay: today,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  selectedDayPredicate: (day) {
                    return isSameDay(state.appointmentDate, day);
                  },
                  enabledDayPredicate: (day) {
                    final normalizedDay = DateTime(day.year, day.month, day.day);
                    final isPast = normalizedDay.isBefore(today);
                    final isOpen = state.calendarAvailability[normalizedDay] ?? false;
                    return !isPast && isOpen;
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    cubit.selectDate(selectedDay);
                    Navigator.pop(context);
                  },
                  onPageChanged: (focusedDay) {
                    cubit.loadCalendarData(
                      month: focusedDay.month,
                      year: focusedDay.year,
                    );
                  },
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeader,
                    ),
                    leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: AppColors.textHeader),
                    rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: AppColors.textHeader),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: AppColors.textSlate, fontWeight: FontWeight.bold),
                    weekendStyle: TextStyle(color: AppColors.textSlate, fontWeight: FontWeight.bold),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    defaultTextStyle: const TextStyle(color: AppColors.textHeader),
                    weekendTextStyle: const TextStyle(color: AppColors.textHeader),
                    outsideDaysVisible: false,
                    disabledTextStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final normalizedDay = DateTime(day.year, day.month, day.day);
                      final isOpen = state.calendarAvailability[normalizedDay] ?? false;
                      
                      if (isOpen) {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              "${day.day}",
                              style: const TextStyle(color: AppColors.textHeader),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
