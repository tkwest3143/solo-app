// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../work_time_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workTimeListStateHash() => r'c62884b1137f690d9b07b54a2c7bbc08f5cfd37c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$WorkTimeListState
    extends BuildlessAutoDisposeAsyncNotifier<List<WorkTime>> {
  late final int userId;

  FutureOr<List<WorkTime>> build(
    int userId,
  );
}

/// See also [WorkTimeListState].
@ProviderFor(WorkTimeListState)
const workTimeListStateProvider = WorkTimeListStateFamily();

/// See also [WorkTimeListState].
class WorkTimeListStateFamily extends Family<AsyncValue<List<WorkTime>>> {
  /// See also [WorkTimeListState].
  const WorkTimeListStateFamily();

  /// See also [WorkTimeListState].
  WorkTimeListStateProvider call(
    int userId,
  ) {
    return WorkTimeListStateProvider(
      userId,
    );
  }

  @override
  WorkTimeListStateProvider getProviderOverride(
    covariant WorkTimeListStateProvider provider,
  ) {
    return call(
      provider.userId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workTimeListStateProvider';
}

/// See also [WorkTimeListState].
class WorkTimeListStateProvider extends AutoDisposeAsyncNotifierProviderImpl<
    WorkTimeListState, List<WorkTime>> {
  /// See also [WorkTimeListState].
  WorkTimeListStateProvider(
    int userId,
  ) : this._internal(
          () => WorkTimeListState()..userId = userId,
          from: workTimeListStateProvider,
          name: r'workTimeListStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workTimeListStateHash,
          dependencies: WorkTimeListStateFamily._dependencies,
          allTransitiveDependencies:
              WorkTimeListStateFamily._allTransitiveDependencies,
          userId: userId,
        );

  WorkTimeListStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final int userId;

  @override
  FutureOr<List<WorkTime>> runNotifierBuild(
    covariant WorkTimeListState notifier,
  ) {
    return notifier.build(
      userId,
    );
  }

  @override
  Override overrideWith(WorkTimeListState Function() create) {
    return ProviderOverride(
      origin: this,
      override: WorkTimeListStateProvider._internal(
        () => create()..userId = userId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<WorkTimeListState, List<WorkTime>>
      createElement() {
    return _WorkTimeListStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkTimeListStateProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WorkTimeListStateRef
    on AutoDisposeAsyncNotifierProviderRef<List<WorkTime>> {
  /// The parameter `userId` of this provider.
  int get userId;
}

class _WorkTimeListStateProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<WorkTimeListState,
        List<WorkTime>> with WorkTimeListStateRef {
  _WorkTimeListStateProviderElement(super.provider);

  @override
  int get userId => (origin as WorkTimeListStateProvider).userId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
