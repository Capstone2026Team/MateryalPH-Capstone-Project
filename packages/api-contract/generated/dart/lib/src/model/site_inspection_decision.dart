//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_inspection_decision.g.dart';

/// SiteInspectionDecision
///
/// Properties:
/// * [lockVersion]
/// * [scheduledFor] - Required for schedule; must be in the future.
/// * [note] - Optional note shown to the Buyer for schedule and complete.
/// * [reason] - Required for decline.
/// * [measuredVolumeM3] - Required for complete; above zero.
@BuiltValue()
abstract class SiteInspectionDecision implements Built<SiteInspectionDecision, SiteInspectionDecisionBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  /// Required for schedule; must be in the future.
  @BuiltValueField(wireName: r'scheduled_for')
  DateTime? get scheduledFor;

  /// Optional note shown to the Buyer for schedule and complete.
  @BuiltValueField(wireName: r'note')
  String? get note;

  /// Required for decline.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  /// Required for complete; above zero.
  @BuiltValueField(wireName: r'measured_volume_m3')
  String? get measuredVolumeM3;

  SiteInspectionDecision._();

  factory SiteInspectionDecision([void updates(SiteInspectionDecisionBuilder b)]) = _$SiteInspectionDecision;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteInspectionDecisionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteInspectionDecision> get serializer => _$SiteInspectionDecisionSerializer();
}

class _$SiteInspectionDecisionSerializer implements PrimitiveSerializer<SiteInspectionDecision> {
  @override
  final Iterable<Type> types = const [SiteInspectionDecision, _$SiteInspectionDecision];

  @override
  final String wireName = r'SiteInspectionDecision';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteInspectionDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.scheduledFor != null) {
      yield r'scheduled_for';
      yield serializers.serialize(
        object.scheduledFor,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.note != null) {
      yield r'note';
      yield serializers.serialize(
        object.note,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType(String),
      );
    }
    if (object.measuredVolumeM3 != null) {
      yield r'measured_volume_m3';
      yield serializers.serialize(
        object.measuredVolumeM3,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SiteInspectionDecision object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteInspectionDecisionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'scheduled_for':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.scheduledFor = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'measured_volume_m3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.measuredVolumeM3 = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SiteInspectionDecision deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteInspectionDecisionBuilder();
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


