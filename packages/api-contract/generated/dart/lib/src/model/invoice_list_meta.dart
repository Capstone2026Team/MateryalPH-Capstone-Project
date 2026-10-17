//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invoice_list_meta.g.dart';

/// InvoiceListMeta
///
/// Properties:
/// * [view]
/// * [counts]
/// * [page]
/// * [perPage]
/// * [total]
/// * [hasMore]
/// * [canUpload]
/// * [issuanceNotice]
/// * [notice]
@BuiltValue()
abstract class InvoiceListMeta implements Built<InvoiceListMeta, InvoiceListMetaBuilder> {
  @BuiltValueField(wireName: r'view')
  String? get view;

  @BuiltValueField(wireName: r'counts')
  BuiltMap<String, int>? get counts;

  @BuiltValueField(wireName: r'page')
  int? get page;

  @BuiltValueField(wireName: r'per_page')
  int? get perPage;

  @BuiltValueField(wireName: r'total')
  int? get total;

  @BuiltValueField(wireName: r'has_more')
  bool? get hasMore;

  @BuiltValueField(wireName: r'can_upload')
  bool? get canUpload;

  @BuiltValueField(wireName: r'issuance_notice')
  String? get issuanceNotice;

  @BuiltValueField(wireName: r'notice')
  String? get notice;

  InvoiceListMeta._();

  factory InvoiceListMeta([void updates(InvoiceListMetaBuilder b)]) = _$InvoiceListMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InvoiceListMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InvoiceListMeta> get serializer => _$InvoiceListMetaSerializer();
}

class _$InvoiceListMetaSerializer implements PrimitiveSerializer<InvoiceListMeta> {
  @override
  final Iterable<Type> types = const [InvoiceListMeta, _$InvoiceListMeta];

  @override
  final String wireName = r'InvoiceListMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InvoiceListMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.view != null) {
      yield r'view';
      yield serializers.serialize(
        object.view,
        specifiedType: const FullType(String),
      );
    }
    if (object.counts != null) {
      yield r'counts';
      yield serializers.serialize(
        object.counts,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
      );
    }
    if (object.page != null) {
      yield r'page';
      yield serializers.serialize(
        object.page,
        specifiedType: const FullType(int),
      );
    }
    if (object.perPage != null) {
      yield r'per_page';
      yield serializers.serialize(
        object.perPage,
        specifiedType: const FullType(int),
      );
    }
    if (object.total != null) {
      yield r'total';
      yield serializers.serialize(
        object.total,
        specifiedType: const FullType(int),
      );
    }
    if (object.hasMore != null) {
      yield r'has_more';
      yield serializers.serialize(
        object.hasMore,
        specifiedType: const FullType(bool),
      );
    }
    if (object.canUpload != null) {
      yield r'can_upload';
      yield serializers.serialize(
        object.canUpload,
        specifiedType: const FullType(bool),
      );
    }
    if (object.issuanceNotice != null) {
      yield r'issuance_notice';
      yield serializers.serialize(
        object.issuanceNotice,
        specifiedType: const FullType(String),
      );
    }
    if (object.notice != null) {
      yield r'notice';
      yield serializers.serialize(
        object.notice,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InvoiceListMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InvoiceListMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'view':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.view = valueDes;
          break;
        case r'counts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>?;
          if (valueDes == null) continue;
          result.counts.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.page = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.perPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.total = valueDes;
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.hasMore = valueDes;
          break;
        case r'can_upload':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canUpload = valueDes;
          break;
        case r'issuance_notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.issuanceNotice = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InvoiceListMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InvoiceListMetaBuilder();
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


