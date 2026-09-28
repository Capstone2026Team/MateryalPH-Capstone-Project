//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'favorite_supplier_state.g.dart';

/// FavoriteSupplierState
///
/// Properties:
/// * [vendorId]
/// * [isFavorite]
@BuiltValue()
abstract class FavoriteSupplierState implements Built<FavoriteSupplierState, FavoriteSupplierStateBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'is_favorite')
  bool get isFavorite;

  FavoriteSupplierState._();

  factory FavoriteSupplierState([void updates(FavoriteSupplierStateBuilder b)]) = _$FavoriteSupplierState;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FavoriteSupplierStateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FavoriteSupplierState> get serializer => _$FavoriteSupplierStateSerializer();
}

class _$FavoriteSupplierStateSerializer implements PrimitiveSerializer<FavoriteSupplierState> {
  @override
  final Iterable<Type> types = const [FavoriteSupplierState, _$FavoriteSupplierState];

  @override
  final String wireName = r'FavoriteSupplierState';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FavoriteSupplierState object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    yield r'is_favorite';
    yield serializers.serialize(
      object.isFavorite,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FavoriteSupplierState object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FavoriteSupplierStateBuilder result,
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
        case r'is_favorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isFavorite = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FavoriteSupplierState deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FavoriteSupplierStateBuilder();
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


