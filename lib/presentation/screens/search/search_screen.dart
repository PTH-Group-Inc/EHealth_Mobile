import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/department.dart';
import 'package:e_health/domain/doctor.dart';
import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';
import 'package:e_health/presentation/widgets/feedback/app_loading_widget.dart';

import 'package:e_health/presentation/widgets/feedback/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/presentation/screens/search/cubit/search_cubit.dart';
import 'package:e_health/presentation/screens/search/cubit/search_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SearchCubit>().loadMoreDoctors();
      context.read<SearchCubit>().loadMoreDepartments();
    }
  }

  void _onChipTap(String text) {
    _searchController.text = text;
    context.read<SearchCubit>().search(text);
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
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
        titleSpacing: 0,
        leadingWidth: 48,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSlate,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'Tìm chuyên khoa, bác sĩ...',
                      hintStyle: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textDark,
                    ),
                    onChanged: (value) {
                      context.read<SearchCubit>().search(value);
                      setState(() {});
                    },
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(
                      Icons.clear,
                      size: 18,
                      color: AppColors.textSlate,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SearchCubit>().clearSearch();
                      setState(() {});
                    },
                    padding: const EdgeInsets.only(right: 8),
                    constraints: const BoxConstraints(),
                  )
                else
                  const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildQuickFilters(),
          Expanded(
            child: AppRefresh(
              onRefresh: () async {
                if (_searchController.text.isNotEmpty) {
                  await context.read<SearchCubit>().search(
                    _searchController.text,
                  );
                }
              },
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.status == SearchStatus.loading) {
                    return const SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 500,
                        child: Center(child: AppLoadingWidget()),
                      ),
                    );
                  }

                  if (state.status == SearchStatus.failure) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 500,
                        child: Center(
                          child: EmptyStateWidget(
                            icon: Icons.error_outline_rounded,
                            title: "Đã xảy ra lỗi",
                            subtitle:
                                state.errorMessage ??
                                "Đã xảy ra lỗi không xác định",
                            onAction: () => context.read<SearchCubit>().search(
                              _searchController.text,
                            ),
                            actionLabel: "Thử lại",
                          ),
                        ),
                      ),
                    );
                  }

                  if (state.status == SearchStatus.success) {
                    if (state.departments.isEmpty && state.doctors.isEmpty) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: 500,
                          child: _buildEmptyResult(),
                        ),
                      );
                    }
                    return _buildSearchResults(state);
                  }

                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(height: 500, child: _buildInitialView()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(SearchState state) {
    return ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (state.departments.isNotEmpty) ...[
          _buildSectionHeader("Chuyên khoa"),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: state.departments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _buildDepartmentCard(state.departments[index]),
          ),
        ],
        if (state.doctors.isNotEmpty) ...[
          const SizedBox(height: 5),
          _buildSectionHeader("Bác sĩ"),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: state.doctors.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _buildDoctorCard(state.doctors[index]),
          ),
        ],
        if (state.isFetchingMoreDoctors)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: AppLoadingWidget(size: 24)),
          ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textSlate,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInitialView() {
    return const EmptyStateWidget(
      icon: Icons.search_rounded,
      title: "Tìm kiếm thông tin",
      subtitle:
          "Nhập tên chuyên khoa, bác sĩ hoặc triệu chứng để tìm thông tin phù hợp.",
    );
  }

  Widget _buildQuickFilters() {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        spacing: 10,
        children: [
          _buildSuggestionChip("Bác sĩ", "BS"),
          _buildSuggestionChip("Chuyên khoa", "Khoa"),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label, String value) {
    return InkWell(
      onTap: () => _onChipTap(value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyResult() {
    return const EmptyStateWidget(
      icon: Icons.search_off_rounded,
      title: "Không tìm thấy kết quả",
      subtitle:
          "Rất tiếc, chúng tôi không tìm thấy thông tin nào khớp với từ khóa của bạn. Vui lòng thử lại.",
    );
  }

  Widget _buildDepartmentCard(Department dept) {
    return InkWell(
      onTap: () => context.pushNamed(
        'specialty-detail',
        pathParameters: {'id': dept.departmentsId ?? ''},
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dept.name ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dept.branchName ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSlate,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.grey400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return InkWell(
      onTap: () => context.pushNamed(
        'doctor-detail',
        pathParameters: {'id': doctor.userId ?? ''},
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: doctor.avatarUrl.isNotEmpty
                  ? Image.network(
                      doctor.avatarUrl[0].url,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _buildDoctorPlaceholder(),
                    )
                  : _buildDoctorPlaceholder(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${doctor.title ?? 'Bác sĩ'} ${doctor.fullName ?? ''}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialtyName ?? 'Đang cập nhật',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.grey400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorPlaceholder() {
    return Container(
      width: 50,
      height: 50,
      color: AppColors.primaryBackground,
      child: const Icon(
        Icons.person_rounded,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }
}
