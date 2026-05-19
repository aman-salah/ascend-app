import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../services/supabase_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthCheckSessionEvent>(_onCheckSession);
    on<AuthLoginEvent>(_onLogin);
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthLogoutEvent>(_onLogout);
  }

  Future<void> _onCheckSession(
    AuthCheckSessionEvent event,
    Emitter<AuthState> emit,
  ) async {
    final session = SupabaseService.client.auth.currentSession;
    if (session != null) {
      emit(AuthAuthenticatedState());
    } else {
      emit(AuthUnauthenticatedState());
    }
  }

  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await SupabaseService.client.auth.signInWithPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticatedState());
    } on AuthException catch (e) {
      emit(AuthErrorState(message: e.message));
    } catch (e) {
      emit(AuthErrorState(message: 'Something went wrong.'));
    }
  }

  Future<void> _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await SupabaseService.client.auth.signUp(
        email: event.email,
        password: event.password,
        data: {'name': event.name},
      );
      emit(AuthAuthenticatedState());
    } on AuthException catch (e) {
      emit(AuthErrorState(message: e.message));
    } catch (e) {
      emit(AuthErrorState(message: 'Something went wrong.'));
    }
  }

  Future<void> _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    await SupabaseService.client.auth.signOut();
    emit(AuthUnauthenticatedState());
  }
}
