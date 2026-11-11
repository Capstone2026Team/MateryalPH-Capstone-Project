//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/commission_payment_period.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'commission_payment_history.g.dart';

/// CommissionPaymentHistory
///
/// Properties:
/// * [items]
/// * [page]
/// * [perPage]
/// * [total]
/// * [hasMore]
@BuiltValue()
abstract class CommissionPaymentHistory implements Built<CommissionPaymentHistory, CommissionPaymentHistoryBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<CommissionPaymentPeriod> get items;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'per_page')
  CommissionPaymentHistoryPerPageEnum get perPage;
  // enum perPageEnum {  10,  };

  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'has_more')
  bool get hasMore;

  CommissionPaymentHistory._();

  factory CommissionPaymentHistory([void updates(CommissionPaymentHistoryBuilder b)]) = _$CommissionPaymentHistory;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CommissionPaymentHistoryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CommissionPaymentHistory> get serializer => _$CommissionPaymentHistorySerializer();
}

class _$CommissionPaymentHistorySerializer implements PrimitiveSerializer<CommissionPaymentHistory> {
  @override
  final Iterable<Type> types = const [CommissionPaymentHistory, _$CommissionPaymentHistory];

  @override
  final String wireName = r'CommissionPaymentHistory';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CommissionPaymentHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CommissionPaymentPeriod)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'per_page';
    yield serializers.serialize(
      object.perPage,
      specifiedType: const FullType(CommissionPaymentHistoryPerPageEnum),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'has_more';
    yield serializers.serialize(
      object.hasMore,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CommissionPaymentHistory object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CommissionPaymentHistoryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CommissionPaymentPeriod)]),
          ) as BuiltList<CommissionPaymentPeriod>;
          result.items.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CommissionPaymentHistoryPerPageEnum),
          ) as CommissionPaymentHistoryPerPageEnum;
          result.perPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'has_more':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hasMore = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CommissionPaymentHistory deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CommissionPaymentHistoryBuilder();
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


class CommissionPaymentHistoryPerPageEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 10)
  static const CommissionPaymentHistoryPerPageEnum number10 = _$commissionPaymentHistoryPerPageEnum_number10;

  static Serializer<CommissionPaymentHistoryPerPageEnum> get serializer => _$commissionPaymentHistoryPerPageEnumSerializer;

  const CommissionPaymentHistoryPerPageEnum._(String name): super(name);

  static BuiltSet<CommissionPaymentHistoryPerPageEnum> get values => _$commissionPaymentHistoryPerPageEnumValues;
  static CommissionPaymentHistoryPerPageEnum valueOf(String name) => _$commissionPaymentHistoryPerPageEnumValueOf(name);
}

