import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_cubit.dart';
import 'package:e_health/presentation/screens/appointment/cubit/book_appointment_state.dart';

class ServiceSelectorSheet extends StatefulWidget {
  final String? facilityId;
  final String? departmentId;
  final TextEditingController searchController;

  const ServiceSelectorSheet({
    super.key,
    required this.facilityId,
    this.departmentId,
    required this.searchController,
  });

  @override
  State<ServiceSelectorSheet> createState() => _ServiceSelectorSheetState();
}

class _ServiceSelectorSheetState extends State<ServiceSelectorSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, controller) {
        controller.addListener(() {
          if (controller.position.pixels >=
              controller.position.maxScrollExtent - 200) {
            context.read<BookAppointmentCubit>().loadMoreServices(
              widget.facilityId,
              departmentId: widget.departmentId,
            );
          }
        });

        return BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
          builder: (context, state) {
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
                    "Chọn Dịch vụ Khám",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeader,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: widget.searchController,
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm dịch vụ...",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textSlate,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (val) => context
                        .read<BookAppointmentCubit>()
                        .searchServices(widget.facilityId, val),
                  ),
                  const SizedBox(height: 16),
                  if (state.isSearchingServices)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.services.isEmpty)
                    const Expanded(
                      child: Center(child: Text("Không tìm thấy dịch vụ nào")),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        controller: controller,
                        itemCount:
                            state.services.length +
                            (state.isFetchingMoreServices ? 1 : 0),
                        separatorBuilder: (_, _) =>
                            const Divider(color: AppColors.border),
                        itemBuilder: (ctx, index) {
                          if (index < state.services.length) {
                            final service = state.services[index];
                            return ListTile(
                              onTap: () {
                                context
                                    .read<BookAppointmentCubit>()
                                    .selectService(service);
                                Navigator.pop(ctx);
                              },
                              title: Text(
                                service.serviceName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                "${service.estimatedDurationMinutes} phút • Mã: ${service.serviceCode}",
                              ),
                              trailing: Text(
                                NumberFormat.currency(
                                  locale: 'vi',
                                  symbol: 'đ',
                                ).format(
                                  double.tryParse(service.basePrice) ?? 0,
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
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
