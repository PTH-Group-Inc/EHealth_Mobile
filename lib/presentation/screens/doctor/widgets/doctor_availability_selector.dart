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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "Bác sĩ không có lịch làm việc công khai.",
            style: TextStyle(color: AppColors.textSlate, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            "Chọn ngày khám",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.textHeader,
            ),
          ),
        ),
        SizedBox(
          height: 105,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dates.length,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final dateStr = _dates[index];
              final date = DateTime.parse(dateStr);
              final isSelected = _selectedDate == dateStr;
              
              return GestureDetector(
                onTap: () {
                   setState(() {
                    _selectedDate = dateStr;
                    _selectedShift = null;
                   });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 72,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected 
                            ? AppColors.primary.withValues(alpha: 0.2) 
                            : AppColors.shadow,
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
                          color: isSelected ? Colors.white : AppColors.textSlate,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat('dd').format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textHeader,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Th ${date.month}",
                        style: TextStyle(
                          color: isSelected ? Colors.white.withValues(alpha: 0.8) : AppColors.textSlate,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 32),

        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            "Chọn ca khám",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.textHeader,
            ),
          ),
        ),
        if (_selectedDate != null)
          ...widget.availability[_selectedDate]!.where((availability) {
            final name = availability.shiftName.toLowerCase();
            final code = availability.shiftCode.toLowerCase();
            return !name.contains("tối") && !code.contains("3") && !name.contains("ca 3");
          }).map((availability) {
            final isSelected = _selectedShift?.staffSchedulesId ==
                availability.staffSchedulesId;
            return _buildSelectionCard(
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedShift = availability;
                });
                widget.onSelected(
                  DateTime.parse(_selectedDate!),
                  availability,
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.access_time_filled_rounded,
                      color: isSelected ? Colors.white : AppColors.primary,
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
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: isSelected ? AppColors.primary : AppColors.textHeader,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${availability.startTime} - ${availability.endTime}",
                          style: const TextStyle(
                            color: AppColors.textSlate,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildSelectionCard({
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected 
                ? AppColors.primary.withValues(alpha: 0.1) 
                : AppColors.shadow,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
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
