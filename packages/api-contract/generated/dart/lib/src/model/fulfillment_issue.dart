//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fulfillment_issue.g.dart';

/// FulfillmentIssue
///
/// Properties:
/// * [id]
/// * [category]
/// * [description]
/// * [state]
/// * [reportedAt]
/// * [vendorResponse]
/// * [vendorRespondedAt]
/// * [resolution]
/// * [resolvedAt]
/// * [photoPaths]
@BuiltValue()
abstract class FulfillmentIssue implements Built<FulfillmentIssue, FulfillmentIssueBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'category')
  FulfillmentIssueCategoryEnum get category;
  // enum categoryEnum {  NOT_RECEIVED,  INCOMPLETE,  DAMAGED,  WRONG_ITEM,  LATE,  ACCESS_PROBLEM,  OTHER,  };

  @BuiltValueField(wireName: r'description')
  String get description;

  @BuiltValueField(wireName: r'state')
  FulfillmentIssueStateEnum get state;
  // enum stateEnum {  OPEN,  RESOLVED,  };

  @BuiltValueField(wireName: r'reported_at')
  DateTime? get reportedAt;

  @BuiltValueField(wireName: r'vendor_response')
  String? get vendorResponse;

  @BuiltValueField(wireName: r'vendor_responded_at')
  DateTime? get vendorRespondedAt;

  @BuiltValueField(wireName: r'resolution')
  FulfillmentIssueResolutionEnum? get resolution;
  // enum resolutionEnum {  BUYER_RESOLVED,  RECEIPT_CONFIRMED,  ORDER_CANCELLED,  };

  @BuiltValueField(wireName: r'resolved_at')
  DateTime? get resolvedAt;

  @BuiltValueField(wireName: r'photo_paths')
  BuiltList<String> get photoPaths;

  FulfillmentIssue._();

  factory FulfillmentIssue([void updates(FulfillmentIssueBuilder b)]) = _$FulfillmentIssue;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FulfillmentIssueBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FulfillmentIssue> get serializer => _$FulfillmentIssueSerializer();
}

class _$FulfillmentIssueSerializer implements PrimitiveSerializer<FulfillmentIssue> {
  @override
  final Iterable<Type> types = const [FulfillmentIssue, _$FulfillmentIssue];

  @override
  final String wireName = r'FulfillmentIssue';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FulfillmentIssue object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'category';
    yield serializers.serialize(
      object.category,
      specifiedType: const FullType(FulfillmentIssueCategoryEnum),
    );
    yield r'description';
    yield serializers.serialize(
      object.description,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(FulfillmentIssueStateEnum),
    );
    if (object.reportedAt != null) {
      yield r'reported_at';
      yield serializers.serialize(
        object.reportedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.vendorResponse != null) {
      yield r'vendor_response';
      yield serializers.serialize(
        object.vendorResponse,
        specifiedType: const FullType(String),
      );
    }
    if (object.vendorRespondedAt != null) {
      yield r'vendor_responded_at';
      yield serializers.serialize(
        object.vendorRespondedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.resolution != null) {
      yield r'resolution';
      yield serializers.serialize(
        object.resolution,
        specifiedType: const FullType(FulfillmentIssueResolutionEnum),
      );
    }
    if (object.resolvedAt != null) {
      yield r'resolved_at';
      yield serializers.serialize(
        object.resolvedAt,
        specifiedType: const FullType(DateTime),
      );
    }
    yield r'photo_paths';
    yield serializers.serialize(
      object.photoPaths,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FulfillmentIssue object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FulfillmentIssueBuilder result,
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
        case r'category':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FulfillmentIssueCategoryEnum),
          ) as FulfillmentIssueCategoryEnum;
          result.category = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.description = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FulfillmentIssueStateEnum),
          ) as FulfillmentIssueStateEnum;
          result.state = valueDes;
          break;
        case r'reported_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reportedAt = valueDes;
          break;
        case r'vendor_response':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorResponse = valueDes;
          break;
        case r'vendor_responded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.vendorRespondedAt = valueDes;
          break;
        case r'resolution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(FulfillmentIssueResolutionEnum),
          ) as FulfillmentIssueResolutionEnum?;
          if (valueDes == null) continue;
          result.resolution = valueDes;
          break;
        case r'resolved_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
          break;
        case r'photo_paths':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.photoPaths.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FulfillmentIssue deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FulfillmentIssueBuilder();
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


class FulfillmentIssueCategoryEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NOT_RECEIVED')
  static const FulfillmentIssueCategoryEnum NOT_RECEIVED = _$fulfillmentIssueCategoryEnum_NOT_RECEIVED;
  @BuiltValueEnumConst(wireName: r'INCOMPLETE')
  static const FulfillmentIssueCategoryEnum INCOMPLETE = _$fulfillmentIssueCategoryEnum_INCOMPLETE;
  @BuiltValueEnumConst(wireName: r'DAMAGED')
  static const FulfillmentIssueCategoryEnum DAMAGED = _$fulfillmentIssueCategoryEnum_DAMAGED;
  @BuiltValueEnumConst(wireName: r'WRONG_ITEM')
  static const FulfillmentIssueCategoryEnum WRONG_ITEM = _$fulfillmentIssueCategoryEnum_WRONG_ITEM;
  @BuiltValueEnumConst(wireName: r'LATE')
  static const FulfillmentIssueCategoryEnum LATE = _$fulfillmentIssueCategoryEnum_LATE;
  @BuiltValueEnumConst(wireName: r'ACCESS_PROBLEM')
  static const FulfillmentIssueCategoryEnum ACCESS_PROBLEM = _$fulfillmentIssueCategoryEnum_ACCESS_PROBLEM;
  @BuiltValueEnumConst(wireName: r'OTHER')
  static const FulfillmentIssueCategoryEnum OTHER = _$fulfillmentIssueCategoryEnum_OTHER;

  static Serializer<FulfillmentIssueCategoryEnum> get serializer => _$fulfillmentIssueCategoryEnumSerializer;

  const FulfillmentIssueCategoryEnum._(String name): super(name);

  static BuiltSet<FulfillmentIssueCategoryEnum> get values => _$fulfillmentIssueCategoryEnumValues;
  static FulfillmentIssueCategoryEnum valueOf(String name) => _$fulfillmentIssueCategoryEnumValueOf(name);
}

class FulfillmentIssueStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const FulfillmentIssueStateEnum OPEN = _$fulfillmentIssueStateEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const FulfillmentIssueStateEnum RESOLVED = _$fulfillmentIssueStateEnum_RESOLVED;

  static Serializer<FulfillmentIssueStateEnum> get serializer => _$fulfillmentIssueStateEnumSerializer;

  const FulfillmentIssueStateEnum._(String name): super(name);

  static BuiltSet<FulfillmentIssueStateEnum> get values => _$fulfillmentIssueStateEnumValues;
  static FulfillmentIssueStateEnum valueOf(String name) => _$fulfillmentIssueStateEnumValueOf(name);
}

class FulfillmentIssueResolutionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER_RESOLVED')
  static const FulfillmentIssueResolutionEnum BUYER_RESOLVED = _$fulfillmentIssueResolutionEnum_BUYER_RESOLVED;
  @BuiltValueEnumConst(wireName: r'RECEIPT_CONFIRMED')
  static const FulfillmentIssueResolutionEnum RECEIPT_CONFIRMED = _$fulfillmentIssueResolutionEnum_RECEIPT_CONFIRMED;
  @BuiltValueEnumConst(wireName: r'ORDER_CANCELLED')
  static const FulfillmentIssueResolutionEnum ORDER_CANCELLED = _$fulfillmentIssueResolutionEnum_ORDER_CANCELLED;

  static Serializer<FulfillmentIssueResolutionEnum> get serializer => _$fulfillmentIssueResolutionEnumSerializer;

  const FulfillmentIssueResolutionEnum._(String name): super(name);

  static BuiltSet<FulfillmentIssueResolutionEnum> get values => _$fulfillmentIssueResolutionEnumValues;
  static FulfillmentIssueResolutionEnum valueOf(String name) => _$fulfillmentIssueResolutionEnumValueOf(name);
}

