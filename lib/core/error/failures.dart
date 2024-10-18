import 'package:dio/dio.dart';

abstract class Failure {
  final String errMassage;
  final int statusCode;

  const Failure(this.errMassage, this.statusCode);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMassage, super.statusCode);

  factory ServerFailure.fromDioError(DioException dioException) {
    if (dioException.type == DioExceptionType.connectionTimeout) {
      return ServerFailure(
        'Connection timeout with ApiServer',
        dioException.response?.statusCode ?? 600,
      );
    } else if (dioException.type == DioExceptionType.sendTimeout) {
      return ServerFailure(
        'Send timeout with ApiServer',
        dioException.response?.statusCode ?? 601,
      );
    } else if (dioException.type == DioExceptionType.receiveTimeout) {
      return ServerFailure(
        'Receive timeout with ApiServer',
        dioException.response?.statusCode ?? 602,
      );
    } else if (dioException.type == DioExceptionType.badResponse) {
      return ServerFailure.fromResponse(
          dioException.response?.statusCode ?? 604,
          dioException.response!.data);
    } else if (dioException.type == DioExceptionType.cancel) {
      return ServerFailure('Request to  ApiServer was cancel',
          dioException.response?.statusCode ?? 605);
    } else {
      //
      // if (dioException.message!.contains('SocketException')) {
      //
      //   return ServerFailure('No Internet Connection');
      // }
      //

      return ServerFailure('network error, check your internet !', 606);
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 401 || statusCode == 403 || statusCode == 422) {
      String error = response['data'];

      return ServerFailure(error, statusCode);
    } else if (statusCode == 404) {
      return ServerFailure(
          'Your requests not found, Please try later!', statusCode);
    } else if (statusCode == 500) {
      return ServerFailure(
          'internal Server error, Please try later', statusCode);
    } else {
      return ServerFailure(
          'Ops There was an Error, Please try again', statusCode);
    }
  }
}
