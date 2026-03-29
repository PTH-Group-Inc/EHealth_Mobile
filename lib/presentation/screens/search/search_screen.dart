import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_color.dart';
import '../../../domain/department.dart';
import 'cubit/search_cubit.dart';
import 'cubit/search_state.dart';
import '../../widgets/feedback/empty_state_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textDark,
            size: 20,
          ),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Tên chuyên khoa, triệu chứng...',
            hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20, color: AppColors.textSlate),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SearchCubit>().clearSearch();
                      setState(() {});
                    },
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 16, color: AppColors.textDark),
          onChanged: (value) {
            context.read<SearchCubit>().search(value);
            setState(() {});
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.grey200),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is SearchError) {
            return EmptyStateWidget(
              icon: Icons.error_outline_rounded,
              title: "Đã xảy ra lỗi",
              subtitle: state.message,
              onAction: () => context.read<SearchCubit>().search(_searchController.text),
              actionLabel: "Thử lại",
            );
          }

          if (state is SearchLoaded) {
            if (state.results.isEmpty) {
              return _buildEmptyResult();
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.results.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildDepartmentCard(state.results[index]),
            );
          }

          return _buildInitialView();
        },
      ),
    );
  }

  Widget _buildInitialView() {
    return const EmptyStateWidget(
      icon: Icons.search_rounded,
      title: "Tìm kiếm chuyên khoa",
      subtitle: "Nhập tên chuyên khoa hoặc triệu chứng để tìm bác sĩ phù hợp nhất với bạn.",
    );
  }

  Widget _buildEmptyResult() {
    return const EmptyStateWidget(
      icon: Icons.search_off_rounded,
      title: "Không tìm thấy kết quả",
      subtitle: "Rất tiếc, chúng tôi không tìm thấy chuyên khoa nào khớp với từ khóa của bạn. Vui lòng thử lại.",
    );
  }

  Widget _buildDepartmentCard(Department dept) {
    return InkWell(
      onTap: () => context.pushNamed('specialty-detail', pathParameters: {'id': dept.id ?? ''}),
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
              child: const Icon(Icons.medical_services_outlined, color: AppColors.primary, size: 24),
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
                    style: const TextStyle(fontSize: 13, color: AppColors.textSlate),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.grey400),
          ],
        ),
      ),
    );
  }
}

