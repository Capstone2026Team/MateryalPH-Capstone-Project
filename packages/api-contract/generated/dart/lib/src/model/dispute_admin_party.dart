//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'dispute_admin_party.g.dart';

/// DisputeAdminParty
///
/// Properties:
/// * [displayName]
/// * [priorCases]
@BuiltValue()
abstract class DisputeAdminParty implements Built<DisputeAdminParty, DisputeAdminPartyBuilder> {
  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'prior_cases')
  int get priorCases;

  DisputeAdminParty._();

  factory DisputeAdminParty([void updates(DisputeAdminPartyBuilder b)]) = _$DisputeAdminParty;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisputeAdminPartyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisputeAdminParty> get serializer => _$DisputeAdminPartySerializer();
}

class _$DisputeAdminPartySerializer implements PrimitiveSerializer<DisputeAdminParty> {
  @override
  final Iterable<Type> types = const [DisputeAdminParty, _$DisputeAdminParty];

  @override
  final String wireName = r'DisputeAdminParty';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisputeAdminParty object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    yield r'prior_cases';
    yield serializers.serialize(
      object.priorCases,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisputeAdminParty object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisputeAdminPartyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'prior_cases':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.priorCases = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisputeAdminParty deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisputeAdminPartyBuilder();
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


