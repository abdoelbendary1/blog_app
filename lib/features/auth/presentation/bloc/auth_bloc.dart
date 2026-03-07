import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user_entity.dart';
import 'package:blog_app/features/auth/domain/usecases/curent_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserSignUp _userSignUp;
  UserLogin _userLogin;
  CurrentUser _currentUser;
  AppUserCubit? _appUserCubit;

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    print(change);
  }

  AuthBloc(
      {required UserSignUp userSignUp,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required AppUserCubit? appUserCubit})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onSignUP);
    on<AuthLogin>(_onLogin);
    on<IsUserLoggedIn>(_isUserLoggedIn);
  }

  Future<void> _onSignUP(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(UserSignUpParams(
      email: event.email,
      password: event.password,
      name: event.name,
    ));
    res.fold(
      (l) => emit(AuthFailure(errorMessage: l.message!)),
      (user) => _emitUserLoggedIn(user, emit),
    );
  }

  Future<void> _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(UserLoginParams(
      email: event.email,
      password: event.password,
    ));
    res.fold(
      (l) => emit(AuthFailure(errorMessage: l.message!)),
      (user) => _emitUserLoggedIn(user, emit),
    );
  }

  FutureOr<void> _isUserLoggedIn(
      IsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());
    res.fold(
        (l) => emit(AuthFailure(errorMessage: l.message!)),
        (user) =>
            user != null ? _emitUserLoggedIn(user, emit) : emit(AuthInitial()));
  }

  void _emitUserLoggedIn(User user, Emitter<AuthState> emit) {
    _appUserCubit?.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
