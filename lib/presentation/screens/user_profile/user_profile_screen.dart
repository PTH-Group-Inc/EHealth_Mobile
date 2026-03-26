import 'package:e_health/presentation/screens/user_profile/cubit/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health/presentation/widgets/feedback/app_refresh.dart';
import 'cubit/user_profile_cubit.dart';
import 'package:e_health/domain/user_profile.dart';

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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF1E293B),
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
              child: CircularProgressIndicator(color: Color(0xFF3B82C4)),
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
                backgroundColor: const Color(0xFFF1F5F9),
                backgroundImage: profile.avatarUrl != null
                    ? NetworkImage(profile.avatarUrl!)
                    : null,
                child: profile.avatarUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF94A3B8),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82C4),
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
              color: Color(0xFF1E293B),
            ),
          ),
          Text(
            profile.email,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
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
          const Text(
            "Thông tin chi tiết",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
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
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF3B82C4)),
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
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
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
