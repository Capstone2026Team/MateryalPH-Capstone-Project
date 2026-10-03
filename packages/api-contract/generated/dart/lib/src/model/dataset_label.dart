//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dataset_label.g.dart';

/// DatasetLabel
///
/// Properties:
/// * [kind]
/// * [label] - DEMO — Simulated Marketplace Data for TEST datasets.
@BuiltValue()
abstract class DatasetLabel implements Built<DatasetLabel, DatasetLabelBuilder> {
  @BuiltValueField(wireName: r'kind')
  DatasetLabelKindEnum get kind;
  // enum kindEnum {  TEST,  LIVE,  };

  /// DEMO — Simulated Marketplace Data for TEST datasets.
  @BuiltValueField(wireName: r'label')
  String? get label;

  DatasetLabel._();

  factory DatasetLabel([void updates(DatasetLabelBuilder b)]) = _$DatasetLabel;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DatasetLabelBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DatasetLabel> get serializer => _$DatasetLabelSerializer();
}

class _$DatasetLabelSerializer implements PrimitiveSerializer<DatasetLabel> {
  @override
  final Iterable<Type> types = const [DatasetLabel, _$DatasetLabel];

  @override
  final String wireName = r'DatasetLabel';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DatasetLabel object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(DatasetLabelKindEnum),
    );
    yield r'label';
    yield object.label == null ? null : serializers.serialize(
      object.label,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DatasetLabel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DatasetLabelBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DatasetLabelKindEnum),
          ) as DatasetLabelKindEnum;
          result.kind = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DatasetLabel deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DatasetLabelBuilder();
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


class DatasetLabelKindEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const DatasetLabelKindEnum TEST = _$datasetLabelKindEnum_TEST;
  @BuiltValueEnumConst(wireName: r'LIVE')
  static const DatasetLabelKindEnum LIVE = _$datasetLabelKindEnum_LIVE;

  static Serializer<DatasetLabelKindEnum> get serializer => _$datasetLabelKindEnumSerializer;

  const DatasetLabelKindEnum._(String name): super(name);

  static BuiltSet<DatasetLabelKindEnum> get values => _$datasetLabelKindEnumValues;
  static DatasetLabelKindEnum valueOf(String name) => _$datasetLabelKindEnumValueOf(name);
}

