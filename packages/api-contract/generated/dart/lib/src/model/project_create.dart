//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_create.g.dart';

/// ProjectCreate
///
/// Properties:
/// * [name]
/// * [budgetCentavos]
/// * [startsOn]
/// * [endsOn]
/// * [locationId]
@BuiltValue()
abstract class ProjectCreate implements Built<ProjectCreate, ProjectCreateBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'budget_centavos')
  int get budgetCentavos;

  @BuiltValueField(wireName: r'starts_on')
  String get startsOn;

  @BuiltValueField(wireName: r'ends_on')
  String get endsOn;

  @BuiltValueField(wireName: r'location_id')
  String get locationId;

  ProjectCreate._();

  factory ProjectCreate([void updates(ProjectCreateBuilder b)]) = _$ProjectCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectCreate> get serializer => _$ProjectCreateSerializer();
}

class _$ProjectCreateSerializer implements PrimitiveSerializer<ProjectCreate> {
  @override
  final Iterable<Type> types = const [ProjectCreate, _$ProjectCreate];

  @override
  final String wireName = r'ProjectCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'budget_centavos';
    yield serializers.serialize(
      object.budgetCentavos,
      specifiedType: const FullType(int),
    );
    yield r'starts_on';
    yield serializers.serialize(
      object.startsOn,
      specifiedType: const FullType(String),
    );
    yield r'ends_on';
    yield serializers.serialize(
      object.endsOn,
      specifiedType: const FullType(String),
    );
    yield r'location_id';
    yield serializers.serialize(
      object.locationId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'budget_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.budgetCentavos = valueDes;
          break;
        case r'starts_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.startsOn = valueDes;
          break;
        case r'ends_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.endsOn = valueDes;
          break;
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.locationId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectCreateBuilder();
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


