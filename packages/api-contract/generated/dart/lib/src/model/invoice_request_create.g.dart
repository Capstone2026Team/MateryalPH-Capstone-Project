// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_request_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const InvoiceRequestCreateKindEnum _$invoiceRequestCreateKindEnum_COPY =
    const InvoiceRequestCreateKindEnum._('COPY');
const InvoiceRequestCreateKindEnum _$invoiceRequestCreateKindEnum_CORRECTION =
    const InvoiceRequestCreateKindEnum._('CORRECTION');

InvoiceRequestCreateKindEnum _$invoiceRequestCreateKindEnumValueOf(
    String name) {
  switch (name) {
    case 'COPY':
      return _$invoiceRequestCreateKindEnum_COPY;
    case 'CORRECTION':
      return _$invoiceRequestCreateKindEnum_CORRECTION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<InvoiceRequestCreateKindEnum>
    _$invoiceRequestCreateKindEnumValues =
    BuiltSet<InvoiceRequestCreateKindEnum>(const <InvoiceRequestCreateKindEnum>[
  _$invoiceRequestCreateKindEnum_COPY,
  _$invoiceRequestCreateKindEnum_CORRECTION,
]);

Serializer<InvoiceRequestCreateKindEnum>
    _$invoiceRequestCreateKindEnumSerializer =
    _$InvoiceRequestCreateKindEnumSerializer();

class _$InvoiceRequestCreateKindEnumSerializer
    implements PrimitiveSerializer<InvoiceRequestCreateKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'COPY': 'COPY',
    'CORRECTION': 'CORRECTION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'COPY': 'COPY',
    'CORRECTION': 'CORRECTION',
  };

  @override
  final Iterable<Type> types = const <Type>[InvoiceRequestCreateKindEnum];
  @override
  final String wireName = 'InvoiceRequestCreateKindEnum';

  @override
  Object serialize(Serializers serializers, InvoiceRequestCreateKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  InvoiceRequestCreateKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      InvoiceRequestCreateKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$InvoiceRequestCreate extends InvoiceRequestCreate {
  @override
  final InvoiceRequestCreateKindEnum kind;
  @override
  final String details;
  @override
  final String? invoiceRecordId;

  factory _$InvoiceRequestCreate(
          [void Function(InvoiceRequestCreateBuilder)? updates]) =>
      (InvoiceRequestCreateBuilder()..update(updates))._build();

  _$InvoiceRequestCreate._(
      {required this.kind, required this.details, this.invoiceRecordId})
      : super._();
  @override
  InvoiceRequestCreate rebuild(
          void Function(InvoiceRequestCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InvoiceRequestCreateBuilder toBuilder() =>
      InvoiceRequestCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InvoiceRequestCreate &&
        kind == other.kind &&
        details == other.details &&
        invoiceRecordId == other.invoiceRecordId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jc(_$hash, invoiceRecordId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InvoiceRequestCreate')
          ..add('kind', kind)
          ..add('details', details)
          ..add('invoiceRecordId', invoiceRecordId))
        .toString();
  }
}

class InvoiceRequestCreateBuilder
    implements Builder<InvoiceRequestCreate, InvoiceRequestCreateBuilder> {
  _$InvoiceRequestCreate? _$v;

  InvoiceRequestCreateKindEnum? _kind;
  InvoiceRequestCreateKindEnum? get kind => _$this._kind;
  set kind(InvoiceRequestCreateKindEnum? kind) => _$this._kind = kind;

  String? _details;
  String? get details => _$this._details;
  set details(String? details) => _$this._details = details;

  String? _invoiceRecordId;
  String? get invoiceRecordId => _$this._invoiceRecordId;
  set invoiceRecordId(String? invoiceRecordId) =>
      _$this._invoiceRecordId = invoiceRecordId;

  InvoiceRequestCreateBuilder() {
    InvoiceRequestCreate._defaults(this);
  }

  InvoiceRequestCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _details = $v.details;
      _invoiceRecordId = $v.invoiceRecordId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InvoiceRequestCreate other) {
    _$v = other as _$InvoiceRequestCreate;
  }

  @override
  void update(void Function(InvoiceRequestCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InvoiceRequestCreate build() => _build();

  _$InvoiceRequestCreate _build() {
    final _$result = _$v ??
        _$InvoiceRequestCreate._(
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'InvoiceRequestCreate', 'kind'),
          details: BuiltValueNullFieldError.checkNotNull(
              details, r'InvoiceRequestCreate', 'details'),
          invoiceRecordId: invoiceRecordId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
