//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_tax_review_history.g.dart';

/// VendorTaxReviewHistory
///
/// Properties:
/// * [id]
/// * [decision]
/// * [reason]
/// * [approvalScope]
/// * [environment]
/// * [createdAt]
@BuiltValue()
abstract class VendorTaxReviewHistory implements Built<VendorTaxReviewHistory, VendorTaxReviewHistoryBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'decision')
  String get decision;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'approval_scope')
  String get approvalScope;

  @BuiltValueField(wireName: r'environment')
  VendorTaxReviewHistoryEnvironmentEnum get environment;
  // enum environmentEnum {  TEST,  };

  @BuiltValueField(wireName: r'created_at')
  String get createdAt;

  VendorTaxReviewHistory._();

  factory VendorTaxReviewHistory([void updates(VendorTaxReviewHistoryBuilder b)]) = _$VendorTaxReviewHistory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTaxReviewHistoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTaxReviewHistory> get serializer => _$VendorTaxReviewHistorySerializer();
}

class _$VendorTaxReviewHistorySerializer implements PrimitiveSerializer<VendorTaxReviewHistory> {
  @override
  final Iterable<Type> types = const [VendorTaxReviewHistory, _$VendorTaxReviewHistory];

  @override
  final String wireName = r'VendorTaxReviewHistory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTaxReviewHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'decision';
    yield serializers.serialize(
      object.decision,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'approval_scope';
    yield serializers.serialize(
      object.approvalScope,
      specifiedType: const FullType(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(VendorTaxReviewHistoryEnvironmentEnum),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTaxReviewHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTaxReviewHistoryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'decision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.decision = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'approval_scope':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.approvalScope = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTaxReviewHistoryEnvironmentEnum),
          ) as VendorTaxReviewHistoryEnvironmentEnum;
          result.environment = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTaxReviewHistory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTaxReviewHistoryBuilder();
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


class VendorTaxReviewHistoryEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const VendorTaxReviewHistoryEnvironmentEnum TEST = _$vendorTaxReviewHistoryEnvironmentEnum_TEST;

  static Serializer<VendorTaxReviewHistoryEnvironmentEnum> get serializer => _$vendorTaxReviewHistoryEnvironmentEnumSerializer;

  const VendorTaxReviewHistoryEnvironmentEnum._(String name): super(name);

  static BuiltSet<VendorTaxReviewHistoryEnvironmentEnum> get values => _$vendorTaxReviewHistoryEnvironmentEnumValues;
  static VendorTaxReviewHistoryEnvironmentEnum valueOf(String name) => _$vendorTaxReviewHistoryEnvironmentEnumValueOf(name);
}

