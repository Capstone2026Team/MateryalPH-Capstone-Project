//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'project_arrangement_submit_payments_inner.g.dart';

/// ProjectArrangementSubmitPaymentsInner
///
/// Properties:
/// * [vendorId]
/// * [paymentMethod]
@BuiltValue()
abstract class ProjectArrangementSubmitPaymentsInner implements Built<ProjectArrangementSubmitPaymentsInner, ProjectArrangementSubmitPaymentsInnerBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'payment_method')
  ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum get paymentMethod;
  // enum paymentMethodEnum {  ONLINE,  CASH_ON_DELIVERY,  IN_STORE,  };

  ProjectArrangementSubmitPaymentsInner._();

  factory ProjectArrangementSubmitPaymentsInner([void updates(ProjectArrangementSubmitPaymentsInnerBuilder b)]) = _$ProjectArrangementSubmitPaymentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ProjectArrangementSubmitPaymentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ProjectArrangementSubmitPaymentsInner> get serializer => _$ProjectArrangementSubmitPaymentsInnerSerializer();
}

class _$ProjectArrangementSubmitPaymentsInnerSerializer implements PrimitiveSerializer<ProjectArrangementSubmitPaymentsInner> {
  @override
  final Iterable<Type> types = const [ProjectArrangementSubmitPaymentsInner, _$ProjectArrangementSubmitPaymentsInner];

  @override
  final String wireName = r'ProjectArrangementSubmitPaymentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ProjectArrangementSubmitPaymentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    yield r'payment_method';
    yield serializers.serialize(
      object.paymentMethod,
      specifiedType: const FullType(ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ProjectArrangementSubmitPaymentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ProjectArrangementSubmitPaymentsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorId = valueDes;
          break;
        case r'payment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum),
          ) as ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum;
          result.paymentMethod = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ProjectArrangementSubmitPaymentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ProjectArrangementSubmitPaymentsInnerBuilder();
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


class ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ONLINE')
  static const ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum ONLINE = _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_ONLINE;
  @BuiltValueEnumConst(wireName: r'CASH_ON_DELIVERY')
  static const ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum CASH_ON_DELIVERY = _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_CASH_ON_DELIVERY;
  @BuiltValueEnumConst(wireName: r'IN_STORE')
  static const ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum IN_STORE = _$projectArrangementSubmitPaymentsInnerPaymentMethodEnum_IN_STORE;

  static Serializer<ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum> get serializer => _$projectArrangementSubmitPaymentsInnerPaymentMethodEnumSerializer;

  const ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum._(String name): super(name);

  static BuiltSet<ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum> get values => _$projectArrangementSubmitPaymentsInnerPaymentMethodEnumValues;
  static ProjectArrangementSubmitPaymentsInnerPaymentMethodEnum valueOf(String name) => _$projectArrangementSubmitPaymentsInnerPaymentMethodEnumValueOf(name);
}

