//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_specification_selection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_draft_item_input.g.dart';

/// ProjectDraftItemInput
///
/// Properties:
/// * [lockVersion]
/// * [priceVersionId]
/// * [selections]
/// * [fulfillmentMethod] - Re-prices the candidate for this method. Omitted, a Vendor offering both opens on its preferred method.
@BuiltValue()
abstract class ProjectDraftItemInput implements Built<ProjectDraftItemInput, ProjectDraftItemInputBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'price_version_id')
  String get priceVersionId;

  @BuiltValueField(wireName: r'selections')
  BuiltList<ProjectSpecificationSelection>? get selections;

  /// Re-prices the candidate for this method. Omitted, a Vendor offering both opens on its preferred method.
  @BuiltValueField(wireName: r'fulfillment_method')
  ProjectDraftItemInputFulfillmentMethodEnum? get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  PICKUP,  DELIVERY,  };

  ProjectDraftItemInput._();

  factory ProjectDraftItemInput([void updates(ProjectDraftItemInputBuilder b)]) = _$ProjectDraftItemInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectDraftItemInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectDraftItemInput> get serializer => _$ProjectDraftItemInputSerializer();
}

class _$ProjectDraftItemInputSerializer implements PrimitiveSerializer<ProjectDraftItemInput> {
  @override
  final Iterable<Type> types = const [ProjectDraftItemInput, _$ProjectDraftItemInput];

  @override
  final String wireName = r'ProjectDraftItemInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectDraftItemInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'price_version_id';
    yield serializers.serialize(
      object.priceVersionId,
      specifiedType: const FullType(String),
    );
    if (object.selections != null) {
      yield r'selections';
      yield serializers.serialize(
        object.selections,
        specifiedType: const FullType(BuiltList, [FullType(ProjectSpecificationSelection)]),
      );
    }
    if (object.fulfillmentMethod != null) {
      yield r'fulfillment_method';
      yield serializers.serialize(
        object.fulfillmentMethod,
        specifiedType: const FullType(ProjectDraftItemInputFulfillmentMethodEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectDraftItemInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectDraftItemInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'price_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.priceVersionId = valueDes;
          break;
        case r'selections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(ProjectSpecificationSelection)]),
          ) as BuiltList<ProjectSpecificationSelection>?;
          if (valueDes == null) continue;
          result.selections.replace(valueDes);
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ProjectDraftItemInputFulfillmentMethodEnum),
          ) as ProjectDraftItemInputFulfillmentMethodEnum?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectDraftItemInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectDraftItemInputBuilder();
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


/// Re-prices the candidate for this method. Omitted, a Vendor offering both opens on its preferred method.
class ProjectDraftItemInputFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const ProjectDraftItemInputFulfillmentMethodEnum PICKUP = _$projectDraftItemInputFulfillmentMethodEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ProjectDraftItemInputFulfillmentMethodEnum DELIVERY = _$projectDraftItemInputFulfillmentMethodEnum_DELIVERY;

  static Serializer<ProjectDraftItemInputFulfillmentMethodEnum> get serializer => _$projectDraftItemInputFulfillmentMethodEnumSerializer;

  const ProjectDraftItemInputFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<ProjectDraftItemInputFulfillmentMethodEnum> get values => _$projectDraftItemInputFulfillmentMethodEnumValues;
  static ProjectDraftItemInputFulfillmentMethodEnum valueOf(String name) => _$projectDraftItemInputFulfillmentMethodEnumValueOf(name);
}

