import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user_retrieval.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_out.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final UserSignOut _userSignOut;
  final CurrentUserRetrieval _currentUserRetrieval;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CurrentUserRetrieval currentUserRetrieval,
    required UserSignOut userSignOut,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _userSignOut = userSignOut,
        _currentUserRetrieval = currentUserRetrieval,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>(_onAuthEvent);
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignIn>(_onAuthSignIn);
    on<AuthIsUserSignedIn>(_onAuthIsUserSignedIn);
    on<AuthSignOut>(_onAuthSignOut);
  }

  void _onAuthEvent(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthLoading());
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userSignUp(
      UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    response.fold(
      (failure) {
        _emitAuthFailure(failure.message, emit);
      },
      (user) {
        _emitAuthSuccess(user, emit);
      },
    );
  }

  void _onAuthSignIn(
    AuthSignIn event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userSignIn(
      UserSignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    response.fold(
      (failure) {
        _emitAuthFailure(failure.message, emit);
      },
      (user) {
        _emitAuthSuccess(user, emit);
      },
    );
  }

  void _onAuthIsUserSignedIn(
    AuthIsUserSignedIn event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _currentUserRetrieval(NoParams());
    response.fold(
      (failure) {
        _emitAuthFailure(failure.message, emit);
      },
      (user) {
        _emitAuthSuccess(user, emit);
      },
    );
  }

  void _onAuthSignOut(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) async {
    final response = await _userSignOut(NoParams());
    response.fold(
      (failure) {
        _emitAuthFailure(failure.message, emit);
      },
      (voidReturn) {
        emit(AuthSignOutSuccess());
      },
    );
  }

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }

  void _emitAuthFailure(
    String message,
    Emitter<AuthState> emit,
  ) {
    emit(AuthFailure(message: message));
  }
}
