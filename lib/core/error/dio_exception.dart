// core/error/dio_exception_x.dart
import 'package:dio/dio.dart';
import 'package:move_app/core/error/exception.dart';
import 'package:move_app/core/network/error_message_model.dart';

extension DioExceptionX on DioException {
  ServerException toServerException() {
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      return ServerException(
        errorMessageModel: ErrorMessageModel.fromjson(data),
      );
    }

    String message;
    switch (type) {
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timed out, please try again';
        break;
      default:
        message = 'Something went wrong, please try again';
    }

    return ServerException(
      errorMessageModel: ErrorMessageModel.fromjson({
        'status_code': response?.statusCode ?? 0,
        'status_message': message,
        'success': false,
      }),
    );
  }
}