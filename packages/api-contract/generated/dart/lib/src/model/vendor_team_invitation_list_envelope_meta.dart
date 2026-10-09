//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_invitation_list_envelope_meta.g.dart';

/// VendorTeamInvitationListEnvelopeMeta
///
/// Properties:
/// * [currentPage]
/// * [lastPage]
@BuiltValue()
abstract class VendorTeamInvitationListEnvelopeMeta implements Built<VendorTeamInvitationListEnvelopeMeta, VendorTeamInvitationListEnvelopeMetaBuilder> {
  @BuiltValueField(wireName: r'current_page')
  int get currentPage;

  @BuiltValueField(wireName: r'last_page')
  int get lastPage;

  VendorTeamInvitationListEnvelopeMeta._();

  factory VendorTeamInvitationListEnvelopeMeta([void updates(VendorTeamInvitationListEnvelopeMetaBuilder b)]) = _$VendorTeamInvitationListEnvelopeMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamInvitationListEnvelopeMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamInvitationListEnvelopeMeta> get serializer => _$VendorTeamInvitationListEnvelopeMetaSerializer();
}

class _$VendorTeamInvitationListEnvelopeMetaSerializer implements PrimitiveSerializer<VendorTeamInvitationListEnvelopeMeta> {
  @override
  final Iterable<Type> types = const [VendorTeamInvitationListEnvelopeMeta, _$VendorTeamInvitationListEnvelopeMeta];

  @override
  final String wireName = r'VendorTeamInvitationListEnvelopeMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamInvitationListEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'current_page';
    yield serializers.serialize(
      object.currentPage,
      specifiedType: const FullType(int),
    );
    yield r'last_page';
    yield serializers.serialize(
      object.lastPage,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamInvitationListEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamInvitationListEnvelopeMetaBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'current_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.currentPage = valueDes;
          break;
        case r'last_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lastPage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamInvitationListEnvelopeMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamInvitationListEnvelopeMetaBuilder();
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


