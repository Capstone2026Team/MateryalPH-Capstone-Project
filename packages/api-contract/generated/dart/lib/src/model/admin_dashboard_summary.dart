//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_summary.g.dart';

/// AdminDashboardSummary
///
/// Properties:
/// * [generatedAt]
/// * [activeVendors]
/// * [inactiveVendors]
/// * [activeBuyers]
/// * [pendingDocumentReviews]
/// * [auditEvents]
/// * [canViewAudit]
@BuiltValue()
abstract class AdminDashboardSummary implements Built<AdminDashboardSummary, AdminDashboardSummaryBuilder> {
  @BuiltValueField(wireName: r'generated_at')
  DateTime get generatedAt;

  @BuiltValueField(wireName: r'active_vendors')
  int? get activeVendors;

  @BuiltValueField(wireName: r'inactive_vendors')
  int? get inactiveVendors;

  @BuiltValueField(wireName: r'active_buyers')
  int? get activeBuyers;

  @BuiltValueField(wireName: r'pending_document_reviews')
  int? get pendingDocumentReviews;

  @BuiltValueField(wireName: r'audit_events')
  int? get auditEvents;

  @BuiltValueField(wireName: r'can_view_audit')
  bool get canViewAudit;

  AdminDashboardSummary._();

  factory AdminDashboardSummary([void updates(AdminDashboardSummaryBuilder b)]) = _$AdminDashboardSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardSummary> get serializer => _$AdminDashboardSummarySerializer();
}

class _$AdminDashboardSummarySerializer implements PrimitiveSerializer<AdminDashboardSummary> {
  @override
  final Iterable<Type> types = const [AdminDashboardSummary, _$AdminDashboardSummary];

  @override
  final String wireName = r'AdminDashboardSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'generated_at';
    yield serializers.serialize(
      object.generatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'active_vendors';
    yield object.activeVendors == null ? null : serializers.serialize(
      object.activeVendors,
      specifiedType: const FullType.nullable(int),
    );
    yield r'inactive_vendors';
    yield object.inactiveVendors == null ? null : serializers.serialize(
      object.inactiveVendors,
      specifiedType: const FullType.nullable(int),
    );
    yield r'active_buyers';
    yield object.activeBuyers == null ? null : serializers.serialize(
      object.activeBuyers,
      specifiedType: const FullType.nullable(int),
    );
    yield r'pending_document_reviews';
    yield object.pendingDocumentReviews == null ? null : serializers.serialize(
      object.pendingDocumentReviews,
      specifiedType: const FullType.nullable(int),
    );
    yield r'audit_events';
    yield object.auditEvents == null ? null : serializers.serialize(
      object.auditEvents,
      specifiedType: const FullType.nullable(int),
    );
    yield r'can_view_audit';
    yield serializers.serialize(
      object.canViewAudit,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'generated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.generatedAt = valueDes;
          break;
        case r'active_vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.activeVendors = valueDes;
          break;
        case r'inactive_vendors':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.inactiveVendors = valueDes;
          break;
        case r'active_buyers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.activeBuyers = valueDes;
          break;
        case r'pending_document_reviews':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.pendingDocumentReviews = valueDes;
          break;
        case r'audit_events':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.auditEvents = valueDes;
          break;
        case r'can_view_audit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canViewAudit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardSummaryBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


