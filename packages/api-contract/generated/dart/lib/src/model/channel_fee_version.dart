//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'channel_fee_version.g.dart';

/// ChannelFeeVersion
///
/// Properties:
/// * [code]
/// * [displayName]
/// * [kind]
/// * [version]
/// * [ratePpm]
/// * [fixedCentavos]
/// * [feeVatBasisPoints]
/// * [rateIncludesVat]
/// * [refundSupported]
/// * [enabled]
/// * [disabledReason]
/// * [sourceType]
/// * [sourceReference]
/// * [effectiveFrom]
@BuiltValue()
abstract class ChannelFeeVersion implements Built<ChannelFeeVersion, ChannelFeeVersionBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'kind')
  String get kind;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'rate_ppm')
  int get ratePpm;

  @BuiltValueField(wireName: r'fixed_centavos')
  int get fixedCentavos;

  @BuiltValueField(wireName: r'fee_vat_basis_points')
  int get feeVatBasisPoints;

  @BuiltValueField(wireName: r'rate_includes_vat')
  bool get rateIncludesVat;

  @BuiltValueField(wireName: r'refund_supported')
  bool get refundSupported;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'disabled_reason')
  String? get disabledReason;

  @BuiltValueField(wireName: r'source_type')
  String get sourceType;

  @BuiltValueField(wireName: r'source_reference')
  String get sourceReference;

  @BuiltValueField(wireName: r'effective_from')
  DateTime? get effectiveFrom;

  ChannelFeeVersion._();

  factory ChannelFeeVersion([void updates(ChannelFeeVersionBuilder b)]) = _$ChannelFeeVersion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChannelFeeVersionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChannelFeeVersion> get serializer => _$ChannelFeeVersionSerializer();
}

class _$ChannelFeeVersionSerializer implements PrimitiveSerializer<ChannelFeeVersion> {
  @override
  final Iterable<Type> types = const [ChannelFeeVersion, _$ChannelFeeVersion];

  @override
  final String wireName = r'ChannelFeeVersion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChannelFeeVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'rate_ppm';
    yield serializers.serialize(
      object.ratePpm,
      specifiedType: const FullType(int),
    );
    yield r'fixed_centavos';
    yield serializers.serialize(
      object.fixedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'fee_vat_basis_points';
    yield serializers.serialize(
      object.feeVatBasisPoints,
      specifiedType: const FullType(int),
    );
    yield r'rate_includes_vat';
    yield serializers.serialize(
      object.rateIncludesVat,
      specifiedType: const FullType(bool),
    );
    yield r'refund_supported';
    yield serializers.serialize(
      object.refundSupported,
      specifiedType: const FullType(bool),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    if (object.disabledReason != null) {
      yield r'disabled_reason';
      yield serializers.serialize(
        object.disabledReason,
        specifiedType: const FullType(String),
      );
    }
    yield r'source_type';
    yield serializers.serialize(
      object.sourceType,
      specifiedType: const FullType(String),
    );
    yield r'source_reference';
    yield serializers.serialize(
      object.sourceReference,
      specifiedType: const FullType(String),
    );
    if (object.effectiveFrom != null) {
      yield r'effective_from';
      yield serializers.serialize(
        object.effectiveFrom,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChannelFeeVersion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChannelFeeVersionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.kind = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'rate_ppm':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ratePpm = valueDes;
          break;
        case r'fixed_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fixedCentavos = valueDes;
          break;
        case r'fee_vat_basis_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.feeVatBasisPoints = valueDes;
          break;
        case r'rate_includes_vat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.rateIncludesVat = valueDes;
          break;
        case r'refund_supported':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.refundSupported = valueDes;
          break;
        case r'enabled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.enabled = valueDes;
          break;
        case r'disabled_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.disabledReason = valueDes;
          break;
        case r'source_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceType = valueDes;
          break;
        case r'source_reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceReference = valueDes;
          break;
        case r'effective_from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.effectiveFrom = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChannelFeeVersion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChannelFeeVersionBuilder();
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


