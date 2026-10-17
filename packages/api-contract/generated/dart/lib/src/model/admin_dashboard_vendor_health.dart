//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_vendor_health_segments.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_vendor_health_classes_inner.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_vendor_health_attention_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_vendor_health.g.dart';

/// scores.view. Indicator classes only; no flag, warning or sanction is created.
///
/// Properties:
/// * [total]
/// * [classes]
/// * [attention]
/// * [segments]
@BuiltValue()
abstract class AdminDashboardVendorHealth implements Built<AdminDashboardVendorHealth, AdminDashboardVendorHealthBuilder> {
  @BuiltValueField(wireName: r'total')
  int get total;

  @BuiltValueField(wireName: r'classes')
  BuiltList<AdminDashboardVendorHealthClassesInner> get classes;

  @BuiltValueField(wireName: r'attention')
  BuiltList<AdminDashboardVendorHealthAttentionInner> get attention;

  @BuiltValueField(wireName: r'segments')
  AdminDashboardVendorHealthSegments get segments;

  AdminDashboardVendorHealth._();

  factory AdminDashboardVendorHealth([void updates(AdminDashboardVendorHealthBuilder b)]) = _$AdminDashboardVendorHealth;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardVendorHealthBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardVendorHealth> get serializer => _$AdminDashboardVendorHealthSerializer();
}

class _$AdminDashboardVendorHealthSerializer implements PrimitiveSerializer<AdminDashboardVendorHealth> {
  @override
  final Iterable<Type> types = const [AdminDashboardVendorHealth, _$AdminDashboardVendorHealth];

  @override
  final String wireName = r'AdminDashboardVendorHealth';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardVendorHealth object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(int),
    );
    yield r'classes';
    yield serializers.serialize(
      object.classes,
      specifiedType: const FullType(BuiltList, [FullType(AdminDashboardVendorHealthClassesInner)]),
    );
    yield r'attention';
    yield serializers.serialize(
      object.attention,
      specifiedType: const FullType(BuiltList, [FullType(AdminDashboardVendorHealthAttentionInner)]),
    );
    yield r'segments';
    yield serializers.serialize(
      object.segments,
      specifiedType: const FullType(AdminDashboardVendorHealthSegments),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardVendorHealth object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardVendorHealthBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.total = valueDes;
          break;
        case r'classes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDashboardVendorHealthClassesInner)]),
          ) as BuiltList<AdminDashboardVendorHealthClassesInner>;
          result.classes.replace(valueDes);
          break;
        case r'attention':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDashboardVendorHealthAttentionInner)]),
          ) as BuiltList<AdminDashboardVendorHealthAttentionInner>;
          result.attention.replace(valueDes);
          break;
        case r'segments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardVendorHealthSegments),
          ) as AdminDashboardVendorHealthSegments;
          result.segments.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardVendorHealth deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardVendorHealthBuilder();
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


