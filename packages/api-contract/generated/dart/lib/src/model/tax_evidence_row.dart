//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:materyalph_api_client/src/model/geo_demand_columns_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'tax_evidence_row.g.dart';

/// TaxEvidenceRow
///
/// Properties:
/// * [id]
/// * [evidenceType]
/// * [origin]
/// * [validFrom]
/// * [validUntil]
/// * [reviewState]
/// * [reviewedAt]
/// * [taxProfileVersion]
/// * [taxableYear]
/// * [vendor]
/// * [decisionHref]
/// * [createdAt]
/// * [note]
@BuiltValue()
abstract class TaxEvidenceRow implements Built<TaxEvidenceRow, TaxEvidenceRowBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'evidence_type')
  String get evidenceType;

  @BuiltValueField(wireName: r'origin')
  String get origin;

  @BuiltValueField(wireName: r'valid_from')
  Date? get validFrom;

  @BuiltValueField(wireName: r'valid_until')
  Date? get validUntil;

  @BuiltValueField(wireName: r'review_state')
  String get reviewState;

  @BuiltValueField(wireName: r'reviewed_at')
  DateTime? get reviewedAt;

  @BuiltValueField(wireName: r'tax_profile_version')
  int get taxProfileVersion;

  @BuiltValueField(wireName: r'taxable_year')
  int? get taxableYear;

  @BuiltValueField(wireName: r'vendor')
  GeoDemandColumnsInner get vendor;

  @BuiltValueField(wireName: r'decision_href')
  String get decisionHref;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'note')
  String get note;

  TaxEvidenceRow._();

  factory TaxEvidenceRow([void updates(TaxEvidenceRowBuilder b)]) = _$TaxEvidenceRow;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TaxEvidenceRowBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TaxEvidenceRow> get serializer => _$TaxEvidenceRowSerializer();
}

class _$TaxEvidenceRowSerializer implements PrimitiveSerializer<TaxEvidenceRow> {
  @override
  final Iterable<Type> types = const [TaxEvidenceRow, _$TaxEvidenceRow];

  @override
  final String wireName = r'TaxEvidenceRow';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TaxEvidenceRow object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'evidence_type';
    yield serializers.serialize(
      object.evidenceType,
      specifiedType: const FullType(String),
    );
    yield r'origin';
    yield serializers.serialize(
      object.origin,
      specifiedType: const FullType(String),
    );
    if (object.validFrom != null) {
      yield r'valid_from';
      yield serializers.serialize(
        object.validFrom,
        specifiedType: const FullType.nullable(Date),
      );
    }
    if (object.validUntil != null) {
      yield r'valid_until';
      yield serializers.serialize(
        object.validUntil,
        specifiedType: const FullType.nullable(Date),
      );
    }
    yield r'review_state';
    yield serializers.serialize(
      object.reviewState,
      specifiedType: const FullType(String),
    );
    if (object.reviewedAt != null) {
      yield r'reviewed_at';
      yield serializers.serialize(
        object.reviewedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'tax_profile_version';
    yield serializers.serialize(
      object.taxProfileVersion,
      specifiedType: const FullType(int),
    );
    if (object.taxableYear != null) {
      yield r'taxable_year';
      yield serializers.serialize(
        object.taxableYear,
        specifiedType: const FullType.nullable(int),
      );
    }
    yield r'vendor';
    yield serializers.serialize(
      object.vendor,
      specifiedType: const FullType(GeoDemandColumnsInner),
    );
    yield r'decision_href';
    yield serializers.serialize(
      object.decisionHref,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'note';
    yield serializers.serialize(
      object.note,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TaxEvidenceRow object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TaxEvidenceRowBuilder result,
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
        case r'evidence_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.evidenceType = valueDes;
          break;
        case r'origin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.origin = valueDes;
          break;
        case r'valid_from':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.validFrom = valueDes;
          break;
        case r'valid_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.validUntil = valueDes;
          break;
        case r'review_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reviewState = valueDes;
          break;
        case r'reviewed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.reviewedAt = valueDes;
          break;
        case r'tax_profile_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.taxProfileVersion = valueDes;
          break;
        case r'taxable_year':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.taxableYear = valueDes;
          break;
        case r'vendor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GeoDemandColumnsInner),
          ) as GeoDemandColumnsInner;
          result.vendor.replace(valueDes);
          break;
        case r'decision_href':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.decisionHref = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TaxEvidenceRow deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TaxEvidenceRowBuilder();
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


