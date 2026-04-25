import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/presentation/screens/doctor/cubit/all_doctor_cubit.dart';
import 'package:e_health/presentation/screens/doctor/cubit/all_doctor_state.dart';
import 'package:e_health/presentation/widgets/data_display/doctor_card.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';
import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';
import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';

class AllDoctorScreen extends StatefulWidget {
  const AllDoctorScreen({super.key});

  @override
  State<AllDoctorScreen> createState() => _AllDoctorScreenState();
}

class _AllDoctorScreenState extends State<AllDoctorScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AllDoctorCubit>().loadDoctors();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AllDoctorCubit>().loadMoreDoctors();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Tất cả bác sĩ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  context.read<AllDoctorCubit>().loadDoctors(query: value),
              decoration: InputDecoration(
                hintText: "Tìm kiếm bác sĩ...",
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSlate,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryBorder),
                ),
              ),
            ),
          ),
          Expanded(
            child: AppRefresh(
              onRefresh: () async {
                await context.read<AllDoctorCubit>().loadDoctors();
              },
              child: BlocBuilder<AllDoctorCubit, AllDoctorState>(
                builder: (context, state) {
                  if (state.status == AllDoctorStatus.loading &&
                      state.doctors.isEmpty) {
                    return const Center(child: AppLoadingWidget());
                  }

                  if (state.status == AllDoctorStatus.failure &&
                      state.doctors.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.error_outline,
                      title: "Đã có lỗi xảy ra",
                      subtitle: state.errorMessage ?? "Vui lòng thử lại sau",
                      onAction: () =>
                          context.read<AllDoctorCubit>().loadDoctors(),
                      actionLabel: "Thử lại",
                    );
                  }

                  final doctors = state.doctors;
                  if (doctors.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.person_off_outlined,
                      title: "Không tìm thấy bác sĩ",
                      subtitle: "Thử tìm kiếm với từ khóa khác",
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: doctors.length + (state.isFetchingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < doctors.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DoctorCard(doctor: doctors[index]),
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: AppLoadingWidget(size: 24)),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
