// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_appointment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookAppointmentRequest _$BookAppointmentRequestFromJson(
  Map<String, dynamic> json,
) => BookAppointmentRequest(
  patientId: json['patient_id'] as String,
  branchId: json['branch_id'] as String,
  shiftId: json['shift_id'] as String,
  appointmentDate: json['appointment_date'] as String,
  bookingChannel: json['booking_channel'] as String,
  reasonForVisit: json['reason_for_visit'] as String,
  symptomsNotes: json['symptoms_notes'] as String,
  facilityServiceId: json['facility_service_id'] as String,
  slotId: json['slot_id'] as String,
);

Map<String, dynamic> _$BookAppointmentRequestToJson(
  BookAppointmentRequest instance,
) => <String, dynamic>{
  'patient_id': instance.patientId,
  'branch_id': instance.branchId,
  'shift_id': instance.shiftId,
  'appointment_date': instance.appointmentDate,
  'booking_channel': instance.bookingChannel,
  'reason_for_visit': instance.reasonForVisit,
  'symptoms_notes': instance.symptomsNotes,
  'facility_service_id': instance.facilityServiceId,
  'slot_id': instance.slotId,
};
