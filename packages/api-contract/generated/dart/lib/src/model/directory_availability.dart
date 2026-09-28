//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/provider_attribution.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_availability.g.dart';

/// DirectoryAvailability
///
/// Properties:
/// * [status]
/// * [asOf]
/// * [attribution]
/// * [coverageNote]
@BuiltValue()
abstract class DirectoryAvailability implements Built<DirectoryAvailability, DirectoryAvailabilityBuilder> {
  @BuiltValueField(wireName: r'status')
  DirectoryAvailabilityStatusEnum get status;
  // enum statusEnum {  AVAILABLE,  CACHED,  UNAVAILABLE,  NOT_CONFIGURED,  FILTERED_OUT,  HIDDEN,  };

  @BuiltValueField(wireName: r'as_of')
  DateTime? get asOf;

  @BuiltValueField(wireName: r'attribution')
  ProviderAttribution get attribution;

  @BuiltValueField(wireName: r'coverage_note')
  String get coverageNote;

  DirectoryAvailability._();

  factory DirectoryAvailability([void updates(DirectoryAvailabilityBuilder b)]) = _$DirectoryAvailability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryAvailabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryAvailability> get serializer => _$DirectoryAvailabilitySerializer();
}

class _$DirectoryAvailabilitySerializer implements PrimitiveSerializer<DirectoryAvailability> {
  @override
  final Iterable<Type> types = const [DirectoryAvailability, _$DirectoryAvailability];

  @override
  final String wireName = r'DirectoryAvailability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DirectoryAvailabilityStatusEnum),
    );
    yield r'as_of';
    yield object.asOf == null ? null : serializers.serialize(
      object.asOf,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'attribution';
    yield serializers.serialize(
      object.attribution,
      specifiedType: const FullType(ProviderAttribution),
    );
    yield r'coverage_note';
    yield serializers.serialize(
      object.coverageNote,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryAvailabilityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryAvailabilityStatusEnum),
          ) as DirectoryAvailabilityStatusEnum;
          result.status = valueDes;
          break;
        case r'as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.asOf = valueDes;
          break;
        case r'attribution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProviderAttribution),
          ) as ProviderAttribution;
          result.attribution.replace(valueDes);
          break;
        case r'coverage_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.coverageNote = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryAvailability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryAvailabilityBuilder();
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


class DirectoryAvailabilityStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const DirectoryAvailabilityStatusEnum AVAILABLE = _$directoryAvailabilityStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'CACHED')
  static const DirectoryAvailabilityStatusEnum CACHED = _$directoryAvailabilityStatusEnum_CACHED;
  @BuiltValueEnumConst(wireName: r'UNAVAILABLE')
  static const DirectoryAvailabilityStatusEnum UNAVAILABLE = _$directoryAvailabilityStatusEnum_UNAVAILABLE;
  @BuiltValueEnumConst(wireName: r'NOT_CONFIGURED')
  static const DirectoryAvailabilityStatusEnum NOT_CONFIGURED = _$directoryAvailabilityStatusEnum_NOT_CONFIGURED;
  @BuiltValueEnumConst(wireName: r'FILTERED_OUT')
  static const DirectoryAvailabilityStatusEnum FILTERED_OUT = _$directoryAvailabilityStatusEnum_FILTERED_OUT;
  @BuiltValueEnumConst(wireName: r'HIDDEN')
  static const DirectoryAvailabilityStatusEnum HIDDEN = _$directoryAvailabilityStatusEnum_HIDDEN;

  static Serializer<DirectoryAvailabilityStatusEnum> get serializer => _$directoryAvailabilityStatusEnumSerializer;

  const DirectoryAvailabilityStatusEnum._(String name): super(name);

  static BuiltSet<DirectoryAvailabilityStatusEnum> get values => _$directoryAvailabilityStatusEnumValues;
  static DirectoryAvailabilityStatusEnum valueOf(String name) => _$directoryAvailabilityStatusEnumValueOf(name);
}

