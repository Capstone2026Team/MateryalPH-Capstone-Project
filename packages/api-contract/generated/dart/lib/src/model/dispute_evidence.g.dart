// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_evidence.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DisputeEvidenceLabelEnum _$disputeEvidenceLabelEnum_ORIGINAL =
    const DisputeEvidenceLabelEnum._('ORIGINAL');
const DisputeEvidenceLabelEnum _$disputeEvidenceLabelEnum_SUPPLEMENTAL =
    const DisputeEvidenceLabelEnum._('SUPPLEMENTAL');
const DisputeEvidenceLabelEnum _$disputeEvidenceLabelEnum_RESPONSE =
    const DisputeEvidenceLabelEnum._('RESPONSE');
const DisputeEvidenceLabelEnum _$disputeEvidenceLabelEnum_CLARIFICATION =
    const DisputeEvidenceLabelEnum._('CLARIFICATION');
const DisputeEvidenceLabelEnum _$disputeEvidenceLabelEnum_APPEAL =
    const DisputeEvidenceLabelEnum._('APPEAL');
const DisputeEvidenceLabelEnum _$disputeEvidenceLabelEnum_FULFILLMENT =
    const DisputeEvidenceLabelEnum._('FULFILLMENT');
const DisputeEvidenceLabelEnum _$disputeEvidenceLabelEnum_REMEDY =
    const DisputeEvidenceLabelEnum._('REMEDY');

DisputeEvidenceLabelEnum _$disputeEvidenceLabelEnumValueOf(String name) {
  switch (name) {
    case 'ORIGINAL':
      return _$disputeEvidenceLabelEnum_ORIGINAL;
    case 'SUPPLEMENTAL':
      return _$disputeEvidenceLabelEnum_SUPPLEMENTAL;
    case 'RESPONSE':
      return _$disputeEvidenceLabelEnum_RESPONSE;
    case 'CLARIFICATION':
      return _$disputeEvidenceLabelEnum_CLARIFICATION;
    case 'APPEAL':
      return _$disputeEvidenceLabelEnum_APPEAL;
    case 'FULFILLMENT':
      return _$disputeEvidenceLabelEnum_FULFILLMENT;
    case 'REMEDY':
      return _$disputeEvidenceLabelEnum_REMEDY;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DisputeEvidenceLabelEnum> _$disputeEvidenceLabelEnumValues =
    BuiltSet<DisputeEvidenceLabelEnum>(const <DisputeEvidenceLabelEnum>[
  _$disputeEvidenceLabelEnum_ORIGINAL,
  _$disputeEvidenceLabelEnum_SUPPLEMENTAL,
  _$disputeEvidenceLabelEnum_RESPONSE,
  _$disputeEvidenceLabelEnum_CLARIFICATION,
  _$disputeEvidenceLabelEnum_APPEAL,
  _$disputeEvidenceLabelEnum_FULFILLMENT,
  _$disputeEvidenceLabelEnum_REMEDY,
]);

Serializer<DisputeEvidenceLabelEnum> _$disputeEvidenceLabelEnumSerializer =
    _$DisputeEvidenceLabelEnumSerializer();

class _$DisputeEvidenceLabelEnumSerializer
    implements PrimitiveSerializer<DisputeEvidenceLabelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ORIGINAL': 'ORIGINAL',
    'SUPPLEMENTAL': 'SUPPLEMENTAL',
    'RESPONSE': 'RESPONSE',
    'CLARIFICATION': 'CLARIFICATION',
    'APPEAL': 'APPEAL',
    'FULFILLMENT': 'FULFILLMENT',
    'REMEDY': 'REMEDY',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ORIGINAL': 'ORIGINAL',
    'SUPPLEMENTAL': 'SUPPLEMENTAL',
    'RESPONSE': 'RESPONSE',
    'CLARIFICATION': 'CLARIFICATION',
    'APPEAL': 'APPEAL',
    'FULFILLMENT': 'FULFILLMENT',
    'REMEDY': 'REMEDY',
  };

  @override
  final Iterable<Type> types = const <Type>[DisputeEvidenceLabelEnum];
  @override
  final String wireName = 'DisputeEvidenceLabelEnum';

  @override
  Object serialize(Serializers serializers, DisputeEvidenceLabelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DisputeEvidenceLabelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DisputeEvidenceLabelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DisputeEvidence extends DisputeEvidence {
  @override
  final String fileId;
  @override
  final DisputeEvidenceLabelEnum label;
  @override
  final String? description;
  @override
  final String contentType;
  @override
  final String name;
  @override
  final int byteSize;
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$DisputeEvidence([void Function(DisputeEvidenceBuilder)? updates]) =>
      (DisputeEvidenceBuilder()..update(updates))._build();

  _$DisputeEvidence._(
      {required this.fileId,
      required this.label,
      this.description,
      required this.contentType,
      required this.name,
      required this.byteSize,
      required this.url,
      required this.expiresAt})
      : super._();
  @override
  DisputeEvidence rebuild(void Function(DisputeEvidenceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisputeEvidenceBuilder toBuilder() => DisputeEvidenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisputeEvidence &&
        fileId == other.fileId &&
        label == other.label &&
        description == other.description &&
        contentType == other.contentType &&
        name == other.name &&
        byteSize == other.byteSize &&
        url == other.url &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fileId.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, byteSize.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisputeEvidence')
          ..add('fileId', fileId)
          ..add('label', label)
          ..add('description', description)
          ..add('contentType', contentType)
          ..add('name', name)
          ..add('byteSize', byteSize)
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class DisputeEvidenceBuilder
    implements Builder<DisputeEvidence, DisputeEvidenceBuilder> {
  _$DisputeEvidence? _$v;

  String? _fileId;
  String? get fileId => _$this._fileId;
  set fileId(String? fileId) => _$this._fileId = fileId;

  DisputeEvidenceLabelEnum? _label;
  DisputeEvidenceLabelEnum? get label => _$this._label;
  set label(DisputeEvidenceLabelEnum? label) => _$this._label = label;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _byteSize;
  int? get byteSize => _$this._byteSize;
  set byteSize(int? byteSize) => _$this._byteSize = byteSize;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DisputeEvidenceBuilder() {
    DisputeEvidence._defaults(this);
  }

  DisputeEvidenceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fileId = $v.fileId;
      _label = $v.label;
      _description = $v.description;
      _contentType = $v.contentType;
      _name = $v.name;
      _byteSize = $v.byteSize;
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisputeEvidence other) {
    _$v = other as _$DisputeEvidence;
  }

  @override
  void update(void Function(DisputeEvidenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisputeEvidence build() => _build();

  _$DisputeEvidence _build() {
    final _$result = _$v ??
        _$DisputeEvidence._(
          fileId: BuiltValueNullFieldError.checkNotNull(
              fileId, r'DisputeEvidence', 'fileId'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'DisputeEvidence', 'label'),
          description: description,
          contentType: BuiltValueNullFieldError.checkNotNull(
              contentType, r'DisputeEvidence', 'contentType'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'DisputeEvidence', 'name'),
          byteSize: BuiltValueNullFieldError.checkNotNull(
              byteSize, r'DisputeEvidence', 'byteSize'),
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'DisputeEvidence', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'DisputeEvidence', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
