//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_year_limit.g.dart';

/// WithholdingYearLimit
///
/// Properties:
/// * [taxableYear]
/// * [totalCentavos]
/// * [limitCentavos]
/// * [crossed]
/// * [status]
@BuiltValue()
abstract class WithholdingYearLimit implements Built<WithholdingYearLimit, WithholdingYearLimitBuilder> {
  @BuiltValueField(wireName: r'taxable_year')
  int get taxableYear;

  @BuiltValueField(wireName: r'total_centavos')
  int get totalCentavos;

  @BuiltValueField(wireName: r'limit_centavos')
  int get limitCentavos;

  @BuiltValueField(wireName: r'crossed')
  bool get crossed;

  @BuiltValueField(wireName: r'status')
  String get status;

  WithholdingYearLimit._();

  factory WithholdingYearLimit([void updates(WithholdingYearLimitBuilder b)]) = _$WithholdingYearLimit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingYearLimitBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingYearLimit> get serializer => _$WithholdingYearLimitSerializer();
}

class _$WithholdingYearLimitSerializer implements PrimitiveSerializer<WithholdingYearLimit> {
  @override
  final Iterable<Type> types = const [WithholdingYearLimit, _$WithholdingYearLimit];

  @override
  final String wireName = r'WithholdingYearLimit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingYearLimit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'taxable_year';
    yield serializers.serialize(
      object.taxableYear,
      specifiedType: const FullType(int),
    );
    yield r'total_centavos';
    yield serializers.serialize(
      object.totalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'limit_centavos';
    yield serializers.serialize(
      object.limitCentavos,
      specifiedType: const FullType(int),
    );
    yield r'crossed';
    yield serializers.serialize(
      object.crossed,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingYearLimit object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingYearLimitBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'taxable_year':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.taxableYear = valueDes;
          break;
        case r'total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalCentavos = valueDes;
          break;
        case r'limit_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.limitCentavos = valueDes;
          break;
        case r'crossed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.crossed = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingYearLimit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingYearLimitBuilder();
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


