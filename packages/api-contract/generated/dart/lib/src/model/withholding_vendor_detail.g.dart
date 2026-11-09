// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_vendor_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WithholdingVendorDetailDeclarationStateEnum
    _$withholdingVendorDetailDeclarationStateEnum_MISSING =
    const WithholdingVendorDetailDeclarationStateEnum._('MISSING');
const WithholdingVendorDetailDeclarationStateEnum
    _$withholdingVendorDetailDeclarationStateEnum_PENDING =
    const WithholdingVendorDetailDeclarationStateEnum._('PENDING');
const WithholdingVendorDetailDeclarationStateEnum
    _$withholdingVendorDetailDeclarationStateEnum_APPROVED =
    const WithholdingVendorDetailDeclarationStateEnum._('APPROVED');
const WithholdingVendorDetailDeclarationStateEnum
    _$withholdingVendorDetailDeclarationStateEnum_REJECTED =
    const WithholdingVendorDetailDeclarationStateEnum._('REJECTED');
const WithholdingVendorDetailDeclarationStateEnum
    _$withholdingVendorDetailDeclarationStateEnum_EXPIRED =
    const WithholdingVendorDetailDeclarationStateEnum._('EXPIRED');

WithholdingVendorDetailDeclarationStateEnum
    _$withholdingVendorDetailDeclarationStateEnumValueOf(String name) {
  switch (name) {
    case 'MISSING':
      return _$withholdingVendorDetailDeclarationStateEnum_MISSING;
    case 'PENDING':
      return _$withholdingVendorDetailDeclarationStateEnum_PENDING;
    case 'APPROVED':
      return _$withholdingVendorDetailDeclarationStateEnum_APPROVED;
    case 'REJECTED':
      return _$withholdingVendorDetailDeclarationStateEnum_REJECTED;
    case 'EXPIRED':
      return _$withholdingVendorDetailDeclarationStateEnum_EXPIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WithholdingVendorDetailDeclarationStateEnum>
    _$withholdingVendorDetailDeclarationStateEnumValues = BuiltSet<
        WithholdingVendorDetailDeclarationStateEnum>(const <WithholdingVendorDetailDeclarationStateEnum>[
  _$withholdingVendorDetailDeclarationStateEnum_MISSING,
  _$withholdingVendorDetailDeclarationStateEnum_PENDING,
  _$withholdingVendorDetailDeclarationStateEnum_APPROVED,
  _$withholdingVendorDetailDeclarationStateEnum_REJECTED,
  _$withholdingVendorDetailDeclarationStateEnum_EXPIRED,
]);

Serializer<WithholdingVendorDetailDeclarationStateEnum>
    _$withholdingVendorDetailDeclarationStateEnumSerializer =
    _$WithholdingVendorDetailDeclarationStateEnumSerializer();

class _$WithholdingVendorDetailDeclarationStateEnumSerializer
    implements
        PrimitiveSerializer<WithholdingVendorDetailDeclarationStateEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'MISSING': 'MISSING',
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'EXPIRED': 'EXPIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'MISSING': 'MISSING',
    'PENDING': 'PENDING',
    'APPROVED': 'APPROVED',
    'REJECTED': 'REJECTED',
    'EXPIRED': 'EXPIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WithholdingVendorDetailDeclarationStateEnum
  ];
  @override
  final String wireName = 'WithholdingVendorDetailDeclarationStateEnum';

  @override
  Object serialize(Serializers serializers,
          WithholdingVendorDetailDeclarationStateEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WithholdingVendorDetailDeclarationStateEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WithholdingVendorDetailDeclarationStateEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WithholdingVendorDetail extends WithholdingVendorDetail {
  @override
  final String vendorId;
  @override
  final String vendorName;
  @override
  final String month;
  @override
  final String withholdingEntity;
  @override
  final WithholdingVendorDetailDeclarationStateEnum declarationState;
  @override
  final WithholdingYearLimit? threshold;
  @override
  final BuiltList<WithholdingRecordedPayment> payments;

  factory _$WithholdingVendorDetail(
          [void Function(WithholdingVendorDetailBuilder)? updates]) =>
      (WithholdingVendorDetailBuilder()..update(updates))._build();

  _$WithholdingVendorDetail._(
      {required this.vendorId,
      required this.vendorName,
      required this.month,
      required this.withholdingEntity,
      required this.declarationState,
      this.threshold,
      required this.payments})
      : super._();
  @override
  WithholdingVendorDetail rebuild(
          void Function(WithholdingVendorDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingVendorDetailBuilder toBuilder() =>
      WithholdingVendorDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingVendorDetail &&
        vendorId == other.vendorId &&
        vendorName == other.vendorName &&
        month == other.month &&
        withholdingEntity == other.withholdingEntity &&
        declarationState == other.declarationState &&
        threshold == other.threshold &&
        payments == other.payments;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, vendorName.hashCode);
    _$hash = $jc(_$hash, month.hashCode);
    _$hash = $jc(_$hash, withholdingEntity.hashCode);
    _$hash = $jc(_$hash, declarationState.hashCode);
    _$hash = $jc(_$hash, threshold.hashCode);
    _$hash = $jc(_$hash, payments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingVendorDetail')
          ..add('vendorId', vendorId)
          ..add('vendorName', vendorName)
          ..add('month', month)
          ..add('withholdingEntity', withholdingEntity)
          ..add('declarationState', declarationState)
          ..add('threshold', threshold)
          ..add('payments', payments))
        .toString();
  }
}

class WithholdingVendorDetailBuilder
    implements
        Builder<WithholdingVendorDetail, WithholdingVendorDetailBuilder> {
  _$WithholdingVendorDetail? _$v;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _vendorName;
  String? get vendorName => _$this._vendorName;
  set vendorName(String? vendorName) => _$this._vendorName = vendorName;

  String? _month;
  String? get month => _$this._month;
  set month(String? month) => _$this._month = month;

  String? _withholdingEntity;
  String? get withholdingEntity => _$this._withholdingEntity;
  set withholdingEntity(String? withholdingEntity) =>
      _$this._withholdingEntity = withholdingEntity;

  WithholdingVendorDetailDeclarationStateEnum? _declarationState;
  WithholdingVendorDetailDeclarationStateEnum? get declarationState =>
      _$this._declarationState;
  set declarationState(
          WithholdingVendorDetailDeclarationStateEnum? declarationState) =>
      _$this._declarationState = declarationState;

  WithholdingYearLimitBuilder? _threshold;
  WithholdingYearLimitBuilder get threshold =>
      _$this._threshold ??= WithholdingYearLimitBuilder();
  set threshold(WithholdingYearLimitBuilder? threshold) =>
      _$this._threshold = threshold;

  ListBuilder<WithholdingRecordedPayment>? _payments;
  ListBuilder<WithholdingRecordedPayment> get payments =>
      _$this._payments ??= ListBuilder<WithholdingRecordedPayment>();
  set payments(ListBuilder<WithholdingRecordedPayment>? payments) =>
      _$this._payments = payments;

  WithholdingVendorDetailBuilder() {
    WithholdingVendorDetail._defaults(this);
  }

  WithholdingVendorDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _vendorName = $v.vendorName;
      _month = $v.month;
      _withholdingEntity = $v.withholdingEntity;
      _declarationState = $v.declarationState;
      _threshold = $v.threshold?.toBuilder();
      _payments = $v.payments.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingVendorDetail other) {
    _$v = other as _$WithholdingVendorDetail;
  }

  @override
  void update(void Function(WithholdingVendorDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingVendorDetail build() => _build();

  _$WithholdingVendorDetail _build() {
    _$WithholdingVendorDetail _$result;
    try {
      _$result = _$v ??
          _$WithholdingVendorDetail._(
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'WithholdingVendorDetail', 'vendorId'),
            vendorName: BuiltValueNullFieldError.checkNotNull(
                vendorName, r'WithholdingVendorDetail', 'vendorName'),
            month: BuiltValueNullFieldError.checkNotNull(
                month, r'WithholdingVendorDetail', 'month'),
            withholdingEntity: BuiltValueNullFieldError.checkNotNull(
                withholdingEntity,
                r'WithholdingVendorDetail',
                'withholdingEntity'),
            declarationState: BuiltValueNullFieldError.checkNotNull(
                declarationState,
                r'WithholdingVendorDetail',
                'declarationState'),
            threshold: _threshold?.build(),
            payments: payments.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'threshold';
        _threshold?.build();
        _$failedField = 'payments';
        payments.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WithholdingVendorDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
