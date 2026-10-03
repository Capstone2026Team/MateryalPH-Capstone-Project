//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_compliance.g.dart';

/// ListingCompliance
///
/// Properties:
/// * [regulated]
/// * [status]
/// * [badge]
/// * [requiredMarking]
/// * [notice]
@BuiltValue()
abstract class ListingCompliance implements Built<ListingCompliance, ListingComplianceBuilder> {
  @BuiltValueField(wireName: r'regulated')
  bool get regulated;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'badge')
  ListingComplianceBadgeEnum? get badge;
  // enum badgeEnum {  PS_ICC_VERIFIED,  ,  };

  @BuiltValueField(wireName: r'required_marking')
  String? get requiredMarking;

  @BuiltValueField(wireName: r'notice')
  String get notice;

  ListingCompliance._();

  factory ListingCompliance([void updates(ListingComplianceBuilder b)]) = _$ListingCompliance;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingComplianceBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingCompliance> get serializer => _$ListingComplianceSerializer();
}

class _$ListingComplianceSerializer implements PrimitiveSerializer<ListingCompliance> {
  @override
  final Iterable<Type> types = const [ListingCompliance, _$ListingCompliance];

  @override
  final String wireName = r'ListingCompliance';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingCompliance object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'regulated';
    yield serializers.serialize(
      object.regulated,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'badge';
    yield object.badge == null ? null : serializers.serialize(
      object.badge,
      specifiedType: const FullType.nullable(ListingComplianceBadgeEnum),
    );
    yield r'required_marking';
    yield object.requiredMarking == null ? null : serializers.serialize(
      object.requiredMarking,
      specifiedType: const FullType.nullable(String),
    );
    yield r'notice';
    yield serializers.serialize(
      object.notice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingCompliance object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingComplianceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'regulated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.regulated = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'badge':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ListingComplianceBadgeEnum),
          ) as ListingComplianceBadgeEnum?;
          if (valueDes == null) continue;
          result.badge = valueDes;
          break;
        case r'required_marking':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.requiredMarking = valueDes;
          break;
        case r'notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.notice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingCompliance deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingComplianceBuilder();
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


class ListingComplianceBadgeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PS_ICC_VERIFIED')
  static const ListingComplianceBadgeEnum PS_ICC_VERIFIED = _$listingComplianceBadgeEnum_PS_ICC_VERIFIED;

  static Serializer<ListingComplianceBadgeEnum> get serializer => _$listingComplianceBadgeEnumSerializer;

  const ListingComplianceBadgeEnum._(String name): super(name);

  static BuiltSet<ListingComplianceBadgeEnum> get values => _$listingComplianceBadgeEnumValues;
  static ListingComplianceBadgeEnum valueOf(String name) => _$listingComplianceBadgeEnumValueOf(name);
}

