//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_package_review.g.dart';

/// TaxPackageReview
///
/// Properties:
/// * [lockVersion]
/// * [actualDueDate]
/// * [dueDateSource]
/// * [reason]
/// * [reconciled]
@BuiltValue()
abstract class TaxPackageReview implements Built<TaxPackageReview, TaxPackageReviewBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'actual_due_date')
  String get actualDueDate;

  @BuiltValueField(wireName: r'due_date_source')
  String get dueDateSource;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'reconciled')
  bool get reconciled;

  TaxPackageReview._();

  factory TaxPackageReview([void updates(TaxPackageReviewBuilder b)]) = _$TaxPackageReview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaxPackageReviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaxPackageReview> get serializer => _$TaxPackageReviewSerializer();
}

class _$TaxPackageReviewSerializer implements PrimitiveSerializer<TaxPackageReview> {
  @override
  final Iterable<Type> types = const [TaxPackageReview, _$TaxPackageReview];

  @override
  final String wireName = r'TaxPackageReview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaxPackageReview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'actual_due_date';
    yield serializers.serialize(
      object.actualDueDate,
      specifiedType: const FullType(String),
    );
    yield r'due_date_source';
    yield serializers.serialize(
      object.dueDateSource,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'reconciled';
    yield serializers.serialize(
      object.reconciled,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TaxPackageReview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaxPackageReviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'actual_due_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.actualDueDate = valueDes;
          break;
        case r'due_date_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.dueDateSource = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'reconciled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.reconciled = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TaxPackageReview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaxPackageReviewBuilder();
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


