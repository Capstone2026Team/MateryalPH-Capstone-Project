//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'catalog_media.g.dart';

/// CatalogMedia
///
/// Properties:
/// * [id]
/// * [fileId]
/// * [altText]
/// * [status]
/// * [version]
/// * [replacesMediaId]
/// * [contentType]
/// * [byteSize]
/// * [scanState]
/// * [uploadedAt]
@BuiltValue()
abstract class CatalogMedia implements Built<CatalogMedia, CatalogMediaBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'file_id')
  String get fileId;

  @BuiltValueField(wireName: r'alt_text')
  String? get altText;

  @BuiltValueField(wireName: r'status')
  CatalogMediaStatusEnum get status;
  // enum statusEnum {  READY,  REPLACED,  REMOVED,  };

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'replaces_media_id')
  String? get replacesMediaId;

  @BuiltValueField(wireName: r'content_type')
  String get contentType;

  @BuiltValueField(wireName: r'byte_size')
  int get byteSize;

  @BuiltValueField(wireName: r'scan_state')
  String get scanState;

  @BuiltValueField(wireName: r'uploaded_at')
  String? get uploadedAt;

  CatalogMedia._();

  factory CatalogMedia([void updates(CatalogMediaBuilder b)]) = _$CatalogMedia;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CatalogMediaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CatalogMedia> get serializer => _$CatalogMediaSerializer();
}

class _$CatalogMediaSerializer implements PrimitiveSerializer<CatalogMedia> {
  @override
  final Iterable<Type> types = const [CatalogMedia, _$CatalogMedia];

  @override
  final String wireName = r'CatalogMedia';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CatalogMedia object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'file_id';
    yield serializers.serialize(
      object.fileId,
      specifiedType: const FullType(String),
    );
    if (object.altText != null) {
      yield r'alt_text';
      yield serializers.serialize(
        object.altText,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CatalogMediaStatusEnum),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    if (object.replacesMediaId != null) {
      yield r'replaces_media_id';
      yield serializers.serialize(
        object.replacesMediaId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'content_type';
    yield serializers.serialize(
      object.contentType,
      specifiedType: const FullType(String),
    );
    yield r'byte_size';
    yield serializers.serialize(
      object.byteSize,
      specifiedType: const FullType(int),
    );
    yield r'scan_state';
    yield serializers.serialize(
      object.scanState,
      specifiedType: const FullType(String),
    );
    if (object.uploadedAt != null) {
      yield r'uploaded_at';
      yield serializers.serialize(
        object.uploadedAt,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CatalogMedia object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CatalogMediaBuilder result,
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
        case r'file_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fileId = valueDes;
          break;
        case r'alt_text':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.altText = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CatalogMediaStatusEnum),
          ) as CatalogMediaStatusEnum;
          result.status = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'replaces_media_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.replacesMediaId = valueDes;
          break;
        case r'content_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.contentType = valueDes;
          break;
        case r'byte_size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.byteSize = valueDes;
          break;
        case r'scan_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.scanState = valueDes;
          break;
        case r'uploaded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.uploadedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CatalogMedia deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CatalogMediaBuilder();
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


class CatalogMediaStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'READY')
  static const CatalogMediaStatusEnum READY = _$catalogMediaStatusEnum_READY;
  @BuiltValueEnumConst(wireName: r'REPLACED')
  static const CatalogMediaStatusEnum REPLACED = _$catalogMediaStatusEnum_REPLACED;
  @BuiltValueEnumConst(wireName: r'REMOVED')
  static const CatalogMediaStatusEnum REMOVED = _$catalogMediaStatusEnum_REMOVED;

  static Serializer<CatalogMediaStatusEnum> get serializer => _$catalogMediaStatusEnumSerializer;

  const CatalogMediaStatusEnum._(String name): super(name);

  static BuiltSet<CatalogMediaStatusEnum> get values => _$catalogMediaStatusEnumValues;
  static CatalogMediaStatusEnum valueOf(String name) => _$catalogMediaStatusEnumValueOf(name);
}

