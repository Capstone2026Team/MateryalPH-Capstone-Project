//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_analytics_point.g.dart';

/// Below three competing Vendors every value and count is null; the sub-threshold count is never returned.
///
/// Properties:
/// * [date]
/// * [status]
/// * [label]
/// * [averagePhp] - Competitor equal-Vendor mean excluding your organization
/// * [competitorCount]
/// * [participantsChanged]
@BuiltValue()
abstract class VendorAnalyticsPoint implements Built<VendorAnalyticsPoint, VendorAnalyticsPointBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'status')
  VendorAnalyticsPointStatusEnum get status;
  // enum statusEnum {  OK,  SUPPRESSED,  MISSING_DAY,  };

  @BuiltValueField(wireName: r'label')
  String? get label;

  /// Competitor equal-Vendor mean excluding your organization
  @BuiltValueField(wireName: r'average_php')
  String? get averagePhp;

  @BuiltValueField(wireName: r'competitor_count')
  int? get competitorCount;

  @BuiltValueField(wireName: r'participants_changed')
  bool? get participantsChanged;

  VendorAnalyticsPoint._();

  factory VendorAnalyticsPoint([void updates(VendorAnalyticsPointBuilder b)]) = _$VendorAnalyticsPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorAnalyticsPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorAnalyticsPoint> get serializer => _$VendorAnalyticsPointSerializer();
}

class _$VendorAnalyticsPointSerializer implements PrimitiveSerializer<VendorAnalyticsPoint> {
  @override
  final Iterable<Type> types = const [VendorAnalyticsPoint, _$VendorAnalyticsPoint];

  @override
  final String wireName = r'VendorAnalyticsPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorAnalyticsPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'date';
    yield serializers.serialize(
      object.date,
      specifiedType: const FullType(Date),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(VendorAnalyticsPointStatusEnum),
    );
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType(String),
      );
    }
    if (object.averagePhp != null) {
      yield r'average_php';
      yield serializers.serialize(
        object.averagePhp,
        specifiedType: const FullType(String),
      );
    }
    if (object.competitorCount != null) {
      yield r'competitor_count';
      yield serializers.serialize(
        object.competitorCount,
        specifiedType: const FullType(int),
      );
    }
    if (object.participantsChanged != null) {
      yield r'participants_changed';
      yield serializers.serialize(
        object.participantsChanged,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorAnalyticsPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorAnalyticsPointBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.date = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorAnalyticsPointStatusEnum),
          ) as VendorAnalyticsPointStatusEnum;
          result.status = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'average_php':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.averagePhp = valueDes;
          break;
        case r'competitor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.competitorCount = valueDes;
          break;
        case r'participants_changed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.participantsChanged = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorAnalyticsPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorAnalyticsPointBuilder();
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


class VendorAnalyticsPointStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OK')
  static const VendorAnalyticsPointStatusEnum OK = _$vendorAnalyticsPointStatusEnum_OK;
  @BuiltValueEnumConst(wireName: r'SUPPRESSED')
  static const VendorAnalyticsPointStatusEnum SUPPRESSED = _$vendorAnalyticsPointStatusEnum_SUPPRESSED;
  @BuiltValueEnumConst(wireName: r'MISSING_DAY')
  static const VendorAnalyticsPointStatusEnum MISSING_DAY = _$vendorAnalyticsPointStatusEnum_MISSING_DAY;

  static Serializer<VendorAnalyticsPointStatusEnum> get serializer => _$vendorAnalyticsPointStatusEnumSerializer;

  const VendorAnalyticsPointStatusEnum._(String name): super(name);

  static BuiltSet<VendorAnalyticsPointStatusEnum> get values => _$vendorAnalyticsPointStatusEnumValues;
  static VendorAnalyticsPointStatusEnum valueOf(String name) => _$vendorAnalyticsPointStatusEnumValueOf(name);
}

