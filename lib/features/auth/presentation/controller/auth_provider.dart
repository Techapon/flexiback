import 'package:flexiback/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flexiback/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flexiback/features/auth/domain/entities/user_entity.dart';
import 'package:flexiback/features/auth/domain/usecases/login_usecase.dart';
import 'package:flexiback/features/auth/domain/usecases/signup_usecase.dart';
import 'package:flutter/material.dart';

class AuthProvider  extends ChangeNotifier {
    final loginUseCase = 
        LoginUseCase(AuthRepositoryImpl(AuthRemoteDataSource()));

    final signupUseCase = 
        SignupUseCase(AuthRepositoryImpl(AuthRemoteDataSource()));

    bool _isLoading = false;
    bool _isLoggedIn = false;
    String? error;

    String? errorEmail;
    String? errorPassword;
    String? errorConfirmPassword;
    UserEntity? _user;

    // Getter
    bool get isLoading => _isLoading;
    bool get isLoggedIn => _isLoggedIn;

    // Validate
    String? validateEmail(String email) {
        if (email.isEmpty) {
            return "Please enter your email";
        }
        if (!email.contains("@")) {
            return "Please enter a valid email address";
        }
        return null;
    }

    String? validatePassword(String password) {
        if (password.isEmpty) {
            return "Please enter your password";
        }
        if (password.length < 6) {
            return "Password must be at least 6 characters long";
        }
        return null;
    }

    String? validateConfirmPassword(String password, String confirmPassword) {
        if (confirmPassword.isEmpty) {
            return "Please enter your password";
        }
        if (password != confirmPassword) {
            return "Passwords do not match";
        }
        return null;
    }

    //  Usecase
    Future<void> login(String email, String password) async {
        errorEmail = validateEmail(email);
        errorPassword = validatePassword(password);

        if (errorEmail != null || errorPassword != null) {
            notifyListeners();
            return;
        }
        

        _isLoading = true;
        notifyListeners();

        try {
            _user = await loginUseCase.call(email, password);
            error = null;
            _isLoggedIn = true;
        }catch (e) {
            error = e.toString();
        }

        _isLoading = false;
        notifyListeners();
    }


    Future<void> signup(
        String email,
        String password,
        String confirmPassword
    ) async {
        errorEmail = validateEmail(email);
        errorPassword = validatePassword(password);
        errorConfirmPassword = validateConfirmPassword(password, confirmPassword);

        if (errorEmail != null || errorPassword != null || errorConfirmPassword != null) {
            notifyListeners();
            return;
        }

        _isLoading = true;
        notifyListeners();

        try  {
            _user = await signupUseCase.call(email, password);
            error = null;
        }catch (e) {
            error = e.toString();
        }

        _isLoading = false;
        notifyListeners();
    }

    void clearError() {
        error = null;
        errorEmail = null;
        errorPassword = null;
        errorConfirmPassword = null;
        // notifyListeners();
    }

    
}