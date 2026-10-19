//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_arrangement_edit.g.dart';

/// ProjectArrangementEdit
///
/// Properties:
/// * [version]
/// * [vendorId]
/// * [lineId]
/// * [itemId]
/// * [variantId]
/// * [priceVersionId]
/// * [optionId]
/// * [fulfillmentMethod]
/// * [method]
/// * [remove]
/// * [replaceItem]
@BuiltValue()
abstract class ProjectArrangementEdit implements Built<ProjectArrangementEdit, ProjectArrangementEditBuilder> {
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'vendor_id')
  String? get vendorId;

  @BuiltValueField(wireName: r'line_id')
  String? get lineId;

  @BuiltValueField(wireName: r'item_id')
  String? get itemId;

  @BuiltValueField(wireName: r'variant_id')
  String? get variantId;

  @BuiltValueField(wireName: r'price_version_id')
  String? get priceVersionId;

  @BuiltValueField(wireName: r'option_id')
  String? get optionId;

  @BuiltValueField(wireName: r'fulfillment_method')
  ProjectArrangementEditFulfillmentMethodEnum? get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  DELIVERY,  PICKUP,  };

  @BuiltValueField(wireName: r'method')
  ProjectArrangementEditMethodEnum? get method;
  // enum methodEnum {  DELIVERY,  PICKUP,  };

  @BuiltValueField(wireName: r'remove')
  bool? get remove;

  @BuiltValueField(wireName: r'replace_item')
  bool? get replaceItem;

  ProjectArrangementEdit._();

  factory ProjectArrangementEdit([void updates(ProjectArrangementEditBuilder b)]) = _$ProjectArrangementEdit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectArrangementEditBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectArrangementEdit> get serializer => _$ProjectArrangementEditSerializer();
}

class _$ProjectArrangementEditSerializer implements PrimitiveSerializer<ProjectArrangementEdit> {
  @override
  final Iterable<Type> types = const [ProjectArrangementEdit, _$ProjectArrangementEdit];

  @override
  final String wireName = r'ProjectArrangementEdit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectArrangementEdit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    if (object.vendorId != null) {
      yield r'vendor_id';
      yield serializers.serialize(
        object.vendorId,
        specifiedType: const FullType(String),
      );
    }
    if (object.lineId != null) {
      yield r'line_id';
      yield serializers.serialize(
        object.lineId,
        specifiedType: const FullType(String),
      );
    }
    if (object.itemId != null) {
      yield r'item_id';
      yield serializers.serialize(
        object.itemId,
        specifiedType: const FullType(String),
      );
    }
    if (object.variantId != null) {
      yield r'variant_id';
      yield serializers.serialize(
        object.variantId,
        specifiedType: const FullType(String),
      );
    }
    if (object.priceVersionId != null) {
      yield r'price_version_id';
      yield serializers.serialize(
        object.priceVersionId,
        specifiedType: const FullType(String),
      );
    }
    if (object.optionId != null) {
      yield r'option_id';
      yield serializers.serialize(
        object.optionId,
        specifiedType: const FullType(String),
      );
    }
    if (object.fulfillmentMethod != null) {
      yield r'fulfillment_method';
      yield serializers.serialize(
        object.fulfillmentMethod,
        specifiedType: const FullType(ProjectArrangementEditFulfillmentMethodEnum),
      );
    }
    if (object.method != null) {
      yield r'method';
      yield serializers.serialize(
        object.method,
        specifiedType: const FullType(ProjectArrangementEditMethodEnum),
      );
    }
    if (object.remove != null) {
      yield r'remove';
      yield serializers.serialize(
        object.remove,
        specifiedType: const FullType(bool),
      );
    }
    if (object.replaceItem != null) {
      yield r'replace_item';
      yield serializers.serialize(
        object.replaceItem,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectArrangementEdit object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectArrangementEditBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorId = valueDes;
          break;
        case r'line_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.lineId = valueDes;
          break;
        case r'item_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.itemId = valueDes;
          break;
        case r'variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.variantId = valueDes;
          break;
        case r'price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.priceVersionId = valueDes;
          break;
        case r'option_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.optionId = valueDes;
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProjectArrangementEditFulfillmentMethodEnum),
          ) as ProjectArrangementEditFulfillmentMethodEnum?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProjectArrangementEditMethodEnum),
          ) as ProjectArrangementEditMethodEnum?;
          if (valueDes == null) continue;
          result.method = valueDes;
          break;
        case r'remove':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.remove = valueDes;
          break;
        case r'replace_item':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.replaceItem = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectArrangementEdit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectArrangementEditBuilder();
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


class ProjectArrangementEditFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ProjectArrangementEditFulfillmentMethodEnum DELIVERY = _$projectArrangementEditFulfillmentMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const ProjectArrangementEditFulfillmentMethodEnum PICKUP = _$projectArrangementEditFulfillmentMethodEnum_PICKUP;

  static Serializer<ProjectArrangementEditFulfillmentMethodEnum> get serializer => _$projectArrangementEditFulfillmentMethodEnumSerializer;

  const ProjectArrangementEditFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<ProjectArrangementEditFulfillmentMethodEnum> get values => _$projectArrangementEditFulfillmentMethodEnumValues;
  static ProjectArrangementEditFulfillmentMethodEnum valueOf(String name) => _$projectArrangementEditFulfillmentMethodEnumValueOf(name);
}

class ProjectArrangementEditMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ProjectArrangementEditMethodEnum DELIVERY = _$projectArrangementEditMethodEnum_DELIVERY;
  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const ProjectArrangementEditMethodEnum PICKUP = _$projectArrangementEditMethodEnum_PICKUP;

  static Serializer<ProjectArrangementEditMethodEnum> get serializer => _$projectArrangementEditMethodEnumSerializer;

  const ProjectArrangementEditMethodEnum._(String name): super(name);

  static BuiltSet<ProjectArrangementEditMethodEnum> get values => _$projectArrangementEditMethodEnumValues;
  static ProjectArrangementEditMethodEnum valueOf(String name) => _$projectArrangementEditMethodEnumValueOf(name);
}

