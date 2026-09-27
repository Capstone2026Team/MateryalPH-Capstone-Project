//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_activity_envelope_meta.g.dart';

/// VendorTeamActivityEnvelopeMeta
///
/// Properties:
/// * [currentPage]
/// * [lastPage]
@BuiltValue()
abstract class VendorTeamActivityEnvelopeMeta implements Built<VendorTeamActivityEnvelopeMeta, VendorTeamActivityEnvelopeMetaBuilder> {
  @BuiltValueField(wireName: r'current_page')
  int get currentPage;

  @BuiltValueField(wireName: r'last_page')
  int get lastPage;

  VendorTeamActivityEnvelopeMeta._();

  factory VendorTeamActivityEnvelopeMeta([void updates(VendorTeamActivityEnvelopeMetaBuilder b)]) = _$VendorTeamActivityEnvelopeMeta;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamActivityEnvelopeMetaBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamActivityEnvelopeMeta> get serializer => _$VendorTeamActivityEnvelopeMetaSerializer();
}

class _$VendorTeamActivityEnvelopeMetaSerializer implements PrimitiveSerializer<VendorTeamActivityEnvelopeMeta> {
  @override
  final Iterable<Type> types = const [VendorTeamActivityEnvelopeMeta, _$VendorTeamActivityEnvelopeMeta];

  @override
  final String wireName = r'VendorTeamActivityEnvelopeMeta';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamActivityEnvelopeMeta object, {
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
    VendorTeamActivityEnvelopeMeta object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamActivityEnvelopeMetaBuilder result,
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
  VendorTeamActivityEnvelopeMeta deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamActivityEnvelopeMetaBuilder();
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


