import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:e_health/app/theme/app_color.dart';
import 'package:e_health/app/theme/app_shadow.dart';
import 'package:e_health/domain/invoice.dart';
import 'package:e_health/domain/encounter.dart';

class PaymentQRScreen extends StatelessWidget {
  final Invoice invoice;
  final Encounter encounter;

  const PaymentQRScreen({
    super.key,
    required this.invoice,
    required this.encounter,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      backgroundColor: AppColors.paymentBackground,
      appBar: AppBar(
        title: const Text(
          "Thanh toán",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textHeader,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Instructions Section
            _buildInstructions(),
            const SizedBox(height: 16),

            // QR Card
            _buildQRCard(context),
            const SizedBox(height: 16),

            // Transfer Info Section
            _buildTransferInfo(currencyFormat),
            const SizedBox(height: 16),

            // Status Polling Card
            _buildStatusCard(),
            const SizedBox(height: 16),

            // Invoice Details Section
            _buildInvoiceDetails(currencyFormat),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadow.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInstructionStep("1", "Mở ứng dụng ngân hàng hoặc Ví điện tử"),
          const SizedBox(height: 12),
          _buildInstructionStep("2", "Chọn quét mã QR để thanh toán"),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 36),
            child: Text(
              "Hỗ trợ Ví điện tử MoMo/ZaloPay\nHoặc ứng dụng ngân hàng để chuyển khoản nhanh 24/7",
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String step, String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.paymentStep,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "Bước $step: $text",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQRCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadow.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            "Mã đơn: ${invoice.code}",
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade100, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data:
                  "PAYMENT_REQUEST:${invoice.id}", // Replace with real VietQR format
              version: QrVersions.auto,
              size: 200.0,
              gapless: false,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.paymentText,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/VietQR_logo.svg/2560px-VietQR_logo.svg.png",
                height: 20,
              ),
              const SizedBox(width: 20),
              const Text(
                "napas",
                style: TextStyle(
                  color: AppColors.paymentNapas,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement download
            },
            icon: const Icon(Icons.file_download_outlined, size: 20),
            label: const Text("Tải xuống Qrcode"),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textDark,
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferInfo(NumberFormat currencyFormat) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadow.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "THÔNG TIN CHUYỂN KHOẢN",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.paymentDanger,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            "Số tiền:",
            currencyFormat.format(double.tryParse(invoice.netAmount) ?? 0),
            valueColor: AppColors.paymentDanger,
            valueSize: 20,
          ),
          const SizedBox(height: 16),
          _buildInfoRow("Nội dung:", invoice.code, showCopy: true),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.paymentDangerBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.paymentDangerBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 18,
                  color: AppColors.paymentDanger,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "CHÚ Ý: Chuyển khoản nội dung quét QR tự động sinh để hệ thống xử lý tự động ghi nhận ngay lập tức! (Không cố gắng sửa đổi nội dung hay số tiền).",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.paymentSubText,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    double valueSize = 16,
    bool showCopy = false,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: valueSize,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? AppColors.textDark,
                ),
              ),
              if (showCopy) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.paymentCopyBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.paymentCopyBorder),
                  ),
                  child: const Icon(
                    Icons.copy_rounded,
                    size: 14,
                    color: AppColors.paymentDanger,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadow.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Đang chờ xác nhận giao dịch...",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.paymentBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Mã hết hạn sau: 14:21", // Hardcoded for mock UI
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetails(NumberFormat currencyFormat) {
    final subtotal = double.tryParse(invoice.totalAmount) ?? 0;
    final insurance = double.tryParse(invoice.insuranceAmount) ?? 0;
    final net = double.tryParse(invoice.netAmount) ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadow.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "CHI TIẾT HÓA ĐƠN",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  invoice.code,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          _buildInvoiceRow("Tạm tính:", currencyFormat.format(subtotal)),
          const SizedBox(height: 12),
          _buildInvoiceRow(
            "BHYT chi trả:",
            "- ${currencyFormat.format(insurance)}",
            valueColor: AppColors.paymentBlue,
          ),
          const Divider(height: 32),
          _buildInvoiceRow(
            "Tổng tiền thanh toán:",
            currencyFormat.format(net),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceRow(
    String label,
    String value, {
    Color? valueColor,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isTotal ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
