//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/vendor_business_draft.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'save_vendor_business.g.dart';

/// SaveVendorBusiness
///
/// Properties:
/// * [lockVersion]
/// * [submit]
/// * [business]
@BuiltValue()
abstract class SaveVendorBusiness implements Built<SaveVendorBusiness, SaveVendorBusinessBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'submit')
  bool get submit;

  @BuiltValueField(wireName: r'business')
  VendorBusinessDraft get business;

  SaveVendorBusiness._();

  factory SaveVendorBusiness([void updates(SaveVendorBusinessBuilder b)]) = _$SaveVendorBusiness;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SaveVendorBusinessBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SaveVendorBusiness> get serializer => _$SaveVendorBusinessSerializer();
}

class _$SaveVendorBusinessSerializer implements PrimitiveSerializer<SaveVendorBusiness> {
  @override
  final Iterable<Type> types = const [SaveVendorBusiness, _$SaveVendorBusiness];

  @override
  final String wireName = r'SaveVendorBusiness';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SaveVendorBusiness object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'submit';
    yield serializers.serialize(
      object.submit,
      specifiedType: const FullType(bool),
    );
    yield r'business';
    yield serializers.serialize(
      object.business,
      specifiedType: const FullType(VendorBusinessDraft),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SaveVendorBusiness object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SaveVendorBusinessBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'submit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.submit = valueDes;
          break;
        case r'business':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorBusinessDraft),
          ) as VendorBusinessDraft;
          result.business.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SaveVendorBusiness deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SaveVendorBusinessBuilder();
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


