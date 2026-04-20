import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/domain/pre_booking.dart';
import 'package:e_health/presentation/screens/appointment/cubit/payment_qr_cubit.dart';
import 'package:e_health/presentation/screens/appointment/cubit/payment_qr_state.dart';
import 'package:e_health/presentation/widgets/feedback/app_toast.dart';
import 'package:e_health/app/dependency_injection/configure_injectable.dart';

class PaymentQrScreen extends StatefulWidget {
  final PreBookingEntity preBookingData;

  const PaymentQrScreen({super.key, required this.preBookingData});

  @override
  State<PaymentQrScreen> createState() => _PaymentQrScreenState();
}

class _PaymentQrScreenState extends State<PaymentQrScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PaymentQrCubit>()..init(widget.preBookingData),
      child: BlocListener<PaymentQrCubit, PaymentQrState>(
        listener: (context, state) {
          if (state.error != null) {
            AppToast.showError(context, state.error!);
          }
          if (state.isPaid) {
            _showSuccessScreen(context);
          }
        },
        child: BlocBuilder<PaymentQrCubit, PaymentQrState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.primaryBackground,
              appBar: _buildAppBar(context),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildQrCard(state),
                      const SizedBox(height: 32),
                      _buildPaymentStatus(state),
                      const SizedBox(height: 24),
                      _buildRegenerateButton(context, state),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Thanh toán cọc",
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
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, Color(0xFF1E40AF)],
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
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.qr_code_2_rounded,
            size: 48,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Vui lòng quét QR để thanh toán",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeader,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          "Lịch khám của bạn sẽ được tự động xác nhận ngay sau khi thanh toán thành công.",
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSlate,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQrCard(PaymentQrState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Số Tiền Thanh Toán",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            NumberFormat.currency(
              locale: 'vi',
              symbol: 'đ',
            ).format(state.totalAmount),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(thickness: 1, height: 1),
          const SizedBox(height: 24),

          // Display the QR Code
          if (state.qrString.isNotEmpty)
            Image.memory(
              base64Decode(state.qrString),
              width: 250,
              height: 250,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => _buildFallbackQr(state),
            )
          else
            _buildFallbackQr(state),
        ],
      ),
    );
  }

  Widget _buildFallbackQr(PaymentQrState state) {
    if (state.qrTemplateData.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: state.qrTemplateData,
        width: 250,
        height: 250,
        fit: BoxFit.contain,
        placeholder: (context, url) => const SizedBox(
          width: 250,
          height: 250,
          child: Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => const SizedBox(
          width: 250,
          height: 250,
          child: Center(
            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
          ),
        ),
      );
    }
    return const SizedBox(
      width: 250,
      height: 250,
      child: Center(
        child: Text("Đang tải mã QR...", style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildPaymentStatus(PaymentQrState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            state.isChecking
                ? "Đang xác thực giao dịch..."
                : "Đang chờ thanh toán...",
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegenerateButton(BuildContext context, PaymentQrState state) {
    return TextButton.icon(
      onPressed: state.isRegeneratingQr
          ? null
          : () {
              context.read<PaymentQrCubit>().regenerateQr();
            },
      icon: state.isRegeneratingQr
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.refresh_rounded),
      label: const Text("Tải lại mã QR"),
      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
    );
  }

  void _showSuccessScreen(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Thanh Toán Thành Công!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeader,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Lịch khám của bạn đã được xác nhận. Vui lòng đến đúng giờ để được phục vụ tốt nhất.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSlate, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Navigate back to home or appointment list
                    Navigator.pop(ctx); // pop dialog
                    context.go('/home'); // Adjust based on your routing
                  },
                  child: const Text(
                    "Theo Dõi Lịch Khám",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
