// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_evidence.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ComplianceEvidenceEvidenceKindEnum
    _$complianceEvidenceEvidenceKindEnum_MARKING_PHOTO =
    const ComplianceEvidenceEvidenceKindEnum._('MARKING_PHOTO');
const ComplianceEvidenceEvidenceKindEnum
    _$complianceEvidenceEvidenceKindEnum_QR_IMAGE =
    const ComplianceEvidenceEvidenceKindEnum._('QR_IMAGE');

ComplianceEvidenceEvidenceKindEnum _$complianceEvidenceEvidenceKindEnumValueOf(
    String name) {
  switch (name) {
    case 'MARKING_PHOTO':
      return _$complianceEvidenceEvidenceKindEnum_MARKING_PHOTO;
    case 'QR_IMAGE':
      return _$complianceEvidenceEvidenceKindEnum_QR_IMAGE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ComplianceEvidenceEvidenceKindEnum>
    _$complianceEvidenceEvidenceKindEnumValues = BuiltSet<
        ComplianceEvidenceEvidenceKindEnum>(const <ComplianceEvidenceEvidenceKindEnum>[
  _$complianceEvidenceEvidenceKindEnum_MARKING_PHOTO,
  _$complianceEvidenceEvidenceKindEnum_QR_IMAGE,
]);

Serializer<ComplianceEvidenceEvidenceKindEnum>
    _$complianceEvidenceEvidenceKindEnumSerializer =
    _$ComplianceEvidenceEvidenceKindEnumSerializer();

class _$ComplianceEvidenceEvidenceKindEnumSerializer
    implements PrimitiveSerializer<ComplianceEvidenceEvidenceKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MARKING_PHOTO': 'MARKING_PHOTO',
    'QR_IMAGE': 'QR_IMAGE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MARKING_PHOTO': 'MARKING_PHOTO',
    'QR_IMAGE': 'QR_IMAGE',
  };

  @override
  final Iterable<Type> types = const <Type>[ComplianceEvidenceEvidenceKindEnum];
  @override
  final String wireName = 'ComplianceEvidenceEvidenceKindEnum';

  @override
  Object serialize(
          Serializers serializers, ComplianceEvidenceEvidenceKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ComplianceEvidenceEvidenceKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ComplianceEvidenceEvidenceKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ComplianceEvidence extends ComplianceEvidence {
  @override
  final String evidenceId;
  @override
  final String fileId;
  @override
  final CompliancePath path;
  @override
  final ComplianceEvidenceEvidenceKindEnum evidenceKind;
  @override
  final String contentType;
  @override
  final int byteSize;
  @override
  final String scanState;
  @override
  final ComplianceExtraction extraction;

  factory _$ComplianceEvidence(
          [void Function(ComplianceEvidenceBuilder)? updates]) =>
      (ComplianceEvidenceBuilder()..update(updates))._build();

  _$ComplianceEvidence._(
      {required this.evidenceId,
      required this.fileId,
      required this.path,
      required this.evidenceKind,
      required this.contentType,
      required this.byteSize,
      required this.scanState,
      required this.extraction})
      : super._();
  @override
  ComplianceEvidence rebuild(
          void Function(ComplianceEvidenceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplianceEvidenceBuilder toBuilder() =>
      ComplianceEvidenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplianceEvidence &&
        evidenceId == other.evidenceId &&
        fileId == other.fileId &&
        path == other.path &&
        evidenceKind == other.evidenceKind &&
        contentType == other.contentType &&
        byteSize == other.byteSize &&
        scanState == other.scanState &&
        extraction == other.extraction;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, evidenceId.hashCode);
    _$hash = $jc(_$hash, fileId.hashCode);
    _$hash = $jc(_$hash, path.hashCode);
    _$hash = $jc(_$hash, evidenceKind.hashCode);
    _$hash = $jc(_$hash, contentType.hashCode);
    _$hash = $jc(_$hash, byteSize.hashCode);
    _$hash = $jc(_$hash, scanState.hashCode);
    _$hash = $jc(_$hash, extraction.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplianceEvidence')
          ..add('evidenceId', evidenceId)
          ..add('fileId', fileId)
          ..add('path', path)
          ..add('evidenceKind', evidenceKind)
          ..add('contentType', contentType)
          ..add('byteSize', byteSize)
          ..add('scanState', scanState)
          ..add('extraction', extraction))
        .toString();
  }
}

class ComplianceEvidenceBuilder
    implements Builder<ComplianceEvidence, ComplianceEvidenceBuilder> {
  _$ComplianceEvidence? _$v;

  String? _evidenceId;
  String? get evidenceId => _$this._evidenceId;
  set evidenceId(String? evidenceId) => _$this._evidenceId = evidenceId;

  String? _fileId;
  String? get fileId => _$this._fileId;
  set fileId(String? fileId) => _$this._fileId = fileId;

  CompliancePath? _path;
  CompliancePath? get path => _$this._path;
  set path(CompliancePath? path) => _$this._path = path;

  ComplianceEvidenceEvidenceKindEnum? _evidenceKind;
  ComplianceEvidenceEvidenceKindEnum? get evidenceKind => _$this._evidenceKind;
  set evidenceKind(ComplianceEvidenceEvidenceKindEnum? evidenceKind) =>
      _$this._evidenceKind = evidenceKind;

  String? _contentType;
  String? get contentType => _$this._contentType;
  set contentType(String? contentType) => _$this._contentType = contentType;

  int? _byteSize;
  int? get byteSize => _$this._byteSize;
  set byteSize(int? byteSize) => _$this._byteSize = byteSize;

  String? _scanState;
  String? get scanState => _$this._scanState;
  set scanState(String? scanState) => _$this._scanState = scanState;

  ComplianceExtractionBuilder? _extraction;
  ComplianceExtractionBuilder get extraction =>
      _$this._extraction ??= ComplianceExtractionBuilder();
  set extraction(ComplianceExtractionBuilder? extraction) =>
      _$this._extraction = extraction;

  ComplianceEvidenceBuilder() {
    ComplianceEvidence._defaults(this);
  }

  ComplianceEvidenceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _evidenceId = $v.evidenceId;
      _fileId = $v.fileId;
      _path = $v.path;
      _evidenceKind = $v.evidenceKind;
      _contentType = $v.contentType;
      _byteSize = $v.byteSize;
      _scanState = $v.scanState;
      _extraction = $v.extraction.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplianceEvidence other) {
    _$v = other as _$ComplianceEvidence;
  }

  @override
  void update(void Function(ComplianceEvidenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplianceEvidence build() => _build();

  _$ComplianceEvidence _build() {
    _$ComplianceEvidence _$result;
    try {
      _$result = _$v ??
          _$ComplianceEvidence._(
            evidenceId: BuiltValueNullFieldError.checkNotNull(
                evidenceId, r'ComplianceEvidence', 'evidenceId'),
            fileId: BuiltValueNullFieldError.checkNotNull(
                fileId, r'ComplianceEvidence', 'fileId'),
            path: BuiltValueNullFieldError.checkNotNull(
                path, r'ComplianceEvidence', 'path'),
            evidenceKind: BuiltValueNullFieldError.checkNotNull(
                evidenceKind, r'ComplianceEvidence', 'evidenceKind'),
            contentType: BuiltValueNullFieldError.checkNotNull(
                contentType, r'ComplianceEvidence', 'contentType'),
            byteSize: BuiltValueNullFieldError.checkNotNull(
                byteSize, r'ComplianceEvidence', 'byteSize'),
            scanState: BuiltValueNullFieldError.checkNotNull(
                scanState, r'ComplianceEvidence', 'scanState'),
            extraction: extraction.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'extraction';
        extraction.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ComplianceEvidence', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
