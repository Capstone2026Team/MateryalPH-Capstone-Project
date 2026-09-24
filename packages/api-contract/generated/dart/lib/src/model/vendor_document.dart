//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_document.g.dart';

/// VendorDocument
///
/// Properties:
/// * [id]
/// * [requirementKey]
/// * [version] - Zero for a pending attachment; review versions are created only on submission.
/// * [status]
/// * [scanState]
@BuiltValue()
abstract class VendorDocument implements Built<VendorDocument, VendorDocumentBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'requirement_key')
  String get requirementKey;

  /// Zero for a pending attachment; review versions are created only on submission.
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'status')
  VendorDocumentStatusEnum get status;
  // enum statusEnum {  PENDING_SUBMISSION,  };

  @BuiltValueField(wireName: r'scan_state')
  VendorDocumentScanStateEnum get scanState;
  // enum scanStateEnum {  PENDING,  CLEAN,  REJECTED,  };

  VendorDocument._();

  factory VendorDocument([void updates(VendorDocumentBuilder b)]) = _$VendorDocument;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorDocumentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorDocument> get serializer => _$VendorDocumentSerializer();
}

class _$VendorDocumentSerializer implements PrimitiveSerializer<VendorDocument> {
  @override
  final Iterable<Type> types = const [VendorDocument, _$VendorDocument];

  @override
  final String wireName = r'VendorDocument';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorDocument object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'requirement_key';
    yield serializers.serialize(
      object.requirementKey,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(VendorDocumentStatusEnum),
    );
    yield r'scan_state';
    yield serializers.serialize(
      object.scanState,
      specifiedType: const FullType(VendorDocumentScanStateEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorDocument object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorDocumentBuilder result,
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
        case r'requirement_key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requirementKey = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDocumentStatusEnum),
          ) as VendorDocumentStatusEnum;
          result.status = valueDes;
          break;
        case r'scan_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorDocumentScanStateEnum),
          ) as VendorDocumentScanStateEnum;
          result.scanState = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorDocument deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorDocumentBuilder();
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


class VendorDocumentStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING_SUBMISSION')
  static const VendorDocumentStatusEnum PENDING_SUBMISSION = _$vendorDocumentStatusEnum_PENDING_SUBMISSION;

  static Serializer<VendorDocumentStatusEnum> get serializer => _$vendorDocumentStatusEnumSerializer;

  const VendorDocumentStatusEnum._(String name): super(name);

  static BuiltSet<VendorDocumentStatusEnum> get values => _$vendorDocumentStatusEnumValues;
  static VendorDocumentStatusEnum valueOf(String name) => _$vendorDocumentStatusEnumValueOf(name);
}

class VendorDocumentScanStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const VendorDocumentScanStateEnum PENDING = _$vendorDocumentScanStateEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'CLEAN')
  static const VendorDocumentScanStateEnum CLEAN = _$vendorDocumentScanStateEnum_CLEAN;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const VendorDocumentScanStateEnum REJECTED = _$vendorDocumentScanStateEnum_REJECTED;

  static Serializer<VendorDocumentScanStateEnum> get serializer => _$vendorDocumentScanStateEnumSerializer;

  const VendorDocumentScanStateEnum._(String name): super(name);

  static BuiltSet<VendorDocumentScanStateEnum> get values => _$vendorDocumentScanStateEnumValues;
  static VendorDocumentScanStateEnum valueOf(String name) => _$vendorDocumentScanStateEnumValueOf(name);
}

