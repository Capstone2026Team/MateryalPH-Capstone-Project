//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_navigation_updates.g.dart';

/// VendorNavigationUpdates
///
/// Properties:
/// * [sections] - Fixed Vendor sidebar paths mapped to section counts. Orders counts currently visible nonterminal orders; completed, declined, expired and cancelled orders are excluded. Team Accounts counts manageable active non-Owner memberships with active user accounts; deleted memberships and unaccepted invitations are excluded. Without current staff-management permission its count is zero. Notifications counts unread notices only; Messages counts received sales and fulfillment messages without a read receipt, restricted to the viewer current role, organization and assignment scope. Fulfillment counts visible confirmed, processing and handover-stage orders. Disputes counts active cases; Invoices counts outstanding requests and remains pending when its notice is read. Store Profile is omitted. Zero or missing counts have no indicator.
@BuiltValue()
abstract class VendorNavigationUpdates implements Built<VendorNavigationUpdates, VendorNavigationUpdatesBuilder> {
  /// Fixed Vendor sidebar paths mapped to section counts. Orders counts currently visible nonterminal orders; completed, declined, expired and cancelled orders are excluded. Team Accounts counts manageable active non-Owner memberships with active user accounts; deleted memberships and unaccepted invitations are excluded. Without current staff-management permission its count is zero. Notifications counts unread notices only; Messages counts received sales and fulfillment messages without a read receipt, restricted to the viewer current role, organization and assignment scope. Fulfillment counts visible confirmed, processing and handover-stage orders. Disputes counts active cases; Invoices counts outstanding requests and remains pending when its notice is read. Store Profile is omitted. Zero or missing counts have no indicator.
  @BuiltValueField(wireName: r'sections')
  BuiltMap<String, int> get sections;

  VendorNavigationUpdates._();

  factory VendorNavigationUpdates([void updates(VendorNavigationUpdatesBuilder b)]) = _$VendorNavigationUpdates;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorNavigationUpdatesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorNavigationUpdates> get serializer => _$VendorNavigationUpdatesSerializer();
}

class _$VendorNavigationUpdatesSerializer implements PrimitiveSerializer<VendorNavigationUpdates> {
  @override
  final Iterable<Type> types = const [VendorNavigationUpdates, _$VendorNavigationUpdates];

  @override
  final String wireName = r'VendorNavigationUpdates';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorNavigationUpdates object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sections';
    yield serializers.serialize(
      object.sections,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorNavigationUpdates object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorNavigationUpdatesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sections':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(int)]),
          ) as BuiltMap<String, int>;
          result.sections.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorNavigationUpdates deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorNavigationUpdatesBuilder();
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


