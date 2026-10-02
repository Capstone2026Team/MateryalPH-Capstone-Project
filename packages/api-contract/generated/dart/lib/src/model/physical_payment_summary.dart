//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/physical_payment_record.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'physical_payment_summary.g.dart';

/// PhysicalPaymentSummary
///
/// Properties:
/// * [applicable]
/// * [method]
/// * [state]
/// * [remainingCentavos]
/// * [onlineBalanceApproved]
/// * [records]
/// * [notice]
@BuiltValue()
abstract class PhysicalPaymentSummary implements Built<PhysicalPaymentSummary, PhysicalPaymentSummaryBuilder> {
  @BuiltValueField(wireName: r'applicable')
  bool get applicable;

  @BuiltValueField(wireName: r'method')
  String get method;

  @BuiltValueField(wireName: r'state')
  String get state;

  @BuiltValueField(wireName: r'remaining_centavos')
  int? get remainingCentavos;

  @BuiltValueField(wireName: r'online_balance_approved')
  bool get onlineBalanceApproved;

  @BuiltValueField(wireName: r'records')
  BuiltList<PhysicalPaymentRecord> get records;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  PhysicalPaymentSummary._();

  factory PhysicalPaymentSummary([void updates(PhysicalPaymentSummaryBuilder b)]) = _$PhysicalPaymentSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PhysicalPaymentSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PhysicalPaymentSummary> get serializer => _$PhysicalPaymentSummarySerializer();
}

class _$PhysicalPaymentSummarySerializer implements PrimitiveSerializer<PhysicalPaymentSummary> {
  @override
  final Iterable<Type> types = const [PhysicalPaymentSummary, _$PhysicalPaymentSummary];

  @override
  final String wireName = r'PhysicalPaymentSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PhysicalPaymentSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'applicable';
    yield serializers.serialize(
      object.applicable,
      specifiedType: const FullType(bool),
    );
    yield r'method';
    yield serializers.serialize(
      object.method,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(String),
    );
    if (object.remainingCentavos != null) {
      yield r'remaining_centavos';
      yield serializers.serialize(
        object.remainingCentavos,
        specifiedType: const FullType(int),
      );
    }
    yield r'online_balance_approved';
    yield serializers.serialize(
      object.onlineBalanceApproved,
      specifiedType: const FullType(bool),
    );
    yield r'records';
    yield serializers.serialize(
      object.records,
      specifiedType: const FullType(BuiltList, [FullType(PhysicalPaymentRecord)]),
    );
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PhysicalPaymentSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PhysicalPaymentSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'applicable':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.applicable = valueDes;
          break;
        case r'method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.method = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.state = valueDes;
          break;
        case r'remaining_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.remainingCentavos = valueDes;
          break;
        case r'online_balance_approved':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.onlineBalanceApproved = valueDes;
          break;
        case r'records':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(PhysicalPaymentRecord)]),
          ) as BuiltList<PhysicalPaymentRecord>;
          result.records.replace(valueDes);
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PhysicalPaymentSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PhysicalPaymentSummaryBuilder();
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


