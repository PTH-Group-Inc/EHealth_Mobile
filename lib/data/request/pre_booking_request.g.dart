// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_booking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreBookingRequest _$PreBookingRequestFromJson(Map<String, dynamic> json) =>
    PreBookingRequest(
      patientId: json['patient_id'] as String,
      branchId: json['branch_id'] as String,
      appointmentDate: json['appointment_date'] as String,
      facilityServiceId: json['facility_service_id'] as String,
      slotId: json['slot_id'] as String,
      doctorId: json['doctor_id'] as String?,
      notes: json['notes'] as String?,
      bookingChannel: json['booking_channel'] as String? ?? 'APP',
    );

Map<String, dynamic> _$PreBookingRequestToJson(PreBookingRequest instance) =>
    <String, dynamic>{
      'patient_id': instance.patientId,
      'branch_id': instance.branchId,
      'appointment_date': instance.appointmentDate,
      'facility_service_id': instance.facilityServiceId,
      'slot_id': instance.slotId,
      'doctor_id': instance.doctorId,
      'notes': instance.notes,
      'booking_channel': instance.bookingChannel,
    };
