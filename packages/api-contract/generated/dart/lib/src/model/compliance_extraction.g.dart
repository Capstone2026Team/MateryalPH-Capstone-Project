// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_extraction.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComplianceExtractionSource_Enum _$complianceExtractionSourceEnum_OCR =
    const ComplianceExtractionSource_Enum._('OCR');
const ComplianceExtractionSource_Enum _$complianceExtractionSourceEnum_QR =
    const ComplianceExtractionSource_Enum._('QR');

ComplianceExtractionSource_Enum _$complianceExtractionSourceEnumValueOf(
    String name) {
  switch (name) {
    case 'OCR':
      return _$complianceExtractionSourceEnum_OCR;
    case 'QR':
      return _$complianceExtractionSourceEnum_QR;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceExtractionSource_Enum>
    _$complianceExtractionSourceEnumValues = BuiltSet<
        ComplianceExtractionSource_Enum>(const <ComplianceExtractionSource_Enum>[
  _$complianceExtractionSourceEnum_OCR,
  _$complianceExtractionSourceEnum_QR,
]);

const ComplianceExtractionStatusEnum
    _$complianceExtractionStatusEnum_EXTRACTED =
    const ComplianceExtractionStatusEnum._('EXTRACTED');
const ComplianceExtractionStatusEnum
    _$complianceExtractionStatusEnum_UNAVAILABLE =
    const ComplianceExtractionStatusEnum._('UNAVAILABLE');
const ComplianceExtractionStatusEnum _$complianceExtractionStatusEnum_FAILED =
    const ComplianceExtractionStatusEnum._('FAILED');
const ComplianceExtractionStatusEnum
    _$complianceExtractionStatusEnum_NOT_REQUESTED =
    const ComplianceExtractionStatusEnum._('NOT_REQUESTED');

ComplianceExtractionStatusEnum _$complianceExtractionStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'EXTRACTED':
      return _$complianceExtractionStatusEnum_EXTRACTED;
    case 'UNAVAILABLE':
      return _$complianceExtractionStatusEnum_UNAVAILABLE;
    case 'FAILED':
      return _$complianceExtractionStatusEnum_FAILED;
    case 'NOT_REQUESTED':
      return _$complianceExtractionStatusEnum_NOT_REQUESTED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceExtractionStatusEnum>
    _$complianceExtractionStatusEnumValues = BuiltSet<
        ComplianceExtractionStatusEnum>(const <ComplianceExtractionStatusEnum>[
  _$complianceExtractionStatusEnum_EXTRACTED,
  _$complianceExtractionStatusEnum_UNAVAILABLE,
  _$complianceExtractionStatusEnum_FAILED,
  _$complianceExtractionStatusEnum_NOT_REQUESTED,
]);

Serializer<ComplianceExtractionSource_Enum>
    _$complianceExtractionSourceEnumSerializer =
    _$ComplianceExtractionSource_EnumSerializer();
Serializer<ComplianceExtractionStatusEnum>
    _$complianceExtractionStatusEnumSerializer =
    _$ComplianceExtractionStatusEnumSerializer();

class _$ComplianceExtractionSource_EnumSerializer
    implements PrimitiveSerializer<ComplianceExtractionSource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'OCR': 'OCR',
    'QR': 'QR',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'OCR': 'OCR',
    'QR': 'QR',
  };

  @override
  final Iterable<Type> types = const <Type>[ComplianceExtractionSource_Enum];
  @override
  final String wireName = 'ComplianceExtractionSource_Enum';

  @override
  Object serialize(
          Serializers serializers, ComplianceExtractionSource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceExtractionSource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceExtractionSource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceExtractionStatusEnumSerializer
    implements PrimitiveSerializer<ComplianceExtractionStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'EXTRACTED': 'EXTRACTED',
    'UNAVAILABLE': 'UNAVAILABLE',
    'FAILED': 'FAILED',
    'NOT_REQUESTED': 'NOT_REQUESTED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'EXTRACTED': 'EXTRACTED',
    'UNAVAILABLE': 'UNAVAILABLE',
    'FAILED': 'FAILED',
    'NOT_REQUESTED': 'NOT_REQUESTED',
  };

  @override
  final Iterable<Type> types = const <Type>[ComplianceExtractionStatusEnum];
  @override
  final String wireName = 'ComplianceExtractionStatusEnum';

  @override
  Object serialize(
          Serializers serializers, ComplianceExtractionStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceExtractionStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceExtractionStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceExtraction extends ComplianceExtraction {
  @override
  final ComplianceExtractionSource_Enum? source_;
  @override
  final ComplianceExtractionStatusEnum status;
  @override
  final num? confidence;
  @override
  final BuiltMap<String, String> suggestions;
  @override
  final bool? assistanceOnly;

  factory _$ComplianceExtraction(
          [void Function(ComplianceExtractionBuilder)? updates]) =>
      (ComplianceExtractionBuilder()..update(updates))._build();

  _$ComplianceExtraction._(
      {this.source_,
      required this.status,
      this.confidence,
      required this.suggestions,
      this.assistanceOnly})
      : super._();
  @override
  ComplianceExtraction rebuild(
          void Function(ComplianceExtractionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceExtractionBuilder toBuilder() =>
      ComplianceExtractionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceExtraction &&
        source_ == other.source_ &&
        status == other.status &&
        confidence == other.confidence &&
        suggestions == other.suggestions &&
        assistanceOnly == other.assistanceOnly;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, confidence.hashCode);
    _$hash = $jc(_$hash, suggestions.hashCode);
    _$hash = $jc(_$hash, assistanceOnly.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplianceExtraction')
          ..add('source_', source_)
          ..add('status', status)
          ..add('confidence', confidence)
          ..add('suggestions', suggestions)
          ..add('assistanceOnly', assistanceOnly))
        .toString();
  }
}

class ComplianceExtractionBuilder
    implements Builder<ComplianceExtraction, ComplianceExtractionBuilder> {
  _$ComplianceExtraction? _$v;

  ComplianceExtractionSource_Enum? _source_;
  ComplianceExtractionSource_Enum? get source_ => _$this._source_;
  set source_(ComplianceExtractionSource_Enum? source_) =>
      _$this._source_ = source_;

  ComplianceExtractionStatusEnum? _status;
  ComplianceExtractionStatusEnum? get status => _$this._status;
  set status(ComplianceExtractionStatusEnum? status) => _$this._status = status;

  num? _confidence;
  num? get confidence => _$this._confidence;
  set confidence(num? confidence) => _$this._confidence = confidence;

  MapBuilder<String, String>? _suggestions;
  MapBuilder<String, String> get suggestions =>
      _$this._suggestions ??= MapBuilder<String, String>();
  set suggestions(MapBuilder<String, String>? suggestions) =>
      _$this._suggestions = suggestions;

  bool? _assistanceOnly;
  bool? get assistanceOnly => _$this._assistanceOnly;
  set assistanceOnly(bool? assistanceOnly) =>
      _$this._assistanceOnly = assistanceOnly;

  ComplianceExtractionBuilder() {
    ComplianceExtraction._defaults(this);
  }

  ComplianceExtractionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _source_ = $v.source_;
      _status = $v.status;
      _confidence = $v.confidence;
      _suggestions = $v.suggestions.toBuilder();
      _assistanceOnly = $v.assistanceOnly;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplianceExtraction other) {
    _$v = other as _$ComplianceExtraction;
  }

  @override
  void update(void Function(ComplianceExtractionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceExtraction build() => _build();

  _$ComplianceExtraction _build() {
    _$ComplianceExtraction _$result;
    try {
      _$result = _$v ??
          _$ComplianceExtraction._(
            source_: source_,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'ComplianceExtraction', 'status'),
            confidence: confidence,
            suggestions: suggestions.build(),
            assistanceOnly: assistanceOnly,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'suggestions';
        suggestions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ComplianceExtraction', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
