//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_specification_selection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_selection_preview.g.dart';

/// ProjectSelectionPreview
///
/// Properties:
/// * [selections]
/// * [fulfillmentMethod] - Re-prices the candidate for this method. Omitted, a Vendor offering both opens on its preferred method.
@BuiltValue()
abstract class ProjectSelectionPreview implements Built<ProjectSelectionPreview, ProjectSelectionPreviewBuilder> {
  @BuiltValueField(wireName: r'selections')
  BuiltList<ProjectSpecificationSelection>? get selections;

  /// Re-prices the candidate for this method. Omitted, a Vendor offering both opens on its preferred method.
  @BuiltValueField(wireName: r'fulfillment_method')
  ProjectSelectionPreviewFulfillmentMethodEnum? get fulfillmentMethod;
  // enum fulfillmentMethodEnum {  PICKUP,  DELIVERY,  };

  ProjectSelectionPreview._();

  factory ProjectSelectionPreview([void updates(ProjectSelectionPreviewBuilder b)]) = _$ProjectSelectionPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectSelectionPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectSelectionPreview> get serializer => _$ProjectSelectionPreviewSerializer();
}

class _$ProjectSelectionPreviewSerializer implements PrimitiveSerializer<ProjectSelectionPreview> {
  @override
  final Iterable<Type> types = const [ProjectSelectionPreview, _$ProjectSelectionPreview];

  @override
  final String wireName = r'ProjectSelectionPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectSelectionPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
        specifiedType: const FullType(ProjectSelectionPreviewFulfillmentMethodEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectSelectionPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectSelectionPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
            specifiedType: const FullType.nullable(ProjectSelectionPreviewFulfillmentMethodEnum),
          ) as ProjectSelectionPreviewFulfillmentMethodEnum?;
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
  ProjectSelectionPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectSelectionPreviewBuilder();
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
class ProjectSelectionPreviewFulfillmentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PICKUP')
  static const ProjectSelectionPreviewFulfillmentMethodEnum PICKUP = _$projectSelectionPreviewFulfillmentMethodEnum_PICKUP;
  @BuiltValueEnumConst(wireName: r'DELIVERY')
  static const ProjectSelectionPreviewFulfillmentMethodEnum DELIVERY = _$projectSelectionPreviewFulfillmentMethodEnum_DELIVERY;

  static Serializer<ProjectSelectionPreviewFulfillmentMethodEnum> get serializer => _$projectSelectionPreviewFulfillmentMethodEnumSerializer;

  const ProjectSelectionPreviewFulfillmentMethodEnum._(String name): super(name);

  static BuiltSet<ProjectSelectionPreviewFulfillmentMethodEnum> get values => _$projectSelectionPreviewFulfillmentMethodEnumValues;
  static ProjectSelectionPreviewFulfillmentMethodEnum valueOf(String name) => _$projectSelectionPreviewFulfillmentMethodEnumValueOf(name);
}

