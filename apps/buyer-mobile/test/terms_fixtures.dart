import 'package:dio/dio.dart';
import 'package:materyalph/auth/auth_repository.dart';
import 'package:materyalph/auth/token_store.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

const termsId = '01995000-0000-7000-8000-000000000001';
final termsHash = List.filled(64, 'a').join();

AuthRepository termsRepository({
  void Function(RequestOptions)? onRequest,
  bool unavailable = false,
}) => AuthRepository(
  tokenStore: MemoryTokens(),
  apiClient: MateryalphApiClient(
    dio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) {
          onRequest?.call(options);
          final dynamic data = options.path.endsWith('/agreements/current')
              ? [
                  {
                    'id': termsId,
                    'code': 'TERMS_OF_SERVICE',
                    'title': 'Terms of Service',
                    'audience': 'ALL',
                    'version': 2,
                    'content_uri': '/legal/terms/2',
                    'effective_at': '2026-09-14T00:00:00Z',
                    'content_hash': termsHash,
                    'content': unavailable
                        ? null
                        : '# Maintained test Terms\n\n${List.generate(24, (i) => '## Section ${i + 1}\n\nTest agreement paragraph for scrolling and accessibility.').join('\n\n')}',
                  },
                ]
              : options.path.endsWith('/google/start')
              ? {'authorization_url': 'https://accounts.google.com/test'}
              : {'message': 'Check your email.'};
          handler.resolve(
            Response<dynamic>(
              requestOptions: options,
              statusCode: 200,
              data: {
                'data': data,
                'meta': <String, dynamic>{},
                'errors': <dynamic>[],
              },
            ),
          );
        },
      ),
    ],
  ),
);

Future<AuthRepository> reviewedRepository() async {
  final repository = termsRepository();
  repository.acceptReviewedTerms(await repository.loadRegistrationTerms());
  return repository;
}

class MemoryTokens implements TokenStore {
  @override
  Future<void> clear() async {}
  @override
  Future<AuthTokens?> read() async => null;
  @override
  Future<void> write(AuthTokens tokens) async {}
}
