//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'cancellation_remedy.g.dart';

/// CancellationRemedy
///
/// Properties:
/// * [code]
/// * [available]
/// * [note]
@BuiltValue()
abstract class CancellationRemedy implements Built<CancellationRemedy, CancellationRemedyBuilder> {
  @BuiltValueField(wireName: r'code')
  CancellationRemedyCodeEnum get code;
  // enum codeEnum {  REPORT_PROBLEM,  DISPUTE,  RETURN,  WARRANTY,  STATUTORY_REMEDIES,  };

  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'note')
  String get note;

  CancellationRemedy._();

  factory CancellationRemedy([void updates(CancellationRemedyBuilder b)]) = _$CancellationRemedy;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CancellationRemedyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CancellationRemedy> get serializer => _$CancellationRemedySerializer();
}

class _$CancellationRemedySerializer implements PrimitiveSerializer<CancellationRemedy> {
  @override
  final Iterable<Type> types = const [CancellationRemedy, _$CancellationRemedy];

  @override
  final String wireName = r'CancellationRemedy';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CancellationRemedy object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(CancellationRemedyCodeEnum),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CancellationRemedy object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CancellationRemedyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CancellationRemedyCodeEnum),
          ) as CancellationRemedyCodeEnum;
          result.code = valueDes;
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CancellationRemedy deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CancellationRemedyBuilder();
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


class CancellationRemedyCodeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REPORT_PROBLEM')
  static const CancellationRemedyCodeEnum REPORT_PROBLEM = _$cancellationRemedyCodeEnum_REPORT_PROBLEM;
  @BuiltValueEnumConst(wireName: r'DISPUTE')
  static const CancellationRemedyCodeEnum DISPUTE = _$cancellationRemedyCodeEnum_DISPUTE;
  @BuiltValueEnumConst(wireName: r'RETURN')
  static const CancellationRemedyCodeEnum RETURN = _$cancellationRemedyCodeEnum_RETURN;
  @BuiltValueEnumConst(wireName: r'WARRANTY')
  static const CancellationRemedyCodeEnum WARRANTY = _$cancellationRemedyCodeEnum_WARRANTY;
  @BuiltValueEnumConst(wireName: r'STATUTORY_REMEDIES')
  static const CancellationRemedyCodeEnum STATUTORY_REMEDIES = _$cancellationRemedyCodeEnum_STATUTORY_REMEDIES;

  static Serializer<CancellationRemedyCodeEnum> get serializer => _$cancellationRemedyCodeEnumSerializer;

  const CancellationRemedyCodeEnum._(String name): super(name);

  static BuiltSet<CancellationRemedyCodeEnum> get values => _$cancellationRemedyCodeEnumValues;
  static CancellationRemedyCodeEnum valueOf(String name) => _$cancellationRemedyCodeEnumValueOf(name);
}

