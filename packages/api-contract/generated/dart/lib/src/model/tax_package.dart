//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_package.g.dart';

/// TaxPackage
///
/// Properties:
/// * [id]
/// * [packageType]
/// * [state]
/// * [periodStart]
/// * [periodEnd]
/// * [withholdingEntity]
/// * [nominalDueDate]
/// * [actualDueDate]
/// * [dueDateSource]
/// * [dueDateStatus]
/// * [dueDateReviewerId]
/// * [lockVersion]
/// * [snapshot]
/// * [contentHash]
/// * [submissionState]
@BuiltValue()
abstract class TaxPackage implements Built<TaxPackage, TaxPackageBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'package_type')
  String get packageType;

  @BuiltValueField(wireName: r'state')
  String get state;

  @BuiltValueField(wireName: r'period_start')
  String get periodStart;

  @BuiltValueField(wireName: r'period_end')
  String get periodEnd;

  @BuiltValueField(wireName: r'withholding_entity')
  String get withholdingEntity;

  @BuiltValueField(wireName: r'nominal_due_date')
  String? get nominalDueDate;

  @BuiltValueField(wireName: r'actual_due_date')
  String? get actualDueDate;

  @BuiltValueField(wireName: r'due_date_source')
  String? get dueDateSource;

  @BuiltValueField(wireName: r'due_date_status')
  String? get dueDateStatus;

  @BuiltValueField(wireName: r'due_date_reviewer_id')
  int? get dueDateReviewerId;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'snapshot')
  BuiltMap<String, JsonObject?>? get snapshot;

  @BuiltValueField(wireName: r'content_hash')
  String? get contentHash;

  @BuiltValueField(wireName: r'submission_state')
  String? get submissionState;

  TaxPackage._();

  factory TaxPackage([void updates(TaxPackageBuilder b)]) = _$TaxPackage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaxPackageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaxPackage> get serializer => _$TaxPackageSerializer();
}

class _$TaxPackageSerializer implements PrimitiveSerializer<TaxPackage> {
  @override
  final Iterable<Type> types = const [TaxPackage, _$TaxPackage];

  @override
  final String wireName = r'TaxPackage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaxPackage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'package_type';
    yield serializers.serialize(
      object.packageType,
      specifiedType: const FullType(String),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(String),
    );
    yield r'period_start';
    yield serializers.serialize(
      object.periodStart,
      specifiedType: const FullType(String),
    );
    yield r'period_end';
    yield serializers.serialize(
      object.periodEnd,
      specifiedType: const FullType(String),
    );
    yield r'withholding_entity';
    yield serializers.serialize(
      object.withholdingEntity,
      specifiedType: const FullType(String),
    );
    yield r'nominal_due_date';
    yield object.nominalDueDate == null ? null : serializers.serialize(
      object.nominalDueDate,
      specifiedType: const FullType.nullable(String),
    );
    yield r'actual_due_date';
    yield object.actualDueDate == null ? null : serializers.serialize(
      object.actualDueDate,
      specifiedType: const FullType.nullable(String),
    );
    if (object.dueDateSource != null) {
      yield r'due_date_source';
      yield serializers.serialize(
        object.dueDateSource,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.dueDateStatus != null) {
      yield r'due_date_status';
      yield serializers.serialize(
        object.dueDateStatus,
        specifiedType: const FullType(String),
      );
    }
    yield r'due_date_reviewer_id';
    yield object.dueDateReviewerId == null ? null : serializers.serialize(
      object.dueDateReviewerId,
      specifiedType: const FullType.nullable(int),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.snapshot != null) {
      yield r'snapshot';
      yield serializers.serialize(
        object.snapshot,
        specifiedType: const FullType(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
      );
    }
    if (object.contentHash != null) {
      yield r'content_hash';
      yield serializers.serialize(
        object.contentHash,
        specifiedType: const FullType(String),
      );
    }
    if (object.submissionState != null) {
      yield r'submission_state';
      yield serializers.serialize(
        object.submissionState,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    TaxPackage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaxPackageBuilder result,
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
        case r'package_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.packageType = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.state = valueDes;
          break;
        case r'period_start':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.periodStart = valueDes;
          break;
        case r'period_end':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.periodEnd = valueDes;
          break;
        case r'withholding_entity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.withholdingEntity = valueDes;
          break;
        case r'nominal_due_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.nominalDueDate = valueDes;
          break;
        case r'actual_due_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.actualDueDate = valueDes;
          break;
        case r'due_date_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.dueDateSource = valueDes;
          break;
        case r'due_date_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.dueDateStatus = valueDes;
          break;
        case r'due_date_reviewer_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.dueDateReviewerId = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'snapshot':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltMap, [FullType(String), FullType.nullable(JsonObject)]),
          ) as BuiltMap<String, JsonObject?>?;
          if (valueDes == null) continue;
          result.snapshot.replace(valueDes);
          break;
        case r'content_hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.contentHash = valueDes;
          break;
        case r'submission_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.submissionState = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TaxPackage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaxPackageBuilder();
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


