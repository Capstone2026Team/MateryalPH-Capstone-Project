//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/checkout_preview_summary.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/checkout_group_preview.dart';
import 'package:materyalph_api_client/src/model/cart_destination.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'checkout_preview.g.dart';

/// CheckoutPreview
///
/// Properties:
/// * [requestVersion]
/// * [cartLockVersion]
/// * [currentAsOf]
/// * [calculationVersion]
/// * [destination]
/// * [groups]
/// * [summary]
@BuiltValue()
abstract class CheckoutPreview implements Built<CheckoutPreview, CheckoutPreviewBuilder> {
  @BuiltValueField(wireName: r'request_version')
  String? get requestVersion;

  @BuiltValueField(wireName: r'cart_lock_version')
  int get cartLockVersion;

  @BuiltValueField(wireName: r'current_as_of')
  DateTime get currentAsOf;

  @BuiltValueField(wireName: r'calculation_version')
  String get calculationVersion;

  @BuiltValueField(wireName: r'destination')
  CartDestination get destination;

  @BuiltValueField(wireName: r'groups')
  BuiltList<CheckoutGroupPreview> get groups;

  @BuiltValueField(wireName: r'summary')
  CheckoutPreviewSummary get summary;

  CheckoutPreview._();

  factory CheckoutPreview([void updates(CheckoutPreviewBuilder b)]) = _$CheckoutPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CheckoutPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CheckoutPreview> get serializer => _$CheckoutPreviewSerializer();
}

class _$CheckoutPreviewSerializer implements PrimitiveSerializer<CheckoutPreview> {
  @override
  final Iterable<Type> types = const [CheckoutPreview, _$CheckoutPreview];

  @override
  final String wireName = r'CheckoutPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CheckoutPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'request_version';
    yield object.requestVersion == null ? null : serializers.serialize(
      object.requestVersion,
      specifiedType: const FullType.nullable(String),
    );
    yield r'cart_lock_version';
    yield serializers.serialize(
      object.cartLockVersion,
      specifiedType: const FullType(int),
    );
    yield r'current_as_of';
    yield serializers.serialize(
      object.currentAsOf,
      specifiedType: const FullType(DateTime),
    );
    yield r'calculation_version';
    yield serializers.serialize(
      object.calculationVersion,
      specifiedType: const FullType(String),
    );
    yield r'destination';
    yield serializers.serialize(
      object.destination,
      specifiedType: const FullType(CartDestination),
    );
    yield r'groups';
    yield serializers.serialize(
      object.groups,
      specifiedType: const FullType(BuiltList, [FullType(CheckoutGroupPreview)]),
    );
    yield r'summary';
    yield serializers.serialize(
      object.summary,
      specifiedType: const FullType(CheckoutPreviewSummary),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CheckoutPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CheckoutPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'request_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.requestVersion = valueDes;
          break;
        case r'cart_lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cartLockVersion = valueDes;
          break;
        case r'current_as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.currentAsOf = valueDes;
          break;
        case r'calculation_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.calculationVersion = valueDes;
          break;
        case r'destination':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CartDestination),
          ) as CartDestination;
          result.destination.replace(valueDes);
          break;
        case r'groups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CheckoutGroupPreview)]),
          ) as BuiltList<CheckoutGroupPreview>;
          result.groups.replace(valueDes);
          break;
        case r'summary':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CheckoutPreviewSummary),
          ) as CheckoutPreviewSummary;
          result.summary.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CheckoutPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CheckoutPreviewBuilder();
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


