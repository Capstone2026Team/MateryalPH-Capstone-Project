//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:built_value/serializer.dart';
import 'package:materyalph_api_client/src/serializers.dart';
import 'package:materyalph_api_client/src/auth/api_key_auth.dart';
import 'package:materyalph_api_client/src/auth/basic_auth.dart';
import 'package:materyalph_api_client/src/auth/bearer_auth.dart';
import 'package:materyalph_api_client/src/auth/oauth.dart';
import 'package:materyalph_api_client/src/api/accounts_api.dart';
import 'package:materyalph_api_client/src/api/admin_audit_log_api.dart';
import 'package:materyalph_api_client/src/api/admin_budget_overrides_api.dart';
import 'package:materyalph_api_client/src/api/admin_disputes_api.dart';
import 'package:materyalph_api_client/src/api/admin_enforcement_api.dart';
import 'package:materyalph_api_client/src/api/admin_finance_api.dart';
import 'package:materyalph_api_client/src/api/admin_finance_operations_api.dart';
import 'package:materyalph_api_client/src/api/admin_geographic_analytics_api.dart';
import 'package:materyalph_api_client/src/api/admin_integration_health_api.dart';
import 'package:materyalph_api_client/src/api/admin_invoices_api.dart';
import 'package:materyalph_api_client/src/api/admin_materials_analytics_api.dart';
import 'package:materyalph_api_client/src/api/admin_order_operations_api.dart';
import 'package:materyalph_api_client/src/api/admin_platform_settings_api.dart';
import 'package:materyalph_api_client/src/api/admin_privacy_requests_api.dart';
import 'package:materyalph_api_client/src/api/admin_product_compliance_api.dart';
import 'package:materyalph_api_client/src/api/admin_review_moderation_api.dart';
import 'package:materyalph_api_client/src/api/admin_score_monitoring_api.dart';
import 'package:materyalph_api_client/src/api/admin_vendor_verification_api.dart';
import 'package:materyalph_api_client/src/api/agreements_api.dart';
import 'package:materyalph_api_client/src/api/authentication_api.dart';
import 'package:materyalph_api_client/src/api/buyer_cart_api.dart';
import 'package:materyalph_api_client/src/api/buyer_discovery_api.dart';
import 'package:materyalph_api_client/src/api/buyer_disputes_api.dart';
import 'package:materyalph_api_client/src/api/buyer_explore_api.dart';
import 'package:materyalph_api_client/src/api/buyer_fulfillment_api.dart';
import 'package:materyalph_api_client/src/api/buyer_invoices_api.dart';
import 'package:materyalph_api_client/src/api/buyer_locations_api.dart';
import 'package:materyalph_api_client/src/api/buyer_materials_analytics_api.dart';
import 'package:materyalph_api_client/src/api/buyer_orders_api.dart';
import 'package:materyalph_api_client/src/api/buyer_payments_api.dart';
import 'package:materyalph_api_client/src/api/buyer_projects_api.dart';
import 'package:materyalph_api_client/src/api/buyer_reviews_api.dart';
import 'package:materyalph_api_client/src/api/messaging_api.dart';
import 'package:materyalph_api_client/src/api/notifications_api.dart';
import 'package:materyalph_api_client/src/api/payment_webhooks_api.dart';
import 'package:materyalph_api_client/src/api/reporting_api.dart';
import 'package:materyalph_api_client/src/api/stores_api.dart';
import 'package:materyalph_api_client/src/api/system_api.dart';
import 'package:materyalph_api_client/src/api/vendor_auto_accept_api.dart';
import 'package:materyalph_api_client/src/api/vendor_catalog_api.dart';
import 'package:materyalph_api_client/src/api/vendor_disputes_api.dart';
import 'package:materyalph_api_client/src/api/vendor_finance_api.dart';
import 'package:materyalph_api_client/src/api/vendor_finance_reviews_api.dart';
import 'package:materyalph_api_client/src/api/vendor_fleet_api.dart';
import 'package:materyalph_api_client/src/api/vendor_fulfillment_api.dart';
import 'package:materyalph_api_client/src/api/vendor_inventory_api.dart';
import 'package:materyalph_api_client/src/api/vendor_invoices_api.dart';
import 'package:materyalph_api_client/src/api/vendor_materials_analytics_api.dart';
import 'package:materyalph_api_client/src/api/vendor_onboarding_api.dart';
import 'package:materyalph_api_client/src/api/vendor_orders_api.dart';
import 'package:materyalph_api_client/src/api/vendor_reviews_api.dart';
import 'package:materyalph_api_client/src/api/vendor_store_performance_api.dart';

class MateryalphApiClient {
  static const String basePath = r'/api/v1';

  final Dio dio;
  final Serializers serializers;

  MateryalphApiClient({
    Dio? dio,
    Serializers? serializers,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  })  : this.serializers = serializers ?? standardSerializers,
        this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the OAuth token associated with the given [name].
  ///
  /// If no [OAuthInterceptor] is registered or no token exists for the given
  /// [name], this method has no effect.
  void removeOAuthToken(String name) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor).tokens.remove(name);
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens[name] = token;
    }
  }

  /// Removes the bearer authentication token associated with the given [name].
  ///
  /// If no [BearerAuthInterceptor] is registered or no token exists for the
  /// given [name], this method has no effect.
  void removeBearerAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor).tokens.remove(name);
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  /// Removes the basic authentication credentials associated with the given [name].
  ///
  /// If no [BasicAuthInterceptor] is registered or no credentials exist for the
  /// given [name], this method has no effect.
  void removeBasicAuth(String name) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor).authInfo.remove(name);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys[name] = apiKey;
    }
  }

  /// Removes the API key associated with the given [name].
  ///
  /// If no [ApiKeyAuthInterceptor] is registered or no API key exists for the
  /// given [name], this method has no effect.
  void removeApiKey(String name) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor) as ApiKeyAuthInterceptor).apiKeys.remove(name);
    }
  }

  /// Get AccountsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AccountsApi getAccountsApi() {
    return AccountsApi(dio, serializers);
  }

  /// Get AdminAuditLogApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminAuditLogApi getAdminAuditLogApi() {
    return AdminAuditLogApi(dio, serializers);
  }

  /// Get AdminBudgetOverridesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminBudgetOverridesApi getAdminBudgetOverridesApi() {
    return AdminBudgetOverridesApi(dio, serializers);
  }

  /// Get AdminDisputesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminDisputesApi getAdminDisputesApi() {
    return AdminDisputesApi(dio, serializers);
  }

  /// Get AdminEnforcementApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminEnforcementApi getAdminEnforcementApi() {
    return AdminEnforcementApi(dio, serializers);
  }

  /// Get AdminFinanceApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminFinanceApi getAdminFinanceApi() {
    return AdminFinanceApi(dio, serializers);
  }

  /// Get AdminFinanceOperationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminFinanceOperationsApi getAdminFinanceOperationsApi() {
    return AdminFinanceOperationsApi(dio, serializers);
  }

  /// Get AdminGeographicAnalyticsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminGeographicAnalyticsApi getAdminGeographicAnalyticsApi() {
    return AdminGeographicAnalyticsApi(dio, serializers);
  }

  /// Get AdminIntegrationHealthApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminIntegrationHealthApi getAdminIntegrationHealthApi() {
    return AdminIntegrationHealthApi(dio, serializers);
  }

  /// Get AdminInvoicesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminInvoicesApi getAdminInvoicesApi() {
    return AdminInvoicesApi(dio, serializers);
  }

  /// Get AdminMaterialsAnalyticsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminMaterialsAnalyticsApi getAdminMaterialsAnalyticsApi() {
    return AdminMaterialsAnalyticsApi(dio, serializers);
  }

  /// Get AdminOrderOperationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminOrderOperationsApi getAdminOrderOperationsApi() {
    return AdminOrderOperationsApi(dio, serializers);
  }

  /// Get AdminPlatformSettingsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminPlatformSettingsApi getAdminPlatformSettingsApi() {
    return AdminPlatformSettingsApi(dio, serializers);
  }

  /// Get AdminPrivacyRequestsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminPrivacyRequestsApi getAdminPrivacyRequestsApi() {
    return AdminPrivacyRequestsApi(dio, serializers);
  }

  /// Get AdminProductComplianceApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminProductComplianceApi getAdminProductComplianceApi() {
    return AdminProductComplianceApi(dio, serializers);
  }

  /// Get AdminReviewModerationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminReviewModerationApi getAdminReviewModerationApi() {
    return AdminReviewModerationApi(dio, serializers);
  }

  /// Get AdminScoreMonitoringApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminScoreMonitoringApi getAdminScoreMonitoringApi() {
    return AdminScoreMonitoringApi(dio, serializers);
  }

  /// Get AdminVendorVerificationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AdminVendorVerificationApi getAdminVendorVerificationApi() {
    return AdminVendorVerificationApi(dio, serializers);
  }

  /// Get AgreementsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AgreementsApi getAgreementsApi() {
    return AgreementsApi(dio, serializers);
  }

  /// Get AuthenticationApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  AuthenticationApi getAuthenticationApi() {
    return AuthenticationApi(dio, serializers);
  }

  /// Get BuyerCartApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerCartApi getBuyerCartApi() {
    return BuyerCartApi(dio, serializers);
  }

  /// Get BuyerDiscoveryApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerDiscoveryApi getBuyerDiscoveryApi() {
    return BuyerDiscoveryApi(dio, serializers);
  }

  /// Get BuyerDisputesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerDisputesApi getBuyerDisputesApi() {
    return BuyerDisputesApi(dio, serializers);
  }

  /// Get BuyerExploreApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerExploreApi getBuyerExploreApi() {
    return BuyerExploreApi(dio, serializers);
  }

  /// Get BuyerFulfillmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerFulfillmentApi getBuyerFulfillmentApi() {
    return BuyerFulfillmentApi(dio, serializers);
  }

  /// Get BuyerInvoicesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerInvoicesApi getBuyerInvoicesApi() {
    return BuyerInvoicesApi(dio, serializers);
  }

  /// Get BuyerLocationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerLocationsApi getBuyerLocationsApi() {
    return BuyerLocationsApi(dio, serializers);
  }

  /// Get BuyerMaterialsAnalyticsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerMaterialsAnalyticsApi getBuyerMaterialsAnalyticsApi() {
    return BuyerMaterialsAnalyticsApi(dio, serializers);
  }

  /// Get BuyerOrdersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerOrdersApi getBuyerOrdersApi() {
    return BuyerOrdersApi(dio, serializers);
  }

  /// Get BuyerPaymentsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerPaymentsApi getBuyerPaymentsApi() {
    return BuyerPaymentsApi(dio, serializers);
  }

  /// Get BuyerProjectsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerProjectsApi getBuyerProjectsApi() {
    return BuyerProjectsApi(dio, serializers);
  }

  /// Get BuyerReviewsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BuyerReviewsApi getBuyerReviewsApi() {
    return BuyerReviewsApi(dio, serializers);
  }

  /// Get MessagingApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  MessagingApi getMessagingApi() {
    return MessagingApi(dio, serializers);
  }

  /// Get NotificationsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  NotificationsApi getNotificationsApi() {
    return NotificationsApi(dio, serializers);
  }

  /// Get PaymentWebhooksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  PaymentWebhooksApi getPaymentWebhooksApi() {
    return PaymentWebhooksApi(dio, serializers);
  }

  /// Get ReportingApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ReportingApi getReportingApi() {
    return ReportingApi(dio, serializers);
  }

  /// Get StoresApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  StoresApi getStoresApi() {
    return StoresApi(dio, serializers);
  }

  /// Get SystemApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SystemApi getSystemApi() {
    return SystemApi(dio, serializers);
  }

  /// Get VendorAutoAcceptApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorAutoAcceptApi getVendorAutoAcceptApi() {
    return VendorAutoAcceptApi(dio, serializers);
  }

  /// Get VendorCatalogApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorCatalogApi getVendorCatalogApi() {
    return VendorCatalogApi(dio, serializers);
  }

  /// Get VendorDisputesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorDisputesApi getVendorDisputesApi() {
    return VendorDisputesApi(dio, serializers);
  }

  /// Get VendorFinanceApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorFinanceApi getVendorFinanceApi() {
    return VendorFinanceApi(dio, serializers);
  }

  /// Get VendorFinanceReviewsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorFinanceReviewsApi getVendorFinanceReviewsApi() {
    return VendorFinanceReviewsApi(dio, serializers);
  }

  /// Get VendorFleetApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorFleetApi getVendorFleetApi() {
    return VendorFleetApi(dio, serializers);
  }

  /// Get VendorFulfillmentApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorFulfillmentApi getVendorFulfillmentApi() {
    return VendorFulfillmentApi(dio, serializers);
  }

  /// Get VendorInventoryApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorInventoryApi getVendorInventoryApi() {
    return VendorInventoryApi(dio, serializers);
  }

  /// Get VendorInvoicesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorInvoicesApi getVendorInvoicesApi() {
    return VendorInvoicesApi(dio, serializers);
  }

  /// Get VendorMaterialsAnalyticsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorMaterialsAnalyticsApi getVendorMaterialsAnalyticsApi() {
    return VendorMaterialsAnalyticsApi(dio, serializers);
  }

  /// Get VendorOnboardingApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorOnboardingApi getVendorOnboardingApi() {
    return VendorOnboardingApi(dio, serializers);
  }

  /// Get VendorOrdersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorOrdersApi getVendorOrdersApi() {
    return VendorOrdersApi(dio, serializers);
  }

  /// Get VendorReviewsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorReviewsApi getVendorReviewsApi() {
    return VendorReviewsApi(dio, serializers);
  }

  /// Get VendorStorePerformanceApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  VendorStorePerformanceApi getVendorStorePerformanceApi() {
    return VendorStorePerformanceApi(dio, serializers);
  }
}
