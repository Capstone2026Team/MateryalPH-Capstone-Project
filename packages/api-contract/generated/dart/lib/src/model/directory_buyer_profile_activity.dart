//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_buyer_profile_activity.g.dart';

/// DirectoryBuyerProfileActivity
///
/// Properties:
/// * [ordersTotal]
/// * [ordersOpen]
/// * [ordersCompleted]
/// * [ordersCancelled] - Cancelled, declined and expired orders.
/// * [quotationsTotal]
/// * [quotationsAccepted]
/// * [projectsTotal]
/// * [workPackagesTotal]
/// * [conversationsTotal]
/// * [favoriteStores]
/// * [disputesTotal]
/// * [disputesOpen]
/// * [signIns30Days]
/// * [lastActiveAt]
@BuiltValue()
abstract class DirectoryBuyerProfileActivity implements Built<DirectoryBuyerProfileActivity, DirectoryBuyerProfileActivityBuilder> {
  @BuiltValueField(wireName: r'orders_total')
  int get ordersTotal;

  @BuiltValueField(wireName: r'orders_open')
  int get ordersOpen;

  @BuiltValueField(wireName: r'orders_completed')
  int get ordersCompleted;

  /// Cancelled, declined and expired orders.
  @BuiltValueField(wireName: r'orders_cancelled')
  int get ordersCancelled;

  @BuiltValueField(wireName: r'quotations_total')
  int get quotationsTotal;

  @BuiltValueField(wireName: r'quotations_accepted')
  int get quotationsAccepted;

  @BuiltValueField(wireName: r'projects_total')
  int get projectsTotal;

  @BuiltValueField(wireName: r'work_packages_total')
  int get workPackagesTotal;

  @BuiltValueField(wireName: r'conversations_total')
  int get conversationsTotal;

  @BuiltValueField(wireName: r'favorite_stores')
  int get favoriteStores;

  @BuiltValueField(wireName: r'disputes_total')
  int get disputesTotal;

  @BuiltValueField(wireName: r'disputes_open')
  int get disputesOpen;

  @BuiltValueField(wireName: r'sign_ins_30_days')
  int get signIns30Days;

  @BuiltValueField(wireName: r'last_active_at')
  DateTime? get lastActiveAt;

  DirectoryBuyerProfileActivity._();

  factory DirectoryBuyerProfileActivity([void updates(DirectoryBuyerProfileActivityBuilder b)]) = _$DirectoryBuyerProfileActivity;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryBuyerProfileActivityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryBuyerProfileActivity> get serializer => _$DirectoryBuyerProfileActivitySerializer();
}

class _$DirectoryBuyerProfileActivitySerializer implements PrimitiveSerializer<DirectoryBuyerProfileActivity> {
  @override
  final Iterable<Type> types = const [DirectoryBuyerProfileActivity, _$DirectoryBuyerProfileActivity];

  @override
  final String wireName = r'DirectoryBuyerProfileActivity';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryBuyerProfileActivity object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders_total';
    yield serializers.serialize(
      object.ordersTotal,
      specifiedType: const FullType(int),
    );
    yield r'orders_open';
    yield serializers.serialize(
      object.ordersOpen,
      specifiedType: const FullType(int),
    );
    yield r'orders_completed';
    yield serializers.serialize(
      object.ordersCompleted,
      specifiedType: const FullType(int),
    );
    yield r'orders_cancelled';
    yield serializers.serialize(
      object.ordersCancelled,
      specifiedType: const FullType(int),
    );
    yield r'quotations_total';
    yield serializers.serialize(
      object.quotationsTotal,
      specifiedType: const FullType(int),
    );
    yield r'quotations_accepted';
    yield serializers.serialize(
      object.quotationsAccepted,
      specifiedType: const FullType(int),
    );
    yield r'projects_total';
    yield serializers.serialize(
      object.projectsTotal,
      specifiedType: const FullType(int),
    );
    yield r'work_packages_total';
    yield serializers.serialize(
      object.workPackagesTotal,
      specifiedType: const FullType(int),
    );
    yield r'conversations_total';
    yield serializers.serialize(
      object.conversationsTotal,
      specifiedType: const FullType(int),
    );
    yield r'favorite_stores';
    yield serializers.serialize(
      object.favoriteStores,
      specifiedType: const FullType(int),
    );
    yield r'disputes_total';
    yield serializers.serialize(
      object.disputesTotal,
      specifiedType: const FullType(int),
    );
    yield r'disputes_open';
    yield serializers.serialize(
      object.disputesOpen,
      specifiedType: const FullType(int),
    );
    yield r'sign_ins_30_days';
    yield serializers.serialize(
      object.signIns30Days,
      specifiedType: const FullType(int),
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
    DirectoryBuyerProfileActivity object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryBuyerProfileActivityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ordersTotal = valueDes;
          break;
        case r'orders_open':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ordersOpen = valueDes;
          break;
        case r'orders_completed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ordersCompleted = valueDes;
          break;
        case r'orders_cancelled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ordersCancelled = valueDes;
          break;
        case r'quotations_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.quotationsTotal = valueDes;
          break;
        case r'quotations_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.quotationsAccepted = valueDes;
          break;
        case r'projects_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.projectsTotal = valueDes;
          break;
        case r'work_packages_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.workPackagesTotal = valueDes;
          break;
        case r'conversations_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.conversationsTotal = valueDes;
          break;
        case r'favorite_stores':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.favoriteStores = valueDes;
          break;
        case r'disputes_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.disputesTotal = valueDes;
          break;
        case r'disputes_open':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.disputesOpen = valueDes;
          break;
        case r'sign_ins_30_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.signIns30Days = valueDes;
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
  DirectoryBuyerProfileActivity deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryBuyerProfileActivityBuilder();
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


