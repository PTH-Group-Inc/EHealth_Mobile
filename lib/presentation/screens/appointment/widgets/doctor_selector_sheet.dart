import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_cubit.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';

class DoctorSelectorSheet extends StatelessWidget {
  const DoctorSelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Chọn bác sĩ chỉ định",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textHeader,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
              builder: (context, state) {
                if (state.isLoadingDoctors) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: AppLoadingWidget(),
                    ),
                  );
                }

                if (state.availableDoctors.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        "Không có bác sĩ nào cho dịch vụ này",
                        style: TextStyle(color: AppColors.textSlate),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.availableDoctors.length + 1,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final isSelected = state.selectedDoctor == null;
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.grey200,
                          child: Icon(Icons.person_outline, color: AppColors.textSlate),
                        ),
                        title: const Text(
                          "Bác sĩ bất kỳ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text("Hệ thống sẽ tự động chỉ định bác sĩ"),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: AppColors.primary)
                            : null,
                        onTap: () {
                          context.read<BookAppointmentCubit>().selectDoctor(null);
                          Navigator.pop(context);
                        },
                      );
                    }

                    final doctor = state.availableDoctors[index - 1];
                    final isSelected = state.selectedDoctor?.doctorId == doctor.doctorId;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        backgroundImage: doctor.doctorAvatar != null
                            ? NetworkImage(doctor.doctorAvatar!)
                            : null,
                        child: doctor.doctorAvatar == null
                            ? const Icon(Icons.person, color: AppColors.primary)
                            : null,
                      ),
                      title: Text(
                        doctor.doctorName ?? "Bác sĩ",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: doctor.isPrimary
                          ? const Text(
                              "Bác sĩ chuyên trách",
                              style: TextStyle(color: AppColors.primary, fontSize: 12),
                            )
                          : null,
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : null,
                      onTap: () {
                        context.read<BookAppointmentCubit>().selectDoctor(doctor);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
