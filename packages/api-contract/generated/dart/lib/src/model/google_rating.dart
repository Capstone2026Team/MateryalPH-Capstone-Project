//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_rating.g.dart';

/// GoogleRating
///
/// Properties:
/// * [source_]
/// * [label] - Always Google rating.
/// * [value]
/// * [count]
@BuiltValue()
abstract class GoogleRating implements Built<GoogleRating, GoogleRatingBuilder> {
  @BuiltValueField(wireName: r'source')
  GoogleRatingSource_Enum get source_;
  // enum source_Enum {  GOOGLE,  };

  /// Always Google rating.
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'value')
  String get value;

  @BuiltValueField(wireName: r'count')
  int? get count;

  GoogleRating._();

  factory GoogleRating([void updates(GoogleRatingBuilder b)]) = _$GoogleRating;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoogleRatingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoogleRating> get serializer => _$GoogleRatingSerializer();
}

class _$GoogleRatingSerializer implements PrimitiveSerializer<GoogleRating> {
  @override
  final Iterable<Type> types = const [GoogleRating, _$GoogleRating];

  @override
  final String wireName = r'GoogleRating';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoogleRating object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(GoogleRatingSource_Enum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield object.count == null ? null : serializers.serialize(
      object.count,
      specifiedType: const FullType.nullable(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GoogleRating object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoogleRatingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GoogleRatingSource_Enum),
          ) as GoogleRatingSource_Enum;
          result.source_ = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.value = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GoogleRating deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoogleRatingBuilder();
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


class GoogleRatingSource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GOOGLE')
  static const GoogleRatingSource_Enum GOOGLE = _$googleRatingSourceEnum_GOOGLE;

  static Serializer<GoogleRatingSource_Enum> get serializer => _$googleRatingSourceEnumSerializer;

  const GoogleRatingSource_Enum._(String name): super(name);

  static BuiltSet<GoogleRatingSource_Enum> get values => _$googleRatingSourceEnumValues;
  static GoogleRatingSource_Enum valueOf(String name) => _$googleRatingSourceEnumValueOf(name);
}

