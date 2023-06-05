import 'package:flutter/material.dart';

/// The state of the `Provider` which describes whether the current working
/// provider has a running process [loading] or not [idle].
enum ProviderState {
  loading,
  idle,
}

/// The type of the emitted loading when the provider has a running process
/// in it.
abstract class LoadingType {
  static const int none = 0;

  /// A fullscreen loading will use the `onShowFullScreenLoadingDialog` and
  /// `onHideFullScreenLoadingDialog` in which they should be implemented
  /// in order to show and hide a custom fullscreen loading dialog.
  static const int fullScreenLoading = 1;

  /// A state loading will set the state of the provider to `loading`, which
  /// then can be used to see of the provider is loading or not.
  static const int stateLoading = 2;
}

abstract class BaseChangeNotifier<T, E> extends ChangeNotifier {
  T? _data;
  E? _error;
  ProviderState _providerState = ProviderState.idle;
  bool _running = false;

  int? _loadingType;

  void Function(T data)? onData;
  void Function(E? error)? onError;

  /// An async method that triggers an async `callback` (typically process)
  /// which sets the provider in its selected state.
  ///
  /// The property `busy` is `true` when the `callback` hasn't finished yet,
  /// otherwise it's `false`.
  @protected
  Future<void> run(
    /// A callback that has to be triggered in async in order to await the
    /// returned results if exists.
    final Future<void> Function() callback, {
    /// The loading type of the current working provider.
    int? loadingType = LoadingType.stateLoading,
  }) async {
    if (!_running) {
      _running = true;
      _loadingType = loadingType;
      switch (loadingType) {
        case LoadingType.fullScreenLoading:
          onShowFullScreenLoadingDialog();
          break;
        case LoadingType.stateLoading:
          loading();
          break;
      }
      await callback();
      _running = false;
    }
  }

  /// Calling `loading()` will set the state to `ProviderState.loading`
  /// which then notify all listeners.
  @protected
  void loading() {
    _providerState = ProviderState.loading;
    notifyListeners();
  }

  /// Calling `idle()` will set the state to `ProviderState.idle`
  /// if the `loadingType` is `stateLoading`, otherwise it will call the
  /// `onHideFullScreenLoadingDialog()` method in order to hide any
  /// fullscreen loading dialog.
  @protected
  void idle() {
    switch (_loadingType) {
      case LoadingType.fullScreenLoading:
        onHideFullScreenLoadingDialog();
        break;
      case LoadingType.stateLoading:
      case LoadingType.none:
        _providerState = ProviderState.idle;
        break;
    }
    notifyListeners();
  }

  /// Must be implemented if the `loadingType` is set to
  /// `loadingType.fullScreenLoading` in order to show a fullscreen loading
  /// dialog.
  @protected
  void onShowFullScreenLoadingDialog() {
    throw UnimplementedError(
      'Must be implemented when loadingType is loadingType.fullScreenLoading',
    );
  }

  /// Must be implemented if the `loadingType` is set to
  /// `loadingType.fullScreenLoading` in order to hide the fullscreen loading
  /// dialog.
  @protected
  void onHideFullScreenLoadingDialog() {
    throw UnimplementedError(
      'Must be implemented when loadingType is loadingType.fullScreenLoading',
    );
  }

  /// Set the provider `data`.
  @protected
  set data(T? data) {
    _error = null;
    _data = data;
    if (hasData) onData?.call(_data as T);
    idle();
  }

  /// Set the provider `error` (typically a DioError type).
  @protected
  set error(E? error) {
    _data = null;
    _error = error;
    onError?.call(_error);
    idle();
  }

  /// Sets `data` and `error` to null.
  @protected
  void clear() {
    _data = null;
    _error = null;
  }

  /// Get the provider `data`.
  T? get data => _data;

  /// Get the provider `error` (typically a DioError type).
  E? get error => _error;

  /// Get the provider `state` which is either `loading` or `idle`
  ///
  /// See [ProviderState]
  ProviderState get state => _providerState;

  /// Whether the provider at some point has data.
  bool get hasData => _data != null;

  /// Whether the provider at some point has error.
  bool get hasError => _error != null;

  /// true, if the `callback` which was triggered in the `run` method is
  /// finished or not.
  bool get busy => _running;
}
