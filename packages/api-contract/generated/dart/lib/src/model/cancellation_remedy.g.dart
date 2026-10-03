// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancellation_remedy.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CancellationRemedyCodeEnum _$cancellationRemedyCodeEnum_REPORT_PROBLEM =
    const CancellationRemedyCodeEnum._('REPORT_PROBLEM');
const CancellationRemedyCodeEnum _$cancellationRemedyCodeEnum_DISPUTE =
    const CancellationRemedyCodeEnum._('DISPUTE');
const CancellationRemedyCodeEnum _$cancellationRemedyCodeEnum_RETURN =
    const CancellationRemedyCodeEnum._('RETURN');
const CancellationRemedyCodeEnum _$cancellationRemedyCodeEnum_WARRANTY =
    const CancellationRemedyCodeEnum._('WARRANTY');
const CancellationRemedyCodeEnum
    _$cancellationRemedyCodeEnum_STATUTORY_REMEDIES =
    const CancellationRemedyCodeEnum._('STATUTORY_REMEDIES');

CancellationRemedyCodeEnum _$cancellationRemedyCodeEnumValueOf(String name) {
  switch (name) {
    case 'REPORT_PROBLEM':
      return _$cancellationRemedyCodeEnum_REPORT_PROBLEM;
    case 'DISPUTE':
      return _$cancellationRemedyCodeEnum_DISPUTE;
    case 'RETURN':
      return _$cancellationRemedyCodeEnum_RETURN;
    case 'WARRANTY':
      return _$cancellationRemedyCodeEnum_WARRANTY;
    case 'STATUTORY_REMEDIES':
      return _$cancellationRemedyCodeEnum_STATUTORY_REMEDIES;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CancellationRemedyCodeEnum> _$cancellationRemedyCodeEnumValues =
    BuiltSet<CancellationRemedyCodeEnum>(const <CancellationRemedyCodeEnum>[
  _$cancellationRemedyCodeEnum_REPORT_PROBLEM,
  _$cancellationRemedyCodeEnum_DISPUTE,
  _$cancellationRemedyCodeEnum_RETURN,
  _$cancellationRemedyCodeEnum_WARRANTY,
  _$cancellationRemedyCodeEnum_STATUTORY_REMEDIES,
]);

Serializer<CancellationRemedyCodeEnum> _$cancellationRemedyCodeEnumSerializer =
    _$CancellationRemedyCodeEnumSerializer();

class _$CancellationRemedyCodeEnumSerializer
    implements PrimitiveSerializer<CancellationRemedyCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'REPORT_PROBLEM': 'REPORT_PROBLEM',
    'DISPUTE': 'DISPUTE',
    'RETURN': 'RETURN',
    'WARRANTY': 'WARRANTY',
    'STATUTORY_REMEDIES': 'STATUTORY_REMEDIES',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'REPORT_PROBLEM': 'REPORT_PROBLEM',
    'DISPUTE': 'DISPUTE',
    'RETURN': 'RETURN',
    'WARRANTY': 'WARRANTY',
    'STATUTORY_REMEDIES': 'STATUTORY_REMEDIES',
  };

  @override
  final Iterable<Type> types = const <Type>[CancellationRemedyCodeEnum];
  @override
  final String wireName = 'CancellationRemedyCodeEnum';

  @override
  Object serialize(Serializers serializers, CancellationRemedyCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CancellationRemedyCodeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CancellationRemedyCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CancellationRemedy extends CancellationRemedy {
  @override
  final CancellationRemedyCodeEnum code;
  @override
  final bool available;
  @override
  final String note;

  factory _$CancellationRemedy(
          [void Function(CancellationRemedyBuilder)? updates]) =>
      (CancellationRemedyBuilder()..update(updates))._build();

  _$CancellationRemedy._(
      {required this.code, required this.available, required this.note})
      : super._();
  @override
  CancellationRemedy rebuild(
          void Function(CancellationRemedyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CancellationRemedyBuilder toBuilder() =>
      CancellationRemedyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CancellationRemedy &&
        code == other.code &&
        available == other.available &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CancellationRemedy')
          ..add('code', code)
          ..add('available', available)
          ..add('note', note))
        .toString();
  }
}

class CancellationRemedyBuilder
    implements Builder<CancellationRemedy, CancellationRemedyBuilder> {
  _$CancellationRemedy? _$v;

  CancellationRemedyCodeEnum? _code;
  CancellationRemedyCodeEnum? get code => _$this._code;
  set code(CancellationRemedyCodeEnum? code) => _$this._code = code;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CancellationRemedyBuilder() {
    CancellationRemedy._defaults(this);
  }

  CancellationRemedyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _available = $v.available;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CancellationRemedy other) {
    _$v = other as _$CancellationRemedy;
  }

  @override
  void update(void Function(CancellationRemedyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CancellationRemedy build() => _build();

  _$CancellationRemedy _build() {
    final _$result = _$v ??
        _$CancellationRemedy._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'CancellationRemedy', 'code'),
          available: BuiltValueNullFieldError.checkNotNull(
              available, r'CancellationRemedy', 'available'),
          note: BuiltValueNullFieldError.checkNotNull(
              note, r'CancellationRemedy', 'note'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
