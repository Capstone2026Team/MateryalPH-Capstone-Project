// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directory_supplier_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DirectorySupplierSummarySource_Enum
    _$directorySupplierSummarySourceEnum_GOOGLE =
    const DirectorySupplierSummarySource_Enum._('GOOGLE');

DirectorySupplierSummarySource_Enum _$directorySupplierSummarySourceEnumValueOf(
    String name) {
  switch (name) {
    case 'GOOGLE':
      return _$directorySupplierSummarySourceEnum_GOOGLE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DirectorySupplierSummarySource_Enum>
    _$directorySupplierSummarySourceEnumValues = BuiltSet<
        DirectorySupplierSummarySource_Enum>(const <DirectorySupplierSummarySource_Enum>[
  _$directorySupplierSummarySourceEnum_GOOGLE,
]);

Serializer<DirectorySupplierSummarySource_Enum>
    _$directorySupplierSummarySourceEnumSerializer =
    _$DirectorySupplierSummarySource_EnumSerializer();

class _$DirectorySupplierSummarySource_EnumSerializer
    implements PrimitiveSerializer<DirectorySupplierSummarySource_Enum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'GOOGLE': 'GOOGLE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'GOOGLE': 'GOOGLE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    DirectorySupplierSummarySource_Enum
  ];
  @override
  final String wireName = 'DirectorySupplierSummarySource_Enum';

  @override
  Object serialize(
          Serializers serializers, DirectorySupplierSummarySource_Enum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DirectorySupplierSummarySource_Enum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DirectorySupplierSummarySource_Enum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DirectorySupplierSummary extends DirectorySupplierSummary {
  @override
  final String? formattedAddress;
  @override
  final String? primaryType;
  @override
  final DirectorySupplierSummarySource_Enum source_;
  @override
  final DateTime refreshedAt;

  factory _$DirectorySupplierSummary(
          [void Function(DirectorySupplierSummaryBuilder)? updates]) =>
      (DirectorySupplierSummaryBuilder()..update(updates))._build();

  _$DirectorySupplierSummary._(
      {this.formattedAddress,
      this.primaryType,
      required this.source_,
      required this.refreshedAt})
      : super._();
  @override
  DirectorySupplierSummary rebuild(
          void Function(DirectorySupplierSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DirectorySupplierSummaryBuilder toBuilder() =>
      DirectorySupplierSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DirectorySupplierSummary &&
        formattedAddress == other.formattedAddress &&
        primaryType == other.primaryType &&
        source_ == other.source_ &&
        refreshedAt == other.refreshedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, formattedAddress.hashCode);
    _$hash = $jc(_$hash, primaryType.hashCode);
    _$hash = $jc(_$hash, source_.hashCode);
    _$hash = $jc(_$hash, refreshedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DirectorySupplierSummary')
          ..add('formattedAddress', formattedAddress)
          ..add('primaryType', primaryType)
          ..add('source_', source_)
          ..add('refreshedAt', refreshedAt))
        .toString();
  }
}

class DirectorySupplierSummaryBuilder
    implements
        Builder<DirectorySupplierSummary, DirectorySupplierSummaryBuilder> {
  _$DirectorySupplierSummary? _$v;

  String? _formattedAddress;
  String? get formattedAddress => _$this._formattedAddress;
  set formattedAddress(String? formattedAddress) =>
      _$this._formattedAddress = formattedAddress;

  String? _primaryType;
  String? get primaryType => _$this._primaryType;
  set primaryType(String? primaryType) => _$this._primaryType = primaryType;

  DirectorySupplierSummarySource_Enum? _source_;
  DirectorySupplierSummarySource_Enum? get source_ => _$this._source_;
  set source_(DirectorySupplierSummarySource_Enum? source_) =>
      _$this._source_ = source_;

  DateTime? _refreshedAt;
  DateTime? get refreshedAt => _$this._refreshedAt;
  set refreshedAt(DateTime? refreshedAt) => _$this._refreshedAt = refreshedAt;

  DirectorySupplierSummaryBuilder() {
    DirectorySupplierSummary._defaults(this);
  }

  DirectorySupplierSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _formattedAddress = $v.formattedAddress;
      _primaryType = $v.primaryType;
      _source_ = $v.source_;
      _refreshedAt = $v.refreshedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DirectorySupplierSummary other) {
    _$v = other as _$DirectorySupplierSummary;
  }

  @override
  void update(void Function(DirectorySupplierSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DirectorySupplierSummary build() => _build();

  _$DirectorySupplierSummary _build() {
    final _$result = _$v ??
        _$DirectorySupplierSummary._(
          formattedAddress: formattedAddress,
          primaryType: primaryType,
          source_: BuiltValueNullFieldError.checkNotNull(
              source_, r'DirectorySupplierSummary', 'source_'),
          refreshedAt: BuiltValueNullFieldError.checkNotNull(
              refreshedAt, r'DirectorySupplierSummary', 'refreshedAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
