import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'cubit/user_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/feedback/app_refresh.dart';
import '../../../app/theme/app_color.dart';
import 'cubit/user_profile_cubit.dart';
import '../../../domain/user_profile.dart';
import '../../../domain/avatar.dart';
import '../../widgets/data_display/full_screen_image_viewer.dart';
import '../../widgets/feedback/app_loading_widget.dart';
import '../../widgets/feedback/app_toast.dart';
import '../../widgets/feedback/empty_state_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  int _currentImageIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final ImagePicker _picker = ImagePicker();
  bool _wasUploading = false;

  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().loadProfile();
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1080,
    );

    if (image != null) {
      if (mounted) {
        context.read<UserProfileCubit>().uploadAvatar(image.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Stack(
        children: [
          BlocConsumer<UserProfileCubit, UserProfileState>(
            listener: (context, state) {
              if (state is UserProfileUploading) {
                _wasUploading = true;
              }

              if (state is UserProfileLoaded &&
                  state is! UserProfileUploading) {
                if (_wasUploading) {
                  AppToast.showSuccess(
                    context,
                    "Cập nhật ảnh đại diện thành công",
                  );
                  _wasUploading = false;
                }
                setState(() {
                  _currentImageIndex = 0;
                });
              }

              if (state is UserProfileError) {
                _wasUploading = false;
              }
            },
            builder: (context, state) {
              if (state is UserProfileLoading) {
                return const AppLoadingWidget();
              }
              if (state is UserProfileError) {
                return AppRefresh(
                  onRefresh: () async =>
                      context.read<UserProfileCubit>().loadProfile(),
                  child: LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: constraints.maxHeight,
                        child: EmptyStateWidget(
                          icon: Icons.error_outline_rounded,
                          title: "Lỗi tải hồ sơ",
                          subtitle: state.message,
                          onAction: () =>
                              context.read<UserProfileCubit>().loadProfile(),
                          actionLabel: "Thử lại",
                        ),
                      ),
                    ),
                  ),
                );
              }
              if (state is UserProfileLoaded) {
                final avatars = List<Avatar>.from(state.profile.avatars ?? []);
                // Sort by uploadedAt descending (Latest first)
                avatars.sort((a, b) {
                  final dateA = a.uploadedAt ?? DateTime(0);
                  final dateB = b.uploadedAt ?? DateTime(0);
                  return dateB.compareTo(dateA);
                });

                return AppRefresh(
                  onRefresh: () async =>
                      context.read<UserProfileCubit>().loadProfile(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildImageSection(state.profile, avatars),
                        _buildPrimaryBorder(),
                        _buildContentSection(state.profile),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          // Sticky Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(UserProfile profile, List<Avatar> avatars) {
    final hasMultipleImages = avatars.length >= 2;
    final isUploading =
        context.watch<UserProfileCubit>().state is UserProfileUploading;

    return Stack(
      children: [
        // Carousel of Avatars
        if (avatars.isNotEmpty)
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.width * 1.2,
              viewportFraction: 1.0,
              initialPage: 0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
            ),
            items: avatars.asMap().entries.map((entry) {
              final index = entry.key;
              final avatar = entry.value;
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewer(
                            imageUrls: avatars.map((e) => e.url).toList(),
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: "avatar_$index",
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(avatar.url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          )
        else
          Container(
            height: MediaQuery.of(context).size.width * 1.2,
            width: double.infinity,
            color: AppColors.grey100,
            child: const Icon(
              Icons.person,
              size: 100,
              color: AppColors.grey300,
            ),
          ),

        // Loading Overlay
        if (isUploading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),

        // Story Style Indicators (Index) - Only if 2+ images
        if (hasMultipleImages)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 50,
            right: 50,
            child: Row(
              children: List.generate(
                avatars.length,
                (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 3,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPrimaryBorder() {
    return Container(
      height: 4,
      width: double.infinity,
      color: AppColors.primary,
    );
  }

  Widget _buildContentSection(UserProfile profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.name,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          if (profile.email.isNotEmpty)
            Text(
              profile.email,
              style: const TextStyle(color: AppColors.grey500, fontSize: 13),
            ),
          const SizedBox(height: 16),

          // Action Buttons (Only 2 left)
          Row(
            children: [
              _buildActionButton(
                icon: Icons.camera_alt_outlined,
                label: "Đặt ảnh",
                onTap: _pickAndUploadImage,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.edit_outlined,
                label: "Sửa thông tin",
                onTap: () async {
                  final cubit = context.read<UserProfileCubit>();
                  final result = await context.pushNamed(
                    'edit-profile',
                    extra: profile,
                  );
                  if (result == true) {
                    cubit.loadProfile();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Detailed Info
          _buildInfoGroup(profile),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoGroup(UserProfile profile) {
    return Column(
      children: [
        _buildInfoCard(
          title: profile.phone ?? "Chưa cập nhật",
          subtitle: "Di động",
          icon: Icons.phone_outlined,
        ),
        const SizedBox(height: 8),
        _buildInfoCard(
          title: profile.address ?? "Chưa cập nhật",
          subtitle: "Địa chỉ",
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 8),
        _buildInfoCard(
          title: profile.birthday != null
              ? "${profile.birthday!.day} thg ${profile.birthday!.month}, ${profile.birthday!.year} (${_calculateAge(profile.birthday!)} tuổi)"
              : "Chưa cập nhật",
          subtitle: "Sinh nhật",
          icon: Icons.cake_outlined,
        ),
        const SizedBox(height: 8),
        _buildInfoCard(
          title: profile.identityCard ?? "Chưa cập nhật",
          subtitle: "CCCD/CMND",
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: 8),
        _buildInfoCard(
          title: profile.gender ?? "Chưa cập nhật",
          subtitle: "Giới tính",
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 8),
        _buildInfoCard(
          title: profile.status ?? "ACTIVE",
          subtitle: "Trạng thái",
          icon: Icons.info_outline,
        ),
        const SizedBox(height: 8),
        _buildInfoCard(
          title: profile.roles?.join(", ") ?? "PATIENT",
          subtitle: "Vai trò",
          icon: Icons.admin_panel_settings_outlined,
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSlate,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
