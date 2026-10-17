// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_export_input.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DocumentExportInputTypeEnum _$documentExportInputTypeEnum_PURCHASE_ORDER =
    const DocumentExportInputTypeEnum._('PURCHASE_ORDER');
const DocumentExportInputTypeEnum
    _$documentExportInputTypeEnum_PAYMENT_CONFIRMATION =
    const DocumentExportInputTypeEnum._('PAYMENT_CONFIRMATION');
const DocumentExportInputTypeEnum
    _$documentExportInputTypeEnum_PROJECT_SUMMARY =
    const DocumentExportInputTypeEnum._('PROJECT_SUMMARY');
const DocumentExportInputTypeEnum _$documentExportInputTypeEnum_BUDGET_REPORT =
    const DocumentExportInputTypeEnum._('BUDGET_REPORT');
const DocumentExportInputTypeEnum
    _$documentExportInputTypeEnum_OPERATIONAL_ORDER =
    const DocumentExportInputTypeEnum._('OPERATIONAL_ORDER');
const DocumentExportInputTypeEnum _$documentExportInputTypeEnum_FEE_STATEMENT =
    const DocumentExportInputTypeEnum._('FEE_STATEMENT');
const DocumentExportInputTypeEnum
    _$documentExportInputTypeEnum_MATERIALS_ANALYTICS =
    const DocumentExportInputTypeEnum._('MATERIALS_ANALYTICS');
const DocumentExportInputTypeEnum _$documentExportInputTypeEnum_TAX_PACKAGE =
    const DocumentExportInputTypeEnum._('TAX_PACKAGE');
const DocumentExportInputTypeEnum _$documentExportInputTypeEnum_AUDIT_LOG =
    const DocumentExportInputTypeEnum._('AUDIT_LOG');
const DocumentExportInputTypeEnum _$documentExportInputTypeEnum_GEO_ANALYTICS =
    const DocumentExportInputTypeEnum._('GEO_ANALYTICS');
const DocumentExportInputTypeEnum
    _$documentExportInputTypeEnum_TRANSACTION_HISTORY =
    const DocumentExportInputTypeEnum._('TRANSACTION_HISTORY');
const DocumentExportInputTypeEnum _$documentExportInputTypeEnum_EARNINGS =
    const DocumentExportInputTypeEnum._('EARNINGS');

DocumentExportInputTypeEnum _$documentExportInputTypeEnumValueOf(String name) {
  switch (name) {
    case 'PURCHASE_ORDER':
      return _$documentExportInputTypeEnum_PURCHASE_ORDER;
    case 'PAYMENT_CONFIRMATION':
      return _$documentExportInputTypeEnum_PAYMENT_CONFIRMATION;
    case 'PROJECT_SUMMARY':
      return _$documentExportInputTypeEnum_PROJECT_SUMMARY;
    case 'BUDGET_REPORT':
      return _$documentExportInputTypeEnum_BUDGET_REPORT;
    case 'OPERATIONAL_ORDER':
      return _$documentExportInputTypeEnum_OPERATIONAL_ORDER;
    case 'FEE_STATEMENT':
      return _$documentExportInputTypeEnum_FEE_STATEMENT;
    case 'MATERIALS_ANALYTICS':
      return _$documentExportInputTypeEnum_MATERIALS_ANALYTICS;
    case 'TAX_PACKAGE':
      return _$documentExportInputTypeEnum_TAX_PACKAGE;
    case 'AUDIT_LOG':
      return _$documentExportInputTypeEnum_AUDIT_LOG;
    case 'GEO_ANALYTICS':
      return _$documentExportInputTypeEnum_GEO_ANALYTICS;
    case 'TRANSACTION_HISTORY':
      return _$documentExportInputTypeEnum_TRANSACTION_HISTORY;
    case 'EARNINGS':
      return _$documentExportInputTypeEnum_EARNINGS;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DocumentExportInputTypeEnum>
    _$documentExportInputTypeEnumValues =
    BuiltSet<DocumentExportInputTypeEnum>(const <DocumentExportInputTypeEnum>[
  _$documentExportInputTypeEnum_PURCHASE_ORDER,
  _$documentExportInputTypeEnum_PAYMENT_CONFIRMATION,
  _$documentExportInputTypeEnum_PROJECT_SUMMARY,
  _$documentExportInputTypeEnum_BUDGET_REPORT,
  _$documentExportInputTypeEnum_OPERATIONAL_ORDER,
  _$documentExportInputTypeEnum_FEE_STATEMENT,
  _$documentExportInputTypeEnum_MATERIALS_ANALYTICS,
  _$documentExportInputTypeEnum_TAX_PACKAGE,
  _$documentExportInputTypeEnum_AUDIT_LOG,
  _$documentExportInputTypeEnum_GEO_ANALYTICS,
  _$documentExportInputTypeEnum_TRANSACTION_HISTORY,
  _$documentExportInputTypeEnum_EARNINGS,
]);

const DocumentExportInputFormatEnum _$documentExportInputFormatEnum_PDF =
    const DocumentExportInputFormatEnum._('PDF');
const DocumentExportInputFormatEnum _$documentExportInputFormatEnum_CSV =
    const DocumentExportInputFormatEnum._('CSV');

DocumentExportInputFormatEnum _$documentExportInputFormatEnumValueOf(
    String name) {
  switch (name) {
    case 'PDF':
      return _$documentExportInputFormatEnum_PDF;
    case 'CSV':
      return _$documentExportInputFormatEnum_CSV;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DocumentExportInputFormatEnum>
    _$documentExportInputFormatEnumValues = BuiltSet<
        DocumentExportInputFormatEnum>(const <DocumentExportInputFormatEnum>[
  _$documentExportInputFormatEnum_PDF,
  _$documentExportInputFormatEnum_CSV,
]);

Serializer<DocumentExportInputTypeEnum>
    _$documentExportInputTypeEnumSerializer =
    _$DocumentExportInputTypeEnumSerializer();
Serializer<DocumentExportInputFormatEnum>
    _$documentExportInputFormatEnumSerializer =
    _$DocumentExportInputFormatEnumSerializer();

class _$DocumentExportInputTypeEnumSerializer
    implements PrimitiveSerializer<DocumentExportInputTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PURCHASE_ORDER': 'PURCHASE_ORDER',
    'PAYMENT_CONFIRMATION': 'PAYMENT_CONFIRMATION',
    'PROJECT_SUMMARY': 'PROJECT_SUMMARY',
    'BUDGET_REPORT': 'BUDGET_REPORT',
    'OPERATIONAL_ORDER': 'OPERATIONAL_ORDER',
    'FEE_STATEMENT': 'FEE_STATEMENT',
    'MATERIALS_ANALYTICS': 'MATERIALS_ANALYTICS',
    'TAX_PACKAGE': 'TAX_PACKAGE',
    'AUDIT_LOG': 'AUDIT_LOG',
    'GEO_ANALYTICS': 'GEO_ANALYTICS',
    'TRANSACTION_HISTORY': 'TRANSACTION_HISTORY',
    'EARNINGS': 'EARNINGS',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PURCHASE_ORDER': 'PURCHASE_ORDER',
    'PAYMENT_CONFIRMATION': 'PAYMENT_CONFIRMATION',
    'PROJECT_SUMMARY': 'PROJECT_SUMMARY',
    'BUDGET_REPORT': 'BUDGET_REPORT',
    'OPERATIONAL_ORDER': 'OPERATIONAL_ORDER',
    'FEE_STATEMENT': 'FEE_STATEMENT',
    'MATERIALS_ANALYTICS': 'MATERIALS_ANALYTICS',
    'TAX_PACKAGE': 'TAX_PACKAGE',
    'AUDIT_LOG': 'AUDIT_LOG',
    'GEO_ANALYTICS': 'GEO_ANALYTICS',
    'TRANSACTION_HISTORY': 'TRANSACTION_HISTORY',
    'EARNINGS': 'EARNINGS',
  };

  @override
  final Iterable<Type> types = const <Type>[DocumentExportInputTypeEnum];
  @override
  final String wireName = 'DocumentExportInputTypeEnum';

  @override
  Object serialize(Serializers serializers, DocumentExportInputTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DocumentExportInputTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DocumentExportInputTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DocumentExportInputFormatEnumSerializer
    implements PrimitiveSerializer<DocumentExportInputFormatEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PDF': 'PDF',
    'CSV': 'CSV',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PDF': 'PDF',
    'CSV': 'CSV',
  };

  @override
  final Iterable<Type> types = const <Type>[DocumentExportInputFormatEnum];
  @override
  final String wireName = 'DocumentExportInputFormatEnum';

  @override
  Object serialize(
          Serializers serializers, DocumentExportInputFormatEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DocumentExportInputFormatEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DocumentExportInputFormatEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DocumentExportInput extends DocumentExportInput {
  @override
  final DocumentExportInputTypeEnum type;
  @override
  final DocumentExportInputFormatEnum format;
  @override
  final String? resourceId;
  @override
  final String purpose;
  @override
  final BuiltMap<String, JsonObject?>? filters;

  factory _$DocumentExportInput(
          [void Function(DocumentExportInputBuilder)? updates]) =>
      (DocumentExportInputBuilder()..update(updates))._build();

  _$DocumentExportInput._(
      {required this.type,
      required this.format,
      this.resourceId,
      required this.purpose,
      this.filters})
      : super._();
  @override
  DocumentExportInput rebuild(
          void Function(DocumentExportInputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DocumentExportInputBuilder toBuilder() =>
      DocumentExportInputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DocumentExportInput &&
        type == other.type &&
        format == other.format &&
        resourceId == other.resourceId &&
        purpose == other.purpose &&
        filters == other.filters;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, format.hashCode);
    _$hash = $jc(_$hash, resourceId.hashCode);
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, filters.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DocumentExportInput')
          ..add('type', type)
          ..add('format', format)
          ..add('resourceId', resourceId)
          ..add('purpose', purpose)
          ..add('filters', filters))
        .toString();
  }
}

class DocumentExportInputBuilder
    implements Builder<DocumentExportInput, DocumentExportInputBuilder> {
  _$DocumentExportInput? _$v;

  DocumentExportInputTypeEnum? _type;
  DocumentExportInputTypeEnum? get type => _$this._type;
  set type(DocumentExportInputTypeEnum? type) => _$this._type = type;

  DocumentExportInputFormatEnum? _format;
  DocumentExportInputFormatEnum? get format => _$this._format;
  set format(DocumentExportInputFormatEnum? format) => _$this._format = format;

  String? _resourceId;
  String? get resourceId => _$this._resourceId;
  set resourceId(String? resourceId) => _$this._resourceId = resourceId;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  MapBuilder<String, JsonObject?>? _filters;
  MapBuilder<String, JsonObject?> get filters =>
      _$this._filters ??= MapBuilder<String, JsonObject?>();
  set filters(MapBuilder<String, JsonObject?>? filters) =>
      _$this._filters = filters;

  DocumentExportInputBuilder() {
    DocumentExportInput._defaults(this);
  }

  DocumentExportInputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _format = $v.format;
      _resourceId = $v.resourceId;
      _purpose = $v.purpose;
      _filters = $v.filters?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DocumentExportInput other) {
    _$v = other as _$DocumentExportInput;
  }

  @override
  void update(void Function(DocumentExportInputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DocumentExportInput build() => _build();

  _$DocumentExportInput _build() {
    _$DocumentExportInput _$result;
    try {
      _$result = _$v ??
          _$DocumentExportInput._(
            type: BuiltValueNullFieldError.checkNotNull(
                type, r'DocumentExportInput', 'type'),
            format: BuiltValueNullFieldError.checkNotNull(
                format, r'DocumentExportInput', 'format'),
            resourceId: resourceId,
            purpose: BuiltValueNullFieldError.checkNotNull(
                purpose, r'DocumentExportInput', 'purpose'),
            filters: _filters?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'filters';
        _filters?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DocumentExportInput', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
