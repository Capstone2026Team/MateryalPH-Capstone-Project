//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'listing_status_change.g.dart';

/// ListingStatusChange
///
/// Properties:
/// * [fromStatus]
/// * [toStatus]
/// * [source_]
/// * [reasonCode]
/// * [reason]
/// * [publicationVersion]
/// * [createdAt]
@BuiltValue()
abstract class ListingStatusChange implements Built<ListingStatusChange, ListingStatusChangeBuilder> {
  @BuiltValueField(wireName: r'from_status')
  String? get fromStatus;

  @BuiltValueField(wireName: r'to_status')
  String get toStatus;

  @BuiltValueField(wireName: r'source')
  String get source_;

  @BuiltValueField(wireName: r'reason_code')
  String? get reasonCode;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'publication_version')
  int? get publicationVersion;

  @BuiltValueField(wireName: r'created_at')
  String? get createdAt;

  ListingStatusChange._();

  factory ListingStatusChange([void updates(ListingStatusChangeBuilder b)]) = _$ListingStatusChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ListingStatusChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ListingStatusChange> get serializer => _$ListingStatusChangeSerializer();
}

class _$ListingStatusChangeSerializer implements PrimitiveSerializer<ListingStatusChange> {
  @override
  final Iterable<Type> types = const [ListingStatusChange, _$ListingStatusChange];

  @override
  final String wireName = r'ListingStatusChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ListingStatusChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.fromStatus != null) {
      yield r'from_status';
      yield serializers.serialize(
        object.fromStatus,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'to_status';
    yield serializers.serialize(
      object.toStatus,
      specifiedType: const FullType(String),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(String),
    );
    if (object.reasonCode != null) {
      yield r'reason_code';
      yield serializers.serialize(
        object.reasonCode,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.publicationVersion != null) {
      yield r'publication_version';
      yield serializers.serialize(
        object.publicationVersion,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ListingStatusChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ListingStatusChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fromStatus = valueDes;
          break;
        case r'to_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.toStatus = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.source_ = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reasonCode = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'publication_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.publicationVersion = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ListingStatusChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ListingStatusChangeBuilder();
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


