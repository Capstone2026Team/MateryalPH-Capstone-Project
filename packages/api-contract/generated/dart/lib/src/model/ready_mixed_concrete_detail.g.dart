// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ready_mixed_concrete_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReadyMixedConcreteDetailDeliveryVehicleEnum
    _$readyMixedConcreteDetailDeliveryVehicleEnum_CONCRETE_MIXER =
    const ReadyMixedConcreteDetailDeliveryVehicleEnum._('CONCRETE_MIXER');

ReadyMixedConcreteDetailDeliveryVehicleEnum
    _$readyMixedConcreteDetailDeliveryVehicleEnumValueOf(String name) {
  switch (name) {
    case 'CONCRETE_MIXER':
      return _$readyMixedConcreteDetailDeliveryVehicleEnum_CONCRETE_MIXER;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReadyMixedConcreteDetailDeliveryVehicleEnum>
    _$readyMixedConcreteDetailDeliveryVehicleEnumValues = BuiltSet<
        ReadyMixedConcreteDetailDeliveryVehicleEnum>(const <ReadyMixedConcreteDetailDeliveryVehicleEnum>[
  _$readyMixedConcreteDetailDeliveryVehicleEnum_CONCRETE_MIXER,
]);

Serializer<ReadyMixedConcreteDetailDeliveryVehicleEnum>
    _$readyMixedConcreteDetailDeliveryVehicleEnumSerializer =
    _$ReadyMixedConcreteDetailDeliveryVehicleEnumSerializer();

class _$ReadyMixedConcreteDetailDeliveryVehicleEnumSerializer
    implements
        PrimitiveSerializer<ReadyMixedConcreteDetailDeliveryVehicleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'CONCRETE_MIXER': 'CONCRETE_MIXER',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'CONCRETE_MIXER': 'CONCRETE_MIXER',
  };

  @override
  final Iterable<Type> types = const <Type>[
    ReadyMixedConcreteDetailDeliveryVehicleEnum
  ];
  @override
  final String wireName = 'ReadyMixedConcreteDetailDeliveryVehicleEnum';

  @override
  Object serialize(Serializers serializers,
          ReadyMixedConcreteDetailDeliveryVehicleEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReadyMixedConcreteDetailDeliveryVehicleEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReadyMixedConcreteDetailDeliveryVehicleEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReadyMixedConcreteDetail extends ReadyMixedConcreteDetail {
  @override
  final String quantityLabel;
  @override
  final String strengthAttribute;
  @override
  final String strengthLabel;
  @override
  final ReadyMixedConcreteDetailDeliveryVehicleEnum deliveryVehicle;
  @override
  final bool siteDeliveryOnly;
  @override
  final ReadyMixedConcreteSiteInspection siteInspection;
  @override
  final String notice;

  factory _$ReadyMixedConcreteDetail(
          [void Function(ReadyMixedConcreteDetailBuilder)? updates]) =>
      (ReadyMixedConcreteDetailBuilder()..update(updates))._build();

  _$ReadyMixedConcreteDetail._(
      {required this.quantityLabel,
      required this.strengthAttribute,
      required this.strengthLabel,
      required this.deliveryVehicle,
      required this.siteDeliveryOnly,
      required this.siteInspection,
      required this.notice})
      : super._();
  @override
  ReadyMixedConcreteDetail rebuild(
          void Function(ReadyMixedConcreteDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReadyMixedConcreteDetailBuilder toBuilder() =>
      ReadyMixedConcreteDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReadyMixedConcreteDetail &&
        quantityLabel == other.quantityLabel &&
        strengthAttribute == other.strengthAttribute &&
        strengthLabel == other.strengthLabel &&
        deliveryVehicle == other.deliveryVehicle &&
        siteDeliveryOnly == other.siteDeliveryOnly &&
        siteInspection == other.siteInspection &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quantityLabel.hashCode);
    _$hash = $jc(_$hash, strengthAttribute.hashCode);
    _$hash = $jc(_$hash, strengthLabel.hashCode);
    _$hash = $jc(_$hash, deliveryVehicle.hashCode);
    _$hash = $jc(_$hash, siteDeliveryOnly.hashCode);
    _$hash = $jc(_$hash, siteInspection.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReadyMixedConcreteDetail')
          ..add('quantityLabel', quantityLabel)
          ..add('strengthAttribute', strengthAttribute)
          ..add('strengthLabel', strengthLabel)
          ..add('deliveryVehicle', deliveryVehicle)
          ..add('siteDeliveryOnly', siteDeliveryOnly)
          ..add('siteInspection', siteInspection)
          ..add('notice', notice))
        .toString();
  }
}

class ReadyMixedConcreteDetailBuilder
    implements
        Builder<ReadyMixedConcreteDetail, ReadyMixedConcreteDetailBuilder> {
  _$ReadyMixedConcreteDetail? _$v;

  String? _quantityLabel;
  String? get quantityLabel => _$this._quantityLabel;
  set quantityLabel(String? quantityLabel) =>
      _$this._quantityLabel = quantityLabel;

  String? _strengthAttribute;
  String? get strengthAttribute => _$this._strengthAttribute;
  set strengthAttribute(String? strengthAttribute) =>
      _$this._strengthAttribute = strengthAttribute;

  String? _strengthLabel;
  String? get strengthLabel => _$this._strengthLabel;
  set strengthLabel(String? strengthLabel) =>
      _$this._strengthLabel = strengthLabel;

  ReadyMixedConcreteDetailDeliveryVehicleEnum? _deliveryVehicle;
  ReadyMixedConcreteDetailDeliveryVehicleEnum? get deliveryVehicle =>
      _$this._deliveryVehicle;
  set deliveryVehicle(
          ReadyMixedConcreteDetailDeliveryVehicleEnum? deliveryVehicle) =>
      _$this._deliveryVehicle = deliveryVehicle;

  bool? _siteDeliveryOnly;
  bool? get siteDeliveryOnly => _$this._siteDeliveryOnly;
  set siteDeliveryOnly(bool? siteDeliveryOnly) =>
      _$this._siteDeliveryOnly = siteDeliveryOnly;

  ReadyMixedConcreteSiteInspectionBuilder? _siteInspection;
  ReadyMixedConcreteSiteInspectionBuilder get siteInspection =>
      _$this._siteInspection ??= ReadyMixedConcreteSiteInspectionBuilder();
  set siteInspection(ReadyMixedConcreteSiteInspectionBuilder? siteInspection) =>
      _$this._siteInspection = siteInspection;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  ReadyMixedConcreteDetailBuilder() {
    ReadyMixedConcreteDetail._defaults(this);
  }

  ReadyMixedConcreteDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quantityLabel = $v.quantityLabel;
      _strengthAttribute = $v.strengthAttribute;
      _strengthLabel = $v.strengthLabel;
      _deliveryVehicle = $v.deliveryVehicle;
      _siteDeliveryOnly = $v.siteDeliveryOnly;
      _siteInspection = $v.siteInspection.toBuilder();
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReadyMixedConcreteDetail other) {
    _$v = other as _$ReadyMixedConcreteDetail;
  }

  @override
  void update(void Function(ReadyMixedConcreteDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReadyMixedConcreteDetail build() => _build();

  _$ReadyMixedConcreteDetail _build() {
    _$ReadyMixedConcreteDetail _$result;
    try {
      _$result = _$v ??
          _$ReadyMixedConcreteDetail._(
            quantityLabel: BuiltValueNullFieldError.checkNotNull(
                quantityLabel, r'ReadyMixedConcreteDetail', 'quantityLabel'),
            strengthAttribute: BuiltValueNullFieldError.checkNotNull(
                strengthAttribute,
                r'ReadyMixedConcreteDetail',
                'strengthAttribute'),
            strengthLabel: BuiltValueNullFieldError.checkNotNull(
                strengthLabel, r'ReadyMixedConcreteDetail', 'strengthLabel'),
            deliveryVehicle: BuiltValueNullFieldError.checkNotNull(
                deliveryVehicle,
                r'ReadyMixedConcreteDetail',
                'deliveryVehicle'),
            siteDeliveryOnly: BuiltValueNullFieldError.checkNotNull(
                siteDeliveryOnly,
                r'ReadyMixedConcreteDetail',
                'siteDeliveryOnly'),
            siteInspection: siteInspection.build(),
            notice: BuiltValueNullFieldError.checkNotNull(
                notice, r'ReadyMixedConcreteDetail', 'notice'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'siteInspection';
        siteInspection.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ReadyMixedConcreteDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
