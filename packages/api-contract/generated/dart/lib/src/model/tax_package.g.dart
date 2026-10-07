// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_package.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaxPackage extends TaxPackage {
  @override
  final String id;
  @override
  final String packageType;
  @override
  final String state;
  @override
  final String periodStart;
  @override
  final String periodEnd;
  @override
  final String withholdingEntity;
  @override
  final String? nominalDueDate;
  @override
  final String? actualDueDate;
  @override
  final String? dueDateSource;
  @override
  final String? dueDateStatus;
  @override
  final int? dueDateReviewerId;
  @override
  final int lockVersion;
  @override
  final BuiltMap<String, JsonObject?>? snapshot;
  @override
  final String? contentHash;
  @override
  final String? submissionState;

  factory _$TaxPackage([void Function(TaxPackageBuilder)? updates]) =>
      (TaxPackageBuilder()..update(updates))._build();

  _$TaxPackage._(
      {required this.id,
      required this.packageType,
      required this.state,
      required this.periodStart,
      required this.periodEnd,
      required this.withholdingEntity,
      this.nominalDueDate,
      this.actualDueDate,
      this.dueDateSource,
      this.dueDateStatus,
      this.dueDateReviewerId,
      required this.lockVersion,
      this.snapshot,
      this.contentHash,
      this.submissionState})
      : super._();
  @override
  TaxPackage rebuild(void Function(TaxPackageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxPackageBuilder toBuilder() => TaxPackageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxPackage &&
        id == other.id &&
        packageType == other.packageType &&
        state == other.state &&
        periodStart == other.periodStart &&
        periodEnd == other.periodEnd &&
        withholdingEntity == other.withholdingEntity &&
        nominalDueDate == other.nominalDueDate &&
        actualDueDate == other.actualDueDate &&
        dueDateSource == other.dueDateSource &&
        dueDateStatus == other.dueDateStatus &&
        dueDateReviewerId == other.dueDateReviewerId &&
        lockVersion == other.lockVersion &&
        snapshot == other.snapshot &&
        contentHash == other.contentHash &&
        submissionState == other.submissionState;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, packageType.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, periodStart.hashCode);
    _$hash = $jc(_$hash, periodEnd.hashCode);
    _$hash = $jc(_$hash, withholdingEntity.hashCode);
    _$hash = $jc(_$hash, nominalDueDate.hashCode);
    _$hash = $jc(_$hash, actualDueDate.hashCode);
    _$hash = $jc(_$hash, dueDateSource.hashCode);
    _$hash = $jc(_$hash, dueDateStatus.hashCode);
    _$hash = $jc(_$hash, dueDateReviewerId.hashCode);
    _$hash = $jc(_$hash, lockVersion.hashCode);
    _$hash = $jc(_$hash, snapshot.hashCode);
    _$hash = $jc(_$hash, contentHash.hashCode);
    _$hash = $jc(_$hash, submissionState.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaxPackage')
          ..add('id', id)
          ..add('packageType', packageType)
          ..add('state', state)
          ..add('periodStart', periodStart)
          ..add('periodEnd', periodEnd)
          ..add('withholdingEntity', withholdingEntity)
          ..add('nominalDueDate', nominalDueDate)
          ..add('actualDueDate', actualDueDate)
          ..add('dueDateSource', dueDateSource)
          ..add('dueDateStatus', dueDateStatus)
          ..add('dueDateReviewerId', dueDateReviewerId)
          ..add('lockVersion', lockVersion)
          ..add('snapshot', snapshot)
          ..add('contentHash', contentHash)
          ..add('submissionState', submissionState))
        .toString();
  }
}

class TaxPackageBuilder implements Builder<TaxPackage, TaxPackageBuilder> {
  _$TaxPackage? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _packageType;
  String? get packageType => _$this._packageType;
  set packageType(String? packageType) => _$this._packageType = packageType;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  String? _periodStart;
  String? get periodStart => _$this._periodStart;
  set periodStart(String? periodStart) => _$this._periodStart = periodStart;

  String? _periodEnd;
  String? get periodEnd => _$this._periodEnd;
  set periodEnd(String? periodEnd) => _$this._periodEnd = periodEnd;

  String? _withholdingEntity;
  String? get withholdingEntity => _$this._withholdingEntity;
  set withholdingEntity(String? withholdingEntity) =>
      _$this._withholdingEntity = withholdingEntity;

  String? _nominalDueDate;
  String? get nominalDueDate => _$this._nominalDueDate;
  set nominalDueDate(String? nominalDueDate) =>
      _$this._nominalDueDate = nominalDueDate;

  String? _actualDueDate;
  String? get actualDueDate => _$this._actualDueDate;
  set actualDueDate(String? actualDueDate) =>
      _$this._actualDueDate = actualDueDate;

  String? _dueDateSource;
  String? get dueDateSource => _$this._dueDateSource;
  set dueDateSource(String? dueDateSource) =>
      _$this._dueDateSource = dueDateSource;

  String? _dueDateStatus;
  String? get dueDateStatus => _$this._dueDateStatus;
  set dueDateStatus(String? dueDateStatus) =>
      _$this._dueDateStatus = dueDateStatus;

  int? _dueDateReviewerId;
  int? get dueDateReviewerId => _$this._dueDateReviewerId;
  set dueDateReviewerId(int? dueDateReviewerId) =>
      _$this._dueDateReviewerId = dueDateReviewerId;

  int? _lockVersion;
  int? get lockVersion => _$this._lockVersion;
  set lockVersion(int? lockVersion) => _$this._lockVersion = lockVersion;

  MapBuilder<String, JsonObject?>? _snapshot;
  MapBuilder<String, JsonObject?> get snapshot =>
      _$this._snapshot ??= MapBuilder<String, JsonObject?>();
  set snapshot(MapBuilder<String, JsonObject?>? snapshot) =>
      _$this._snapshot = snapshot;

  String? _contentHash;
  String? get contentHash => _$this._contentHash;
  set contentHash(String? contentHash) => _$this._contentHash = contentHash;

  String? _submissionState;
  String? get submissionState => _$this._submissionState;
  set submissionState(String? submissionState) =>
      _$this._submissionState = submissionState;

  TaxPackageBuilder() {
    TaxPackage._defaults(this);
  }

  TaxPackageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _packageType = $v.packageType;
      _state = $v.state;
      _periodStart = $v.periodStart;
      _periodEnd = $v.periodEnd;
      _withholdingEntity = $v.withholdingEntity;
      _nominalDueDate = $v.nominalDueDate;
      _actualDueDate = $v.actualDueDate;
      _dueDateSource = $v.dueDateSource;
      _dueDateStatus = $v.dueDateStatus;
      _dueDateReviewerId = $v.dueDateReviewerId;
      _lockVersion = $v.lockVersion;
      _snapshot = $v.snapshot?.toBuilder();
      _contentHash = $v.contentHash;
      _submissionState = $v.submissionState;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxPackage other) {
    _$v = other as _$TaxPackage;
  }

  @override
  void update(void Function(TaxPackageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxPackage build() => _build();

  _$TaxPackage _build() {
    _$TaxPackage _$result;
    try {
      _$result = _$v ??
          _$TaxPackage._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'TaxPackage', 'id'),
            packageType: BuiltValueNullFieldError.checkNotNull(
                packageType, r'TaxPackage', 'packageType'),
            state: BuiltValueNullFieldError.checkNotNull(
                state, r'TaxPackage', 'state'),
            periodStart: BuiltValueNullFieldError.checkNotNull(
                periodStart, r'TaxPackage', 'periodStart'),
            periodEnd: BuiltValueNullFieldError.checkNotNull(
                periodEnd, r'TaxPackage', 'periodEnd'),
            withholdingEntity: BuiltValueNullFieldError.checkNotNull(
                withholdingEntity, r'TaxPackage', 'withholdingEntity'),
            nominalDueDate: nominalDueDate,
            actualDueDate: actualDueDate,
            dueDateSource: dueDateSource,
            dueDateStatus: dueDateStatus,
            dueDateReviewerId: dueDateReviewerId,
            lockVersion: BuiltValueNullFieldError.checkNotNull(
                lockVersion, r'TaxPackage', 'lockVersion'),
            snapshot: _snapshot?.build(),
            contentHash: contentHash,
            submissionState: submissionState,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'snapshot';
        _snapshot?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TaxPackage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
