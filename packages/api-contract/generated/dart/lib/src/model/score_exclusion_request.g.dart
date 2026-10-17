// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_exclusion_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ScoreExclusionRequestReasonCodeEnum
    _$scoreExclusionRequestReasonCodeEnum_FRAUD =
    const ScoreExclusionRequestReasonCodeEnum._('FRAUD');
const ScoreExclusionRequestReasonCodeEnum
    _$scoreExclusionRequestReasonCodeEnum_DUPLICATE =
    const ScoreExclusionRequestReasonCodeEnum._('DUPLICATE');
const ScoreExclusionRequestReasonCodeEnum
    _$scoreExclusionRequestReasonCodeEnum_TEST =
    const ScoreExclusionRequestReasonCodeEnum._('TEST');
const ScoreExclusionRequestReasonCodeEnum
    _$scoreExclusionRequestReasonCodeEnum_INVALID_SOURCE =
    const ScoreExclusionRequestReasonCodeEnum._('INVALID_SOURCE');

ScoreExclusionRequestReasonCodeEnum
    _$scoreExclusionRequestReasonCodeEnumValueOf(String name) {
  switch (name) {
    case 'FRAUD':
      return _$scoreExclusionRequestReasonCodeEnum_FRAUD;
    case 'DUPLICATE':
      return _$scoreExclusionRequestReasonCodeEnum_DUPLICATE;
    case 'TEST':
      return _$scoreExclusionRequestReasonCodeEnum_TEST;
    case 'INVALID_SOURCE':
      return _$scoreExclusionRequestReasonCodeEnum_INVALID_SOURCE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ScoreExclusionRequestReasonCodeEnum>
    _$scoreExclusionRequestReasonCodeEnumValues = BuiltSet<
        ScoreExclusionRequestReasonCodeEnum>(const <ScoreExclusionRequestReasonCodeEnum>[
  _$scoreExclusionRequestReasonCodeEnum_FRAUD,
  _$scoreExclusionRequestReasonCodeEnum_DUPLICATE,
  _$scoreExclusionRequestReasonCodeEnum_TEST,
  _$scoreExclusionRequestReasonCodeEnum_INVALID_SOURCE,
]);

Serializer<ScoreExclusionRequestReasonCodeEnum>
    _$scoreExclusionRequestReasonCodeEnumSerializer =
    _$ScoreExclusionRequestReasonCodeEnumSerializer();

class _$ScoreExclusionRequestReasonCodeEnumSerializer
    implements PrimitiveSerializer<ScoreExclusionRequestReasonCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'FRAUD': 'FRAUD',
    'DUPLICATE': 'DUPLICATE',
    'TEST': 'TEST',
    'INVALID_SOURCE': 'INVALID_SOURCE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'FRAUD': 'FRAUD',
    'DUPLICATE': 'DUPLICATE',
    'TEST': 'TEST',
    'INVALID_SOURCE': 'INVALID_SOURCE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ScoreExclusionRequestReasonCodeEnum
  ];
  @override
  final String wireName = 'ScoreExclusionRequestReasonCodeEnum';

  @override
  Object serialize(
          Serializers serializers, ScoreExclusionRequestReasonCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ScoreExclusionRequestReasonCodeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ScoreExclusionRequestReasonCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ScoreExclusionRequest extends ScoreExclusionRequest {
  @override
  final String orderId;
  @override
  final ScoreExclusionRequestReasonCodeEnum reasonCode;
  @override
  final String note;

  factory _$ScoreExclusionRequest(
          [void Function(ScoreExclusionRequestBuilder)? updates]) =>
      (ScoreExclusionRequestBuilder()..update(updates))._build();

  _$ScoreExclusionRequest._(
      {required this.orderId, required this.reasonCode, required this.note})
      : super._();
  @override
  ScoreExclusionRequest rebuild(
          void Function(ScoreExclusionRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScoreExclusionRequestBuilder toBuilder() =>
      ScoreExclusionRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScoreExclusionRequest &&
        orderId == other.orderId &&
        reasonCode == other.reasonCode &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, reasonCode.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScoreExclusionRequest')
          ..add('orderId', orderId)
          ..add('reasonCode', reasonCode)
          ..add('note', note))
        .toString();
  }
}

class ScoreExclusionRequestBuilder
    implements Builder<ScoreExclusionRequest, ScoreExclusionRequestBuilder> {
  _$ScoreExclusionRequest? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  ScoreExclusionRequestReasonCodeEnum? _reasonCode;
  ScoreExclusionRequestReasonCodeEnum? get reasonCode => _$this._reasonCode;
  set reasonCode(ScoreExclusionRequestReasonCodeEnum? reasonCode) =>
      _$this._reasonCode = reasonCode;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ScoreExclusionRequestBuilder() {
    ScoreExclusionRequest._defaults(this);
  }

  ScoreExclusionRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _reasonCode = $v.reasonCode;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScoreExclusionRequest other) {
    _$v = other as _$ScoreExclusionRequest;
  }

  @override
  void update(void Function(ScoreExclusionRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScoreExclusionRequest build() => _build();

  _$ScoreExclusionRequest _build() {
    final _$result = _$v ??
        _$ScoreExclusionRequest._(
          orderId: BuiltValueNullFieldError.checkNotNull(
              orderId, r'ScoreExclusionRequest', 'orderId'),
          reasonCode: BuiltValueNullFieldError.checkNotNull(
              reasonCode, r'ScoreExclusionRequest', 'reasonCode'),
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'ScoreExclusionRequest', 'note'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
