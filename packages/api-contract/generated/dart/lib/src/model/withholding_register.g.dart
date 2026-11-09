// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withholding_register.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const WithholdingRegisterEnvironmentEnum
    _$withholdingRegisterEnvironmentEnum_TEST =
    const WithholdingRegisterEnvironmentEnum._('TEST');

WithholdingRegisterEnvironmentEnum _$withholdingRegisterEnvironmentEnumValueOf(
    String name) {
  switch (name) {
    case 'TEST':
      return _$withholdingRegisterEnvironmentEnum_TEST;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WithholdingRegisterEnvironmentEnum>
    _$withholdingRegisterEnvironmentEnumValues = BuiltSet<
        WithholdingRegisterEnvironmentEnum>(const <WithholdingRegisterEnvironmentEnum>[
  _$withholdingRegisterEnvironmentEnum_TEST,
]);

const WithholdingRegisterAssignmentStatusEnum
    _$withholdingRegisterAssignmentStatusEnum_UNCONFIRMED =
    const WithholdingRegisterAssignmentStatusEnum._('UNCONFIRMED');

WithholdingRegisterAssignmentStatusEnum
    _$withholdingRegisterAssignmentStatusEnumValueOf(String name) {
  switch (name) {
    case 'UNCONFIRMED':
      return _$withholdingRegisterAssignmentStatusEnum_UNCONFIRMED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<WithholdingRegisterAssignmentStatusEnum>
    _$withholdingRegisterAssignmentStatusEnumValues = BuiltSet<
        WithholdingRegisterAssignmentStatusEnum>(const <WithholdingRegisterAssignmentStatusEnum>[
  _$withholdingRegisterAssignmentStatusEnum_UNCONFIRMED,
]);

Serializer<WithholdingRegisterEnvironmentEnum>
    _$withholdingRegisterEnvironmentEnumSerializer =
    _$WithholdingRegisterEnvironmentEnumSerializer();
Serializer<WithholdingRegisterAssignmentStatusEnum>
    _$withholdingRegisterAssignmentStatusEnumSerializer =
    _$WithholdingRegisterAssignmentStatusEnumSerializer();

class _$WithholdingRegisterEnvironmentEnumSerializer
    implements PrimitiveSerializer<WithholdingRegisterEnvironmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
  };

  @override
  final Iterable<Type> types = const <Type>[WithholdingRegisterEnvironmentEnum];
  @override
  final String wireName = 'WithholdingRegisterEnvironmentEnum';

  @override
  Object serialize(
          Serializers serializers, WithholdingRegisterEnvironmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WithholdingRegisterEnvironmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WithholdingRegisterEnvironmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WithholdingRegisterAssignmentStatusEnumSerializer
    implements PrimitiveSerializer<WithholdingRegisterAssignmentStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'UNCONFIRMED': 'UNCONFIRMED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'UNCONFIRMED': 'UNCONFIRMED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    WithholdingRegisterAssignmentStatusEnum
  ];
  @override
  final String wireName = 'WithholdingRegisterAssignmentStatusEnum';

  @override
  Object serialize(Serializers serializers,
          WithholdingRegisterAssignmentStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  WithholdingRegisterAssignmentStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      WithholdingRegisterAssignmentStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$WithholdingRegister extends WithholdingRegister {
  @override
  final String month;
  @override
  final String periodStart;
  @override
  final String periodEnd;
  @override
  final WithholdingRegisterEnvironmentEnum environment;
  @override
  final WithholdingRegisterAssignmentStatusEnum assignmentStatus;
  @override
  final int platformWithheldCentavos;
  @override
  final int providerWithheldCentavos;
  @override
  final int vendorCount;
  @override
  final int assessmentCount;
  @override
  final int reviewRequired;
  @override
  final BuiltList<WithholdingVendorRow> vendors;

  factory _$WithholdingRegister(
          [void Function(WithholdingRegisterBuilder)? updates]) =>
      (WithholdingRegisterBuilder()..update(updates))._build();

  _$WithholdingRegister._(
      {required this.month,
      required this.periodStart,
      required this.periodEnd,
      required this.environment,
      required this.assignmentStatus,
      required this.platformWithheldCentavos,
      required this.providerWithheldCentavos,
      required this.vendorCount,
      required this.assessmentCount,
      required this.reviewRequired,
      required this.vendors})
      : super._();
  @override
  WithholdingRegister rebuild(
          void Function(WithholdingRegisterBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  WithholdingRegisterBuilder toBuilder() =>
      WithholdingRegisterBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is WithholdingRegister &&
        month == other.month &&
        periodStart == other.periodStart &&
        periodEnd == other.periodEnd &&
        environment == other.environment &&
        assignmentStatus == other.assignmentStatus &&
        platformWithheldCentavos == other.platformWithheldCentavos &&
        providerWithheldCentavos == other.providerWithheldCentavos &&
        vendorCount == other.vendorCount &&
        assessmentCount == other.assessmentCount &&
        reviewRequired == other.reviewRequired &&
        vendors == other.vendors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, month.hashCode);
    _$hash = $jc(_$hash, periodStart.hashCode);
    _$hash = $jc(_$hash, periodEnd.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, assignmentStatus.hashCode);
    _$hash = $jc(_$hash, platformWithheldCentavos.hashCode);
    _$hash = $jc(_$hash, providerWithheldCentavos.hashCode);
    _$hash = $jc(_$hash, vendorCount.hashCode);
    _$hash = $jc(_$hash, assessmentCount.hashCode);
    _$hash = $jc(_$hash, reviewRequired.hashCode);
    _$hash = $jc(_$hash, vendors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'WithholdingRegister')
          ..add('month', month)
          ..add('periodStart', periodStart)
          ..add('periodEnd', periodEnd)
          ..add('environment', environment)
          ..add('assignmentStatus', assignmentStatus)
          ..add('platformWithheldCentavos', platformWithheldCentavos)
          ..add('providerWithheldCentavos', providerWithheldCentavos)
          ..add('vendorCount', vendorCount)
          ..add('assessmentCount', assessmentCount)
          ..add('reviewRequired', reviewRequired)
          ..add('vendors', vendors))
        .toString();
  }
}

class WithholdingRegisterBuilder
    implements Builder<WithholdingRegister, WithholdingRegisterBuilder> {
  _$WithholdingRegister? _$v;

  String? _month;
  String? get month => _$this._month;
  set month(String? month) => _$this._month = month;

  String? _periodStart;
  String? get periodStart => _$this._periodStart;
  set periodStart(String? periodStart) => _$this._periodStart = periodStart;

  String? _periodEnd;
  String? get periodEnd => _$this._periodEnd;
  set periodEnd(String? periodEnd) => _$this._periodEnd = periodEnd;

  WithholdingRegisterEnvironmentEnum? _environment;
  WithholdingRegisterEnvironmentEnum? get environment => _$this._environment;
  set environment(WithholdingRegisterEnvironmentEnum? environment) =>
      _$this._environment = environment;

  WithholdingRegisterAssignmentStatusEnum? _assignmentStatus;
  WithholdingRegisterAssignmentStatusEnum? get assignmentStatus =>
      _$this._assignmentStatus;
  set assignmentStatus(
          WithholdingRegisterAssignmentStatusEnum? assignmentStatus) =>
      _$this._assignmentStatus = assignmentStatus;

  int? _platformWithheldCentavos;
  int? get platformWithheldCentavos => _$this._platformWithheldCentavos;
  set platformWithheldCentavos(int? platformWithheldCentavos) =>
      _$this._platformWithheldCentavos = platformWithheldCentavos;

  int? _providerWithheldCentavos;
  int? get providerWithheldCentavos => _$this._providerWithheldCentavos;
  set providerWithheldCentavos(int? providerWithheldCentavos) =>
      _$this._providerWithheldCentavos = providerWithheldCentavos;

  int? _vendorCount;
  int? get vendorCount => _$this._vendorCount;
  set vendorCount(int? vendorCount) => _$this._vendorCount = vendorCount;

  int? _assessmentCount;
  int? get assessmentCount => _$this._assessmentCount;
  set assessmentCount(int? assessmentCount) =>
      _$this._assessmentCount = assessmentCount;

  int? _reviewRequired;
  int? get reviewRequired => _$this._reviewRequired;
  set reviewRequired(int? reviewRequired) =>
      _$this._reviewRequired = reviewRequired;

  ListBuilder<WithholdingVendorRow>? _vendors;
  ListBuilder<WithholdingVendorRow> get vendors =>
      _$this._vendors ??= ListBuilder<WithholdingVendorRow>();
  set vendors(ListBuilder<WithholdingVendorRow>? vendors) =>
      _$this._vendors = vendors;

  WithholdingRegisterBuilder() {
    WithholdingRegister._defaults(this);
  }

  WithholdingRegisterBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _month = $v.month;
      _periodStart = $v.periodStart;
      _periodEnd = $v.periodEnd;
      _environment = $v.environment;
      _assignmentStatus = $v.assignmentStatus;
      _platformWithheldCentavos = $v.platformWithheldCentavos;
      _providerWithheldCentavos = $v.providerWithheldCentavos;
      _vendorCount = $v.vendorCount;
      _assessmentCount = $v.assessmentCount;
      _reviewRequired = $v.reviewRequired;
      _vendors = $v.vendors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(WithholdingRegister other) {
    _$v = other as _$WithholdingRegister;
  }

  @override
  void update(void Function(WithholdingRegisterBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  WithholdingRegister build() => _build();

  _$WithholdingRegister _build() {
    _$WithholdingRegister _$result;
    try {
      _$result = _$v ??
          _$WithholdingRegister._(
            month: BuiltValueNullFieldError.checkNotNull(
                month, r'WithholdingRegister', 'month'),
            periodStart: BuiltValueNullFieldError.checkNotNull(
                periodStart, r'WithholdingRegister', 'periodStart'),
            periodEnd: BuiltValueNullFieldError.checkNotNull(
                periodEnd, r'WithholdingRegister', 'periodEnd'),
            environment: BuiltValueNullFieldError.checkNotNull(
                environment, r'WithholdingRegister', 'environment'),
            assignmentStatus: BuiltValueNullFieldError.checkNotNull(
                assignmentStatus, r'WithholdingRegister', 'assignmentStatus'),
            platformWithheldCentavos: BuiltValueNullFieldError.checkNotNull(
                platformWithheldCentavos,
                r'WithholdingRegister',
                'platformWithheldCentavos'),
            providerWithheldCentavos: BuiltValueNullFieldError.checkNotNull(
                providerWithheldCentavos,
                r'WithholdingRegister',
                'providerWithheldCentavos'),
            vendorCount: BuiltValueNullFieldError.checkNotNull(
                vendorCount, r'WithholdingRegister', 'vendorCount'),
            assessmentCount: BuiltValueNullFieldError.checkNotNull(
                assessmentCount, r'WithholdingRegister', 'assessmentCount'),
            reviewRequired: BuiltValueNullFieldError.checkNotNull(
                reviewRequired, r'WithholdingRegister', 'reviewRequired'),
            vendors: vendors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'vendors';
        vendors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'WithholdingRegister', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
