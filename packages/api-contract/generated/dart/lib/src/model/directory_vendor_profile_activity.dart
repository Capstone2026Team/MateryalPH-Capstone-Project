//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_vendor_profile_activity.g.dart';

/// DirectoryVendorProfileActivity
///
/// Properties:
/// * [quotesSent] - Published quotation versions.
/// * [quotesAccepted]
/// * [ordersTotal]
/// * [ordersFulfilled] - Orders in the COMPLETED state.
/// * [ordersOpen]
/// * [ordersCancelled] - Cancelled, declined and expired orders.
/// * [disputesTotal]
/// * [disputesOpen]
/// * [listingsTotal]
/// * [listingsActive]
/// * [teamMembers]
/// * [lastLoginAt]
/// * [signIns30Days]
@BuiltValue()
abstract class DirectoryVendorProfileActivity implements Built<DirectoryVendorProfileActivity, DirectoryVendorProfileActivityBuilder> {
  /// Published quotation versions.
  @BuiltValueField(wireName: r'quotes_sent')
  int get quotesSent;

  @BuiltValueField(wireName: r'quotes_accepted')
  int get quotesAccepted;

  @BuiltValueField(wireName: r'orders_total')
  int get ordersTotal;

  /// Orders in the COMPLETED state.
  @BuiltValueField(wireName: r'orders_fulfilled')
  int get ordersFulfilled;

  @BuiltValueField(wireName: r'orders_open')
  int get ordersOpen;

  /// Cancelled, declined and expired orders.
  @BuiltValueField(wireName: r'orders_cancelled')
  int get ordersCancelled;

  @BuiltValueField(wireName: r'disputes_total')
  int get disputesTotal;

  @BuiltValueField(wireName: r'disputes_open')
  int get disputesOpen;

  @BuiltValueField(wireName: r'listings_total')
  int get listingsTotal;

  @BuiltValueField(wireName: r'listings_active')
  int get listingsActive;

  @BuiltValueField(wireName: r'team_members')
  int get teamMembers;

  @BuiltValueField(wireName: r'last_login_at')
  DateTime? get lastLoginAt;

  @BuiltValueField(wireName: r'sign_ins_30_days')
  int get signIns30Days;

  DirectoryVendorProfileActivity._();

  factory DirectoryVendorProfileActivity([void updates(DirectoryVendorProfileActivityBuilder b)]) = _$DirectoryVendorProfileActivity;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryVendorProfileActivityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryVendorProfileActivity> get serializer => _$DirectoryVendorProfileActivitySerializer();
}

class _$DirectoryVendorProfileActivitySerializer implements PrimitiveSerializer<DirectoryVendorProfileActivity> {
  @override
  final Iterable<Type> types = const [DirectoryVendorProfileActivity, _$DirectoryVendorProfileActivity];

  @override
  final String wireName = r'DirectoryVendorProfileActivity';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryVendorProfileActivity object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'quotes_sent';
    yield serializers.serialize(
      object.quotesSent,
      specifiedType: const FullType(int),
    );
    yield r'quotes_accepted';
    yield serializers.serialize(
      object.quotesAccepted,
      specifiedType: const FullType(int),
    );
    yield r'orders_total';
    yield serializers.serialize(
      object.ordersTotal,
      specifiedType: const FullType(int),
    );
    yield r'orders_fulfilled';
    yield serializers.serialize(
      object.ordersFulfilled,
      specifiedType: const FullType(int),
    );
    yield r'orders_open';
    yield serializers.serialize(
      object.ordersOpen,
      specifiedType: const FullType(int),
    );
    yield r'orders_cancelled';
    yield serializers.serialize(
      object.ordersCancelled,
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
    yield r'listings_total';
    yield serializers.serialize(
      object.listingsTotal,
      specifiedType: const FullType(int),
    );
    yield r'listings_active';
    yield serializers.serialize(
      object.listingsActive,
      specifiedType: const FullType(int),
    );
    yield r'team_members';
    yield serializers.serialize(
      object.teamMembers,
      specifiedType: const FullType(int),
    );
    yield r'last_login_at';
    yield object.lastLoginAt == null ? null : serializers.serialize(
      object.lastLoginAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'sign_ins_30_days';
    yield serializers.serialize(
      object.signIns30Days,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryVendorProfileActivity object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryVendorProfileActivityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'quotes_sent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.quotesSent = valueDes;
          break;
        case r'quotes_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.quotesAccepted = valueDes;
          break;
        case r'orders_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ordersTotal = valueDes;
          break;
        case r'orders_fulfilled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ordersFulfilled = valueDes;
          break;
        case r'orders_open':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ordersOpen = valueDes;
          break;
        case r'orders_cancelled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ordersCancelled = valueDes;
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
        case r'listings_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.listingsTotal = valueDes;
          break;
        case r'listings_active':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.listingsActive = valueDes;
          break;
        case r'team_members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.teamMembers = valueDes;
          break;
        case r'last_login_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastLoginAt = valueDes;
          break;
        case r'sign_ins_30_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.signIns30Days = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryVendorProfileActivity deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryVendorProfileActivityBuilder();
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


