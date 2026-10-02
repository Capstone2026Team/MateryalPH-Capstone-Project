//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'finance_review_item.g.dart';

/// FinanceReviewItem
///
/// Properties:
/// * [id]
/// * [kind]
/// * [state]
/// * [reasonCode]
/// * [summary]
/// * [vendor]
/// * [sourceType]
/// * [sourceId]
/// * [expected]
/// * [reported]
/// * [resolution]
/// * [createdAt]
/// * [resolvedAt]
@BuiltValue()
abstract class FinanceReviewItem implements Built<FinanceReviewItem, FinanceReviewItemBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  String get kind;

  @BuiltValueField(wireName: r'state')
  FinanceReviewItemStateEnum get state;
  // enum stateEnum {  OPEN,  RESOLVED,  };

  @BuiltValueField(wireName: r'reason_code')
  String get reasonCode;

  @BuiltValueField(wireName: r'summary')
  String get summary;

  @BuiltValueField(wireName: r'vendor')
  BuiltMap<String, JsonObject?>? get vendor;

  @BuiltValueField(wireName: r'source_type')
  String get sourceType;

  @BuiltValueField(wireName: r'source_id')
  String get sourceId;

  @BuiltValueField(wireName: r'expected')
  BuiltMap<String, JsonObject?> get expected;

  @BuiltValueField(wireName: r'reported')
  BuiltMap<String, JsonObject?> get reported;

  @BuiltValueField(wireName: r'resolution')
  String? get resolution;

  @BuiltValueField(wireName: r'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: r'resolved_at')
  DateTime? get resolvedAt;

  FinanceReviewItem._();

  factory FinanceReviewItem([void updates(FinanceReviewItemBuilder b)]) = _$FinanceReviewItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinanceReviewItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinanceReviewItem> get serializer => _$FinanceReviewItemSerializer();
}

class _$FinanceReviewItemSerializer implements PrimitiveSerializer<FinanceReviewItem> {
  @override
  final Iterable<Type> types = const [FinanceReviewItem, _$FinanceReviewItem];

  @override
  final String wireName = r'FinanceReviewItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinanceReviewItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(FinanceReviewItemStateEnum),
    );
    yield r'reason_code';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(String),
    );
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(String),
    );
    if (object.vendor != null) {
      yield r'vendor';
      yield serializers.serialize(
        object.vendor,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    yield r'source_type';
    yield serializers.serialize(
      object.sourceType,
      specifiedType: const FullType(String),
    );
    yield r'source_id';
    yield serializers.serialize(
      object.sourceId,
      specifiedType: const FullType(String),
    );
    yield r'expected';
    yield serializers.serialize(
      object.expected,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    yield r'reported';
    yield serializers.serialize(
      object.reported,
      specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
    );
    if (object.resolution != null) {
      yield r'resolution';
      yield serializers.serialize(
        object.resolution,
        specifiedType: const FullType(String),
      );
    }
    if (object.createdAt != null) {
      yield r'created_at';
      yield serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.resolvedAt != null) {
      yield r'resolved_at';
      yield serializers.serialize(
        object.resolvedAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    FinanceReviewItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinanceReviewItemBuilder result,
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
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.kind = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FinanceReviewItemStateEnum),
          ) as FinanceReviewItemStateEnum;
          result.state = valueDes;
          break;
        case r'reason_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reasonCode = valueDes;
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.summary = valueDes;
          break;
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.vendor.replace(valueDes);
          break;
        case r'source_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceType = valueDes;
          break;
        case r'source_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.sourceId = valueDes;
          break;
        case r'expected':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.expected.replace(valueDes);
          break;
        case r'reported':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>;
          result.reported.replace(valueDes);
          break;
        case r'resolution':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.resolution = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'resolved_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinanceReviewItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinanceReviewItemBuilder();
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


class FinanceReviewItemStateEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'OPEN')
  static const FinanceReviewItemStateEnum OPEN = _$financeReviewItemStateEnum_OPEN;
  @BuiltValueEnumConst(wireName: r'RESOLVED')
  static const FinanceReviewItemStateEnum RESOLVED = _$financeReviewItemStateEnum_RESOLVED;

  static Serializer<FinanceReviewItemStateEnum> get serializer => _$financeReviewItemStateEnumSerializer;

  const FinanceReviewItemStateEnum._(String name): super(name);

  static BuiltSet<FinanceReviewItemStateEnum> get values => _$financeReviewItemStateEnumValues;
  static FinanceReviewItemStateEnum valueOf(String name) => _$financeReviewItemStateEnumValueOf(name);
}

