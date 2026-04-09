import 'package:flexiback/core/exception/core_exception/core_error_type.dart';

class CoreFailure implements Exception {
  final CoreErrorType type;
  final String message;

  const CoreFailure({
    required this.type,
    required this.message,
    this.debugMessage,
  });

  final String? debugMessage;

  factory CoreFailure.databaseError([String? debugMessage]) => CoreFailure(
        type: CoreErrorType.databaseError,
        message: 'Failed to load data. Try again.',
        debugMessage: debugMessage,
      );

  factory CoreFailure.network([String? debugMessage]) => CoreFailure(
        type: CoreErrorType.network,
        message: 'Network error. Check your connection.',
        debugMessage: debugMessage,
      );

  factory CoreFailure.unknown([String? debugMessage]) => CoreFailure(
        type: CoreErrorType.unknown,
        message: 'Some thing went wrong. Please try again.',
        debugMessage: debugMessage,
      );

  @override
  String toString() => message;
}