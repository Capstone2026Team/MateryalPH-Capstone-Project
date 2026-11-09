//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_account_deletion_result.g.dart';

/// VendorAccountDeletionResult
///
/// Properties:
/// * [reference] - Account deletion audit reference.
/// * [deletedAt]
/// * [signInRequired]
@BuiltValue()
abstract class VendorAccountDeletionResult implements Built<VendorAccountDeletionResult, VendorAccountDeletionResultBuilder> {
  /// Account deletion audit reference.
  @BuiltValueField(wireName: r'reference')
  String get reference;

  @BuiltValueField(wireName: r'deleted_at')
  DateTime get deletedAt;

  @BuiltValueField(wireName: r'sign_in_required')
  VendorAccountDeletionResultSignInRequiredEnum get signInRequired;
  // enum signInRequiredEnum {  true,  };

  VendorAccountDeletionResult._();

  factory VendorAccountDeletionResult([void updates(VendorAccountDeletionResultBuilder b)]) = _$VendorAccountDeletionResult;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorAccountDeletionResultBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorAccountDeletionResult> get serializer => _$VendorAccountDeletionResultSerializer();
}

class _$VendorAccountDeletionResultSerializer implements PrimitiveSerializer<VendorAccountDeletionResult> {
  @override
  final Iterable<Type> types = const [VendorAccountDeletionResult, _$VendorAccountDeletionResult];

  @override
  final String wireName = r'VendorAccountDeletionResult';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorAccountDeletionResult object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(String),
    );
    yield r'deleted_at';
    yield serializers.serialize(
      object.deletedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'sign_in_required';
    yield serializers.serialize(
      object.signInRequired,
      specifiedType: const FullType(VendorAccountDeletionResultSignInRequiredEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorAccountDeletionResult object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorAccountDeletionResultBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reference = valueDes;
          break;
        case r'deleted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.deletedAt = valueDes;
          break;
        case r'sign_in_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorAccountDeletionResultSignInRequiredEnum),
          ) as VendorAccountDeletionResultSignInRequiredEnum;
          result.signInRequired = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorAccountDeletionResult deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorAccountDeletionResultBuilder();
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


class VendorAccountDeletionResultSignInRequiredEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const VendorAccountDeletionResultSignInRequiredEnum true_ = _$vendorAccountDeletionResultSignInRequiredEnum_true_;

  static Serializer<VendorAccountDeletionResultSignInRequiredEnum> get serializer => _$vendorAccountDeletionResultSignInRequiredEnumSerializer;

  const VendorAccountDeletionResultSignInRequiredEnum._(String name): super(name);

  static BuiltSet<VendorAccountDeletionResultSignInRequiredEnum> get values => _$vendorAccountDeletionResultSignInRequiredEnumValues;
  static VendorAccountDeletionResultSignInRequiredEnum valueOf(String name) => _$vendorAccountDeletionResultSignInRequiredEnumValueOf(name);
}

