//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_buyer_row.g.dart';

/// DirectoryBuyerRow
///
/// Properties:
/// * [id]
/// * [name]
/// * [email] - Masked for a self-deleted Buyer.
/// * [status]
/// * [buyerType]
/// * [companyName]
/// * [joinedAt]
/// * [lastActiveAt]
@BuiltValue()
abstract class DirectoryBuyerRow implements Built<DirectoryBuyerRow, DirectoryBuyerRowBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Masked for a self-deleted Buyer.
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'status')
  DirectoryBuyerRowStatusEnum get status;
  // enum statusEnum {  ACTIVE,  PENDING_VERIFICATION,  SUSPENDED,  DEACTIVATED,  DELETED,  };

  @BuiltValueField(wireName: r'buyer_type')
  DirectoryBuyerRowBuyerTypeEnum get buyerType;
  // enum buyerTypeEnum {  INDIVIDUAL,  BUSINESS,  };

  @BuiltValueField(wireName: r'company_name')
  String? get companyName;

  @BuiltValueField(wireName: r'joined_at')
  DateTime get joinedAt;

  @BuiltValueField(wireName: r'last_active_at')
  DateTime? get lastActiveAt;

  DirectoryBuyerRow._();

  factory DirectoryBuyerRow([void updates(DirectoryBuyerRowBuilder b)]) = _$DirectoryBuyerRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryBuyerRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryBuyerRow> get serializer => _$DirectoryBuyerRowSerializer();
}

class _$DirectoryBuyerRowSerializer implements PrimitiveSerializer<DirectoryBuyerRow> {
  @override
  final Iterable<Type> types = const [DirectoryBuyerRow, _$DirectoryBuyerRow];

  @override
  final String wireName = r'DirectoryBuyerRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryBuyerRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DirectoryBuyerRowStatusEnum),
    );
    yield r'buyer_type';
    yield serializers.serialize(
      object.buyerType,
      specifiedType: const FullType(DirectoryBuyerRowBuyerTypeEnum),
    );
    yield r'company_name';
    yield object.companyName == null ? null : serializers.serialize(
      object.companyName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'joined_at';
    yield serializers.serialize(
      object.joinedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'last_active_at';
    yield object.lastActiveAt == null ? null : serializers.serialize(
      object.lastActiveAt,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryBuyerRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryBuyerRowBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryBuyerRowStatusEnum),
          ) as DirectoryBuyerRowStatusEnum;
          result.status = valueDes;
          break;
        case r'buyer_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryBuyerRowBuyerTypeEnum),
          ) as DirectoryBuyerRowBuyerTypeEnum;
          result.buyerType = valueDes;
          break;
        case r'company_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companyName = valueDes;
          break;
        case r'joined_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.joinedAt = valueDes;
          break;
        case r'last_active_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastActiveAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryBuyerRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryBuyerRowBuilder();
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


class DirectoryBuyerRowStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const DirectoryBuyerRowStatusEnum ACTIVE = _$directoryBuyerRowStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const DirectoryBuyerRowStatusEnum PENDING_VERIFICATION = _$directoryBuyerRowStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const DirectoryBuyerRowStatusEnum SUSPENDED = _$directoryBuyerRowStatusEnum_SUSPENDED;
  @BuiltValueEnumConst(wireName: r'DEACTIVATED')
  static const DirectoryBuyerRowStatusEnum DEACTIVATED = _$directoryBuyerRowStatusEnum_DEACTIVATED;
  @BuiltValueEnumConst(wireName: r'DELETED')
  static const DirectoryBuyerRowStatusEnum DELETED = _$directoryBuyerRowStatusEnum_DELETED;

  static Serializer<DirectoryBuyerRowStatusEnum> get serializer => _$directoryBuyerRowStatusEnumSerializer;

  const DirectoryBuyerRowStatusEnum._(String name): super(name);

  static BuiltSet<DirectoryBuyerRowStatusEnum> get values => _$directoryBuyerRowStatusEnumValues;
  static DirectoryBuyerRowStatusEnum valueOf(String name) => _$directoryBuyerRowStatusEnumValueOf(name);
}

class DirectoryBuyerRowBuyerTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'INDIVIDUAL')
  static const DirectoryBuyerRowBuyerTypeEnum INDIVIDUAL = _$directoryBuyerRowBuyerTypeEnum_INDIVIDUAL;
  @BuiltValueEnumConst(wireName: r'BUSINESS')
  static const DirectoryBuyerRowBuyerTypeEnum BUSINESS = _$directoryBuyerRowBuyerTypeEnum_BUSINESS;

  static Serializer<DirectoryBuyerRowBuyerTypeEnum> get serializer => _$directoryBuyerRowBuyerTypeEnumSerializer;

  const DirectoryBuyerRowBuyerTypeEnum._(String name): super(name);

  static BuiltSet<DirectoryBuyerRowBuyerTypeEnum> get values => _$directoryBuyerRowBuyerTypeEnumValues;
  static DirectoryBuyerRowBuyerTypeEnum valueOf(String name) => _$directoryBuyerRowBuyerTypeEnumValueOf(name);
}

