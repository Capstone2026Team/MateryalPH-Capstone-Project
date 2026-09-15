//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_commission_terms.g.dart';

/// VendorCommissionTerms
///
/// Properties:
/// * [agreement]
/// * [commissionBasisPoints]
/// * [basis]
/// * [cadence]
/// * [environment]
/// * [contentAvailable]
@BuiltValue()
abstract class VendorCommissionTerms implements Built<VendorCommissionTerms, VendorCommissionTermsBuilder> {
  @BuiltValueField(wireName: r'agreement')
  BuiltMap<String, JsonObject?>? get agreement;

  @BuiltValueField(wireName: r'commission_basis_points')
  int get commissionBasisPoints;

  @BuiltValueField(wireName: r'basis')
  String get basis;

  @BuiltValueField(wireName: r'cadence')
  String get cadence;

  @BuiltValueField(wireName: r'environment')
  String get environment;

  @BuiltValueField(wireName: r'content_available')
  bool get contentAvailable;

  VendorCommissionTerms._();

  factory VendorCommissionTerms([void updates(VendorCommissionTermsBuilder b)]) = _$VendorCommissionTerms;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorCommissionTermsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorCommissionTerms> get serializer => _$VendorCommissionTermsSerializer();
}

class _$VendorCommissionTermsSerializer implements PrimitiveSerializer<VendorCommissionTerms> {
  @override
  final Iterable<Type> types = const [VendorCommissionTerms, _$VendorCommissionTerms];

  @override
  final String wireName = r'VendorCommissionTerms';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorCommissionTerms object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'agreement';
    yield object.agreement == null ? null : serializers.serialize(
      object.agreement,
      specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'commission_basis_points';
    yield serializers.serialize(
      object.commissionBasisPoints,
      specifiedType: const FullType(int),
    );
    yield r'basis';
    yield serializers.serialize(
      object.basis,
      specifiedType: const FullType(String),
    );
    yield r'cadence';
    yield serializers.serialize(
      object.cadence,
      specifiedType: const FullType(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(String),
    );
    yield r'content_available';
    yield serializers.serialize(
      object.contentAvailable,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorCommissionTerms object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorCommissionTermsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'agreement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.agreement.replace(valueDes);
          break;
        case r'commission_basis_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionBasisPoints = valueDes;
          break;
        case r'basis':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.basis = valueDes;
          break;
        case r'cadence':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cadence = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.environment = valueDes;
          break;
        case r'content_available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.contentAvailable = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorCommissionTerms deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorCommissionTermsBuilder();
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


