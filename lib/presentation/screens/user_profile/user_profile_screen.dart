import 'cubit/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/feedback/app_refresh.dart';
import '../../../app/theme/app_color.dart';
import 'cubit/user_profile_cubit.dart';
import '../../../domain/user_profile.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textDark,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is UserProfileError) {
            return AppRefresh(
              onRefresh: () async =>
                  context.read<UserProfileCubit>().loadProfile(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: Center(child: Text(state.message)),
                ),
              ),
            );
          }
          if (state is UserProfileLoaded) {
            return AppRefresh(
              onRefresh: () async =>
                  context.read<UserProfileCubit>().loadProfile(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeader(state.profile),
                    _buildInfoSection(state.profile),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHeader(UserProfile profile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.surface,
                backgroundImage: profile.avatarUrl != null
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: profile.avatarUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.textLight,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(
            profile.email,
            style: const TextStyle(fontSize: 14, color: AppColors.textSlate),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(UserProfile profile) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Thông tin chi tiết",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final cubit = context.read<UserProfileCubit>();
                    final state = cubit.state;
                    if (state is UserProfileLoaded) {
                      final result = await context.pushNamed('edit-profile', extra: state.profile);
                      if (result == true) {
                        cubit.loadProfile();
                      }
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Chỉnh sửa",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            Icons.phone_outlined,
            "Số điện thoại",
            profile.phone ?? "Chưa cập nhật",
          ),
          _buildInfoItem(
            Icons.location_on_outlined,
            "Địa chỉ",
            profile.address ?? "Chưa cập nhật",
          ),
          _buildInfoItem(
            Icons.credit_card_outlined,
            "CCCD/CMND",
            profile.identityCard ?? "Chưa cập nhật",
          ),
          _buildInfoItem(
            Icons.person_outline,
            "Giới tính",
            profile.gender ?? "Chưa cập nhật",
          ),
          _buildInfoItem(
            Icons.cake_outlined,
            "Ngày sinh",
            profile.birthday != null
                ? "${profile.birthday!.day}/${profile.birthday!.month}/${profile.birthday!.year}"
                : "Chưa cập nhật",
          ),
          _buildInfoItem(
            Icons.info_outline,
            "Trạng thái",
            profile.status ?? "N/A",
          ),
          _buildInfoItem(
            Icons.admin_panel_settings_outlined,
            "Vai trò",
            profile.roles?.join(", ") ?? "PATIENT",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.surface),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSlate,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
