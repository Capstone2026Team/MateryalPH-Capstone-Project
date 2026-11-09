//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/withholding_year_limit.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/withholding_recorded_payment.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'withholding_vendor_detail.g.dart';

/// WithholdingVendorDetail
///
/// Properties:
/// * [vendorId]
/// * [vendorName]
/// * [month]
/// * [withholdingEntity]
/// * [declarationState]
/// * [threshold]
/// * [payments]
@BuiltValue()
abstract class WithholdingVendorDetail implements Built<WithholdingVendorDetail, WithholdingVendorDetailBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'vendor_name')
  String get vendorName;

  @BuiltValueField(wireName: r'month')
  String get month;

  @BuiltValueField(wireName: r'withholding_entity')
  String get withholdingEntity;

  @BuiltValueField(wireName: r'declaration_state')
  WithholdingVendorDetailDeclarationStateEnum get declarationState;
  // enum declarationStateEnum {  MISSING,  PENDING,  APPROVED,  REJECTED,  EXPIRED,  };

  @BuiltValueField(wireName: r'threshold')
  WithholdingYearLimit? get threshold;

  @BuiltValueField(wireName: r'payments')
  BuiltList<WithholdingRecordedPayment> get payments;

  WithholdingVendorDetail._();

  factory WithholdingVendorDetail([void updates(WithholdingVendorDetailBuilder b)]) = _$WithholdingVendorDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(WithholdingVendorDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<WithholdingVendorDetail> get serializer => _$WithholdingVendorDetailSerializer();
}

class _$WithholdingVendorDetailSerializer implements PrimitiveSerializer<WithholdingVendorDetail> {
  @override
  final Iterable<Type> types = const [WithholdingVendorDetail, _$WithholdingVendorDetail];

  @override
  final String wireName = r'WithholdingVendorDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    WithholdingVendorDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    yield r'vendor_name';
    yield serializers.serialize(
      object.vendorName,
      specifiedType: const FullType(String),
    );
    yield r'month';
    yield serializers.serialize(
      object.month,
      specifiedType: const FullType(String),
    );
    yield r'withholding_entity';
    yield serializers.serialize(
      object.withholdingEntity,
      specifiedType: const FullType(String),
    );
    yield r'declaration_state';
    yield serializers.serialize(
      object.declarationState,
      specifiedType: const FullType(WithholdingVendorDetailDeclarationStateEnum),
    );
    yield r'threshold';
    yield object.threshold == null ? null : serializers.serialize(
      object.threshold,
      specifiedType: const FullType.nullable(WithholdingYearLimit),
    );
    yield r'payments';
    yield serializers.serialize(
      object.payments,
      specifiedType: const FullType(BuiltList, [FullType(WithholdingRecordedPayment)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    WithholdingVendorDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required WithholdingVendorDetailBuilder result,
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
        case r'vendor_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorName = valueDes;
          break;
        case r'month':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.month = valueDes;
          break;
        case r'withholding_entity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.withholdingEntity = valueDes;
          break;
        case r'declaration_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(WithholdingVendorDetailDeclarationStateEnum),
          ) as WithholdingVendorDetailDeclarationStateEnum;
          result.declarationState = valueDes;
          break;
        case r'threshold':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(WithholdingYearLimit),
          ) as WithholdingYearLimit?;
          if (valueDes == null) continue;
          result.threshold.replace(valueDes);
          break;
        case r'payments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(WithholdingRecordedPayment)]),
          ) as BuiltList<WithholdingRecordedPayment>;
          result.payments.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  WithholdingVendorDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = WithholdingVendorDetailBuilder();
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


class WithholdingVendorDetailDeclarationStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'MISSING')
  static const WithholdingVendorDetailDeclarationStateEnum MISSING = _$withholdingVendorDetailDeclarationStateEnum_MISSING;
  @BuiltValueEnumConst(wireName: r'PENDING')
  static const WithholdingVendorDetailDeclarationStateEnum PENDING = _$withholdingVendorDetailDeclarationStateEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'APPROVED')
  static const WithholdingVendorDetailDeclarationStateEnum APPROVED = _$withholdingVendorDetailDeclarationStateEnum_APPROVED;
  @BuiltValueEnumConst(wireName: r'REJECTED')
  static const WithholdingVendorDetailDeclarationStateEnum REJECTED = _$withholdingVendorDetailDeclarationStateEnum_REJECTED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const WithholdingVendorDetailDeclarationStateEnum EXPIRED = _$withholdingVendorDetailDeclarationStateEnum_EXPIRED;

  static Serializer<WithholdingVendorDetailDeclarationStateEnum> get serializer => _$withholdingVendorDetailDeclarationStateEnumSerializer;

  const WithholdingVendorDetailDeclarationStateEnum._(String name): super(name);

  static BuiltSet<WithholdingVendorDetailDeclarationStateEnum> get values => _$withholdingVendorDetailDeclarationStateEnumValues;
  static WithholdingVendorDetailDeclarationStateEnum valueOf(String name) => _$withholdingVendorDetailDeclarationStateEnumValueOf(name);
}

