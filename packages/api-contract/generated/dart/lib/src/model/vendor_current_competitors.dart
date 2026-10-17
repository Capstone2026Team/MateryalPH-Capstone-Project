//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_current_competitors.g.dart';

/// VendorCurrentCompetitors
///
/// Properties:
/// * [competitorCount]
/// * [status]
/// * [label]
@BuiltValue()
abstract class VendorCurrentCompetitors implements Built<VendorCurrentCompetitors, VendorCurrentCompetitorsBuilder> {
  @BuiltValueField(wireName: r'competitor_count')
  int? get competitorCount;

  @BuiltValueField(wireName: r'status')
  VendorCurrentCompetitorsStatusEnum get status;
  // enum statusEnum {  AVAILABLE,  SUPPRESSED,  };

  @BuiltValueField(wireName: r'label')
  String? get label;

  VendorCurrentCompetitors._();

  factory VendorCurrentCompetitors([void updates(VendorCurrentCompetitorsBuilder b)]) = _$VendorCurrentCompetitors;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorCurrentCompetitorsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorCurrentCompetitors> get serializer => _$VendorCurrentCompetitorsSerializer();
}

class _$VendorCurrentCompetitorsSerializer implements PrimitiveSerializer<VendorCurrentCompetitors> {
  @override
  final Iterable<Type> types = const [VendorCurrentCompetitors, _$VendorCurrentCompetitors];

  @override
  final String wireName = r'VendorCurrentCompetitors';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorCurrentCompetitors object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.competitorCount != null) {
      yield r'competitor_count';
      yield serializers.serialize(
        object.competitorCount,
        specifiedType: const FullType(int),
      );
    }
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(VendorCurrentCompetitorsStatusEnum),
    );
    if (object.label != null) {
      yield r'label';
      yield serializers.serialize(
        object.label,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorCurrentCompetitors object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorCurrentCompetitorsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'competitor_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.competitorCount = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorCurrentCompetitorsStatusEnum),
          ) as VendorCurrentCompetitorsStatusEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorCurrentCompetitors deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorCurrentCompetitorsBuilder();
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


class VendorCurrentCompetitorsStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const VendorCurrentCompetitorsStatusEnum AVAILABLE = _$vendorCurrentCompetitorsStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'SUPPRESSED')
  static const VendorCurrentCompetitorsStatusEnum SUPPRESSED = _$vendorCurrentCompetitorsStatusEnum_SUPPRESSED;

  static Serializer<VendorCurrentCompetitorsStatusEnum> get serializer => _$vendorCurrentCompetitorsStatusEnumSerializer;

  const VendorCurrentCompetitorsStatusEnum._(String name): super(name);

  static BuiltSet<VendorCurrentCompetitorsStatusEnum> get values => _$vendorCurrentCompetitorsStatusEnumValues;
  static VendorCurrentCompetitorsStatusEnum valueOf(String name) => _$vendorCurrentCompetitorsStatusEnumValueOf(name);
}

