// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_patient_appointment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookPatientAppointmentRequest _$BookPatientAppointmentRequestFromJson(
  Map<String, dynamic> json,
) => BookPatientAppointmentRequest(
  patientId: json['patient_id'] as String,
  branchId: json['branch_id'] as String,
  shiftId: json['shift_id'] as String,
  appointmentDate: json['appointment_date'] as String,
  bookingChannel: json['booking_channel'] as String,
  reasonForVisit: json['reason_for_visit'] as String,
  doctorId: json['doctor_id'] as String,
  slotId: json['slot_id'] as String,
  roomId: json['room_id'] as String,
  facilityServiceId: json['facility_service_id'] as String,
);

Map<String, dynamic> _$BookPatientAppointmentRequestToJson(
  BookPatientAppointmentRequest instance,
) => <String, dynamic>{
  'patient_id': instance.patientId,
  'branch_id': instance.branchId,
  'shift_id': instance.shiftId,
  'appointment_date': instance.appointmentDate,
  'booking_channel': instance.bookingChannel,
  'reason_for_visit': instance.reasonForVisit,
  'doctor_id': instance.doctorId,
  'slot_id': instance.slotId,
  'room_id': instance.roomId,
  'facility_service_id': instance.facilityServiceId,
};
