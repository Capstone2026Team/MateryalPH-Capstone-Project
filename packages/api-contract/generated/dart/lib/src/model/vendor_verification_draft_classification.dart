//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_verification_draft_classification.g.dart';

/// VendorVerificationDraftClassification
///
/// Properties:
/// * [supplierType] - WHOLESALER_DISTRIBUTOR or RETAIL_HARDWARE_STORE or SPECIALIZED_SUPPLIER.
/// * [niches]
/// * [customLabel] - Legacy single label; used when custom_labels is omitted.
/// * [customLabels] - Vendor-provided labels for Other Category, kept separate from canonical taxonomy. Returned in onboarding classification; legacy custom_label mirrors the first label. Empty when Other Category is not selected.
@BuiltValue()
abstract class VendorVerificationDraftClassification implements Built<VendorVerificationDraftClassification, VendorVerificationDraftClassificationBuilder> {
  /// WHOLESALER_DISTRIBUTOR or RETAIL_HARDWARE_STORE or SPECIALIZED_SUPPLIER.
  @BuiltValueField(wireName: r'supplier_type')
  String? get supplierType;

  @BuiltValueField(wireName: r'niches')
  BuiltList<String>? get niches;

  /// Legacy single label; used when custom_labels is omitted.
  @Deprecated('customLabel has been deprecated')
  @BuiltValueField(wireName: r'custom_label')
  String? get customLabel;

  /// Vendor-provided labels for Other Category, kept separate from canonical taxonomy. Returned in onboarding classification; legacy custom_label mirrors the first label. Empty when Other Category is not selected.
  @BuiltValueField(wireName: r'custom_labels')
  BuiltSet<String>? get customLabels;

  VendorVerificationDraftClassification._();

  factory VendorVerificationDraftClassification([void updates(VendorVerificationDraftClassificationBuilder b)]) = _$VendorVerificationDraftClassification;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorVerificationDraftClassificationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorVerificationDraftClassification> get serializer => _$VendorVerificationDraftClassificationSerializer();
}

class _$VendorVerificationDraftClassificationSerializer implements PrimitiveSerializer<VendorVerificationDraftClassification> {
  @override
  final Iterable<Type> types = const [VendorVerificationDraftClassification, _$VendorVerificationDraftClassification];

  @override
  final String wireName = r'VendorVerificationDraftClassification';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorVerificationDraftClassification object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.supplierType != null) {
      yield r'supplier_type';
      yield serializers.serialize(
        object.supplierType,
        specifiedType: const FullType(String),
      );
    }
    if (object.niches != null) {
      yield r'niches';
      yield serializers.serialize(
        object.niches,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
    if (object.customLabel != null) {
      yield r'custom_label';
      yield serializers.serialize(
        object.customLabel,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.customLabels != null) {
      yield r'custom_labels';
      yield serializers.serialize(
        object.customLabels,
        specifiedType: const FullType(BuiltSet, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorVerificationDraftClassification object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorVerificationDraftClassificationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'supplier_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supplierType = valueDes;
          break;
        case r'niches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.niches.replace(valueDes);
          break;
        case r'custom_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.customLabel = valueDes;
          break;
        case r'custom_labels':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltSet, [FullType(String)]),
          ) as BuiltSet<String>?;
          if (valueDes == null) continue;
          result.customLabels.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorVerificationDraftClassification deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorVerificationDraftClassificationBuilder();
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


