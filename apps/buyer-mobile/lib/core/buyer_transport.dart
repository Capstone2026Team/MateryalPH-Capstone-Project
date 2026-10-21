import 'package:dio/dio.dart';

import 'file_upload_transport.dart';

/// One bounded policy for hosted Buyer API calls. Provider-specific operations
/// can set their own budgets; file scanning retains the shared upload allowance.
void configureBuyerTransport(Dio dio) {
  const connection = Duration(seconds: 30);
  const response = Duration(seconds: 60);
  if ((dio.options.connectTimeout ?? Duration.zero) < connection) {
    dio.options.connectTimeout = connection;
  }
  if ((dio.options.sendTimeout ?? Duration.zero) < connection) {
    dio.options.sendTimeout = connection;
  }
  if ((dio.options.receiveTimeout ?? Duration.zero) < response) {
    dio.options.receiveTimeout = response;
  }
  configureFileUploads(dio);
}
