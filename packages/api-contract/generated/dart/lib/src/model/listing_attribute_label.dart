//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_attribute_label.g.dart';

/// ListingAttributeLabel
///
/// Properties:
/// * [code]
/// * [label]
/// * [unitCode]
@BuiltValue()
abstract class ListingAttributeLabel implements Built<ListingAttributeLabel, ListingAttributeLabelBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'unit_code')
  String? get unitCode;

  ListingAttributeLabel._();

  factory ListingAttributeLabel([void updates(ListingAttributeLabelBuilder b)]) = _$ListingAttributeLabel;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingAttributeLabelBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingAttributeLabel> get serializer => _$ListingAttributeLabelSerializer();
}

class _$ListingAttributeLabelSerializer implements PrimitiveSerializer<ListingAttributeLabel> {
  @override
  final Iterable<Type> types = const [ListingAttributeLabel, _$ListingAttributeLabel];

  @override
  final String wireName = r'ListingAttributeLabel';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingAttributeLabel object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'unit_code';
    yield object.unitCode == null ? null : serializers.serialize(
      object.unitCode,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingAttributeLabel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingAttributeLabelBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'unit_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.unitCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingAttributeLabel deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingAttributeLabelBuilder();
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


