//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'audit_search_meta.g.dart';

/// AuditSearchMeta
///
/// Properties:
/// * [nextCursor]
/// * [pageSize]
/// * [canViewDetail]
/// * [canExport]
@BuiltValue()
abstract class AuditSearchMeta implements Built<AuditSearchMeta, AuditSearchMetaBuilder> {
  @BuiltValueField(wireName: r'next_cursor')
  String? get nextCursor;

  @BuiltValueField(wireName: r'page_size')
  int? get pageSize;

  @BuiltValueField(wireName: r'can_view_detail')
  bool? get canViewDetail;

  @BuiltValueField(wireName: r'can_export')
  bool? get canExport;

  AuditSearchMeta._();

  factory AuditSearchMeta([void updates(AuditSearchMetaBuilder b)]) = _$AuditSearchMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuditSearchMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuditSearchMeta> get serializer => _$AuditSearchMetaSerializer();
}

class _$AuditSearchMetaSerializer implements PrimitiveSerializer<AuditSearchMeta> {
  @override
  final Iterable<Type> types = const [AuditSearchMeta, _$AuditSearchMeta];

  @override
  final String wireName = r'AuditSearchMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuditSearchMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.nextCursor != null) {
      yield r'next_cursor';
      yield serializers.serialize(
        object.nextCursor,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.pageSize != null) {
      yield r'page_size';
      yield serializers.serialize(
        object.pageSize,
        specifiedType: const FullType(int),
      );
    }
    if (object.canViewDetail != null) {
      yield r'can_view_detail';
      yield serializers.serialize(
        object.canViewDetail,
        specifiedType: const FullType(bool),
      );
    }
    if (object.canExport != null) {
      yield r'can_export';
      yield serializers.serialize(
        object.canExport,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AuditSearchMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuditSearchMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'next_cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nextCursor = valueDes;
          break;
        case r'page_size':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.pageSize = valueDes;
          break;
        case r'can_view_detail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canViewDetail = valueDes;
          break;
        case r'can_export':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canExport = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuditSearchMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuditSearchMetaBuilder();
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


