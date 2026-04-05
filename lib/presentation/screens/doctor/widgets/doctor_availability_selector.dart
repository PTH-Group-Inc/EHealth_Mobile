import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/doctor_availability.dart';

class DoctorAvailabilitySelector extends StatefulWidget {
  final Map<String, List<DoctorAvailability>> availability;
  final Function(DateTime date, DoctorAvailability shift) onSelected;

  const DoctorAvailabilitySelector({
    super.key,
    required this.availability,
    required this.onSelected,
  });

  @override
  State<DoctorAvailabilitySelector> createState() =>
      _DoctorAvailabilitySelectorState();
}

class _DoctorAvailabilitySelectorState
    extends State<DoctorAvailabilitySelector> {
  late List<String> _dates;
  String? _selectedDate;
  DoctorAvailability? _selectedShift;

  @override
  void initState() {
    super.initState();
    // Filter dates that have at least one non-evening shift
    _dates = widget.availability.keys.where((dateStr) {
      final shifts = widget.availability[dateStr]!;
      return shifts.any((availability) {
        final name = availability.shiftName.toLowerCase();
        final code = availability.shiftCode.toLowerCase();
        return !name.contains("tối") && !code.contains("3") && !name.contains("ca 3");
      });
    }).toList()..sort();

    if (_dates.isNotEmpty) {
      _selectedDate = _dates.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dates.isEmpty) {
      return const Center(
        child: Text("Bác sĩ không có lịch làm việc công khai."),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Selection
        const Text(
          "Chọn ngày khám",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeader,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dates.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final dateStr = _dates[index];
              final date = DateTime.parse(dateStr);
              final isSelected = _selectedDate == dateStr;
              
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedDate = dateStr;
                    _selectedShift = null;
                  });
                },
                child: Container(
                  width: 75,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getDayOfWeek(date),
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat('dd/MM').format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // Shift Selection
        const Text(
          "Chọn ca khám",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeader,
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedDate != null)
          ...widget.availability[_selectedDate]!.where((availability) {
            final name = availability.shiftName.toLowerCase();
            final code = availability.shiftCode.toLowerCase();
            // Filter evening shifts (Ca tối / Ca 3)
            return !name.contains("tối") && !code.contains("3") && !name.contains("ca 3");
          }).map((availability) {
            final isSelected = _selectedShift?.staffSchedulesId ==
                availability.staffSchedulesId;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedShift = availability;
                  });
                  widget.onSelected(
                    DateTime.parse(_selectedDate!),
                    availability,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              availability.shiftName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.textHeader,
                              ),
                            ),
                            Text(
                              "${availability.startTime} - ${availability.endTime}",
                              style: const TextStyle(
                                color: AppColors.textSlate,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }

  String _getDayOfWeek(DateTime date) {
    final now = DateTime.now();
    if (DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(now)) {
      return "Hôm nay";
    }
    final weekday = date.weekday;
    switch (weekday) {
      case 1: return "Thứ 2";
      case 2: return "Thứ 3";
      case 3: return "Thứ 4";
      case 4: return "Thứ 5";
      case 5: return "Thứ 6";
      case 6: return "Thứ 7";
      case 7: return "CN";
      default: return "";
    }
  }
}
