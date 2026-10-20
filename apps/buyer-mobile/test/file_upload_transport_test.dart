import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/core/file_upload_transport.dart';

void main() {
  test(
    'multipart files get bounded upload budgets without changing ordinary requests',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.example.test',
          receiveTimeout: const Duration(seconds: 3),
        ),
      );
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requests.add(options);
            handler.resolve(
              Response<void>(requestOptions: options, statusCode: 204),
            );
          },
        ),
      );
      configureFileUploads(dio);
      configureFileUploads(dio);
      for (final count in [1, 3, 4]) {
        await dio.post<void>(
          '/uploads',
          data: FormData.fromMap({
            'files': List.generate(
              count,
              (_) => MultipartFile.fromBytes([1, 2, 3], filename: 'file.bin'),
            ),
          }),
        );
      }
      expect(requests.take(3).map((request) => request.receiveTimeout), [
        const Duration(seconds: 90),
        const Duration(seconds: 270),
        const Duration(seconds: 270),
      ]);
      expect(
        requests
            .take(3)
            .every(
              (request) => request.sendTimeout == const Duration(seconds: 90),
            ),
        isTrue,
      );
      await dio.get<void>('/ordinary');
      await dio.post<void>('/ordinary', data: {'note': 'text'});
      await dio.post<void>(
        '/ordinary',
        data: FormData.fromMap({'note': 'text'}),
      );
      expect(
        requests
            .skip(3)
            .every(
              (request) => request.receiveTimeout == const Duration(seconds: 3),
            ),
        isTrue,
      );
      expect(
        requests.skip(3).every((request) => request.sendTimeout == null),
        isTrue,
      );
      dio.close();
    },
  );
}
