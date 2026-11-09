// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_vendor_row.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WithholdingVendorRowFilingIssuesEnum
    _$withholdingVendorRowFilingIssuesEnum_CALCULATION_INCOMPLETE =
    const WithholdingVendorRowFilingIssuesEnum._('CALCULATION_INCOMPLETE');
const WithholdingVendorRowFilingIssuesEnum
    _$withholdingVendorRowFilingIssuesEnum_RECONCILIATION_EXCEPTION =
    const WithholdingVendorRowFilingIssuesEnum._('RECONCILIATION_EXCEPTION');
const WithholdingVendorRowFilingIssuesEnum
    _$withholdingVendorRowFilingIssuesEnum_TAX_PROFILE_MISSING =
    const WithholdingVendorRowFilingIssuesEnum._('TAX_PROFILE_MISSING');
const WithholdingVendorRowFilingIssuesEnum
    _$withholdingVendorRowFilingIssuesEnum_REPORTING_CODE_MISSING =
    const WithholdingVendorRowFilingIssuesEnum._('REPORTING_CODE_MISSING');
const WithholdingVendorRowFilingIssuesEnum
    _$withholdingVendorRowFilingIssuesEnum_TAX_ADJUSTMENT_OPEN =
    const WithholdingVendorRowFilingIssuesEnum._('TAX_ADJUSTMENT_OPEN');

WithholdingVendorRowFilingIssuesEnum
    _$withholdingVendorRowFilingIssuesEnumValueOf(String name) {
  switch (name) {
    case 'CALCULATION_INCOMPLETE':
      return _$withholdingVendorRowFilingIssuesEnum_CALCULATION_INCOMPLETE;
    case 'RECONCILIATION_EXCEPTION':
      return _$withholdingVendorRowFilingIssuesEnum_RECONCILIATION_EXCEPTION;
    case 'TAX_PROFILE_MISSING':
      return _$withholdingVendorRowFilingIssuesEnum_TAX_PROFILE_MISSING;
    case 'REPORTING_CODE_MISSING':
      return _$withholdingVendorRowFilingIssuesEnum_REPORTING_CODE_MISSING;
    case 'TAX_ADJUSTMENT_OPEN':
      return _$withholdingVendorRowFilingIssuesEnum_TAX_ADJUSTMENT_OPEN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WithholdingVendorRowFilingIssuesEnum>
    _$withholdingVendorRowFilingIssuesEnumValues = BuiltSet<
        WithholdingVendorRowFilingIssuesEnum>(const <WithholdingVendorRowFilingIssuesEnum>[
  _$withholdingVendorRowFilingIssuesEnum_CALCULATION_INCOMPLETE,
  _$withholdingVendorRowFilingIssuesEnum_RECONCILIATION_EXCEPTION,
  _$withholdingVendorRowFilingIssuesEnum_TAX_PROFILE_MISSING,
  _$withholdingVendorRowFilingIssuesEnum_REPORTING_CODE_MISSING,
  _$withholdingVendorRowFilingIssuesEnum_TAX_ADJUSTMENT_OPEN,
]);

Serializer<WithholdingVendorRowFilingIssuesEnum>
    _$withholdingVendorRowFilingIssuesEnumSerializer =
    _$WithholdingVendorRowFilingIssuesEnumSerializer();

class _$WithholdingVendorRowFilingIssuesEnumSerializer
    implements PrimitiveSerializer<WithholdingVendorRowFilingIssuesEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CALCULATION_INCOMPLETE': 'CALCULATION_INCOMPLETE',
    'RECONCILIATION_EXCEPTION': 'RECONCILIATION_EXCEPTION',
    'TAX_PROFILE_MISSING': 'TAX_PROFILE_MISSING',
    'REPORTING_CODE_MISSING': 'REPORTING_CODE_MISSING',
    'TAX_ADJUSTMENT_OPEN': 'TAX_ADJUSTMENT_OPEN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CALCULATION_INCOMPLETE': 'CALCULATION_INCOMPLETE',
    'RECONCILIATION_EXCEPTION': 'RECONCILIATION_EXCEPTION',
    'TAX_PROFILE_MISSING': 'TAX_PROFILE_MISSING',
    'REPORTING_CODE_MISSING': 'REPORTING_CODE_MISSING',
    'TAX_ADJUSTMENT_OPEN': 'TAX_ADJUSTMENT_OPEN',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WithholdingVendorRowFilingIssuesEnum
  ];
  @override
  final String wireName = 'WithholdingVendorRowFilingIssuesEnum';

  @override
  Object serialize(
          Serializers serializers, WithholdingVendorRowFilingIssuesEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WithholdingVendorRowFilingIssuesEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WithholdingVendorRowFilingIssuesEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WithholdingVendorRow extends WithholdingVendorRow {
  @override
  final String vendorId;
  @override
  final String vendorName;
  @override
  final String withholdingEntity;
  @override
  final int assessmentCount;
  @override
  final int withheldCentavos;
  @override
  final int reviewRequired;
  @override
  final WithholdingCalculation calculation;
  @override
  final BuiltSet<WithholdingVendorRowFilingIssuesEnum> filingIssues;

  factory _$WithholdingVendorRow(
          [void Function(WithholdingVendorRowBuilder)? updates]) =>
      (WithholdingVendorRowBuilder()..update(updates))._build();

  _$WithholdingVendorRow._(
      {required this.vendorId,
      required this.vendorName,
      required this.withholdingEntity,
      required this.assessmentCount,
      required this.withheldCentavos,
      required this.reviewRequired,
      required this.calculation,
      required this.filingIssues})
      : super._();
  @override
  WithholdingVendorRow rebuild(
          void Function(WithholdingVendorRowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingVendorRowBuilder toBuilder() =>
      WithholdingVendorRowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingVendorRow &&
        vendorId == other.vendorId &&
        vendorName == other.vendorName &&
        withholdingEntity == other.withholdingEntity &&
        assessmentCount == other.assessmentCount &&
        withheldCentavos == other.withheldCentavos &&
        reviewRequired == other.reviewRequired &&
        calculation == other.calculation &&
        filingIssues == other.filingIssues;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, vendorName.hashCode);
    _$hash = $jc(_$hash, withholdingEntity.hashCode);
    _$hash = $jc(_$hash, assessmentCount.hashCode);
    _$hash = $jc(_$hash, withheldCentavos.hashCode);
    _$hash = $jc(_$hash, reviewRequired.hashCode);
    _$hash = $jc(_$hash, calculation.hashCode);
    _$hash = $jc(_$hash, filingIssues.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingVendorRow')
          ..add('vendorId', vendorId)
          ..add('vendorName', vendorName)
          ..add('withholdingEntity', withholdingEntity)
          ..add('assessmentCount', assessmentCount)
          ..add('withheldCentavos', withheldCentavos)
          ..add('reviewRequired', reviewRequired)
          ..add('calculation', calculation)
          ..add('filingIssues', filingIssues))
        .toString();
  }
}

class WithholdingVendorRowBuilder
    implements Builder<WithholdingVendorRow, WithholdingVendorRowBuilder> {
  _$WithholdingVendorRow? _$v;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _vendorName;
  String? get vendorName => _$this._vendorName;
  set vendorName(String? vendorName) => _$this._vendorName = vendorName;

  String? _withholdingEntity;
  String? get withholdingEntity => _$this._withholdingEntity;
  set withholdingEntity(String? withholdingEntity) =>
      _$this._withholdingEntity = withholdingEntity;

  int? _assessmentCount;
  int? get assessmentCount => _$this._assessmentCount;
  set assessmentCount(int? assessmentCount) =>
      _$this._assessmentCount = assessmentCount;

  int? _withheldCentavos;
  int? get withheldCentavos => _$this._withheldCentavos;
  set withheldCentavos(int? withheldCentavos) =>
      _$this._withheldCentavos = withheldCentavos;

  int? _reviewRequired;
  int? get reviewRequired => _$this._reviewRequired;
  set reviewRequired(int? reviewRequired) =>
      _$this._reviewRequired = reviewRequired;

  WithholdingCalculationBuilder? _calculation;
  WithholdingCalculationBuilder get calculation =>
      _$this._calculation ??= WithholdingCalculationBuilder();
  set calculation(WithholdingCalculationBuilder? calculation) =>
      _$this._calculation = calculation;

  SetBuilder<WithholdingVendorRowFilingIssuesEnum>? _filingIssues;
  SetBuilder<WithholdingVendorRowFilingIssuesEnum> get filingIssues =>
      _$this._filingIssues ??=
          SetBuilder<WithholdingVendorRowFilingIssuesEnum>();
  set filingIssues(
          SetBuilder<WithholdingVendorRowFilingIssuesEnum>? filingIssues) =>
      _$this._filingIssues = filingIssues;

  WithholdingVendorRowBuilder() {
    WithholdingVendorRow._defaults(this);
  }

  WithholdingVendorRowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _vendorName = $v.vendorName;
      _withholdingEntity = $v.withholdingEntity;
      _assessmentCount = $v.assessmentCount;
      _withheldCentavos = $v.withheldCentavos;
      _reviewRequired = $v.reviewRequired;
      _calculation = $v.calculation.toBuilder();
      _filingIssues = $v.filingIssues.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingVendorRow other) {
    _$v = other as _$WithholdingVendorRow;
  }

  @override
  void update(void Function(WithholdingVendorRowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingVendorRow build() => _build();

  _$WithholdingVendorRow _build() {
    _$WithholdingVendorRow _$result;
    try {
      _$result = _$v ??
          _$WithholdingVendorRow._(
            vendorId: BuiltValueNullFieldError.checkNotNull(
                vendorId, r'WithholdingVendorRow', 'vendorId'),
            vendorName: BuiltValueNullFieldError.checkNotNull(
                vendorName, r'WithholdingVendorRow', 'vendorName'),
            withholdingEntity: BuiltValueNullFieldError.checkNotNull(
                withholdingEntity,
                r'WithholdingVendorRow',
                'withholdingEntity'),
            assessmentCount: BuiltValueNullFieldError.checkNotNull(
                assessmentCount, r'WithholdingVendorRow', 'assessmentCount'),
            withheldCentavos: BuiltValueNullFieldError.checkNotNull(
                withheldCentavos, r'WithholdingVendorRow', 'withheldCentavos'),
            reviewRequired: BuiltValueNullFieldError.checkNotNull(
                reviewRequired, r'WithholdingVendorRow', 'reviewRequired'),
            calculation: calculation.build(),
            filingIssues: filingIssues.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'calculation';
        calculation.build();
        _$failedField = 'filingIssues';
        filingIssues.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WithholdingVendorRow', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
