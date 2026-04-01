import 'package:flutter/material.dart';

class AppointmentStatusBadge extends StatelessWidget {
  final String status;

  const AppointmentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status.toUpperCase()) {
      case 'PENDING':
        bgColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        label = "Đang chờ";
        break;
      case 'CONFIRMED':
        bgColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        label = "Đã xác nhận";
        break;
      case 'CHECKED_IN':
        bgColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        label = "Đã check-in";
        break;
      case 'IN_PROGRESS':
        bgColor = Colors.purple[50]!;
        textColor = Colors.purple[700]!;
        label = "Đang khám";
        break;
      case 'COMPLETED':
        bgColor = Colors.teal[50]!;
        textColor = Colors.teal[700]!;
        label = "Hoàn tất";
        break;
      case 'CANCELLED':
        bgColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        label = "Đã hủy";
        break;
      case 'NO_SHOW':
        bgColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        label = "Không đến";
        break;
      default:
        bgColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
