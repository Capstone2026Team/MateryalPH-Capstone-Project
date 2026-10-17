//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'navigation_updates.g.dart';

/// NavigationUpdates
///
/// Properties:
/// * [sections] - Authorized navigation paths mapped to unread messages/notices, active records or pending actions. Team headcounts are retained only in the legacy Vendor summary and are not displayed as attention badges.
/// * [cartQuantity] - Buyer only. Exact sum of active selected line quantities, excluding saved-for-later; never a line or unread count.
/// * [cartVersion] - Buyer only. Current active cart lock_version, zero when no cart exists.
@BuiltValue()
abstract class NavigationUpdates implements Built<NavigationUpdates, NavigationUpdatesBuilder> {
  /// Authorized navigation paths mapped to unread messages/notices, active records or pending actions. Team headcounts are retained only in the legacy Vendor summary and are not displayed as attention badges.
  @BuiltValueField(wireName: r'sections')
  BuiltMap<String, int> get sections;

  /// Buyer only. Exact sum of active selected line quantities, excluding saved-for-later; never a line or unread count.
  @BuiltValueField(wireName: r'cart_quantity')
  String? get cartQuantity;

  /// Buyer only. Current active cart lock_version, zero when no cart exists.
  @BuiltValueField(wireName: r'cart_version')
  int? get cartVersion;

  NavigationUpdates._();

  factory NavigationUpdates([void updates(NavigationUpdatesBuilder b)]) = _$NavigationUpdates;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NavigationUpdatesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NavigationUpdates> get serializer => _$NavigationUpdatesSerializer();
}

class _$NavigationUpdatesSerializer implements PrimitiveSerializer<NavigationUpdates> {
  @override
  final Iterable<Type> types = const [NavigationUpdates, _$NavigationUpdates];

  @override
  final String wireName = r'NavigationUpdates';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NavigationUpdates object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sections';
    yield serializers.serialize(
      object.sections,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
    if (object.cartQuantity != null) {
      yield r'cart_quantity';
      yield serializers.serialize(
        object.cartQuantity,
        specifiedType: const FullType(String),
      );
    }
    if (object.cartVersion != null) {
      yield r'cart_version';
      yield serializers.serialize(
        object.cartVersion,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NavigationUpdates object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NavigationUpdatesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.sections.replace(valueDes);
          break;
        case r'cart_quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cartQuantity = valueDes;
          break;
        case r'cart_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.cartVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NavigationUpdates deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NavigationUpdatesBuilder();
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


