// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_document_ref.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PlatformDocumentRefKindEnum _$platformDocumentRefKindEnum_PURCHASE_ORDER =
    const PlatformDocumentRefKindEnum._('PURCHASE_ORDER');
const PlatformDocumentRefKindEnum
    _$platformDocumentRefKindEnum_PAYMENT_CONFIRMATION =
    const PlatformDocumentRefKindEnum._('PAYMENT_CONFIRMATION');

PlatformDocumentRefKindEnum _$platformDocumentRefKindEnumValueOf(String name) {
  switch (name) {
    case 'PURCHASE_ORDER':
      return _$platformDocumentRefKindEnum_PURCHASE_ORDER;
    case 'PAYMENT_CONFIRMATION':
      return _$platformDocumentRefKindEnum_PAYMENT_CONFIRMATION;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlatformDocumentRefKindEnum>
    _$platformDocumentRefKindEnumValues =
    BuiltSet<PlatformDocumentRefKindEnum>(const <PlatformDocumentRefKindEnum>[
  _$platformDocumentRefKindEnum_PURCHASE_ORDER,
  _$platformDocumentRefKindEnum_PAYMENT_CONFIRMATION,
]);

const PlatformDocumentRefLabelEnum
    _$platformDocumentRefLabelEnum_notATaxInvoice =
    const PlatformDocumentRefLabelEnum._('notATaxInvoice');

PlatformDocumentRefLabelEnum _$platformDocumentRefLabelEnumValueOf(
    String name) {
  switch (name) {
    case 'notATaxInvoice':
      return _$platformDocumentRefLabelEnum_notATaxInvoice;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlatformDocumentRefLabelEnum>
    _$platformDocumentRefLabelEnumValues =
    BuiltSet<PlatformDocumentRefLabelEnum>(const <PlatformDocumentRefLabelEnum>[
  _$platformDocumentRefLabelEnum_notATaxInvoice,
]);

Serializer<PlatformDocumentRefKindEnum>
    _$platformDocumentRefKindEnumSerializer =
    _$PlatformDocumentRefKindEnumSerializer();
Serializer<PlatformDocumentRefLabelEnum>
    _$platformDocumentRefLabelEnumSerializer =
    _$PlatformDocumentRefLabelEnumSerializer();

class _$PlatformDocumentRefKindEnumSerializer
    implements PrimitiveSerializer<PlatformDocumentRefKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PURCHASE_ORDER': 'PURCHASE_ORDER',
    'PAYMENT_CONFIRMATION': 'PAYMENT_CONFIRMATION',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PURCHASE_ORDER': 'PURCHASE_ORDER',
    'PAYMENT_CONFIRMATION': 'PAYMENT_CONFIRMATION',
  };

  @override
  final Iterable<Type> types = const <Type>[PlatformDocumentRefKindEnum];
  @override
  final String wireName = 'PlatformDocumentRefKindEnum';

  @override
  Object serialize(Serializers serializers, PlatformDocumentRefKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PlatformDocumentRefKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PlatformDocumentRefKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PlatformDocumentRefLabelEnumSerializer
    implements PrimitiveSerializer<PlatformDocumentRefLabelEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'notATaxInvoice': 'Not a tax invoice',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'Not a tax invoice': 'notATaxInvoice',
  };

  @override
  final Iterable<Type> types = const <Type>[PlatformDocumentRefLabelEnum];
  @override
  final String wireName = 'PlatformDocumentRefLabelEnum';

  @override
  Object serialize(Serializers serializers, PlatformDocumentRefLabelEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PlatformDocumentRefLabelEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PlatformDocumentRefLabelEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PlatformDocumentRef extends PlatformDocumentRef {
  @override
  final PlatformDocumentRefKindEnum kind;
  @override
  final String title;
  @override
  final bool notTaxInvoice;
  @override
  final PlatformDocumentRefLabelEnum label;
  @override
  final String availability;

  factory _$PlatformDocumentRef(
          [void Function(PlatformDocumentRefBuilder)? updates]) =>
      (PlatformDocumentRefBuilder()..update(updates))._build();

  _$PlatformDocumentRef._(
      {required this.kind,
      required this.title,
      required this.notTaxInvoice,
      required this.label,
      required this.availability})
      : super._();
  @override
  PlatformDocumentRef rebuild(
          void Function(PlatformDocumentRefBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlatformDocumentRefBuilder toBuilder() =>
      PlatformDocumentRefBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlatformDocumentRef &&
        kind == other.kind &&
        title == other.title &&
        notTaxInvoice == other.notTaxInvoice &&
        label == other.label &&
        availability == other.availability;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, notTaxInvoice.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, availability.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlatformDocumentRef')
          ..add('kind', kind)
          ..add('title', title)
          ..add('notTaxInvoice', notTaxInvoice)
          ..add('label', label)
          ..add('availability', availability))
        .toString();
  }
}

class PlatformDocumentRefBuilder
    implements Builder<PlatformDocumentRef, PlatformDocumentRefBuilder> {
  _$PlatformDocumentRef? _$v;

  PlatformDocumentRefKindEnum? _kind;
  PlatformDocumentRefKindEnum? get kind => _$this._kind;
  set kind(PlatformDocumentRefKindEnum? kind) => _$this._kind = kind;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  bool? _notTaxInvoice;
  bool? get notTaxInvoice => _$this._notTaxInvoice;
  set notTaxInvoice(bool? notTaxInvoice) =>
      _$this._notTaxInvoice = notTaxInvoice;

  PlatformDocumentRefLabelEnum? _label;
  PlatformDocumentRefLabelEnum? get label => _$this._label;
  set label(PlatformDocumentRefLabelEnum? label) => _$this._label = label;

  String? _availability;
  String? get availability => _$this._availability;
  set availability(String? availability) => _$this._availability = availability;

  PlatformDocumentRefBuilder() {
    PlatformDocumentRef._defaults(this);
  }

  PlatformDocumentRefBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _title = $v.title;
      _notTaxInvoice = $v.notTaxInvoice;
      _label = $v.label;
      _availability = $v.availability;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlatformDocumentRef other) {
    _$v = other as _$PlatformDocumentRef;
  }

  @override
  void update(void Function(PlatformDocumentRefBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlatformDocumentRef build() => _build();

  _$PlatformDocumentRef _build() {
    final _$result = _$v ??
        _$PlatformDocumentRef._(
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'PlatformDocumentRef', 'kind'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'PlatformDocumentRef', 'title'),
          notTaxInvoice: BuiltValueNullFieldError.checkNotNull(
              notTaxInvoice, r'PlatformDocumentRef', 'notTaxInvoice'),
          label: BuiltValueNullFieldError.checkNotNull(
              label, r'PlatformDocumentRef', 'label'),
          availability: BuiltValueNullFieldError.checkNotNull(
              availability, r'PlatformDocumentRef', 'availability'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
