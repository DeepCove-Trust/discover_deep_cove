import 'package:discover_deep_cove/util/permissions.dart';

class InsufficientStorageException implements Exception{
  final String message;
  InsufficientStorageException({this.message});
}

class InsufficientPermissionException implements Exception{
  final String message;
  final PermissionGroup permission;
  InsufficientPermissionException({this.message, this.permission});
}

class FailedDownloadException implements Exception{
  final String message;
  FailedDownloadException({this.message});
}

class ApiException implements Exception{
  final String message;
  final int statusCode;
  ApiException({this.message, this.statusCode});
}

class ServerUnreachableException implements Exception{
  final String message;
  ServerUnreachableException({this.message});
}