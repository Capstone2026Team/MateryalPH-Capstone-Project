//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_vendor_health_segments_segments_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_vendor_health_segments.g.dart';

/// AdminDashboardVendorHealthSegments
///
/// Properties:
/// * [state]
/// * [reason]
/// * [considered]
/// * [features]
/// * [k]
/// * [silhouette]
/// * [segments]
@BuiltValue()
abstract class AdminDashboardVendorHealthSegments implements Built<AdminDashboardVendorHealthSegments, AdminDashboardVendorHealthSegmentsBuilder> {
  @BuiltValueField(wireName: r'state')
  AdminDashboardVendorHealthSegmentsStateEnum get state;
  // enum stateEnum {  OK,  INSUFFICIENT_DATA,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'considered')
  int get considered;

  @BuiltValueField(wireName: r'features')
  BuiltList<String> get features;

  @BuiltValueField(wireName: r'k')
  int? get k;

  @BuiltValueField(wireName: r'silhouette')
  num? get silhouette;

  @BuiltValueField(wireName: r'segments')
  BuiltList<AdminDashboardVendorHealthSegmentsSegmentsInner> get segments;

  AdminDashboardVendorHealthSegments._();

  factory AdminDashboardVendorHealthSegments([void updates(AdminDashboardVendorHealthSegmentsBuilder b)]) = _$AdminDashboardVendorHealthSegments;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardVendorHealthSegmentsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardVendorHealthSegments> get serializer => _$AdminDashboardVendorHealthSegmentsSerializer();
}

class _$AdminDashboardVendorHealthSegmentsSerializer implements PrimitiveSerializer<AdminDashboardVendorHealthSegments> {
  @override
  final Iterable<Type> types = const [AdminDashboardVendorHealthSegments, _$AdminDashboardVendorHealthSegments];

  @override
  final String wireName = r'AdminDashboardVendorHealthSegments';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardVendorHealthSegments object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(AdminDashboardVendorHealthSegmentsStateEnum),
    );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'considered';
    yield serializers.serialize(
      object.considered,
      specifiedType: const FullType(int),
    );
    yield r'features';
    yield serializers.serialize(
      object.features,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.k != null) {
      yield r'k';
      yield serializers.serialize(
        object.k,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.silhouette != null) {
      yield r'silhouette';
      yield serializers.serialize(
        object.silhouette,
        specifiedType: const FullType.nullable(num),
      );
    }
    yield r'segments';
    yield serializers.serialize(
      object.segments,
      specifiedType: const FullType(BuiltList, [FullType(AdminDashboardVendorHealthSegmentsSegmentsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardVendorHealthSegments object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardVendorHealthSegmentsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardVendorHealthSegmentsStateEnum),
          ) as AdminDashboardVendorHealthSegmentsStateEnum;
          result.state = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'considered':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.considered = valueDes;
          break;
        case r'features':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.features.replace(valueDes);
          break;
        case r'k':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.k = valueDes;
          break;
        case r'silhouette':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.silhouette = valueDes;
          break;
        case r'segments':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminDashboardVendorHealthSegmentsSegmentsInner)]),
          ) as BuiltList<AdminDashboardVendorHealthSegmentsSegmentsInner>;
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
  AdminDashboardVendorHealthSegments deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardVendorHealthSegmentsBuilder();
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


class AdminDashboardVendorHealthSegmentsStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OK')
  static const AdminDashboardVendorHealthSegmentsStateEnum OK = _$adminDashboardVendorHealthSegmentsStateEnum_OK;
  @BuiltValueEnumConst(wireName: r'INSUFFICIENT_DATA')
  static const AdminDashboardVendorHealthSegmentsStateEnum INSUFFICIENT_DATA = _$adminDashboardVendorHealthSegmentsStateEnum_INSUFFICIENT_DATA;

  static Serializer<AdminDashboardVendorHealthSegmentsStateEnum> get serializer => _$adminDashboardVendorHealthSegmentsStateEnumSerializer;

  const AdminDashboardVendorHealthSegmentsStateEnum._(String name): super(name);

  static BuiltSet<AdminDashboardVendorHealthSegmentsStateEnum> get values => _$adminDashboardVendorHealthSegmentsStateEnumValues;
  static AdminDashboardVendorHealthSegmentsStateEnum valueOf(String name) => _$adminDashboardVendorHealthSegmentsStateEnumValueOf(name);
}

