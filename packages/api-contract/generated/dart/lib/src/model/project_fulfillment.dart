//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/project_fulfillment_line.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/project_separate_purchase.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_fulfillment.g.dart';

/// How much of the Work Package this quotation covers, derived on every read from the Work Package lines, this Vendor's priced lines and the Item-Based purchases tagged to the lines. The Vendor card, quotation, order summary and missing-item list all read this one result. A separate purchase closes a gap only when its product satisfies the line's brand and specifications; `complete` on the candidate remains the Vendor's own ability and drives ranking.
///
/// Properties:
/// * [status]
/// * [linesTotal]
/// * [linesFulfilled]
/// * [linesPartial]
/// * [linesUnfulfilled]
/// * [vendorLinesFulfilled] - Lines this Vendor supplies in full by itself.
/// * [lines]
/// * [separateItems]
/// * [separateTotalCentavos]
/// * [combinedTotalCentavos] - Projected total (materials when delivery is under review) plus the separate purchases.
@BuiltValue()
abstract class ProjectFulfillment implements Built<ProjectFulfillment, ProjectFulfillmentBuilder> {
  @BuiltValueField(wireName: r'status')
  ProjectFulfillmentStatusEnum get status;
  // enum statusEnum {  COMPLETE,  PARTIAL,  NONE,  };

  @BuiltValueField(wireName: r'lines_total')
  int get linesTotal;

  @BuiltValueField(wireName: r'lines_fulfilled')
  int get linesFulfilled;

  @BuiltValueField(wireName: r'lines_partial')
  int get linesPartial;

  @BuiltValueField(wireName: r'lines_unfulfilled')
  int get linesUnfulfilled;

  /// Lines this Vendor supplies in full by itself.
  @BuiltValueField(wireName: r'vendor_lines_fulfilled')
  int get vendorLinesFulfilled;

  @BuiltValueField(wireName: r'lines')
  BuiltList<ProjectFulfillmentLine> get lines;

  @BuiltValueField(wireName: r'separate_items')
  BuiltList<ProjectSeparatePurchase> get separateItems;

  @BuiltValueField(wireName: r'separate_total_centavos')
  int get separateTotalCentavos;

  /// Projected total (materials when delivery is under review) plus the separate purchases.
  @BuiltValueField(wireName: r'combined_total_centavos')
  int get combinedTotalCentavos;

  ProjectFulfillment._();

  factory ProjectFulfillment([void updates(ProjectFulfillmentBuilder b)]) = _$ProjectFulfillment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectFulfillmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectFulfillment> get serializer => _$ProjectFulfillmentSerializer();
}

class _$ProjectFulfillmentSerializer implements PrimitiveSerializer<ProjectFulfillment> {
  @override
  final Iterable<Type> types = const [ProjectFulfillment, _$ProjectFulfillment];

  @override
  final String wireName = r'ProjectFulfillment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectFulfillment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ProjectFulfillmentStatusEnum),
    );
    yield r'lines_total';
    yield serializers.serialize(
      object.linesTotal,
      specifiedType: const FullType(int),
    );
    yield r'lines_fulfilled';
    yield serializers.serialize(
      object.linesFulfilled,
      specifiedType: const FullType(int),
    );
    yield r'lines_partial';
    yield serializers.serialize(
      object.linesPartial,
      specifiedType: const FullType(int),
    );
    yield r'lines_unfulfilled';
    yield serializers.serialize(
      object.linesUnfulfilled,
      specifiedType: const FullType(int),
    );
    yield r'vendor_lines_fulfilled';
    yield serializers.serialize(
      object.vendorLinesFulfilled,
      specifiedType: const FullType(int),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [FullType(ProjectFulfillmentLine)]),
    );
    yield r'separate_items';
    yield serializers.serialize(
      object.separateItems,
      specifiedType: const FullType(BuiltList, [FullType(ProjectSeparatePurchase)]),
    );
    yield r'separate_total_centavos';
    yield serializers.serialize(
      object.separateTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'combined_total_centavos';
    yield serializers.serialize(
      object.combinedTotalCentavos,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectFulfillment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectFulfillmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectFulfillmentStatusEnum),
          ) as ProjectFulfillmentStatusEnum;
          result.status = valueDes;
          break;
        case r'lines_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.linesTotal = valueDes;
          break;
        case r'lines_fulfilled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.linesFulfilled = valueDes;
          break;
        case r'lines_partial':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.linesPartial = valueDes;
          break;
        case r'lines_unfulfilled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.linesUnfulfilled = valueDes;
          break;
        case r'vendor_lines_fulfilled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorLinesFulfilled = valueDes;
          break;
        case r'lines':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProjectFulfillmentLine)]),
          ) as BuiltList<ProjectFulfillmentLine>;
          result.lines.replace(valueDes);
          break;
        case r'separate_items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ProjectSeparatePurchase)]),
          ) as BuiltList<ProjectSeparatePurchase>;
          result.separateItems.replace(valueDes);
          break;
        case r'separate_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.separateTotalCentavos = valueDes;
          break;
        case r'combined_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.combinedTotalCentavos = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectFulfillment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectFulfillmentBuilder();
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


class ProjectFulfillmentStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'COMPLETE')
  static const ProjectFulfillmentStatusEnum COMPLETE = _$projectFulfillmentStatusEnum_COMPLETE;
  @BuiltValueEnumConst(wireName: r'PARTIAL')
  static const ProjectFulfillmentStatusEnum PARTIAL = _$projectFulfillmentStatusEnum_PARTIAL;
  @BuiltValueEnumConst(wireName: r'NONE')
  static const ProjectFulfillmentStatusEnum NONE = _$projectFulfillmentStatusEnum_NONE;

  static Serializer<ProjectFulfillmentStatusEnum> get serializer => _$projectFulfillmentStatusEnumSerializer;

  const ProjectFulfillmentStatusEnum._(String name): super(name);

  static BuiltSet<ProjectFulfillmentStatusEnum> get values => _$projectFulfillmentStatusEnumValues;
  static ProjectFulfillmentStatusEnum valueOf(String name) => _$projectFulfillmentStatusEnumValueOf(name);
}

