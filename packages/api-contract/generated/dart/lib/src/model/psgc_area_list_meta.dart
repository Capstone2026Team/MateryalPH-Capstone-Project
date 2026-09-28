//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'psgc_area_list_meta.g.dart';

/// PsgcAreaListMeta
///
/// Properties:
/// * [correlationId]
/// * [psgcVersion]
/// * [page]
/// * [hasMore]
/// * [status]
@BuiltValue()
abstract class PsgcAreaListMeta implements Built<PsgcAreaListMeta, PsgcAreaListMetaBuilder> {
  @BuiltValueField(wireName: r'correlation_id')
  String? get correlationId;

  @BuiltValueField(wireName: r'psgc_version')
  String? get psgcVersion;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  @BuiltValueField(wireName: r'status')
  PsgcAreaListMetaStatusEnum get status;
  // enum statusEnum {  AVAILABLE,  NO_ACTIVE_PSGC_VERSION,  PARENT_UNKNOWN,  };

  PsgcAreaListMeta._();

  factory PsgcAreaListMeta([void updates(PsgcAreaListMetaBuilder b)]) = _$PsgcAreaListMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PsgcAreaListMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PsgcAreaListMeta> get serializer => _$PsgcAreaListMetaSerializer();
}

class _$PsgcAreaListMetaSerializer implements PrimitiveSerializer<PsgcAreaListMeta> {
  @override
  final Iterable<Type> types = const [PsgcAreaListMeta, _$PsgcAreaListMeta];

  @override
  final String wireName = r'PsgcAreaListMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PsgcAreaListMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.correlationId != null) {
      yield r'correlation_id';
      yield serializers.serialize(
        object.correlationId,
        specifiedType: const FullType(String),
      );
    }
    yield r'psgc_version';
    yield object.psgcVersion == null ? null : serializers.serialize(
      object.psgcVersion,
      specifiedType: const FullType.nullable(String),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PsgcAreaListMetaStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PsgcAreaListMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PsgcAreaListMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'correlation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.correlationId = valueDes;
          break;
        case r'psgc_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.psgcVersion = valueDes;
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PsgcAreaListMetaStatusEnum),
          ) as PsgcAreaListMetaStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PsgcAreaListMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PsgcAreaListMetaBuilder();
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


class PsgcAreaListMetaStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const PsgcAreaListMetaStatusEnum AVAILABLE = _$psgcAreaListMetaStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'NO_ACTIVE_PSGC_VERSION')
  static const PsgcAreaListMetaStatusEnum NO_ACTIVE_PSGC_VERSION = _$psgcAreaListMetaStatusEnum_NO_ACTIVE_PSGC_VERSION;
  @BuiltValueEnumConst(wireName: r'PARENT_UNKNOWN')
  static const PsgcAreaListMetaStatusEnum PARENT_UNKNOWN = _$psgcAreaListMetaStatusEnum_PARENT_UNKNOWN;

  static Serializer<PsgcAreaListMetaStatusEnum> get serializer => _$psgcAreaListMetaStatusEnumSerializer;

  const PsgcAreaListMetaStatusEnum._(String name): super(name);

  static BuiltSet<PsgcAreaListMetaStatusEnum> get values => _$psgcAreaListMetaStatusEnumValues;
  static PsgcAreaListMetaStatusEnum valueOf(String name) => _$psgcAreaListMetaStatusEnumValueOf(name);
}

