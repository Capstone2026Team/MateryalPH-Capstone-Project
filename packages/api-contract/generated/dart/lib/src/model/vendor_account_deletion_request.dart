//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_account_deletion_request.g.dart';

/// VendorAccountDeletionRequest
///
/// Properties:
/// * [confirmation]
@BuiltValue()
abstract class VendorAccountDeletionRequest implements Built<VendorAccountDeletionRequest, VendorAccountDeletionRequestBuilder> {
  @BuiltValueField(wireName: r'confirmation')
  VendorAccountDeletionRequestConfirmationEnum get confirmation;
  // enum confirmationEnum {  DELETE,  };

  VendorAccountDeletionRequest._();

  factory VendorAccountDeletionRequest([void updates(VendorAccountDeletionRequestBuilder b)]) = _$VendorAccountDeletionRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorAccountDeletionRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorAccountDeletionRequest> get serializer => _$VendorAccountDeletionRequestSerializer();
}

class _$VendorAccountDeletionRequestSerializer implements PrimitiveSerializer<VendorAccountDeletionRequest> {
  @override
  final Iterable<Type> types = const [VendorAccountDeletionRequest, _$VendorAccountDeletionRequest];

  @override
  final String wireName = r'VendorAccountDeletionRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorAccountDeletionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'confirmation';
    yield serializers.serialize(
      object.confirmation,
      specifiedType: const FullType(VendorAccountDeletionRequestConfirmationEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorAccountDeletionRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorAccountDeletionRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorAccountDeletionRequestConfirmationEnum),
          ) as VendorAccountDeletionRequestConfirmationEnum;
          result.confirmation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorAccountDeletionRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorAccountDeletionRequestBuilder();
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


class VendorAccountDeletionRequestConfirmationEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELETE')
  static const VendorAccountDeletionRequestConfirmationEnum DELETE = _$vendorAccountDeletionRequestConfirmationEnum_DELETE;

  static Serializer<VendorAccountDeletionRequestConfirmationEnum> get serializer => _$vendorAccountDeletionRequestConfirmationEnumSerializer;

  const VendorAccountDeletionRequestConfirmationEnum._(String name): super(name);

  static BuiltSet<VendorAccountDeletionRequestConfirmationEnum> get values => _$vendorAccountDeletionRequestConfirmationEnumValues;
  static VendorAccountDeletionRequestConfirmationEnum valueOf(String name) => _$vendorAccountDeletionRequestConfirmationEnumValueOf(name);
}

