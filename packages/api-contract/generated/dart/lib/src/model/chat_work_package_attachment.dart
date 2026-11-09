//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'chat_work_package_attachment.g.dart';

/// ChatWorkPackageAttachment
///
/// Properties:
/// * [inquiryId] - Private quotation linkage used by the attachment action, not a separate user-facing chat subject.
/// * [orderId]
/// * [orderLockVersion]
/// * [reference] - Vendor-scoped read projection of the locked Work Package. Only this store's assigned quantities or its order snapshot items are included; other suppliers' materials and the package-wide budget are excluded. material_scope is VENDOR_ALLOCATION or VENDOR_ORDER; work_package contains the scoped lines and fulfillment details. order, when present, identifies the order and whether its terms were accepted. Source version/hash identify the retained complete original, not a hash of the filtered projection.
/// * [canPrepareQuotation] - Authorized Vendor may prepare the quotation directly from this attachment. Accepted orders cannot be replaced.
@BuiltValue()
abstract class ChatWorkPackageAttachment implements Built<ChatWorkPackageAttachment, ChatWorkPackageAttachmentBuilder> {
  /// Private quotation linkage used by the attachment action, not a separate user-facing chat subject.
  @BuiltValueField(wireName: r'inquiry_id')
  String? get inquiryId;

  @BuiltValueField(wireName: r'order_id')
  String? get orderId;

  @BuiltValueField(wireName: r'order_lock_version')
  int? get orderLockVersion;

  /// Vendor-scoped read projection of the locked Work Package. Only this store's assigned quantities or its order snapshot items are included; other suppliers' materials and the package-wide budget are excluded. material_scope is VENDOR_ALLOCATION or VENDOR_ORDER; work_package contains the scoped lines and fulfillment details. order, when present, identifies the order and whether its terms were accepted. Source version/hash identify the retained complete original, not a hash of the filtered projection.
  @BuiltValueField(wireName: r'reference')
  BuiltMap<String, JsonObject?> get reference;

  /// Authorized Vendor may prepare the quotation directly from this attachment. Accepted orders cannot be replaced.
  @BuiltValueField(wireName: r'can_prepare_quotation')
  bool get canPrepareQuotation;

  ChatWorkPackageAttachment._();

  factory ChatWorkPackageAttachment([void updates(ChatWorkPackageAttachmentBuilder b)]) = _$ChatWorkPackageAttachment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChatWorkPackageAttachmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChatWorkPackageAttachment> get serializer => _$ChatWorkPackageAttachmentSerializer();
}

class _$ChatWorkPackageAttachmentSerializer implements PrimitiveSerializer<ChatWorkPackageAttachment> {
  @override
  final Iterable<Type> types = const [ChatWorkPackageAttachment, _$ChatWorkPackageAttachment];

  @override
  final String wireName = r'ChatWorkPackageAttachment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChatWorkPackageAttachment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.inquiryId != null) {
      yield r'inquiry_id';
      yield serializers.serialize(
        object.inquiryId,
        specifiedType: const FullType(String),
      );
    }
    if (object.orderId != null) {
      yield r'order_id';
      yield serializers.serialize(
        object.orderId,
        specifiedType: const FullType(String),
      );
    }
    if (object.orderLockVersion != null) {
      yield r'order_lock_version';
      yield serializers.serialize(
        object.orderLockVersion,
        specifiedType: const FullType(int),
      );
    }
    yield r'reference';
    yield serializers.serialize(
      object.reference,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'can_prepare_quotation';
    yield serializers.serialize(
      object.canPrepareQuotation,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ChatWorkPackageAttachment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChatWorkPackageAttachmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'inquiry_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.inquiryId = valueDes;
          break;
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.orderId = valueDes;
          break;
        case r'order_lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.orderLockVersion = valueDes;
          break;
        case r'reference':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.reference.replace(valueDes);
          break;
        case r'can_prepare_quotation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canPrepareQuotation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ChatWorkPackageAttachment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatWorkPackageAttachmentBuilder();
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


