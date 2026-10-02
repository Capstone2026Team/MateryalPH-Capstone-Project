// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_finance_overview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorFinanceOverview extends VendorFinanceOverview {
  @override
  final String demoLabel;
  @override
  final BuiltMap<String, JsonObject?> xenditConnection;
  @override
  final BuiltMap<String, JsonObject?> taxProfile;
  @override
  final BuiltMap<String, JsonObject?> withholdingArrangement;
  @override
  final WithholdingThresholdPanel? threshold;
  @override
  final BuiltMap<String, JsonObject?> commissionTerms;
  @override
  final BuiltMap<String, JsonObject?> onlineChannels;
  @override
  final BuiltMap<String, JsonObject?> physicalPayments;
  @override
  final BuiltMap<String, JsonObject?> refundCapability;
  @override
  final BuiltMap<String, JsonObject?> statements;
  @override
  final BuiltList<VendorFinanceNotice> notices;

  factory _$VendorFinanceOverview(
          [void Function(VendorFinanceOverviewBuilder)? updates]) =>
      (VendorFinanceOverviewBuilder()..update(updates))._build();

  _$VendorFinanceOverview._(
      {required this.demoLabel,
      required this.xenditConnection,
      required this.taxProfile,
      required this.withholdingArrangement,
      this.threshold,
      required this.commissionTerms,
      required this.onlineChannels,
      required this.physicalPayments,
      required this.refundCapability,
      required this.statements,
      required this.notices})
      : super._();
  @override
  VendorFinanceOverview rebuild(
          void Function(VendorFinanceOverviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorFinanceOverviewBuilder toBuilder() =>
      VendorFinanceOverviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorFinanceOverview &&
        demoLabel == other.demoLabel &&
        xenditConnection == other.xenditConnection &&
        taxProfile == other.taxProfile &&
        withholdingArrangement == other.withholdingArrangement &&
        threshold == other.threshold &&
        commissionTerms == other.commissionTerms &&
        onlineChannels == other.onlineChannels &&
        physicalPayments == other.physicalPayments &&
        refundCapability == other.refundCapability &&
        statements == other.statements &&
        notices == other.notices;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, demoLabel.hashCode);
    _$hash = $jc(_$hash, xenditConnection.hashCode);
    _$hash = $jc(_$hash, taxProfile.hashCode);
    _$hash = $jc(_$hash, withholdingArrangement.hashCode);
    _$hash = $jc(_$hash, threshold.hashCode);
    _$hash = $jc(_$hash, commissionTerms.hashCode);
    _$hash = $jc(_$hash, onlineChannels.hashCode);
    _$hash = $jc(_$hash, physicalPayments.hashCode);
    _$hash = $jc(_$hash, refundCapability.hashCode);
    _$hash = $jc(_$hash, statements.hashCode);
    _$hash = $jc(_$hash, notices.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorFinanceOverview')
          ..add('demoLabel', demoLabel)
          ..add('xenditConnection', xenditConnection)
          ..add('taxProfile', taxProfile)
          ..add('withholdingArrangement', withholdingArrangement)
          ..add('threshold', threshold)
          ..add('commissionTerms', commissionTerms)
          ..add('onlineChannels', onlineChannels)
          ..add('physicalPayments', physicalPayments)
          ..add('refundCapability', refundCapability)
          ..add('statements', statements)
          ..add('notices', notices))
        .toString();
  }
}

class VendorFinanceOverviewBuilder
    implements Builder<VendorFinanceOverview, VendorFinanceOverviewBuilder> {
  _$VendorFinanceOverview? _$v;

  String? _demoLabel;
  String? get demoLabel => _$this._demoLabel;
  set demoLabel(String? demoLabel) => _$this._demoLabel = demoLabel;

  MapBuilder<String, JsonObject?>? _xenditConnection;
  MapBuilder<String, JsonObject?> get xenditConnection =>
      _$this._xenditConnection ??= MapBuilder<String, JsonObject?>();
  set xenditConnection(MapBuilder<String, JsonObject?>? xenditConnection) =>
      _$this._xenditConnection = xenditConnection;

  MapBuilder<String, JsonObject?>? _taxProfile;
  MapBuilder<String, JsonObject?> get taxProfile =>
      _$this._taxProfile ??= MapBuilder<String, JsonObject?>();
  set taxProfile(MapBuilder<String, JsonObject?>? taxProfile) =>
      _$this._taxProfile = taxProfile;

  MapBuilder<String, JsonObject?>? _withholdingArrangement;
  MapBuilder<String, JsonObject?> get withholdingArrangement =>
      _$this._withholdingArrangement ??= MapBuilder<String, JsonObject?>();
  set withholdingArrangement(
          MapBuilder<String, JsonObject?>? withholdingArrangement) =>
      _$this._withholdingArrangement = withholdingArrangement;

  WithholdingThresholdPanelBuilder? _threshold;
  WithholdingThresholdPanelBuilder get threshold =>
      _$this._threshold ??= WithholdingThresholdPanelBuilder();
  set threshold(WithholdingThresholdPanelBuilder? threshold) =>
      _$this._threshold = threshold;

  MapBuilder<String, JsonObject?>? _commissionTerms;
  MapBuilder<String, JsonObject?> get commissionTerms =>
      _$this._commissionTerms ??= MapBuilder<String, JsonObject?>();
  set commissionTerms(MapBuilder<String, JsonObject?>? commissionTerms) =>
      _$this._commissionTerms = commissionTerms;

  MapBuilder<String, JsonObject?>? _onlineChannels;
  MapBuilder<String, JsonObject?> get onlineChannels =>
      _$this._onlineChannels ??= MapBuilder<String, JsonObject?>();
  set onlineChannels(MapBuilder<String, JsonObject?>? onlineChannels) =>
      _$this._onlineChannels = onlineChannels;

  MapBuilder<String, JsonObject?>? _physicalPayments;
  MapBuilder<String, JsonObject?> get physicalPayments =>
      _$this._physicalPayments ??= MapBuilder<String, JsonObject?>();
  set physicalPayments(MapBuilder<String, JsonObject?>? physicalPayments) =>
      _$this._physicalPayments = physicalPayments;

  MapBuilder<String, JsonObject?>? _refundCapability;
  MapBuilder<String, JsonObject?> get refundCapability =>
      _$this._refundCapability ??= MapBuilder<String, JsonObject?>();
  set refundCapability(MapBuilder<String, JsonObject?>? refundCapability) =>
      _$this._refundCapability = refundCapability;

  MapBuilder<String, JsonObject?>? _statements;
  MapBuilder<String, JsonObject?> get statements =>
      _$this._statements ??= MapBuilder<String, JsonObject?>();
  set statements(MapBuilder<String, JsonObject?>? statements) =>
      _$this._statements = statements;

  ListBuilder<VendorFinanceNotice>? _notices;
  ListBuilder<VendorFinanceNotice> get notices =>
      _$this._notices ??= ListBuilder<VendorFinanceNotice>();
  set notices(ListBuilder<VendorFinanceNotice>? notices) =>
      _$this._notices = notices;

  VendorFinanceOverviewBuilder() {
    VendorFinanceOverview._defaults(this);
  }

  VendorFinanceOverviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _demoLabel = $v.demoLabel;
      _xenditConnection = $v.xenditConnection.toBuilder();
      _taxProfile = $v.taxProfile.toBuilder();
      _withholdingArrangement = $v.withholdingArrangement.toBuilder();
      _threshold = $v.threshold?.toBuilder();
      _commissionTerms = $v.commissionTerms.toBuilder();
      _onlineChannels = $v.onlineChannels.toBuilder();
      _physicalPayments = $v.physicalPayments.toBuilder();
      _refundCapability = $v.refundCapability.toBuilder();
      _statements = $v.statements.toBuilder();
      _notices = $v.notices.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorFinanceOverview other) {
    _$v = other as _$VendorFinanceOverview;
  }

  @override
  void update(void Function(VendorFinanceOverviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorFinanceOverview build() => _build();

  _$VendorFinanceOverview _build() {
    _$VendorFinanceOverview _$result;
    try {
      _$result = _$v ??
          _$VendorFinanceOverview._(
            demoLabel: BuiltValueNullFieldError.checkNotNull(
                demoLabel, r'VendorFinanceOverview', 'demoLabel'),
            xenditConnection: xenditConnection.build(),
            taxProfile: taxProfile.build(),
            withholdingArrangement: withholdingArrangement.build(),
            threshold: _threshold?.build(),
            commissionTerms: commissionTerms.build(),
            onlineChannels: onlineChannels.build(),
            physicalPayments: physicalPayments.build(),
            refundCapability: refundCapability.build(),
            statements: statements.build(),
            notices: notices.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'xenditConnection';
        xenditConnection.build();
        _$failedField = 'taxProfile';
        taxProfile.build();
        _$failedField = 'withholdingArrangement';
        withholdingArrangement.build();
        _$failedField = 'threshold';
        _threshold?.build();
        _$failedField = 'commissionTerms';
        commissionTerms.build();
        _$failedField = 'onlineChannels';
        onlineChannels.build();
        _$failedField = 'physicalPayments';
        physicalPayments.build();
        _$failedField = 'refundCapability';
        refundCapability.build();
        _$failedField = 'statements';
        statements.build();
        _$failedField = 'notices';
        notices.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorFinanceOverview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
