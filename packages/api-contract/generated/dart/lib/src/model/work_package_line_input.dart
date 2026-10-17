//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'work_package_line_input.g.dart';

/// WorkPackageLineInput
///
/// Properties:
/// * [materialId] - Canonical catalog material; omitted or null for an unlisted material the Buyer names. Unlisted lines accept any normalized unit and are always missing lines.
/// * [name]
/// * [description]
/// * [color]
/// * [unitId]
/// * [quantity] - Positive quantity within the selected normalized unit precision; maximum 1,000,000.
/// * [specifications]
/// * [preferredBrand]
@BuiltValue()
abstract class WorkPackageLineInput implements Built<WorkPackageLineInput, WorkPackageLineInputBuilder> {
  /// Canonical catalog material; omitted or null for an unlisted material the Buyer names. Unlisted lines accept any normalized unit and are always missing lines.
  @BuiltValueField(wireName: r'material_id')
  String? get materialId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'color')
  String? get color;

  @BuiltValueField(wireName: r'unit_id')
  String get unitId;

  /// Positive quantity within the selected normalized unit precision; maximum 1,000,000.
  @BuiltValueField(wireName: r'quantity')
  String get quantity;

  @BuiltValueField(wireName: r'specifications')
  BuiltMap<String, String> get specifications;

  @BuiltValueField(wireName: r'preferred_brand')
  String? get preferredBrand;

  WorkPackageLineInput._();

  factory WorkPackageLineInput([void updates(WorkPackageLineInputBuilder b)]) = _$WorkPackageLineInput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WorkPackageLineInputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WorkPackageLineInput> get serializer => _$WorkPackageLineInputSerializer();
}

class _$WorkPackageLineInputSerializer implements PrimitiveSerializer<WorkPackageLineInput> {
  @override
  final Iterable<Type> types = const [WorkPackageLineInput, _$WorkPackageLineInput];

  @override
  final String wireName = r'WorkPackageLineInput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WorkPackageLineInput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.materialId != null) {
      yield r'material_id';
      yield serializers.serialize(
        object.materialId,
        specifiedType: const FullType(String),
      );
    }
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      );
    }
    if (object.color != null) {
      yield r'color';
      yield serializers.serialize(
        object.color,
        specifiedType: const FullType(String),
      );
    }
    yield r'unit_id';
    yield serializers.serialize(
      object.unitId,
      specifiedType: const FullType(String),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(String),
    );
    yield r'specifications';
    yield serializers.serialize(
      object.specifications,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
    );
    if (object.preferredBrand != null) {
      yield r'preferred_brand';
      yield serializers.serialize(
        object.preferredBrand,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    WorkPackageLineInput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WorkPackageLineInputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'material_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.materialId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'color':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.color = valueDes;
          break;
        case r'unit_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.unitId = valueDes;
          break;
        case r'quantity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.quantity = valueDes;
          break;
        case r'specifications':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(String)]),
          ) as BuiltMap<String, String>;
          result.specifications.replace(valueDes);
          break;
        case r'preferred_brand':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.preferredBrand = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WorkPackageLineInput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WorkPackageLineInputBuilder();
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


