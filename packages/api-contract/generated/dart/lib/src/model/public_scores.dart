//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/public_badge.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_scores.g.dart';

/// PublicScores
///
/// Properties:
/// * [label]
/// * [newVendor]
/// * [vps]
/// * [vcs]
/// * [mqs]
/// * [ohs]
/// * [asOf]
/// * [badges]
@BuiltValue()
abstract class PublicScores implements Built<PublicScores, PublicScoresBuilder> {
  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'new_vendor')
  bool get newVendor;

  @BuiltValueField(wireName: r'vps')
  String? get vps;

  @BuiltValueField(wireName: r'vcs')
  String? get vcs;

  @BuiltValueField(wireName: r'mqs')
  String? get mqs;

  @BuiltValueField(wireName: r'ohs')
  String? get ohs;

  @BuiltValueField(wireName: r'as_of')
  Date? get asOf;

  @BuiltValueField(wireName: r'badges')
  BuiltList<PublicBadge> get badges;

  PublicScores._();

  factory PublicScores([void updates(PublicScoresBuilder b)]) = _$PublicScores;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicScoresBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicScores> get serializer => _$PublicScoresSerializer();
}

class _$PublicScoresSerializer implements PrimitiveSerializer<PublicScores> {
  @override
  final Iterable<Type> types = const [PublicScores, _$PublicScores];

  @override
  final String wireName = r'PublicScores';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicScores object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'new_vendor';
    yield serializers.serialize(
      object.newVendor,
      specifiedType: const FullType(bool),
    );
    if (object.vps != null) {
      yield r'vps';
      yield serializers.serialize(
        object.vps,
        specifiedType: const FullType(String),
      );
    }
    if (object.vcs != null) {
      yield r'vcs';
      yield serializers.serialize(
        object.vcs,
        specifiedType: const FullType(String),
      );
    }
    if (object.mqs != null) {
      yield r'mqs';
      yield serializers.serialize(
        object.mqs,
        specifiedType: const FullType(String),
      );
    }
    if (object.ohs != null) {
      yield r'ohs';
      yield serializers.serialize(
        object.ohs,
        specifiedType: const FullType(String),
      );
    }
    if (object.asOf != null) {
      yield r'as_of';
      yield serializers.serialize(
        object.asOf,
        specifiedType: const FullType(Date),
      );
    }
    yield r'badges';
    yield serializers.serialize(
      object.badges,
      specifiedType: const FullType(BuiltList, [FullType(PublicBadge)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicScores object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicScoresBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'new_vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.newVendor = valueDes;
          break;
        case r'vps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vps = valueDes;
          break;
        case r'vcs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vcs = valueDes;
          break;
        case r'mqs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.mqs = valueDes;
          break;
        case r'ohs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ohs = valueDes;
          break;
        case r'as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.asOf = valueDes;
          break;
        case r'badges':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PublicBadge)]),
          ) as BuiltList<PublicBadge>;
          result.badges.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicScores deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicScoresBuilder();
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


