// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_suppression_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BadgeSuppressionRequestBadgeCodeEnum
    _$badgeSuppressionRequestBadgeCodeEnum_FAST_RESPONDER =
    const BadgeSuppressionRequestBadgeCodeEnum._('FAST_RESPONDER');
const BadgeSuppressionRequestBadgeCodeEnum
    _$badgeSuppressionRequestBadgeCodeEnum_ON_TIME =
    const BadgeSuppressionRequestBadgeCodeEnum._('ON_TIME');
const BadgeSuppressionRequestBadgeCodeEnum
    _$badgeSuppressionRequestBadgeCodeEnum_MOST_ORDERED =
    const BadgeSuppressionRequestBadgeCodeEnum._('MOST_ORDERED');
const BadgeSuppressionRequestBadgeCodeEnum
    _$badgeSuppressionRequestBadgeCodeEnum_HIGHLY_RATED =
    const BadgeSuppressionRequestBadgeCodeEnum._('HIGHLY_RATED');
const BadgeSuppressionRequestBadgeCodeEnum
    _$badgeSuppressionRequestBadgeCodeEnum_HIGH_QUALITY_MATERIALS =
    const BadgeSuppressionRequestBadgeCodeEnum._('HIGH_QUALITY_MATERIALS');
const BadgeSuppressionRequestBadgeCodeEnum
    _$badgeSuppressionRequestBadgeCodeEnum_TRUSTED_SUPPLIER =
    const BadgeSuppressionRequestBadgeCodeEnum._('TRUSTED_SUPPLIER');

BadgeSuppressionRequestBadgeCodeEnum
    _$badgeSuppressionRequestBadgeCodeEnumValueOf(String name) {
  switch (name) {
    case 'FAST_RESPONDER':
      return _$badgeSuppressionRequestBadgeCodeEnum_FAST_RESPONDER;
    case 'ON_TIME':
      return _$badgeSuppressionRequestBadgeCodeEnum_ON_TIME;
    case 'MOST_ORDERED':
      return _$badgeSuppressionRequestBadgeCodeEnum_MOST_ORDERED;
    case 'HIGHLY_RATED':
      return _$badgeSuppressionRequestBadgeCodeEnum_HIGHLY_RATED;
    case 'HIGH_QUALITY_MATERIALS':
      return _$badgeSuppressionRequestBadgeCodeEnum_HIGH_QUALITY_MATERIALS;
    case 'TRUSTED_SUPPLIER':
      return _$badgeSuppressionRequestBadgeCodeEnum_TRUSTED_SUPPLIER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BadgeSuppressionRequestBadgeCodeEnum>
    _$badgeSuppressionRequestBadgeCodeEnumValues = BuiltSet<
        BadgeSuppressionRequestBadgeCodeEnum>(const <BadgeSuppressionRequestBadgeCodeEnum>[
  _$badgeSuppressionRequestBadgeCodeEnum_FAST_RESPONDER,
  _$badgeSuppressionRequestBadgeCodeEnum_ON_TIME,
  _$badgeSuppressionRequestBadgeCodeEnum_MOST_ORDERED,
  _$badgeSuppressionRequestBadgeCodeEnum_HIGHLY_RATED,
  _$badgeSuppressionRequestBadgeCodeEnum_HIGH_QUALITY_MATERIALS,
  _$badgeSuppressionRequestBadgeCodeEnum_TRUSTED_SUPPLIER,
]);

const BadgeSuppressionRequestReasonCodeEnum
    _$badgeSuppressionRequestReasonCodeEnum_FRAUD =
    const BadgeSuppressionRequestReasonCodeEnum._('FRAUD');
const BadgeSuppressionRequestReasonCodeEnum
    _$badgeSuppressionRequestReasonCodeEnum_COMPLIANCE =
    const BadgeSuppressionRequestReasonCodeEnum._('COMPLIANCE');

BadgeSuppressionRequestReasonCodeEnum
    _$badgeSuppressionRequestReasonCodeEnumValueOf(String name) {
  switch (name) {
    case 'FRAUD':
      return _$badgeSuppressionRequestReasonCodeEnum_FRAUD;
    case 'COMPLIANCE':
      return _$badgeSuppressionRequestReasonCodeEnum_COMPLIANCE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BadgeSuppressionRequestReasonCodeEnum>
    _$badgeSuppressionRequestReasonCodeEnumValues = BuiltSet<
        BadgeSuppressionRequestReasonCodeEnum>(const <BadgeSuppressionRequestReasonCodeEnum>[
  _$badgeSuppressionRequestReasonCodeEnum_FRAUD,
  _$badgeSuppressionRequestReasonCodeEnum_COMPLIANCE,
]);

Serializer<BadgeSuppressionRequestBadgeCodeEnum>
    _$badgeSuppressionRequestBadgeCodeEnumSerializer =
    _$BadgeSuppressionRequestBadgeCodeEnumSerializer();
Serializer<BadgeSuppressionRequestReasonCodeEnum>
    _$badgeSuppressionRequestReasonCodeEnumSerializer =
    _$BadgeSuppressionRequestReasonCodeEnumSerializer();

class _$BadgeSuppressionRequestBadgeCodeEnumSerializer
    implements PrimitiveSerializer<BadgeSuppressionRequestBadgeCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FAST_RESPONDER': 'FAST_RESPONDER',
    'ON_TIME': 'ON_TIME',
    'MOST_ORDERED': 'MOST_ORDERED',
    'HIGHLY_RATED': 'HIGHLY_RATED',
    'HIGH_QUALITY_MATERIALS': 'HIGH_QUALITY_MATERIALS',
    'TRUSTED_SUPPLIER': 'TRUSTED_SUPPLIER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FAST_RESPONDER': 'FAST_RESPONDER',
    'ON_TIME': 'ON_TIME',
    'MOST_ORDERED': 'MOST_ORDERED',
    'HIGHLY_RATED': 'HIGHLY_RATED',
    'HIGH_QUALITY_MATERIALS': 'HIGH_QUALITY_MATERIALS',
    'TRUSTED_SUPPLIER': 'TRUSTED_SUPPLIER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BadgeSuppressionRequestBadgeCodeEnum
  ];
  @override
  final String wireName = 'BadgeSuppressionRequestBadgeCodeEnum';

  @override
  Object serialize(
          Serializers serializers, BadgeSuppressionRequestBadgeCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BadgeSuppressionRequestBadgeCodeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BadgeSuppressionRequestBadgeCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BadgeSuppressionRequestReasonCodeEnumSerializer
    implements PrimitiveSerializer<BadgeSuppressionRequestReasonCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FRAUD': 'FRAUD',
    'COMPLIANCE': 'COMPLIANCE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FRAUD': 'FRAUD',
    'COMPLIANCE': 'COMPLIANCE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BadgeSuppressionRequestReasonCodeEnum
  ];
  @override
  final String wireName = 'BadgeSuppressionRequestReasonCodeEnum';

  @override
  Object serialize(
          Serializers serializers, BadgeSuppressionRequestReasonCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BadgeSuppressionRequestReasonCodeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BadgeSuppressionRequestReasonCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BadgeSuppressionRequest extends BadgeSuppressionRequest {
  @override
  final BadgeSuppressionRequestBadgeCodeEnum badgeCode;
  @override
  final BadgeSuppressionRequestReasonCodeEnum reasonCode;
  @override
  final String caseReference;
  @override
  final String note;

  factory _$BadgeSuppressionRequest(
          [void Function(BadgeSuppressionRequestBuilder)? updates]) =>
      (BadgeSuppressionRequestBuilder()..update(updates))._build();

  _$BadgeSuppressionRequest._(
      {required this.badgeCode,
      required this.reasonCode,
      required this.caseReference,
      required this.note})
      : super._();
  @override
  BadgeSuppressionRequest rebuild(
          void Function(BadgeSuppressionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BadgeSuppressionRequestBuilder toBuilder() =>
      BadgeSuppressionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BadgeSuppressionRequest &&
        badgeCode == other.badgeCode &&
        reasonCode == other.reasonCode &&
        caseReference == other.caseReference &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, badgeCode.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, caseReference.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BadgeSuppressionRequest')
          ..add('badgeCode', badgeCode)
          ..add('reasonCode', reasonCode)
          ..add('caseReference', caseReference)
          ..add('note', note))
        .toString();
  }
}

class BadgeSuppressionRequestBuilder
    implements
        Builder<BadgeSuppressionRequest, BadgeSuppressionRequestBuilder> {
  _$BadgeSuppressionRequest? _$v;

  BadgeSuppressionRequestBadgeCodeEnum? _badgeCode;
  BadgeSuppressionRequestBadgeCodeEnum? get badgeCode => _$this._badgeCode;
  set badgeCode(BadgeSuppressionRequestBadgeCodeEnum? badgeCode) =>
      _$this._badgeCode = badgeCode;

  BadgeSuppressionRequestReasonCodeEnum? _reasonCode;
  BadgeSuppressionRequestReasonCodeEnum? get reasonCode => _$this._reasonCode;
  set reasonCode(BadgeSuppressionRequestReasonCodeEnum? reasonCode) =>
      _$this._reasonCode = reasonCode;

  String? _caseReference;
  String? get caseReference => _$this._caseReference;
  set caseReference(String? caseReference) =>
      _$this._caseReference = caseReference;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  BadgeSuppressionRequestBuilder() {
    BadgeSuppressionRequest._defaults(this);
  }

  BadgeSuppressionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _badgeCode = $v.badgeCode;
      _reasonCode = $v.reasonCode;
      _caseReference = $v.caseReference;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BadgeSuppressionRequest other) {
    _$v = other as _$BadgeSuppressionRequest;
  }

  @override
  void update(void Function(BadgeSuppressionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BadgeSuppressionRequest build() => _build();

  _$BadgeSuppressionRequest _build() {
    final _$result = _$v ??
        _$BadgeSuppressionRequest._(
          badgeCode: BuiltValueNullFieldError.checkNotNull(
              badgeCode, r'BadgeSuppressionRequest', 'badgeCode'),
          reasonCode: BuiltValueNullFieldError.checkNotNull(
              reasonCode, r'BadgeSuppressionRequest', 'reasonCode'),
          caseReference: BuiltValueNullFieldError.checkNotNull(
              caseReference, r'BadgeSuppressionRequest', 'caseReference'),
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'BadgeSuppressionRequest', 'note'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
