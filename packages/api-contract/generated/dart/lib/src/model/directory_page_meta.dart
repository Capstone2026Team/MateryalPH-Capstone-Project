//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_page_meta.g.dart';

/// DirectoryPageMeta
///
/// Properties:
/// * [page]
/// * [perPage]
/// * [total]
/// * [lastPage]
/// * [statusCounts] - Row counts per status under every other active filter.
/// * [canModerate] - True when the caller also holds reviews.moderate and may read hidden review text.
/// * [direction]
/// * [type]
@BuiltValue()
abstract class DirectoryPageMeta implements Built<DirectoryPageMeta, DirectoryPageMetaBuilder> {
  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'per_page')
  int get perPage;

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'last_page')
  int get lastPage;

  /// Row counts per status under every other active filter.
  @BuiltValueField(wireName: r'status_counts')
  BuiltMap<String, int>? get statusCounts;

  /// True when the caller also holds reviews.moderate and may read hidden review text.
  @BuiltValueField(wireName: r'can_moderate')
  bool? get canModerate;

  @BuiltValueField(wireName: r'direction')
  DirectoryPageMetaDirectionEnum? get direction;
  // enum directionEnum {  RECEIVED,  WRITTEN,  };

  @BuiltValueField(wireName: r'type')
  DirectoryPageMetaTypeEnum? get type;
  // enum typeEnum {  VENDOR,  PRODUCT,  };

  DirectoryPageMeta._();

  factory DirectoryPageMeta([void updates(DirectoryPageMetaBuilder b)]) = _$DirectoryPageMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryPageMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryPageMeta> get serializer => _$DirectoryPageMetaSerializer();
}

class _$DirectoryPageMetaSerializer implements PrimitiveSerializer<DirectoryPageMeta> {
  @override
  final Iterable<Type> types = const [DirectoryPageMeta, _$DirectoryPageMeta];

  @override
  final String wireName = r'DirectoryPageMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryPageMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'per_page';
    yield serializers.serialize(
      object.perPage,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'last_page';
    yield serializers.serialize(
      object.lastPage,
      specifiedType: const FullType(int),
    );
    if (object.statusCounts != null) {
      yield r'status_counts';
      yield serializers.serialize(
        object.statusCounts,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
      );
    }
    if (object.canModerate != null) {
      yield r'can_moderate';
      yield serializers.serialize(
        object.canModerate,
        specifiedType: const FullType(bool),
      );
    }
    if (object.direction != null) {
      yield r'direction';
      yield serializers.serialize(
        object.direction,
        specifiedType: const FullType(DirectoryPageMetaDirectionEnum),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(DirectoryPageMetaTypeEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryPageMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryPageMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.perPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'last_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lastPage = valueDes;
          break;
        case r'status_counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>?;
          if (valueDes == null) continue;
          result.statusCounts.replace(valueDes);
          break;
        case r'can_moderate':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canModerate = valueDes;
          break;
        case r'direction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DirectoryPageMetaDirectionEnum),
          ) as DirectoryPageMetaDirectionEnum?;
          if (valueDes == null) continue;
          result.direction = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DirectoryPageMetaTypeEnum),
          ) as DirectoryPageMetaTypeEnum?;
          if (valueDes == null) continue;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryPageMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryPageMetaBuilder();
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


class DirectoryPageMetaDirectionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'RECEIVED')
  static const DirectoryPageMetaDirectionEnum RECEIVED = _$directoryPageMetaDirectionEnum_RECEIVED;
  @BuiltValueEnumConst(wireName: r'WRITTEN')
  static const DirectoryPageMetaDirectionEnum WRITTEN = _$directoryPageMetaDirectionEnum_WRITTEN;

  static Serializer<DirectoryPageMetaDirectionEnum> get serializer => _$directoryPageMetaDirectionEnumSerializer;

  const DirectoryPageMetaDirectionEnum._(String name): super(name);

  static BuiltSet<DirectoryPageMetaDirectionEnum> get values => _$directoryPageMetaDirectionEnumValues;
  static DirectoryPageMetaDirectionEnum valueOf(String name) => _$directoryPageMetaDirectionEnumValueOf(name);
}

class DirectoryPageMetaTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const DirectoryPageMetaTypeEnum VENDOR = _$directoryPageMetaTypeEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'PRODUCT')
  static const DirectoryPageMetaTypeEnum PRODUCT = _$directoryPageMetaTypeEnum_PRODUCT;

  static Serializer<DirectoryPageMetaTypeEnum> get serializer => _$directoryPageMetaTypeEnumSerializer;

  const DirectoryPageMetaTypeEnum._(String name): super(name);

  static BuiltSet<DirectoryPageMetaTypeEnum> get values => _$directoryPageMetaTypeEnumValues;
  static DirectoryPageMetaTypeEnum valueOf(String name) => _$directoryPageMetaTypeEnumValueOf(name);
}

