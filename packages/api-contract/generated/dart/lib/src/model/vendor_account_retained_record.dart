//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_account_retained_record.g.dart';

/// VendorAccountRetainedRecord
///
/// Properties:
/// * [category]
/// * [purpose]
@BuiltValue()
abstract class VendorAccountRetainedRecord implements Built<VendorAccountRetainedRecord, VendorAccountRetainedRecordBuilder> {
  @BuiltValueField(wireName: r'category')
  String get category;

  @BuiltValueField(wireName: r'purpose')
  String get purpose;

  VendorAccountRetainedRecord._();

  factory VendorAccountRetainedRecord([void updates(VendorAccountRetainedRecordBuilder b)]) = _$VendorAccountRetainedRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorAccountRetainedRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorAccountRetainedRecord> get serializer => _$VendorAccountRetainedRecordSerializer();
}

class _$VendorAccountRetainedRecordSerializer implements PrimitiveSerializer<VendorAccountRetainedRecord> {
  @override
  final Iterable<Type> types = const [VendorAccountRetainedRecord, _$VendorAccountRetainedRecord];

  @override
  final String wireName = r'VendorAccountRetainedRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorAccountRetainedRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(String),
    );
    yield r'purpose';
    yield serializers.serialize(
      object.purpose,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorAccountRetainedRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorAccountRetainedRecordBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.category = valueDes;
          break;
        case r'purpose':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.purpose = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorAccountRetainedRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorAccountRetainedRecordBuilder();
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


