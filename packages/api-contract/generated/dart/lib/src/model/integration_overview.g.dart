// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'integration_overview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IntegrationOverview extends IntegrationOverview {
  @override
  final DateTime generatedAt;
  @override
  final BuiltMap<String, JsonObject?> environment;
  @override
  final BuiltList<IntegrationStatus> integrations;
  @override
  final BuiltMap<String, JsonObject?> queues;
  @override
  final BuiltList<ScheduledTaskHealth> scheduledTasks;
  @override
  final BuiltMap<String, JsonObject?> analytics;
  @override
  final bool canRetry;

  factory _$IntegrationOverview(
          [void Function(IntegrationOverviewBuilder)? updates]) =>
      (IntegrationOverviewBuilder()..update(updates))._build();

  _$IntegrationOverview._(
      {required this.generatedAt,
      required this.environment,
      required this.integrations,
      required this.queues,
      required this.scheduledTasks,
      required this.analytics,
      required this.canRetry})
      : super._();
  @override
  IntegrationOverview rebuild(
          void Function(IntegrationOverviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IntegrationOverviewBuilder toBuilder() =>
      IntegrationOverviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IntegrationOverview &&
        generatedAt == other.generatedAt &&
        environment == other.environment &&
        integrations == other.integrations &&
        queues == other.queues &&
        scheduledTasks == other.scheduledTasks &&
        analytics == other.analytics &&
        canRetry == other.canRetry;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, generatedAt.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, integrations.hashCode);
    _$hash = $jc(_$hash, queues.hashCode);
    _$hash = $jc(_$hash, scheduledTasks.hashCode);
    _$hash = $jc(_$hash, analytics.hashCode);
    _$hash = $jc(_$hash, canRetry.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IntegrationOverview')
          ..add('generatedAt', generatedAt)
          ..add('environment', environment)
          ..add('integrations', integrations)
          ..add('queues', queues)
          ..add('scheduledTasks', scheduledTasks)
          ..add('analytics', analytics)
          ..add('canRetry', canRetry))
        .toString();
  }
}

class IntegrationOverviewBuilder
    implements Builder<IntegrationOverview, IntegrationOverviewBuilder> {
  _$IntegrationOverview? _$v;

  DateTime? _generatedAt;
  DateTime? get generatedAt => _$this._generatedAt;
  set generatedAt(DateTime? generatedAt) => _$this._generatedAt = generatedAt;

  MapBuilder<String, JsonObject?>? _environment;
  MapBuilder<String, JsonObject?> get environment =>
      _$this._environment ??= MapBuilder<String, JsonObject?>();
  set environment(MapBuilder<String, JsonObject?>? environment) =>
      _$this._environment = environment;

  ListBuilder<IntegrationStatus>? _integrations;
  ListBuilder<IntegrationStatus> get integrations =>
      _$this._integrations ??= ListBuilder<IntegrationStatus>();
  set integrations(ListBuilder<IntegrationStatus>? integrations) =>
      _$this._integrations = integrations;

  MapBuilder<String, JsonObject?>? _queues;
  MapBuilder<String, JsonObject?> get queues =>
      _$this._queues ??= MapBuilder<String, JsonObject?>();
  set queues(MapBuilder<String, JsonObject?>? queues) =>
      _$this._queues = queues;

  ListBuilder<ScheduledTaskHealth>? _scheduledTasks;
  ListBuilder<ScheduledTaskHealth> get scheduledTasks =>
      _$this._scheduledTasks ??= ListBuilder<ScheduledTaskHealth>();
  set scheduledTasks(ListBuilder<ScheduledTaskHealth>? scheduledTasks) =>
      _$this._scheduledTasks = scheduledTasks;

  MapBuilder<String, JsonObject?>? _analytics;
  MapBuilder<String, JsonObject?> get analytics =>
      _$this._analytics ??= MapBuilder<String, JsonObject?>();
  set analytics(MapBuilder<String, JsonObject?>? analytics) =>
      _$this._analytics = analytics;

  bool? _canRetry;
  bool? get canRetry => _$this._canRetry;
  set canRetry(bool? canRetry) => _$this._canRetry = canRetry;

  IntegrationOverviewBuilder() {
    IntegrationOverview._defaults(this);
  }

  IntegrationOverviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _generatedAt = $v.generatedAt;
      _environment = $v.environment.toBuilder();
      _integrations = $v.integrations.toBuilder();
      _queues = $v.queues.toBuilder();
      _scheduledTasks = $v.scheduledTasks.toBuilder();
      _analytics = $v.analytics.toBuilder();
      _canRetry = $v.canRetry;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IntegrationOverview other) {
    _$v = other as _$IntegrationOverview;
  }

  @override
  void update(void Function(IntegrationOverviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IntegrationOverview build() => _build();

  _$IntegrationOverview _build() {
    _$IntegrationOverview _$result;
    try {
      _$result = _$v ??
          _$IntegrationOverview._(
            generatedAt: BuiltValueNullFieldError.checkNotNull(
                generatedAt, r'IntegrationOverview', 'generatedAt'),
            environment: environment.build(),
            integrations: integrations.build(),
            queues: queues.build(),
            scheduledTasks: scheduledTasks.build(),
            analytics: analytics.build(),
            canRetry: BuiltValueNullFieldError.checkNotNull(
                canRetry, r'IntegrationOverview', 'canRetry'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'environment';
        environment.build();
        _$failedField = 'integrations';
        integrations.build();
        _$failedField = 'queues';
        queues.build();
        _$failedField = 'scheduledTasks';
        scheduledTasks.build();
        _$failedField = 'analytics';
        analytics.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'IntegrationOverview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
