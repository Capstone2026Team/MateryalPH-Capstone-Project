//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'platform_document_ref.g.dart';

/// MateryalPH documents are always labelled not a tax invoice.
///
/// Properties:
/// * [kind]
/// * [title]
/// * [notTaxInvoice]
/// * [label]
/// * [availability]
/// * [generatedAt] - UTC generation time of the stored document.
/// * [checksum]
/// * [downloadUrl] - Authenticated API download route; null until ready or when files are not available to this role.
@BuiltValue()
abstract class PlatformDocumentRef implements Built<PlatformDocumentRef, PlatformDocumentRefBuilder> {
  @BuiltValueField(wireName: r'kind')
  PlatformDocumentRefKindEnum get kind;
  // enum kindEnum {  PURCHASE_ORDER,  };

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'not_tax_invoice')
  bool get notTaxInvoice;

  @BuiltValueField(wireName: r'label')
  PlatformDocumentRefLabelEnum get label;
  // enum labelEnum {  Not a tax invoice,  };

  @BuiltValueField(wireName: r'availability')
  String get availability;

  /// UTC generation time of the stored document.
  @BuiltValueField(wireName: r'generated_at')
  String? get generatedAt;

  @BuiltValueField(wireName: r'checksum')
  String? get checksum;

  /// Authenticated API download route; null until ready or when files are not available to this role.
  @BuiltValueField(wireName: r'download_url')
  String? get downloadUrl;

  PlatformDocumentRef._();

  factory PlatformDocumentRef([void updates(PlatformDocumentRefBuilder b)]) = _$PlatformDocumentRef;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlatformDocumentRefBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PlatformDocumentRef> get serializer => _$PlatformDocumentRefSerializer();
}

class _$PlatformDocumentRefSerializer implements PrimitiveSerializer<PlatformDocumentRef> {
  @override
  final Iterable<Type> types = const [PlatformDocumentRef, _$PlatformDocumentRef];

  @override
  final String wireName = r'PlatformDocumentRef';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlatformDocumentRef object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(PlatformDocumentRefKindEnum),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'not_tax_invoice';
    yield serializers.serialize(
      object.notTaxInvoice,
      specifiedType: const FullType(bool),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(PlatformDocumentRefLabelEnum),
    );
    yield r'availability';
    yield serializers.serialize(
      object.availability,
      specifiedType: const FullType(String),
    );
    if (object.generatedAt != null) {
      yield r'generated_at';
      yield serializers.serialize(
        object.generatedAt,
        specifiedType: const FullType(String),
      );
    }
    if (object.checksum != null) {
      yield r'checksum';
      yield serializers.serialize(
        object.checksum,
        specifiedType: const FullType(String),
      );
    }
    if (object.downloadUrl != null) {
      yield r'download_url';
      yield serializers.serialize(
        object.downloadUrl,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    PlatformDocumentRef object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlatformDocumentRefBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlatformDocumentRefKindEnum),
          ) as PlatformDocumentRefKindEnum;
          result.kind = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'not_tax_invoice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.notTaxInvoice = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlatformDocumentRefLabelEnum),
          ) as PlatformDocumentRefLabelEnum;
          result.label = valueDes;
          break;
        case r'availability':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.availability = valueDes;
          break;
        case r'generated_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.generatedAt = valueDes;
          break;
        case r'checksum':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.checksum = valueDes;
          break;
        case r'download_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.downloadUrl = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PlatformDocumentRef deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlatformDocumentRefBuilder();
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


class PlatformDocumentRefKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PURCHASE_ORDER')
  static const PlatformDocumentRefKindEnum PURCHASE_ORDER = _$platformDocumentRefKindEnum_PURCHASE_ORDER;

  static Serializer<PlatformDocumentRefKindEnum> get serializer => _$platformDocumentRefKindEnumSerializer;

  const PlatformDocumentRefKindEnum._(String name): super(name);

  static BuiltSet<PlatformDocumentRefKindEnum> get values => _$platformDocumentRefKindEnumValues;
  static PlatformDocumentRefKindEnum valueOf(String name) => _$platformDocumentRefKindEnumValueOf(name);
}

class PlatformDocumentRefLabelEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Not a tax invoice')
  static const PlatformDocumentRefLabelEnum notATaxInvoice = _$platformDocumentRefLabelEnum_notATaxInvoice;

  static Serializer<PlatformDocumentRefLabelEnum> get serializer => _$platformDocumentRefLabelEnumSerializer;

  const PlatformDocumentRefLabelEnum._(String name): super(name);

  static BuiltSet<PlatformDocumentRefLabelEnum> get values => _$platformDocumentRefLabelEnumValues;
  static PlatformDocumentRefLabelEnum valueOf(String name) => _$platformDocumentRefLabelEnumValueOf(name);
}

