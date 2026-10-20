import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:dio/dio.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

import '../core/file_upload_transport.dart';
import 'token_store.dart';

final class AuthRepository {
  AuthRepository({
    required TokenStore tokenStore,
    MateryalphApiClient? apiClient,
  }) : _tokenStore = tokenStore,
       _client =
           apiClient ??
           MateryalphApiClient(
             basePathOverride: const String.fromEnvironment(
               'API_BASE_URL',
               defaultValue: 'http://10.0.2.2:8080/api/v1',
             ),
           ) {
    if (!_client.dio.interceptors.any(
      (item) => item is _ProfilePhotoRequests,
    )) {
      _client.dio.interceptors.insert(0, _ProfilePhotoRequests());
    }
    configureFileUploads(_client.dio);
  }

  final TokenStore _tokenStore;
  final MateryalphApiClient _client;
  Agreement? _registrationTerms;
  Agreement? _reviewedTerms;

  bool get hasReviewedTerms => _reviewedTerms != null;
  Agreement? get reviewedTerms => _reviewedTerms;

  void clearTermsReview() {
    _registrationTerms = null;
    _reviewedTerms = null;
  }

  Future<Agreement> loadRegistrationTerms() async {
    clearTermsReview();
    try {
      final response = await _client.getAgreementsApi().listCurrentAgreements();
      final terms = response.data?.data
          .where(
            (item) =>
                item.code == 'TERMS_OF_SERVICE' &&
                (item.audience == 'ALL' || item.audience == 'BUYER'),
          )
          .toList();
      if (terms == null ||
          terms.length != 1 ||
          (terms.single.content?.trim().isEmpty ?? true) ||
          !RegExp(r'^[a-f0-9]{64}$').hasMatch(terms.single.contentHash ?? '')) {
        throw const BuyerAuthException(
          'The current Terms are unavailable. Please retry later.',
        );
      }
      return _registrationTerms = terms.single;
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  // Temporary flow state only. The API validates the version/hash and records
  // authoritative acceptance in the account-creation transaction.
  void acceptReviewedTerms(Agreement terms) {
    if (!identical(terms, _registrationTerms)) {
      throw const BuyerAuthException('Please review the current Terms again.');
    }
    _reviewedTerms = terms;
  }

  void _invalidateStaleTerms(DioException error) {
    final data = error.response?.data;
    if (data is! Map) return;
    final errors = data['errors'];
    if (errors is List &&
        errors.any(
          (item) => item is Map && item['code'] == 'AGREEMENT_VERSION_CONFLICT',
        )) {
      clearTermsReview();
    }
  }

  Agreement _requireTermsReview() {
    final terms = _reviewedTerms;
    if (terms == null) {
      throw const BuyerAuthException(
        'Review and accept the Terms of Service first.',
      );
    }
    return terms;
  }

  AuthenticationApi get _authentication => _client.getAuthenticationApi();

  /// The bearer-authenticated generated client shared by Buyer feature repositories.
  MateryalphApiClient get apiClient => _client;

  Future<T> accountOperation<T>(
    Future<T> Function(AccountsApi api) operation,
  ) async {
    try {
      return await operation(_client.getAccountsApi());
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await clearAccountSession();
        throw const BuyerSessionExpired();
      }
      throw BuyerAuthException(_messageFrom(error), code: _codeFrom(error));
    }
  }

  Future<void> clearAccountSession() async {
    _client.setBearerAuth('passportBearer', '');
    await _tokenStore.clear();
  }

  Future<AccountProfile> uploadProfilePhoto(
    Uint8List bytes,
    String filename,
    int version,
  ) async {
    final extension = filename.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'webp'].contains(extension) ||
        bytes.isEmpty ||
        bytes.length > 2 * 1024 * 1024) {
      throw const BuyerAuthException('Choose a JPEG, PNG or WebP up to 2 MB.');
    }
    final response = await accountOperation((api) async {
      try {
        return await api.uploadBuyerAccountPhoto(
          photo: MultipartFile.fromBytes(bytes, filename: filename),
          lockVersion: version,
        );
      } on DioException catch (error) {
        if (error.type == DioExceptionType.receiveTimeout) {
          throw const BuyerAuthException(
            'The photo upload is taking longer than expected. Refresh your profile to check whether it finished before uploading again.',
          );
        }
        rethrow;
      }
    });
    final profile = response.data?.data;
    if (profile == null || profile.accountType != 'BUYER') {
      throw const BuyerAuthException(
        'Your profile could not be refreshed. Please retry.',
      );
    }
    return profile;
  }

  Future<Uint8List?> profilePhoto(AccountProfile profile) async {
    if (profile.avatarUrl == null) return null;
    final query = Uri.tryParse(profile.avatarUrl!)?.queryParameters;
    final expires = int.tryParse(query?['expires'] ?? '');
    final version = int.tryParse(query?['version'] ?? '');
    final signature = query?['signature'];
    final owner = query?['owner'];
    if (expires == null ||
        version != profile.lockVersion ||
        signature == null ||
        signature.isEmpty ||
        owner != profile.id) {
      throw const BuyerAuthException(
        'Your profile photo is unavailable. Refresh to retry.',
      );
    }
    // Only signed query fields are used; the authenticated generated client
    // always requests the configured API, never a URL-provided host.
    final response = await accountOperation(
      (api) => api.getBuyerAccountPhoto(
        expires: expires,
        signature: signature,
        version: version!,
        owner: owner!,
      ),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw const BuyerAuthException(
        'Your profile photo is unavailable. Refresh to retry.',
      );
    }
    return bytes;
  }

  Future<bool> restoreSession() async {
    final tokens = await _tokenStore.read();
    if (tokens == null) {
      return false;
    }

    _client.setBearerAuth('passportBearer', tokens.accessToken);
    try {
      await _authentication.getBuyerMobileSession();
      return true;
    } on DioException catch (error) {
      return error.response?.statusCode == 401
          ? _refresh(tokens.refreshToken)
          : false;
    } catch (_) {
      // Fail closed when the server cannot validate a stored session. The
      // encrypted tokens remain available for a later online revalidation.
      return false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
    String? proof,
  }) async {
    try {
      final response = await _authentication.loginBuyerMobile(
        buyerMobileLoginRequest: BuyerMobileLoginRequest(
          (builder) => builder
            ..email = email.trim().toLowerCase()
            ..password = password
            ..riskProofToken = proof,
        ),
      );
      await _saveTokensOrChallenge(response.data?.data);
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  /// Completes a sign-in that returned [BuyerTwoFactorRequired] with the current authenticator code.
  Future<void> completeTwoFactorSignIn(
    BuyerTwoFactorRequired challenge,
    String code,
  ) async {
    try {
      final response = await _authentication.completeBuyerMobileMfaChallenge(
        buyerMobileMfaChallengeRequest: BuyerMobileMfaChallengeRequest(
          (b) => b
            ..challengeToken = challenge.challengeToken
            ..code = code,
        ),
      );
      await _saveTokens(response.data?.data);
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error), code: _codeFrom(error));
    }
  }

  /// Completes the sign-in with a single-use recovery code and returns the replacement codes,
  /// which the server shows only once.
  Future<List<String>> recoverTwoFactorSignIn(
    BuyerTwoFactorRequired challenge,
    String recoveryCode,
  ) async {
    try {
      final response = await _authentication.recoverBuyerMobileMfaChallenge(
        buyerMobileMfaRecoveryRequest: BuyerMobileMfaRecoveryRequest(
          (b) => b
            ..challengeToken = challenge.challengeToken
            ..recoveryCode = recoveryCode.trim(),
        ),
      );
      final data = response.data?.data;
      await _saveTokens(data);
      final codes = data?['recovery_codes']?.value;
      return codes is List ? codes.whereType<String>().toList() : const [];
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error), code: _codeFrom(error));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String mobileE164,
    required String password,
    String? passwordConfirmation,
    required String buyerType,
    String? companyName,
    String? proof,
  }) async {
    final terms = _requireTermsReview();
    try {
      await _authentication.registerBuyerMobile(
        buyerMobileRegisterRequest: BuyerMobileRegisterRequest(
          (builder) => builder
            ..fullName = fullName.trim()
            ..riskProofToken = proof
            ..email = email.trim().toLowerCase()
            ..mobileE164 = mobileE164.trim()
            ..password = password
            ..passwordConfirmation = passwordConfirmation ?? password
            ..termsVersionId = terms.id
            ..termsContentHash = terms.contentHash!
            ..buyerType = buyerType
            ..companyName = companyName?.trim()
            ..termsAccepted = BuyerMobileRegisterRequestTermsAcceptedEnum.true_
            ..privacyAccepted =
                BuyerMobileRegisterRequestPrivacyAcceptedEnum.true_,
        ),
      );
    } on DioException catch (error) {
      _invalidateStaleTerms(error);
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      await _authentication.verifyBuyerMobileEmail(
        verifyEmailRequest: VerifyEmailRequest(
          (builder) => builder
            ..email = email.trim().toLowerCase()
            ..code = code,
        ),
      );
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<void> resendVerification(String email) async {
    try {
      await _authentication.resendBuyerMobileEmailVerification(
        emailRequest: EmailRequest(
          (builder) => builder.email = email.trim().toLowerCase(),
        ),
      );
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<Uri> startGoogleSignIn({
    bool signUp = false,
    String? mobileE164,
    String? buyerType,
    String? companyName,
    bool termsAccepted = false,
    bool privacyAccepted = false,
  }) async {
    final terms = signUp ? _requireTermsReview() : null;
    try {
      final response = await _authentication.startBuyerMobileGoogleOidc(
        buyerMobileGoogleOidcStartRequest: BuyerMobileGoogleOidcStartRequest(
          (builder) => builder
            ..mode = signUp
                ? BuyerMobileGoogleOidcStartRequestModeEnum.SIGN_UP
                : BuyerMobileGoogleOidcStartRequestModeEnum.SIGN_IN
            ..mobileE164 = mobileE164?.trim()
            ..buyerType = buyerType
            ..companyName = companyName?.trim()
            ..termsAccepted = termsAccepted
            ..termsVersionId = terms?.id
            ..termsContentHash = terms?.contentHash
            ..privacyAccepted = privacyAccepted,
        ),
      );
      final value = response.data?.data['authorization_url']?.value;
      final uri = value is String ? Uri.tryParse(value) : null;
      if (uri == null || uri.scheme != 'https') {
        throw const BuyerAuthException(
          'Google sign-in could not be opened safely.',
        );
      }
      return uri;
    } on BuyerAuthException {
      rethrow;
    } on DioException catch (error) {
      _invalidateStaleTerms(error);
      throw BuyerAuthException(_messageFrom(error, google: true));
    }
  }

  Future<void> exchangeGoogleMobileCode(String exchangeCode) async {
    try {
      final response = await _authentication.exchangeBuyerMobileGoogleCode(
        googleMobileExchangeRequest: GoogleMobileExchangeRequest(
          (builder) => builder.exchangeCode = exchangeCode,
        ),
      );
      await _saveTokensOrChallenge(response.data?.data);
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error, google: true));
    }
  }

  Future<void> requestPasswordRecovery(String email, {String? proof}) async {
    try {
      await _authentication.requestBuyerMobilePasswordRecovery(
        buyerMobilePasswordRecoveryRequest: BuyerMobilePasswordRecoveryRequest(
          (builder) => builder
            ..email = email.trim().toLowerCase()
            ..riskProofToken = proof,
        ),
      );
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    try {
      await _authentication.resetBuyerMobilePassword(
        passwordResetRequest: PasswordResetRequest(
          (builder) => builder
            ..email = email.trim().toLowerCase()
            ..code = code
            ..password = password
            ..passwordConfirmation = password,
        ),
      );
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<void> logout() async {
    try {
      await _authentication.logoutBuyerMobile();
    } catch (_) {
      // Local sign-out must remain available when the network is unavailable.
    } finally {
      _client.removeBearerAuth('passportBearer');
      await _tokenStore.clear();
    }
  }

  Future<String> verifyRiskChallenge(
    BuyerRiskChallenge challenge,
    String email,
    String code,
  ) async {
    try {
      final response = await _authentication.verifyBuyerMobileBotChallenge(
        challengeId: challenge.id,
        verifyBotChallengeRequest: VerifyBotChallengeRequest(
          (b) => b
            ..email = email.trim().toLowerCase()
            ..code = code,
        ),
      );
      final token = response.data?.data['step_up_token']?.value;
      if (token is! String || token.isEmpty) {
        throw const BuyerAuthException(
          'Verification did not complete. Please try again.',
        );
      }
      return token;
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<void> resendRiskChallenge(
    BuyerRiskChallenge challenge,
    String email,
  ) async {
    try {
      await _authentication.resendBuyerMobileBotChallenge(
        challengeId: challenge.id,
        resendBotChallengeRequest: ResendBotChallengeRequest(
          (b) => b.email = email.trim().toLowerCase(),
        ),
      );
    } on DioException catch (error) {
      throw BuyerAuthException(_messageFrom(error));
    }
  }

  Future<bool> _refresh(String refreshToken) async {
    try {
      final response = await _authentication.refreshBuyerMobileSession(
        buyerMobileRefreshRequest: BuyerMobileRefreshRequest(
          (builder) => builder.refreshToken = refreshToken,
        ),
      );
      await _saveTokens(response.data?.data);
      return true;
    } catch (_) {
      _client.removeBearerAuth('passportBearer');
      await _tokenStore.clear();
      return false;
    }
  }

  /// A Buyer with an authenticator gets a short-lived challenge instead of tokens. The token stays
  /// in memory on the thrown signal only; it is never written to storage or logs.
  Future<void> _saveTokensOrChallenge(BuiltMap<String, JsonObject?>? data) {
    if (data?['mfa_required']?.value == true) {
      final token = data?['challenge_token']?.value;
      final expiresIn = data?['challenge_expires_in']?.value;
      if (token is! String || token.isEmpty) {
        throw const BuyerAuthException(
          'Two-factor sign-in could not start. Please try again.',
        );
      }
      throw BuyerTwoFactorRequired(
        token,
        expiresIn is num ? expiresIn.toInt() : 300,
      );
    }
    return _saveTokens(data);
  }

  Future<void> _saveTokens(BuiltMap<String, JsonObject?>? data) async {
    final accessToken = data?['access_token']?.value;
    final refreshToken = data?['refresh_token']?.value;
    if (accessToken is! String || refreshToken is! String) {
      throw const BuyerAuthException(
        'The server returned an incomplete session. Please try again.',
      );
    }

    await _tokenStore.write(
      AuthTokens(accessToken: accessToken, refreshToken: refreshToken),
    );
    _client.setBearerAuth('passportBearer', accessToken);
  }

  String? _codeFrom(DioException error) {
    final body = error.response?.data;
    if (body is! Map) return null;
    final errors = body['errors'];
    if (errors is! List || errors.isEmpty) return null;
    final first = errors.first;
    return first is Map && first['code'] is String
        ? first['code'] as String
        : null;
  }

  String _messageFrom(DioException error, {bool google = false}) {
    final body = error.response?.data;
    if (body is Map<String, dynamic>) {
      final errors = body['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is Map &&
            first['code'] == 'BOT_STEP_UP_REQUIRED' &&
            first['details'] is Map) {
          final details = first['details'] as Map;
          final id = details['challenge_id'];
          final expiry = details['expires_at'];
          final resend = details['resend_after_seconds'];
          if (id is String && expiry is String && resend is int) {
            throw BuyerRiskChallenge(id, expiry, resend);
          }
        }
        if (google && first is Map) {
          const messages = {
            'PORTAL_ACCESS_DENIED':
                'This Google account belongs to another MateryalPH account type. Use a different Google account for Buyer access.',
            'ACCOUNT_NOT_FOUND':
                'No Buyer account is linked to this Google account. Create a Buyer account or choose a different Google account.',
            'OIDC_STATE_INVALID':
                'This Google sign-in request expired. Start sign-in again.',
            'OIDC_EXCHANGE_CODE_INVALID':
                'This Google sign-in request expired. Start sign-in again.',
            'OIDC_KEYS_UNAVAILABLE':
                'Google sign-in is temporarily unavailable. Try again shortly or use email sign-in.',
            'OIDC_NOT_CONFIGURED':
                'Google sign-in is currently unavailable. Use email sign-in to continue.',
          };
          return messages[first['code']] ??
              'Google sign-in could not finish. Try again or use email sign-in.';
        }
        if (first is Map && first['message'] is String) {
          return first['message'] as String;
        }
      }
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'MateryalPH is unavailable right now. Check your connection and try again.';
    }

    return 'We could not complete that request. Please try again.';
  }
}

final class BuyerRiskChallenge extends BuyerAuthException {
  const BuyerRiskChallenge(this.id, this.expiresAt, this.resendAfterSeconds)
    : super(
        'Confirm this request using the risk-verification code from your email.',
      );
  final String id;
  final String expiresAt;
  final int resendAfterSeconds;
}

/// Password or Google sign-in succeeded, but this Buyer turned on two-factor authentication.
final class BuyerTwoFactorRequired extends BuyerAuthException {
  const BuyerTwoFactorRequired(this.challengeToken, this.expiresInSeconds)
    : super('Enter the code from your authenticator app to finish signing in.');
  final String challengeToken;
  final int expiresInSeconds;
}

class BuyerAuthException implements Exception {
  const BuyerAuthException(this.message, {this.code});

  final String message;

  /// The stable API error code when the server sent one, such as RECENT_AUTHENTICATION_REQUIRED.
  final String? code;

  bool get needsRecentAuthentication =>
      code == 'RECENT_AUTHENTICATION_REQUIRED';

  @override
  String toString() => message;
}

final class BuyerSessionExpired extends BuyerAuthException {
  const BuyerSessionExpired() : super('Your session expired. Sign in again.');
}

/// Signed avatar reads keep their own budget; multipart mutations use the shared upload transport.
final class _ProfilePhotoRequests extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.path == '/buyers/account/photo') {
      if (options.method == 'GET') {
        options.receiveTimeout = const Duration(seconds: 15);
      }
    }
    handler.next(options);
  }
}
