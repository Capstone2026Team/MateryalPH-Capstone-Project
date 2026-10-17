import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminAuditLogApi
void main() {
  final instance = MateryalphApiClient().getAdminAuditLogApi();

  group(AdminAuditLogApi, () {
    // audit.view_sensitive. Redacted before/after; the opening is itself audited. There is no edit or delete operation.
    //
    //Future<AuditEventDetailEnvelope> getAuditEvent(String auditId) async
    test('test getAuditEvent', () async {
      // TODO
    });

    // audit.view. Distinct action codes for the filter control.
    //
    //Future<AuditActionListEnvelope> listAuditActions() async
    test('test listAuditActions', () async {
      // TODO
    });

    // audit.view. Append-only safe projection filterable by actor, role, action, resource, organization, result, date, correlation ID and reason; cursor paginated.
    //
    //Future<AuditEventListEnvelope> searchAuditLog({ String actor, String actorRole, String action, String resourceType, String resourceId, String organizationId, String result, String correlationId, String reason, Date from, Date to, String cursor }) async
    test('test searchAuditLog', () async {
      // TODO
    });

  });
}
