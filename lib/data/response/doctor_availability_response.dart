import 'package:json_annotation/json_annotation.dart';
import 'package:e_health/domain/doctor_availability.dart';

part 'doctor_availability_response.g.dart';

@JsonSerializable()
class DoctorAvailabilityResponse {
  @JsonKey(name: 'staff_schedules_id')
  final String? staffSchedulesId;
  @JsonKey(name: 'working_date')
  final String? workingDate;
  @JsonKey(name: 'start_time')
  final String? startTime;
  @JsonKey(name: 'end_time')
  final String? endTime;
  @JsonKey(name: 'is_leave')
  final bool? isLeave;
  @JsonKey(name: 'leave_reason')
  final String? leaveReason;
  @JsonKey(name: 'schedule_status')
  final String? scheduleStatus;
  @JsonKey(name: 'shift_id')
  final String? shiftId;
  @JsonKey(name: 'shift_code')
  final String? shiftCode;
  @JsonKey(name: 'shift_name')
  final String? shiftName;
  @JsonKey(name: 'room_id')
  final String? roomId;
  @JsonKey(name: 'room_name')
  final String? roomName;
  @JsonKey(name: 'doctor_id')
  final String? doctorId;
  @JsonKey(name: 'specialty_name')
  final String? specialtyName;
  @JsonKey(name: 'availability_status')
  final String? availabilityStatus;

  DoctorAvailabilityResponse({
    this.staffSchedulesId,
    this.workingDate,
    this.startTime,
    this.endTime,
    this.isLeave,
    this.leaveReason,
    this.scheduleStatus,
    this.shiftId,
    this.shiftCode,
    this.shiftName,
    this.roomId,
    this.roomName,
    this.doctorId,
    this.specialtyName,
    this.availabilityStatus,
  });

  factory DoctorAvailabilityResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorAvailabilityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorAvailabilityResponseToJson(this);

  DoctorAvailability map() {
    return DoctorAvailability(
      staffSchedulesId: staffSchedulesId ?? "",
      workingDate: workingDate ?? "",
      startTime: startTime ?? "",
      endTime: endTime ?? "",
      isLeave: isLeave ?? false,
      leaveReason: leaveReason,
      scheduleStatus: scheduleStatus ?? "",
      shiftId: shiftId ?? "",
      shiftCode: shiftCode ?? "",
      shiftName: shiftName ?? "",
      roomId: roomId ?? "",
      roomName: roomName ?? "",
      doctorId: doctorId ?? "",
      specialtyName: specialtyName ?? "",
      availabilityStatus: availabilityStatus ?? "",
    );
  }
}
