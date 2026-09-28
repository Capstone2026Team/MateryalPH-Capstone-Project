//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/score_label.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'favorite_supplier.g.dart';

/// FavoriteSupplier
///
/// Properties:
/// * [vendorId]
/// * [name]
/// * [logoUrl]
/// * [scoreLabel]
/// * [currentlyDiscoverable]
/// * [savedAt]
@BuiltValue()
abstract class FavoriteSupplier implements Built<FavoriteSupplier, FavoriteSupplierBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'logo_url')
  String? get logoUrl;

  @BuiltValueField(wireName: r'score_label')
  ScoreLabel get scoreLabel;

  @BuiltValueField(wireName: r'currently_discoverable')
  bool get currentlyDiscoverable;

  @BuiltValueField(wireName: r'saved_at')
  DateTime get savedAt;

  FavoriteSupplier._();

  factory FavoriteSupplier([void updates(FavoriteSupplierBuilder b)]) = _$FavoriteSupplier;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FavoriteSupplierBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FavoriteSupplier> get serializer => _$FavoriteSupplierSerializer();
}

class _$FavoriteSupplierSerializer implements PrimitiveSerializer<FavoriteSupplier> {
  @override
  final Iterable<Type> types = const [FavoriteSupplier, _$FavoriteSupplier];

  @override
  final String wireName = r'FavoriteSupplier';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FavoriteSupplier object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
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
    yield r'currently_discoverable';
    yield serializers.serialize(
      object.currentlyDiscoverable,
      specifiedType: const FullType(bool),
    );
    yield r'saved_at';
    yield serializers.serialize(
      object.savedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FavoriteSupplier object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FavoriteSupplierBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorId = valueDes;
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
        case r'currently_discoverable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.currentlyDiscoverable = valueDes;
          break;
        case r'saved_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.savedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FavoriteSupplier deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FavoriteSupplierBuilder();
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


