## BaseChangeNotifier

A change notifier base class which helps reducing boilerplate code used in the
`ChangeNotifier` classes

## Usage

```dart
class AuthProvider extends BaseChangeNotifier<AuthResponse, DioException> {
    final AuthRepository _authRepository;

    AuthProvider(this._authRepository);

    Future<void> login({required LoginRequest request}) async {
        await run(() async {
            final response = await _apiRepository.login(request);

            if (response.isSuccessfull) {
                /// [response.data] is a [AuthResponse] type
                data = response.data;
            } else {
                /// [response.error] is a [DioException] type
                error = response.error;
            }
        }, loadingType: LoadingType.fullscreenLoading);
    }

    /// Ignore overriding it if the [loadingType] is [loadingType.stateLoading]
    @override
    void onShowFullScreenLoadingDialog() {
        showFullScreenLoadingDialog();
    }

    /// Ignore overriding it if the [loadingType] is [loadingType.stateLoading]
    @override
    void onHideFullScreenLoadingDialog() {
        hideFullScreenLoadingDialog();
    }
}
```

## Medium articles by the author

You can always read the articles I write on my [devmuaz](https://devmuaz.medium.com/) account which I write pretty great flutter content out there.

## Contributions & Support

Issues and pull requests are always welcome 😄

If you find this package useful for you and liked it, give it a like ❤️ and star the repo ⭐️ it would mean a lot!

## License

**MIT**
