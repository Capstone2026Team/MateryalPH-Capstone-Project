//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_supplier_summary.g.dart';

/// DirectorySupplierSummary
///
/// Properties:
/// * [formattedAddress]
/// * [primaryType]
/// * [source_]
/// * [refreshedAt]
@BuiltValue()
abstract class DirectorySupplierSummary implements Built<DirectorySupplierSummary, DirectorySupplierSummaryBuilder> {
  @BuiltValueField(wireName: r'formatted_address')
  String? get formattedAddress;

  @BuiltValueField(wireName: r'primary_type')
  String? get primaryType;

  @BuiltValueField(wireName: r'source')
  DirectorySupplierSummarySource_Enum get source_;
  // enum source_Enum {  GOOGLE,  };

  @BuiltValueField(wireName: r'refreshed_at')
  DateTime get refreshedAt;

  DirectorySupplierSummary._();

  factory DirectorySupplierSummary([void updates(DirectorySupplierSummaryBuilder b)]) = _$DirectorySupplierSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectorySupplierSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectorySupplierSummary> get serializer => _$DirectorySupplierSummarySerializer();
}

class _$DirectorySupplierSummarySerializer implements PrimitiveSerializer<DirectorySupplierSummary> {
  @override
  final Iterable<Type> types = const [DirectorySupplierSummary, _$DirectorySupplierSummary];

  @override
  final String wireName = r'DirectorySupplierSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectorySupplierSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'formatted_address';
    yield object.formattedAddress == null ? null : serializers.serialize(
      object.formattedAddress,
      specifiedType: const FullType.nullable(String),
    );
    yield r'primary_type';
    yield object.primaryType == null ? null : serializers.serialize(
      object.primaryType,
      specifiedType: const FullType.nullable(String),
    );
    yield r'source';
    yield serializers.serialize(
      object.source_,
      specifiedType: const FullType(DirectorySupplierSummarySource_Enum),
    );
    yield r'refreshed_at';
    yield serializers.serialize(
      object.refreshedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectorySupplierSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectorySupplierSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'formatted_address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.formattedAddress = valueDes;
          break;
        case r'primary_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.primaryType = valueDes;
          break;
        case r'source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectorySupplierSummarySource_Enum),
          ) as DirectorySupplierSummarySource_Enum;
          result.source_ = valueDes;
          break;
        case r'refreshed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.refreshedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectorySupplierSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectorySupplierSummaryBuilder();
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


class DirectorySupplierSummarySource_Enum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'GOOGLE')
  static const DirectorySupplierSummarySource_Enum GOOGLE = _$directorySupplierSummarySourceEnum_GOOGLE;

  static Serializer<DirectorySupplierSummarySource_Enum> get serializer => _$directorySupplierSummarySourceEnumSerializer;

  const DirectorySupplierSummarySource_Enum._(String name): super(name);

  static BuiltSet<DirectorySupplierSummarySource_Enum> get values => _$directorySupplierSummarySourceEnumValues;
  static DirectorySupplierSummarySource_Enum valueOf(String name) => _$directorySupplierSummarySourceEnumValueOf(name);
}

