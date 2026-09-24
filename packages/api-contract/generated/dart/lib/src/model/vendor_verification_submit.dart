//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_verification_draft.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_verification_submit.g.dart';

/// VendorVerificationSubmit
///
/// Properties:
/// * [draft]
/// * [lockVersion]
/// * [privacyAcknowledged]
@BuiltValue()
abstract class VendorVerificationSubmit implements Built<VendorVerificationSubmit, VendorVerificationSubmitBuilder> {
  @BuiltValueField(wireName: r'draft')
  VendorVerificationDraft? get draft;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'privacy_acknowledged')
  VendorVerificationSubmitPrivacyAcknowledgedEnum get privacyAcknowledged;
  // enum privacyAcknowledgedEnum {  true,  };

  VendorVerificationSubmit._();

  factory VendorVerificationSubmit([void updates(VendorVerificationSubmitBuilder b)]) = _$VendorVerificationSubmit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorVerificationSubmitBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorVerificationSubmit> get serializer => _$VendorVerificationSubmitSerializer();
}

class _$VendorVerificationSubmitSerializer implements PrimitiveSerializer<VendorVerificationSubmit> {
  @override
  final Iterable<Type> types = const [VendorVerificationSubmit, _$VendorVerificationSubmit];

  @override
  final String wireName = r'VendorVerificationSubmit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorVerificationSubmit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.draft != null) {
      yield r'draft';
      yield serializers.serialize(
        object.draft,
        specifiedType: const FullType(VendorVerificationDraft),
      );
    }
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'privacy_acknowledged';
    yield serializers.serialize(
      object.privacyAcknowledged,
      specifiedType: const FullType(VendorVerificationSubmitPrivacyAcknowledgedEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorVerificationSubmit object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorVerificationSubmitBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'draft':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorVerificationDraft),
          ) as VendorVerificationDraft?;
          if (valueDes == null) continue;
          result.draft = valueDes.toBuilder();
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'privacy_acknowledged':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorVerificationSubmitPrivacyAcknowledgedEnum),
          ) as VendorVerificationSubmitPrivacyAcknowledgedEnum;
          result.privacyAcknowledged = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorVerificationSubmit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorVerificationSubmitBuilder();
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


class VendorVerificationSubmitPrivacyAcknowledgedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const VendorVerificationSubmitPrivacyAcknowledgedEnum true_ = _$vendorVerificationSubmitPrivacyAcknowledgedEnum_true_;

  static Serializer<VendorVerificationSubmitPrivacyAcknowledgedEnum> get serializer => _$vendorVerificationSubmitPrivacyAcknowledgedEnumSerializer;

  const VendorVerificationSubmitPrivacyAcknowledgedEnum._(String name): super(name);

  static BuiltSet<VendorVerificationSubmitPrivacyAcknowledgedEnum> get values => _$vendorVerificationSubmitPrivacyAcknowledgedEnumValues;
  static VendorVerificationSubmitPrivacyAcknowledgedEnum valueOf(String name) => _$vendorVerificationSubmitPrivacyAcknowledgedEnumValueOf(name);
}

