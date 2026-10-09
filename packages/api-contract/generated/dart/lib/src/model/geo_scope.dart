//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/geo_scope_psgc_version.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/geo_breadcrumb.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'geo_scope.g.dart';

/// GeoScope
///
/// Properties:
/// * [code]
/// * [name]
/// * [level]
/// * [levelLabel]
/// * [label]
/// * [breadcrumbs]
/// * [childrenLabel]
/// * [drillable]
/// * [psgcVersion]
@BuiltValue()
abstract class GeoScope implements Built<GeoScope, GeoScopeBuilder> {
  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'level')
  String? get level;

  @BuiltValueField(wireName: r'level_label')
  String get levelLabel;

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'breadcrumbs')
  BuiltList<GeoBreadcrumb> get breadcrumbs;

  @BuiltValueField(wireName: r'children_label')
  String get childrenLabel;

  @BuiltValueField(wireName: r'drillable')
  bool get drillable;

  @BuiltValueField(wireName: r'psgc_version')
  GeoScopePsgcVersion? get psgcVersion;

  GeoScope._();

  factory GeoScope([void updates(GeoScopeBuilder b)]) = _$GeoScope;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GeoScopeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GeoScope> get serializer => _$GeoScopeSerializer();
}

class _$GeoScopeSerializer implements PrimitiveSerializer<GeoScope> {
  @override
  final Iterable<Type> types = const [GeoScope, _$GeoScope];

  @override
  final String wireName = r'GeoScope';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GeoScope object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.level != null) {
      yield r'level';
      yield serializers.serialize(
        object.level,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'level_label';
    yield serializers.serialize(
      object.levelLabel,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'breadcrumbs';
    yield serializers.serialize(
      object.breadcrumbs,
      specifiedType: const FullType(BuiltList, [FullType(GeoBreadcrumb)]),
    );
    yield r'children_label';
    yield serializers.serialize(
      object.childrenLabel,
      specifiedType: const FullType(String),
    );
    yield r'drillable';
    yield serializers.serialize(
      object.drillable,
      specifiedType: const FullType(bool),
    );
    if (object.psgcVersion != null) {
      yield r'psgc_version';
      yield serializers.serialize(
        object.psgcVersion,
        specifiedType: const FullType.nullable(GeoScopePsgcVersion),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GeoScope object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GeoScopeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'level':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.level = valueDes;
          break;
        case r'level_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.levelLabel = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'breadcrumbs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GeoBreadcrumb)]),
          ) as BuiltList<GeoBreadcrumb>;
          result.breadcrumbs.replace(valueDes);
          break;
        case r'children_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.childrenLabel = valueDes;
          break;
        case r'drillable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.drillable = valueDes;
          break;
        case r'psgc_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(GeoScopePsgcVersion),
          ) as GeoScopePsgcVersion?;
          if (valueDes == null) continue;
          result.psgcVersion.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GeoScope deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GeoScopeBuilder();
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


