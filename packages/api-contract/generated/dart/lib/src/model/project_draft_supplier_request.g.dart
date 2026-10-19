// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_draft_supplier_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ProjectDraftSupplierRequestPaymentMethodEnum
    _$projectDraftSupplierRequestPaymentMethodEnum_ONLINE =
    const ProjectDraftSupplierRequestPaymentMethodEnum._('ONLINE');
const ProjectDraftSupplierRequestPaymentMethodEnum
    _$projectDraftSupplierRequestPaymentMethodEnum_CASH_ON_DELIVERY =
    const ProjectDraftSupplierRequestPaymentMethodEnum._('CASH_ON_DELIVERY');
const ProjectDraftSupplierRequestPaymentMethodEnum
    _$projectDraftSupplierRequestPaymentMethodEnum_IN_STORE =
    const ProjectDraftSupplierRequestPaymentMethodEnum._('IN_STORE');

ProjectDraftSupplierRequestPaymentMethodEnum
    _$projectDraftSupplierRequestPaymentMethodEnumValueOf(String name) {
  switch (name) {
    case 'ONLINE':
      return _$projectDraftSupplierRequestPaymentMethodEnum_ONLINE;
    case 'CASH_ON_DELIVERY':
      return _$projectDraftSupplierRequestPaymentMethodEnum_CASH_ON_DELIVERY;
    case 'IN_STORE':
      return _$projectDraftSupplierRequestPaymentMethodEnum_IN_STORE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ProjectDraftSupplierRequestPaymentMethodEnum>
    _$projectDraftSupplierRequestPaymentMethodEnumValues = BuiltSet<
        ProjectDraftSupplierRequestPaymentMethodEnum>(const <ProjectDraftSupplierRequestPaymentMethodEnum>[
  _$projectDraftSupplierRequestPaymentMethodEnum_ONLINE,
  _$projectDraftSupplierRequestPaymentMethodEnum_CASH_ON_DELIVERY,
  _$projectDraftSupplierRequestPaymentMethodEnum_IN_STORE,
]);

Serializer<ProjectDraftSupplierRequestPaymentMethodEnum>
    _$projectDraftSupplierRequestPaymentMethodEnumSerializer =
    _$ProjectDraftSupplierRequestPaymentMethodEnumSerializer();

class _$ProjectDraftSupplierRequestPaymentMethodEnumSerializer
    implements
        PrimitiveSerializer<ProjectDraftSupplierRequestPaymentMethodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ONLINE': 'ONLINE',
    'CASH_ON_DELIVERY': 'CASH_ON_DELIVERY',
    'IN_STORE': 'IN_STORE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ONLINE': 'ONLINE',
    'CASH_ON_DELIVERY': 'CASH_ON_DELIVERY',
    'IN_STORE': 'IN_STORE',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ProjectDraftSupplierRequestPaymentMethodEnum
  ];
  @override
  final String wireName = 'ProjectDraftSupplierRequestPaymentMethodEnum';

  @override
  Object serialize(Serializers serializers,
          ProjectDraftSupplierRequestPaymentMethodEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ProjectDraftSupplierRequestPaymentMethodEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ProjectDraftSupplierRequestPaymentMethodEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ProjectDraftSupplierRequest extends ProjectDraftSupplierRequest {
  @override
  final int lockVersion;
  @override
  final ProjectDraftSupplierRequestPaymentMethodEnum paymentMethod;
  @override
  final String draftFingerprint;
  @override
  final String? budgetOverrideReason;

  factory _$ProjectDraftSupplierRequest(
          [void Function(ProjectDraftSupplierRequestBuilder)? updates]) =>
      (ProjectDraftSupplierRequestBuilder()..update(updates))._build();

  _$ProjectDraftSupplierRequest._(
      {required this.lockVersion,
      required this.paymentMethod,
      required this.draftFingerprint,
      this.budgetOverrideReason})
      : super._();
  @override
  ProjectDraftSupplierRequest rebuild(
          void Function(ProjectDraftSupplierRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProjectDraftSupplierRequestBuilder toBuilder() =>
      ProjectDraftSupplierRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProjectDraftSupplierRequest &&
        lockVersion == other.lockVersion &&
        paymentMethod == other.paymentMethod &&
        draftFingerprint == other.draftFingerprint &&
        budgetOverrideReason == other.budgetOverrideReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, draftFingerprint.hashCode);
    _$hash = $jc(_$hash, budgetOverrideReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProjectDraftSupplierRequest')
          ..add('lockVersion', lockVersion)
          ..add('paymentMethod', paymentMethod)
          ..add('draftFingerprint', draftFingerprint)
          ..add('budgetOverrideReason', budgetOverrideReason))
        .toString();
  }
}

class ProjectDraftSupplierRequestBuilder
    implements
        Builder<ProjectDraftSupplierRequest,
            ProjectDraftSupplierRequestBuilder> {
  _$ProjectDraftSupplierRequest? _$v;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  ProjectDraftSupplierRequestPaymentMethodEnum? _paymentMethod;
  ProjectDraftSupplierRequestPaymentMethodEnum? get paymentMethod =>
      _$this._paymentMethod;
  set paymentMethod(
          ProjectDraftSupplierRequestPaymentMethodEnum? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  String? _draftFingerprint;
  String? get draftFingerprint => _$this._draftFingerprint;
  set draftFingerprint(String? draftFingerprint) =>
      _$this._draftFingerprint = draftFingerprint;

  String? _budgetOverrideReason;
  String? get budgetOverrideReason => _$this._budgetOverrideReason;
  set budgetOverrideReason(String? budgetOverrideReason) =>
      _$this._budgetOverrideReason = budgetOverrideReason;

  ProjectDraftSupplierRequestBuilder() {
    ProjectDraftSupplierRequest._defaults(this);
  }

  ProjectDraftSupplierRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lockVersion = $v.lockVersion;
      _paymentMethod = $v.paymentMethod;
      _draftFingerprint = $v.draftFingerprint;
      _budgetOverrideReason = $v.budgetOverrideReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProjectDraftSupplierRequest other) {
    _$v = other as _$ProjectDraftSupplierRequest;
  }

  @override
  void update(void Function(ProjectDraftSupplierRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProjectDraftSupplierRequest build() => _build();

  _$ProjectDraftSupplierRequest _build() {
    final _$result = _$v ??
        _$ProjectDraftSupplierRequest._(
          lockVersion: BuiltValueNullFieldError.checkNotNull(
              lockVersion, r'ProjectDraftSupplierRequest', 'lockVersion'),
          paymentMethod: BuiltValueNullFieldError.checkNotNull(
              paymentMethod, r'ProjectDraftSupplierRequest', 'paymentMethod'),
          draftFingerprint: BuiltValueNullFieldError.checkNotNull(
              draftFingerprint,
              r'ProjectDraftSupplierRequest',
              'draftFingerprint'),
          budgetOverrideReason: budgetOverrideReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
