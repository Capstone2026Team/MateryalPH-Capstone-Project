// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_compliance.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ListingComplianceBadgeEnum _$listingComplianceBadgeEnum_PS_ICC_VERIFIED =
    const ListingComplianceBadgeEnum._('PS_ICC_VERIFIED');

ListingComplianceBadgeEnum _$listingComplianceBadgeEnumValueOf(String name) {
  switch (name) {
    case 'PS_ICC_VERIFIED':
      return _$listingComplianceBadgeEnum_PS_ICC_VERIFIED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ListingComplianceBadgeEnum> _$listingComplianceBadgeEnumValues =
    BuiltSet<ListingComplianceBadgeEnum>(const <ListingComplianceBadgeEnum>[
  _$listingComplianceBadgeEnum_PS_ICC_VERIFIED,
]);

Serializer<ListingComplianceBadgeEnum> _$listingComplianceBadgeEnumSerializer =
    _$ListingComplianceBadgeEnumSerializer();

class _$ListingComplianceBadgeEnumSerializer
    implements PrimitiveSerializer<ListingComplianceBadgeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'PS_ICC_VERIFIED': 'PS_ICC_VERIFIED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'PS_ICC_VERIFIED': 'PS_ICC_VERIFIED',
  };

  @override
  final Iterable<Type> types = const <Type>[ListingComplianceBadgeEnum];
  @override
  final String wireName = 'ListingComplianceBadgeEnum';

  @override
  Object serialize(Serializers serializers, ListingComplianceBadgeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ListingComplianceBadgeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ListingComplianceBadgeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ListingCompliance extends ListingCompliance {
  @override
  final bool regulated;
  @override
  final String status;
  @override
  final ListingComplianceBadgeEnum? badge;
  @override
  final String? requiredMarking;
  @override
  final String notice;

  factory _$ListingCompliance(
          [void Function(ListingComplianceBuilder)? updates]) =>
      (ListingComplianceBuilder()..update(updates))._build();

  _$ListingCompliance._(
      {required this.regulated,
      required this.status,
      this.badge,
      this.requiredMarking,
      required this.notice})
      : super._();
  @override
  ListingCompliance rebuild(void Function(ListingComplianceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ListingComplianceBuilder toBuilder() =>
      ListingComplianceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ListingCompliance &&
        regulated == other.regulated &&
        status == other.status &&
        badge == other.badge &&
        requiredMarking == other.requiredMarking &&
        notice == other.notice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, regulated.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, badge.hashCode);
    _$hash = $jc(_$hash, requiredMarking.hashCode);
    _$hash = $jc(_$hash, notice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ListingCompliance')
          ..add('regulated', regulated)
          ..add('status', status)
          ..add('badge', badge)
          ..add('requiredMarking', requiredMarking)
          ..add('notice', notice))
        .toString();
  }
}

class ListingComplianceBuilder
    implements Builder<ListingCompliance, ListingComplianceBuilder> {
  _$ListingCompliance? _$v;

  bool? _regulated;
  bool? get regulated => _$this._regulated;
  set regulated(bool? regulated) => _$this._regulated = regulated;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  ListingComplianceBadgeEnum? _badge;
  ListingComplianceBadgeEnum? get badge => _$this._badge;
  set badge(ListingComplianceBadgeEnum? badge) => _$this._badge = badge;

  String? _requiredMarking;
  String? get requiredMarking => _$this._requiredMarking;
  set requiredMarking(String? requiredMarking) =>
      _$this._requiredMarking = requiredMarking;

  String? _notice;
  String? get notice => _$this._notice;
  set notice(String? notice) => _$this._notice = notice;

  ListingComplianceBuilder() {
    ListingCompliance._defaults(this);
  }

  ListingComplianceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _regulated = $v.regulated;
      _status = $v.status;
      _badge = $v.badge;
      _requiredMarking = $v.requiredMarking;
      _notice = $v.notice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ListingCompliance other) {
    _$v = other as _$ListingCompliance;
  }

  @override
  void update(void Function(ListingComplianceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ListingCompliance build() => _build();

  _$ListingCompliance _build() {
    final _$result = _$v ??
        _$ListingCompliance._(
          regulated: BuiltValueNullFieldError.checkNotNull(
              regulated, r'ListingCompliance', 'regulated'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'ListingCompliance', 'status'),
          badge: badge,
          requiredMarking: requiredMarking,
          notice: BuiltValueNullFieldError.checkNotNull(
              notice, r'ListingCompliance', 'notice'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
