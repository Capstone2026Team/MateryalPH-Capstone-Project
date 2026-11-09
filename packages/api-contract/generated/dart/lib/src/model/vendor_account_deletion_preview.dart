//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_account_retained_record.dart';
import 'package:materyalph_api_client/src/model/vendor_account_deletion_blockers.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_account_deletion_preview.g.dart';

/// VendorAccountDeletionPreview
///
/// Properties:
/// * [canDelete]
/// * [blockers]
/// * [retainedRecords]
/// * [confirmationPhrase]
@BuiltValue()
abstract class VendorAccountDeletionPreview implements Built<VendorAccountDeletionPreview, VendorAccountDeletionPreviewBuilder> {
  @BuiltValueField(wireName: r'can_delete')
  bool get canDelete;

  @BuiltValueField(wireName: r'blockers')
  VendorAccountDeletionBlockers get blockers;

  @BuiltValueField(wireName: r'retained_records')
  BuiltList<VendorAccountRetainedRecord> get retainedRecords;

  @BuiltValueField(wireName: r'confirmation_phrase')
  VendorAccountDeletionPreviewConfirmationPhraseEnum get confirmationPhrase;
  // enum confirmationPhraseEnum {  DELETE,  };

  VendorAccountDeletionPreview._();

  factory VendorAccountDeletionPreview([void updates(VendorAccountDeletionPreviewBuilder b)]) = _$VendorAccountDeletionPreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorAccountDeletionPreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorAccountDeletionPreview> get serializer => _$VendorAccountDeletionPreviewSerializer();
}

class _$VendorAccountDeletionPreviewSerializer implements PrimitiveSerializer<VendorAccountDeletionPreview> {
  @override
  final Iterable<Type> types = const [VendorAccountDeletionPreview, _$VendorAccountDeletionPreview];

  @override
  final String wireName = r'VendorAccountDeletionPreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorAccountDeletionPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'can_delete';
    yield serializers.serialize(
      object.canDelete,
      specifiedType: const FullType(bool),
    );
    yield r'blockers';
    yield serializers.serialize(
      object.blockers,
      specifiedType: const FullType(VendorAccountDeletionBlockers),
    );
    yield r'retained_records';
    yield serializers.serialize(
      object.retainedRecords,
      specifiedType: const FullType(BuiltList, [FullType(VendorAccountRetainedRecord)]),
    );
    yield r'confirmation_phrase';
    yield serializers.serialize(
      object.confirmationPhrase,
      specifiedType: const FullType(VendorAccountDeletionPreviewConfirmationPhraseEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorAccountDeletionPreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorAccountDeletionPreviewBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'can_delete':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canDelete = valueDes;
          break;
        case r'blockers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorAccountDeletionBlockers),
          ) as VendorAccountDeletionBlockers;
          result.blockers.replace(valueDes);
          break;
        case r'retained_records':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(VendorAccountRetainedRecord)]),
          ) as BuiltList<VendorAccountRetainedRecord>;
          result.retainedRecords.replace(valueDes);
          break;
        case r'confirmation_phrase':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorAccountDeletionPreviewConfirmationPhraseEnum),
          ) as VendorAccountDeletionPreviewConfirmationPhraseEnum;
          result.confirmationPhrase = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorAccountDeletionPreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorAccountDeletionPreviewBuilder();
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


class VendorAccountDeletionPreviewConfirmationPhraseEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DELETE')
  static const VendorAccountDeletionPreviewConfirmationPhraseEnum DELETE = _$vendorAccountDeletionPreviewConfirmationPhraseEnum_DELETE;

  static Serializer<VendorAccountDeletionPreviewConfirmationPhraseEnum> get serializer => _$vendorAccountDeletionPreviewConfirmationPhraseEnumSerializer;

  const VendorAccountDeletionPreviewConfirmationPhraseEnum._(String name): super(name);

  static BuiltSet<VendorAccountDeletionPreviewConfirmationPhraseEnum> get values => _$vendorAccountDeletionPreviewConfirmationPhraseEnumValues;
  static VendorAccountDeletionPreviewConfirmationPhraseEnum valueOf(String name) => _$vendorAccountDeletionPreviewConfirmationPhraseEnumValueOf(name);
}

