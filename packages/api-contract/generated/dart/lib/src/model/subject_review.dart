//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'subject_review.g.dart';

/// Account-review facts only: no contact details, coordinates, documents or payment data.
///
/// Properties:
/// * [subjectType]
/// * [subjectId]
/// * [displayName]
/// * [maskedEmail]
/// * [accountStatus]
/// * [storeActivationStatus]
/// * [openOrders]
/// * [ordersTotal]
/// * [disputesTotal]
/// * [disputesOpen]
/// * [commerceRestrictedUntil]
@BuiltValue(instantiable: false)
abstract class SubjectReview  {
  @BuiltValueField(wireName: r'subject_type')
  String? get subjectType;

  @BuiltValueField(wireName: r'subject_id')
  String? get subjectId;

  @BuiltValueField(wireName: r'display_name')
  String? get displayName;

  @BuiltValueField(wireName: r'masked_email')
  String? get maskedEmail;

  @BuiltValueField(wireName: r'account_status')
  String? get accountStatus;

  @BuiltValueField(wireName: r'store_activation_status')
  String? get storeActivationStatus;

  @BuiltValueField(wireName: r'open_orders')
  int? get openOrders;

  @BuiltValueField(wireName: r'orders_total')
  int? get ordersTotal;

  @BuiltValueField(wireName: r'disputes_total')
  int? get disputesTotal;

  @BuiltValueField(wireName: r'disputes_open')
  int? get disputesOpen;

  @BuiltValueField(wireName: r'commerce_restricted_until')
  DateTime? get commerceRestrictedUntil;

  @BuiltValueSerializer(custom: true)
  static Serializer<SubjectReview> get serializer => _$SubjectReviewSerializer();
}

class _$SubjectReviewSerializer implements PrimitiveSerializer<SubjectReview> {
  @override
  final Iterable<Type> types = const [SubjectReview];

  @override
  final String wireName = r'SubjectReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SubjectReview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.subjectType != null) {
      yield r'subject_type';
      yield serializers.serialize(
        object.subjectType,
        specifiedType: const FullType(String),
      );
    }
    if (object.subjectId != null) {
      yield r'subject_id';
      yield serializers.serialize(
        object.subjectId,
        specifiedType: const FullType(String),
      );
    }
    if (object.displayName != null) {
      yield r'display_name';
      yield serializers.serialize(
        object.displayName,
        specifiedType: const FullType(String),
      );
    }
    if (object.maskedEmail != null) {
      yield r'masked_email';
      yield serializers.serialize(
        object.maskedEmail,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.accountStatus != null) {
      yield r'account_status';
      yield serializers.serialize(
        object.accountStatus,
        specifiedType: const FullType(String),
      );
    }
    if (object.storeActivationStatus != null) {
      yield r'store_activation_status';
      yield serializers.serialize(
        object.storeActivationStatus,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.openOrders != null) {
      yield r'open_orders';
      yield serializers.serialize(
        object.openOrders,
        specifiedType: const FullType(int),
      );
    }
    if (object.ordersTotal != null) {
      yield r'orders_total';
      yield serializers.serialize(
        object.ordersTotal,
        specifiedType: const FullType(int),
      );
    }
    if (object.disputesTotal != null) {
      yield r'disputes_total';
      yield serializers.serialize(
        object.disputesTotal,
        specifiedType: const FullType(int),
      );
    }
    if (object.disputesOpen != null) {
      yield r'disputes_open';
      yield serializers.serialize(
        object.disputesOpen,
        specifiedType: const FullType(int),
      );
    }
    if (object.commerceRestrictedUntil != null) {
      yield r'commerce_restricted_until';
      yield serializers.serialize(
        object.commerceRestrictedUntil,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SubjectReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  SubjectReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($SubjectReview)) as $SubjectReview;
  }
}


/// a concrete implementation of [SubjectReview], since [SubjectReview] is not instantiable
@BuiltValue(instantiable: true)
abstract class $SubjectReview implements SubjectReview, Built<$SubjectReview, $SubjectReviewBuilder> {
  $SubjectReview._();

  factory $SubjectReview([void Function($SubjectReviewBuilder)? updates]) = _$$SubjectReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($SubjectReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$SubjectReview> get serializer => _$$SubjectReviewSerializer();
}

class _$$SubjectReviewSerializer implements PrimitiveSerializer<$SubjectReview> {
  @override
  final Iterable<Type> types = const [$SubjectReview, _$$SubjectReview];

  @override
  final String wireName = r'$SubjectReview';

  @override
  Object serialize(
    Serializers serializers,
    $SubjectReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(SubjectReview))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SubjectReviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'subject_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.subjectType = valueDes;
          break;
        case r'subject_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.subjectId = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.displayName = valueDes;
          break;
        case r'masked_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.maskedEmail = valueDes;
          break;
        case r'account_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accountStatus = valueDes;
          break;
        case r'store_activation_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storeActivationStatus = valueDes;
          break;
        case r'open_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.openOrders = valueDes;
          break;
        case r'orders_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.ordersTotal = valueDes;
          break;
        case r'disputes_total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.disputesTotal = valueDes;
          break;
        case r'disputes_open':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.disputesOpen = valueDes;
          break;
        case r'commerce_restricted_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.commerceRestrictedUntil = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  $SubjectReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $SubjectReviewBuilder();
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

