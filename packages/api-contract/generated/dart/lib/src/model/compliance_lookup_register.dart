//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'compliance_lookup_register.g.dart';

/// ComplianceLookupRegister
///
/// Properties:
/// * [registerKind]
/// * [snapshotDate]
/// * [sourceReference]
@BuiltValue()
abstract class ComplianceLookupRegister implements Built<ComplianceLookupRegister, ComplianceLookupRegisterBuilder> {
  @BuiltValueField(wireName: r'register_kind')
  String? get registerKind;

  @BuiltValueField(wireName: r'snapshot_date')
  String? get snapshotDate;

  @BuiltValueField(wireName: r'source_reference')
  String? get sourceReference;

  ComplianceLookupRegister._();

  factory ComplianceLookupRegister([void updates(ComplianceLookupRegisterBuilder b)]) = _$ComplianceLookupRegister;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ComplianceLookupRegisterBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ComplianceLookupRegister> get serializer => _$ComplianceLookupRegisterSerializer();
}

class _$ComplianceLookupRegisterSerializer implements PrimitiveSerializer<ComplianceLookupRegister> {
  @override
  final Iterable<Type> types = const [ComplianceLookupRegister, _$ComplianceLookupRegister];

  @override
  final String wireName = r'ComplianceLookupRegister';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ComplianceLookupRegister object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'register_kind';
    yield object.registerKind == null ? null : serializers.serialize(
      object.registerKind,
      specifiedType: const FullType.nullable(String),
    );
    yield r'snapshot_date';
    yield object.snapshotDate == null ? null : serializers.serialize(
      object.snapshotDate,
      specifiedType: const FullType.nullable(String),
    );
    yield r'source_reference';
    yield object.sourceReference == null ? null : serializers.serialize(
      object.sourceReference,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ComplianceLookupRegister object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ComplianceLookupRegisterBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'register_kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.registerKind = valueDes;
          break;
        case r'snapshot_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.snapshotDate = valueDes;
          break;
        case r'source_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sourceReference = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ComplianceLookupRegister deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplianceLookupRegisterBuilder();
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


