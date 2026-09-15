//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_team_member.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team.g.dart';

/// VendorTeam
///
/// Properties:
/// * [members]
/// * [page]
/// * [lastPage]
/// * [total]
@BuiltValue()
abstract class VendorTeam implements Built<VendorTeam, VendorTeamBuilder> {
  @BuiltValueField(wireName: r'members')
  BuiltList<VendorTeamMember> get members;

  @BuiltValueField(wireName: r'page')
  int get page;

  @BuiltValueField(wireName: r'last_page')
  int get lastPage;

  @BuiltValueField(wireName: r'total')
  int get total;

  VendorTeam._();

  factory VendorTeam([void updates(VendorTeamBuilder b)]) = _$VendorTeam;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeam> get serializer => _$VendorTeamSerializer();
}

class _$VendorTeamSerializer implements PrimitiveSerializer<VendorTeam> {
  @override
  final Iterable<Type> types = const [VendorTeam, _$VendorTeam];

  @override
  final String wireName = r'VendorTeam';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeam object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'members';
    yield serializers.serialize(
      object.members,
      specifiedType: const FullType(BuiltList, [FullType(VendorTeamMember)]),
    );
    yield r'page';
    yield serializers.serialize(
      object.page,
      specifiedType: const FullType(int),
    );
    yield r'last_page';
    yield serializers.serialize(
      object.lastPage,
      specifiedType: const FullType(int),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeam object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorTeamMember)]),
          ) as BuiltList<VendorTeamMember>;
          result.members.replace(valueDes);
          break;
        case r'page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.page = valueDes;
          break;
        case r'last_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lastPage = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeam deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamBuilder();
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


