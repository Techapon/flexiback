import 'dart:io';

import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'storage_failure.dart';

class StorageErrorMapper {
  StorageErrorMapper._();

  static Exception fromStorageException(StorageException e) {
    final msg = e.message.toLowerCase();

    // ── File size limit ────────────────────────────────────────────────────
    if (msg.contains('payload too large') ||
        msg.contains('file size') ||
        msg.contains('too large')) {
      return StorageFailure.fileTooLarge(e.message);
    }

    // ── Invalid file type ──────────────────────────────────────────────────
    if (msg.contains('invalid mime type') ||
        msg.contains('mime type') ||
        msg.contains('not allowed')) {
      return StorageFailure.invalidFileType(e.message);
    }

    // ── Bucket not found ───────────────────────────────────────────────────
    if (msg.contains('bucket not found') ||
        msg.contains('bucket_not_found')) {
      return StorageFailure.bucketNotFound(e.message);
    }

    // ── Permission / Policy ────────────────────────────────────────────────
    if (msg.contains('policy') ||
        msg.contains('permission') ||
        msg.contains('unauthorized') ||
        msg.contains('security')) {
      return StorageFailure.permissionDenied(e.message);
    }

    // ── Fallback ───────────────────────────────────────────────────────────
    return StorageFailure.uploadFailed(e.message);
  }

  static Exception fromFileSystemException(FileSystemException e) {
    return StorageFailure.fileReadError(e.message);
  }

  static CoreFailure fromUnknown(Object e) {
    return CoreFailure.unknown(e.toString());
  }
}
