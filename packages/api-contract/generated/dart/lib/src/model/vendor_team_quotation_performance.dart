//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_quotation_performance.g.dart';

/// VendorTeamQuotationPerformance
///
/// Properties:
/// * [drafts]
/// * [published]
/// * [accepted]
@BuiltValue()
abstract class VendorTeamQuotationPerformance implements Built<VendorTeamQuotationPerformance, VendorTeamQuotationPerformanceBuilder> {
  @BuiltValueField(wireName: r'drafts')
  int get drafts;

  @BuiltValueField(wireName: r'published')
  int get published;

  @BuiltValueField(wireName: r'accepted')
  int get accepted;

  VendorTeamQuotationPerformance._();

  factory VendorTeamQuotationPerformance([void updates(VendorTeamQuotationPerformanceBuilder b)]) = _$VendorTeamQuotationPerformance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamQuotationPerformanceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamQuotationPerformance> get serializer => _$VendorTeamQuotationPerformanceSerializer();
}

class _$VendorTeamQuotationPerformanceSerializer implements PrimitiveSerializer<VendorTeamQuotationPerformance> {
  @override
  final Iterable<Type> types = const [VendorTeamQuotationPerformance, _$VendorTeamQuotationPerformance];

  @override
  final String wireName = r'VendorTeamQuotationPerformance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamQuotationPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'drafts';
    yield serializers.serialize(
      object.drafts,
      specifiedType: const FullType(int),
    );
    yield r'published';
    yield serializers.serialize(
      object.published,
      specifiedType: const FullType(int),
    );
    yield r'accepted';
    yield serializers.serialize(
      object.accepted,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamQuotationPerformance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamQuotationPerformanceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'drafts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.drafts = valueDes;
          break;
        case r'published':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.published = valueDes;
          break;
        case r'accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.accepted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamQuotationPerformance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamQuotationPerformanceBuilder();
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


