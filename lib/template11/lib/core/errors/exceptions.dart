class ValidationException implements Exception {
  const ValidationException({required this.message});
  final String message;

  @override
  String toString() => 'Validation Exception: $message';
}

class NotFoundException implements Exception {
  const NotFoundException({required this.message});

  final String message;

  @override
  String toString() => '${runtimeType.toString()}: $message';
}

class BusinessLogicException implements Exception {
  const BusinessLogicException({required this.message});

  final String message;

  @override
  String toString() => '${runtimeType.toString()}: $message';
}

class DataException implements Exception {
  const DataException({required this.message});

  final String message;
  @override
  String toString() => '${runtimeType.toString()}: $message';
}
