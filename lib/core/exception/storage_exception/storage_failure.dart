import 'storage_error_type.dart';

class StorageFailure implements Exception {
  final StorageErrorType type;
  final String message;

  const StorageFailure({
    required this.type,
    required this.message,
  });


  factory StorageFailure.uploadFailed([String? debugMessage]) => StorageFailure(
        type: StorageErrorType.uploadFailed,
        message: 'ไม่สามารถอัปโหลดไฟล์ได้ กรุณาลองใหม่อีกครั้ง',
      );

  factory StorageFailure.fileTooLarge([String? debugMessage]) => StorageFailure(
        type: StorageErrorType.fileTooLarge,
        message: 'ไฟล์มีขนาดใหญ่เกินไป กรุณาเลือกไฟล์ที่มีขนาดเล็กลง',
      );

  factory StorageFailure.invalidFileType([String? debugMessage]) =>
      StorageFailure(
        type: StorageErrorType.invalidFileType,
        message: 'ประเภทไฟล์ไม่ถูกต้อง กรุณาเลือกไฟล์รูปภาพ',
      );

  factory StorageFailure.bucketNotFound([String? debugMessage]) =>
      StorageFailure(
        type: StorageErrorType.bucketNotFound,
        message: 'ไม่พบที่จัดเก็บไฟล์ กรุณาติดต่อผู้ดูแลระบบ',
      );

  factory StorageFailure.permissionDenied([String? debugMessage]) =>
      StorageFailure(
        type: StorageErrorType.permissionDenied,
        message: 'ไม่มีสิทธิ์ในการอัปโหลดไฟล์',
      );

  factory StorageFailure.fileReadError([String? debugMessage]) =>
      StorageFailure(
        type: StorageErrorType.fileReadError,
        message: 'ไม่สามารถอ่านไฟล์ได้ กรุณาเลือกไฟล์ใหม่',
      );

  @override
  String toString() => message;
}
