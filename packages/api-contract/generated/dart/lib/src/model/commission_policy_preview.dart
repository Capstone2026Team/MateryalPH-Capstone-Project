//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_policy_preview.g.dart';

/// CommissionPolicyPreview
///
/// Properties:
/// * [vendorCount]
/// * [noticeHours]
/// * [noticeRequired]
/// * [exampleCommissionCentavos]
/// * [monthlyBasisCentavos]
/// * [estimatedMonthlyChangeCentavos]
/// * [volumePeriod]
/// * [currentTerms]
/// * [newTerms]
/// * [emailSubject]
/// * [emailHtml]
@BuiltValue()
abstract class CommissionPolicyPreview implements Built<CommissionPolicyPreview, CommissionPolicyPreviewBuilder> {
  @BuiltValueField(wireName: r'vendor_count')
  int get vendorCount;

  @BuiltValueField(wireName: r'notice_hours')
  int get noticeHours;

  @BuiltValueField(wireName: r'notice_required')
  bool get noticeRequired;

  @BuiltValueField(wireName: r'example_commission_centavos')
  int get exampleCommissionCentavos;

  @BuiltValueField(wireName: r'monthly_basis_centavos')
  int get monthlyBasisCentavos;

  @BuiltValueField(wireName: r'estimated_monthly_change_centavos')
  int get estimatedMonthlyChangeCentavos;

  @BuiltValueField(wireName: r'volume_period')
  String get volumePeriod;

  @BuiltValueField(wireName: r'current_terms')
  String? get currentTerms;

  @BuiltValueField(wireName: r'new_terms')
  String get newTerms;

  @BuiltValueField(wireName: r'email_subject')
  String get emailSubject;

  @BuiltValueField(wireName: r'email_html')
  String get emailHtml;

  CommissionPolicyPreview._();

  factory CommissionPolicyPreview([void updates(CommissionPolicyPreviewBuilder b)]) = _$CommissionPolicyPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionPolicyPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionPolicyPreview> get serializer => _$CommissionPolicyPreviewSerializer();
}

class _$CommissionPolicyPreviewSerializer implements PrimitiveSerializer<CommissionPolicyPreview> {
  @override
  final Iterable<Type> types = const [CommissionPolicyPreview, _$CommissionPolicyPreview];

  @override
  final String wireName = r'CommissionPolicyPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionPolicyPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_count';
    yield serializers.serialize(
      object.vendorCount,
      specifiedType: const FullType(int),
    );
    yield r'notice_hours';
    yield serializers.serialize(
      object.noticeHours,
      specifiedType: const FullType(int),
    );
    yield r'notice_required';
    yield serializers.serialize(
      object.noticeRequired,
      specifiedType: const FullType(bool),
    );
    yield r'example_commission_centavos';
    yield serializers.serialize(
      object.exampleCommissionCentavos,
      specifiedType: const FullType(int),
    );
    yield r'monthly_basis_centavos';
    yield serializers.serialize(
      object.monthlyBasisCentavos,
      specifiedType: const FullType(int),
    );
    yield r'estimated_monthly_change_centavos';
    yield serializers.serialize(
      object.estimatedMonthlyChangeCentavos,
      specifiedType: const FullType(int),
    );
    yield r'volume_period';
    yield serializers.serialize(
      object.volumePeriod,
      specifiedType: const FullType(String),
    );
    yield r'current_terms';
    yield object.currentTerms == null ? null : serializers.serialize(
      object.currentTerms,
      specifiedType: const FullType.nullable(String),
    );
    yield r'new_terms';
    yield serializers.serialize(
      object.newTerms,
      specifiedType: const FullType(String),
    );
    yield r'email_subject';
    yield serializers.serialize(
      object.emailSubject,
      specifiedType: const FullType(String),
    );
    yield r'email_html';
    yield serializers.serialize(
      object.emailHtml,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionPolicyPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionPolicyPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorCount = valueDes;
          break;
        case r'notice_hours':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.noticeHours = valueDes;
          break;
        case r'notice_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.noticeRequired = valueDes;
          break;
        case r'example_commission_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.exampleCommissionCentavos = valueDes;
          break;
        case r'monthly_basis_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.monthlyBasisCentavos = valueDes;
          break;
        case r'estimated_monthly_change_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.estimatedMonthlyChangeCentavos = valueDes;
          break;
        case r'volume_period':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.volumePeriod = valueDes;
          break;
        case r'current_terms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.currentTerms = valueDes;
          break;
        case r'new_terms':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.newTerms = valueDes;
          break;
        case r'email_subject':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.emailSubject = valueDes;
          break;
        case r'email_html':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.emailHtml = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionPolicyPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionPolicyPreviewBuilder();
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


