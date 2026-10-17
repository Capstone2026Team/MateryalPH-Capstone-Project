//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dashboard_action.g.dart';

/// Work waiting for this role; present only when the role may act on it.
///
/// Properties:
/// * [key]
/// * [label]
/// * [count]
/// * [severity]
/// * [href]
/// * [detail]
@BuiltValue()
abstract class DashboardAction implements Built<DashboardAction, DashboardActionBuilder> {
  @BuiltValueField(wireName: r'key')
  DashboardActionKeyEnum get key;
  // enum keyEnum {  ORDER_CONFIRMATION,  FULFILLMENT_OVERDUE,  FULFILLMENT_DUE_TODAY,  ASSIGNED_FULFILLMENT,  DISPUTE_RESPONSE,  OUT_OF_STOCK,  LIMITED_STOCK,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'severity')
  DashboardActionSeverityEnum get severity;
  // enum severityEnum {  ACTION,  ALERT,  };

  @BuiltValueField(wireName: r'href')
  String get href;

  @BuiltValueField(wireName: r'detail')
  String? get detail;

  DashboardAction._();

  factory DashboardAction([void updates(DashboardActionBuilder b)]) = _$DashboardAction;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DashboardActionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DashboardAction> get serializer => _$DashboardActionSerializer();
}

class _$DashboardActionSerializer implements PrimitiveSerializer<DashboardAction> {
  @override
  final Iterable<Type> types = const [DashboardAction, _$DashboardAction];

  @override
  final String wireName = r'DashboardAction';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DashboardAction object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(DashboardActionKeyEnum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'severity';
    yield serializers.serialize(
      object.severity,
      specifiedType: const FullType(DashboardActionSeverityEnum),
    );
    yield r'href';
    yield serializers.serialize(
      object.href,
      specifiedType: const FullType(String),
    );
    if (object.detail != null) {
      yield r'detail';
      yield serializers.serialize(
        object.detail,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DashboardAction object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DashboardActionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardActionKeyEnum),
          ) as DashboardActionKeyEnum;
          result.key = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.count = valueDes;
          break;
        case r'severity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DashboardActionSeverityEnum),
          ) as DashboardActionSeverityEnum;
          result.severity = valueDes;
          break;
        case r'href':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.href = valueDes;
          break;
        case r'detail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.detail = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DashboardAction deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DashboardActionBuilder();
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


class DashboardActionKeyEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ORDER_CONFIRMATION')
  static const DashboardActionKeyEnum ORDER_CONFIRMATION = _$dashboardActionKeyEnum_ORDER_CONFIRMATION;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT_OVERDUE')
  static const DashboardActionKeyEnum FULFILLMENT_OVERDUE = _$dashboardActionKeyEnum_FULFILLMENT_OVERDUE;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT_DUE_TODAY')
  static const DashboardActionKeyEnum FULFILLMENT_DUE_TODAY = _$dashboardActionKeyEnum_FULFILLMENT_DUE_TODAY;
  @BuiltValueEnumConst(wireName: r'ASSIGNED_FULFILLMENT')
  static const DashboardActionKeyEnum ASSIGNED_FULFILLMENT = _$dashboardActionKeyEnum_ASSIGNED_FULFILLMENT;
  @BuiltValueEnumConst(wireName: r'DISPUTE_RESPONSE')
  static const DashboardActionKeyEnum DISPUTE_RESPONSE = _$dashboardActionKeyEnum_DISPUTE_RESPONSE;
  @BuiltValueEnumConst(wireName: r'OUT_OF_STOCK')
  static const DashboardActionKeyEnum OUT_OF_STOCK = _$dashboardActionKeyEnum_OUT_OF_STOCK;
  @BuiltValueEnumConst(wireName: r'LIMITED_STOCK')
  static const DashboardActionKeyEnum LIMITED_STOCK = _$dashboardActionKeyEnum_LIMITED_STOCK;

  static Serializer<DashboardActionKeyEnum> get serializer => _$dashboardActionKeyEnumSerializer;

  const DashboardActionKeyEnum._(String name): super(name);

  static BuiltSet<DashboardActionKeyEnum> get values => _$dashboardActionKeyEnumValues;
  static DashboardActionKeyEnum valueOf(String name) => _$dashboardActionKeyEnumValueOf(name);
}

class DashboardActionSeverityEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTION')
  static const DashboardActionSeverityEnum ACTION = _$dashboardActionSeverityEnum_ACTION;
  @BuiltValueEnumConst(wireName: r'ALERT')
  static const DashboardActionSeverityEnum ALERT = _$dashboardActionSeverityEnum_ALERT;

  static Serializer<DashboardActionSeverityEnum> get serializer => _$dashboardActionSeverityEnumSerializer;

  const DashboardActionSeverityEnum._(String name): super(name);

  static BuiltSet<DashboardActionSeverityEnum> get values => _$dashboardActionSeverityEnumValues;
  static DashboardActionSeverityEnum valueOf(String name) => _$dashboardActionSeverityEnumValueOf(name);
}

