//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_vendor_health_attention_inner.g.dart';

/// AdminDashboardVendorHealthAttentionInner
///
/// Properties:
/// * [vendorId]
/// * [storeName]
/// * [class_]
/// * [label]
/// * [vps]
/// * [ohs]
/// * [reasons]
@BuiltValue()
abstract class AdminDashboardVendorHealthAttentionInner implements Built<AdminDashboardVendorHealthAttentionInner, AdminDashboardVendorHealthAttentionInnerBuilder> {
  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'class')
  AdminDashboardVendorHealthAttentionInnerClass_Enum get class_;
  // enum class_Enum {  BELOW_WATCH_LEVEL,  WATCH,  };

  @BuiltValueField(wireName: r'label')
  String get label;

  @BuiltValueField(wireName: r'vps')
  String? get vps;

  @BuiltValueField(wireName: r'ohs')
  String? get ohs;

  @BuiltValueField(wireName: r'reasons')
  BuiltList<String> get reasons;

  AdminDashboardVendorHealthAttentionInner._();

  factory AdminDashboardVendorHealthAttentionInner([void updates(AdminDashboardVendorHealthAttentionInnerBuilder b)]) = _$AdminDashboardVendorHealthAttentionInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardVendorHealthAttentionInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardVendorHealthAttentionInner> get serializer => _$AdminDashboardVendorHealthAttentionInnerSerializer();
}

class _$AdminDashboardVendorHealthAttentionInnerSerializer implements PrimitiveSerializer<AdminDashboardVendorHealthAttentionInner> {
  @override
  final Iterable<Type> types = const [AdminDashboardVendorHealthAttentionInner, _$AdminDashboardVendorHealthAttentionInner];

  @override
  final String wireName = r'AdminDashboardVendorHealthAttentionInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardVendorHealthAttentionInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    yield r'store_name';
    yield serializers.serialize(
      object.storeName,
      specifiedType: const FullType(String),
    );
    yield r'class';
    yield serializers.serialize(
      object.class_,
      specifiedType: const FullType(AdminDashboardVendorHealthAttentionInnerClass_Enum),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    if (object.vps != null) {
      yield r'vps';
      yield serializers.serialize(
        object.vps,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.ohs != null) {
      yield r'ohs';
      yield serializers.serialize(
        object.ohs,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardVendorHealthAttentionInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminDashboardVendorHealthAttentionInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorId = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storeName = valueDes;
          break;
        case r'class':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminDashboardVendorHealthAttentionInnerClass_Enum),
          ) as AdminDashboardVendorHealthAttentionInnerClass_Enum;
          result.class_ = valueDes;
          break;
        case r'label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.label = valueDes;
          break;
        case r'vps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vps = valueDes;
          break;
        case r'ohs':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ohs = valueDes;
          break;
        case r'reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.reasons.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardVendorHealthAttentionInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardVendorHealthAttentionInnerBuilder();
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


class AdminDashboardVendorHealthAttentionInnerClass_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BELOW_WATCH_LEVEL')
  static const AdminDashboardVendorHealthAttentionInnerClass_Enum BELOW_WATCH_LEVEL = _$adminDashboardVendorHealthAttentionInnerClassEnum_BELOW_WATCH_LEVEL;
  @BuiltValueEnumConst(wireName: r'WATCH')
  static const AdminDashboardVendorHealthAttentionInnerClass_Enum WATCH = _$adminDashboardVendorHealthAttentionInnerClassEnum_WATCH;

  static Serializer<AdminDashboardVendorHealthAttentionInnerClass_Enum> get serializer => _$adminDashboardVendorHealthAttentionInnerClassEnumSerializer;

  const AdminDashboardVendorHealthAttentionInnerClass_Enum._(String name): super(name);

  static BuiltSet<AdminDashboardVendorHealthAttentionInnerClass_Enum> get values => _$adminDashboardVendorHealthAttentionInnerClassEnumValues;
  static AdminDashboardVendorHealthAttentionInnerClass_Enum valueOf(String name) => _$adminDashboardVendorHealthAttentionInnerClassEnumValueOf(name);
}

