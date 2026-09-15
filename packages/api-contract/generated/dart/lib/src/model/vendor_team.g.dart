// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_team.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorTeam extends VendorTeam {
  @override
  final BuiltList<VendorTeamMember> members;
  @override
  final int page;
  @override
  final int lastPage;
  @override
  final int total;

  factory _$VendorTeam([void Function(VendorTeamBuilder)? updates]) =>
      (VendorTeamBuilder()..update(updates))._build();

  _$VendorTeam._(
      {required this.members,
      required this.page,
      required this.lastPage,
      required this.total})
      : super._();
  @override
  VendorTeam rebuild(void Function(VendorTeamBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorTeamBuilder toBuilder() => VendorTeamBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorTeam &&
        members == other.members &&
        page == other.page &&
        lastPage == other.lastPage &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, lastPage.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorTeam')
          ..add('members', members)
          ..add('page', page)
          ..add('lastPage', lastPage)
          ..add('total', total))
        .toString();
  }
}

class VendorTeamBuilder implements Builder<VendorTeam, VendorTeamBuilder> {
  _$VendorTeam? _$v;

  ListBuilder<VendorTeamMember>? _members;
  ListBuilder<VendorTeamMember> get members =>
      _$this._members ??= ListBuilder<VendorTeamMember>();
  set members(ListBuilder<VendorTeamMember>? members) =>
      _$this._members = members;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _lastPage;
  int? get lastPage => _$this._lastPage;
  set lastPage(int? lastPage) => _$this._lastPage = lastPage;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  VendorTeamBuilder() {
    VendorTeam._defaults(this);
  }

  VendorTeamBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _members = $v.members.toBuilder();
      _page = $v.page;
      _lastPage = $v.lastPage;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorTeam other) {
    _$v = other as _$VendorTeam;
  }

  @override
  void update(void Function(VendorTeamBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorTeam build() => _build();

  _$VendorTeam _build() {
    _$VendorTeam _$result;
    try {
      _$result = _$v ??
          _$VendorTeam._(
            members: members.build(),
            page: BuiltValueNullFieldError.checkNotNull(
                page, r'VendorTeam', 'page'),
            lastPage: BuiltValueNullFieldError.checkNotNull(
                lastPage, r'VendorTeam', 'lastPage'),
            total: BuiltValueNullFieldError.checkNotNull(
                total, r'VendorTeam', 'total'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'members';
        members.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'VendorTeam', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
