//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_analytics_point.g.dart';

/// AdminAnalyticsPoint
///
/// Properties:
/// * [date]
/// * [status]
/// * [label]
/// * [averagePhp]
/// * [averagePhpExact]
/// * [vendorCount]
/// * [participantsChanged]
@BuiltValue()
abstract class AdminAnalyticsPoint implements Built<AdminAnalyticsPoint, AdminAnalyticsPointBuilder> {
  @BuiltValueField(wireName: r'date')
  Date get date;

  @BuiltValueField(wireName: r'status')
  AdminAnalyticsPointStatusEnum get status;
  // enum statusEnum {  OK,  LIMITED_DATA,  NO_LOCAL_OBSERVATIONS,  SUPPRESSED,  MISSING_DAY,  };

  @BuiltValueField(wireName: r'label')
  String? get label;

  @BuiltValueField(wireName: r'average_php')
  String? get averagePhp;

  @BuiltValueField(wireName: r'average_php_exact')
  String? get averagePhpExact;

  @BuiltValueField(wireName: r'vendor_count')
  int? get vendorCount;

  @BuiltValueField(wireName: r'participants_changed')
  bool? get participantsChanged;

  AdminAnalyticsPoint._();

  factory AdminAnalyticsPoint([void updates(AdminAnalyticsPointBuilder b)]) = _$AdminAnalyticsPoint;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAnalyticsPointBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAnalyticsPoint> get serializer => _$AdminAnalyticsPointSerializer();
}

class _$AdminAnalyticsPointSerializer implements PrimitiveSerializer<AdminAnalyticsPoint> {
  @override
  final Iterable<Type> types = const [AdminAnalyticsPoint, _$AdminAnalyticsPoint];

  @override
  final String wireName = r'AdminAnalyticsPoint';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAnalyticsPoint object, {
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
      specifiedType: const FullType(AdminAnalyticsPointStatusEnum),
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
    if (object.averagePhpExact != null) {
      yield r'average_php_exact';
      yield serializers.serialize(
        object.averagePhpExact,
        specifiedType: const FullType(String),
      );
    }
    if (object.vendorCount != null) {
      yield r'vendor_count';
      yield serializers.serialize(
        object.vendorCount,
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
    AdminAnalyticsPoint object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminAnalyticsPointBuilder result,
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
            specifiedType: const FullType(AdminAnalyticsPointStatusEnum),
          ) as AdminAnalyticsPointStatusEnum;
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
        case r'average_php_exact':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.averagePhpExact = valueDes;
          break;
        case r'vendor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.vendorCount = valueDes;
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
  AdminAnalyticsPoint deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAnalyticsPointBuilder();
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


class AdminAnalyticsPointStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OK')
  static const AdminAnalyticsPointStatusEnum OK = _$adminAnalyticsPointStatusEnum_OK;
  @BuiltValueEnumConst(wireName: r'LIMITED_DATA')
  static const AdminAnalyticsPointStatusEnum LIMITED_DATA = _$adminAnalyticsPointStatusEnum_LIMITED_DATA;
  @BuiltValueEnumConst(wireName: r'NO_LOCAL_OBSERVATIONS')
  static const AdminAnalyticsPointStatusEnum NO_LOCAL_OBSERVATIONS = _$adminAnalyticsPointStatusEnum_NO_LOCAL_OBSERVATIONS;
  @BuiltValueEnumConst(wireName: r'SUPPRESSED')
  static const AdminAnalyticsPointStatusEnum SUPPRESSED = _$adminAnalyticsPointStatusEnum_SUPPRESSED;
  @BuiltValueEnumConst(wireName: r'MISSING_DAY')
  static const AdminAnalyticsPointStatusEnum MISSING_DAY = _$adminAnalyticsPointStatusEnum_MISSING_DAY;

  static Serializer<AdminAnalyticsPointStatusEnum> get serializer => _$adminAnalyticsPointStatusEnumSerializer;

  const AdminAnalyticsPointStatusEnum._(String name): super(name);

  static BuiltSet<AdminAnalyticsPointStatusEnum> get values => _$adminAnalyticsPointStatusEnumValues;
  static AdminAnalyticsPointStatusEnum valueOf(String name) => _$adminAnalyticsPointStatusEnumValueOf(name);
}

