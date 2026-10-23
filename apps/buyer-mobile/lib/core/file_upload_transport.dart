import 'package:dio/dio.dart';

/// File mutations wait for validation, the bounded scanner call and private storage.
/// Ordinary JSON requests keep the configured API timeouts.
void configureFileUploads(Dio dio) {
  if (!dio.interceptors.any((item) => item is _FileUploadTimeouts)) {
    dio.interceptors.insert(0, _FileUploadTimeouts());
  }
}

final class _FileUploadTimeouts extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final body = options.data;
    if (body is FormData &&
        body.files.isNotEmpty &&
        const ['POST', 'PUT', 'PATCH'].contains(options.method)) {
      final files = body.files.length > 3 ? 3 : body.files.length;
      options.sendTimeout = const Duration(seconds: 90);
      options.receiveTimeout = Duration(seconds: 90 * files);
    }
    handler.next(options);
  }
}
