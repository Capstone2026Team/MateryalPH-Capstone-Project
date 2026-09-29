//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/score_label.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_vendor_card.g.dart';

/// ListingVendorCard
///
/// Properties:
/// * [id]
/// * [name]
/// * [logoUrl]
/// * [scoreLabel]
/// * [vacationMode]
@BuiltValue()
abstract class ListingVendorCard implements Built<ListingVendorCard, ListingVendorCardBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'logo_url')
  String? get logoUrl;

  @BuiltValueField(wireName: r'score_label')
  ScoreLabel get scoreLabel;

  @BuiltValueField(wireName: r'vacation_mode')
  bool get vacationMode;

  ListingVendorCard._();

  factory ListingVendorCard([void updates(ListingVendorCardBuilder b)]) = _$ListingVendorCard;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingVendorCardBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingVendorCard> get serializer => _$ListingVendorCardSerializer();
}

class _$ListingVendorCardSerializer implements PrimitiveSerializer<ListingVendorCard> {
  @override
  final Iterable<Type> types = const [ListingVendorCard, _$ListingVendorCard];

  @override
  final String wireName = r'ListingVendorCard';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingVendorCard object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'logo_url';
    yield object.logoUrl == null ? null : serializers.serialize(
      object.logoUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'score_label';
    yield serializers.serialize(
      object.scoreLabel,
      specifiedType: const FullType(ScoreLabel),
    );
    yield r'vacation_mode';
    yield serializers.serialize(
      object.vacationMode,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingVendorCard object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingVendorCardBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'logo_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoUrl = valueDes;
          break;
        case r'score_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScoreLabel),
          ) as ScoreLabel;
          result.scoreLabel.replace(valueDes);
          break;
        case r'vacation_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.vacationMode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingVendorCard deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingVendorCardBuilder();
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


