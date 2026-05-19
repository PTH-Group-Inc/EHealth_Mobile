import 'package:flutter_test/flutter_test.dart';
import 'package:e_health/data/response/pre_booking_response.dart';

void main() {
  test('PreBookingResponse should parse correctly with integer amount', () {
    final Map<String, dynamic> jsonResponse = {
      "appointments_id": "APT_be762203-a2b",
      "status": "PENDING_DEPOSIT",
      "deposit_invoice": {
        "invoice_id": "INV_1f6e6572-18d",
        "deposit_amount": 5000
      },
      "payment_order": {
        "payment_order_id": "PO_64329efb0c3c4c",
        "qr_code_url": "https://qr.sepay.vn/img?acc=3015112004&bank=MBBank&amount=5000&des=EHealth56826",
        "amount": 5000
      }
    };

    final preBooking = PreBookingResponse.fromJson(jsonResponse);
    final entity = preBooking.map();

    expect(preBooking.appointmentsId, "APT_be762203-a2b");
    expect(preBooking.status, "PENDING_DEPOSIT");
    expect(preBooking.depositInvoice.invoiceId, "INV_1f6e6572-18d");
    expect(preBooking.depositInvoice.depositAmount, 5000.0);
    expect(preBooking.paymentOrder.amount, 5000.0);
    expect(preBooking.paymentOrder.qrCodeUrl, "https://qr.sepay.vn/img?acc=3015112004&bank=MBBank&amount=5000&des=EHealth56826");
    expect(entity.totalAmount, 5000.0);
  });

  test('PreBookingResponse should parse correctly with string amount', () {
    final Map<String, dynamic> jsonResponse = {
      "appointments_id": "APT_be762203-a2b",
      "status": "PENDING_DEPOSIT",
      "deposit_invoice": {
        "invoice_id": "INV_1f6e6572-18d",
        "deposit_amount": "5000.5"
      },
      "payment_order": {
        "payment_order_id": "PO_64329efb0c3c4c",
        "qr_code_url": "https://qr.sepay.vn/img?acc=3015112004&bank=MBBank&amount=5000&des=EHealth56826",
        "amount": "5000.5"
      }
    };

    final preBooking = PreBookingResponse.fromJson(jsonResponse);
    final entity = preBooking.map();

    expect(preBooking.depositInvoice.depositAmount, 5000.5);
    expect(preBooking.paymentOrder.amount, 5000.5);
    expect(entity.totalAmount, 5000.5);
  });
}
