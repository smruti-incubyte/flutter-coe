# Flutter BLoC State Management Guide

A comprehensive guide to the BLoC (Business Logic Component) design pattern and its implementation in Flutter.

## Table of Contents

- [Introduction](#introduction)
- [Core Concepts](#core-concepts)
- [Package: bloc](#package-bloc)
- [Package: flutter_bloc](#package-flutter_bloc)
- [Cubit](#cubit)
- [Bloc](#bloc)
- [Flutter Widgets](#flutter-widgets)
- [Best Practices](#best-practices)
- [Examples](#examples)
- [Resources](#resources)

---

## Introduction

The BLoC (Business Logic Component) pattern is a predictable state management library that helps separate presentation from business logic in Flutter applications. It's built on top of streams and reactive programming principles.

### Why BLoC?

- **Separation of Concerns**: Business logic is completely separated from UI
- **Testability**: Easy to test business logic without UI dependencies
- **Reusability**: Blocs can be reused across different parts of the app
- **Predictability**: State changes are predictable and traceable
- **Platform Independence**: Core business logic works across all platforms

### Package Information

| Package | Version | Pub.dev |
|---------|---------|---------|
| **bloc** | 9.2.0 | [pub.dev/packages/bloc](https://pub.dev/packages/bloc) |
| **flutter_bloc** | 9.1.1 | [pub.dev/packages/flutter_bloc](https://pub.dev/packages/flutter_bloc) |

---

## Core Concepts

### BLoC Architecture

```
┌─────────────────────────────────────────────┐
│                  UI Layer                   │
│         (Widgets, Screens, Pages)           │
└──────────────────┬──────────────────────────┘
                   │
                   │ Events/Methods
                   ▼
┌─────────────────────────────────────────────┐
│             BLoC/Cubit Layer                │
│           (Business Logic)                  │
└──────────────────┬──────────────────────────┘
                   │
                   │ State Changes
                   ▼
┌─────────────────────────────────────────────┐
│                UI Updates                   │
│         (Automatic Rebuilds)                │
└─────────────────────────────────────────────┘
```

### Key Principles

1. **Events In, States Out**: UI sends events/calls methods, BLoC emits states
2. **Unidirectional Data Flow**: Data flows in one direction
3. **Single Responsibility**: Each BLoC handles one feature/domain
4. **Immutable State**: States are immutable for predictability

---

## Package: bloc

The `bloc` package is the core Dart package that provides the foundation for BLoC pattern implementation. It works with any Dart project (Flutter, AngularDart, web, CLI).

### Installation

```yaml
dependencies:
  bloc: ^9.2.0
```

### Core Classes

- **BlocBase**: Base class for Cubit and Bloc
- **Cubit**: Simplified state management with methods
- **Bloc**: Event-driven state management
- **BlocObserver**: Global observer for all Blocs/Cubits
- **Change**: Represents a state change (currentState → nextState)
- **Transition**: Represents an event → state change (includes event, currentState, nextState)

---

## Package: flutter_bloc

The `flutter_bloc` package provides Flutter-specific widgets that integrate seamlessly with the `bloc` package.

### Installation

```yaml
dependencies:
  flutter_bloc: ^9.1.1
```

### Key Widgets

- **BlocProvider**: Provides a Bloc/Cubit to the widget tree
- **BlocBuilder**: Rebuilds UI in response to state changes
- **BlocListener**: Performs side effects in response to state changes
- **BlocConsumer**: Combines BlocBuilder and BlocListener
- **BlocSelector**: Filters state updates based on selected value
- **RepositoryProvider**: Provides repositories to the widget tree

---

## Cubit

Cubit is a simplified version of Bloc that uses methods instead of events. Perfect for simple state management scenarios.

### Cubit Architecture

```
┌──────────────┐
│   UI Layer   │
│              │
│  increment() │
└──────┬───────┘
       │
       │ Method Call
       ▼
┌──────────────────┐
│   CounterCubit   │
│   state: int     │
│                  │
│  increment() {   │
│    emit(state+1) │
│  }               │
└──────┬───────────┘
       │
       │ emit()
       ▼
┌──────────────┐
│  New State   │
│  state: 1    │
└──────────────┘
```

### Creating a Cubit

```dart
import 'package:bloc/bloc.dart';

/// A simple counter cubit that manages an integer state
class CounterCubit extends Cubit<int> {
  /// Initialize with state 0
  CounterCubit() : super(0);

  /// Increment the counter
  void increment() => emit(state + 1);
  
  /// Decrement the counter
  void decrement() => emit(state - 1);
  
  /// Reset the counter
  void reset() => emit(0);
}
```

### Using a Cubit (Pure Dart)

```dart
void main() {
  // Create instance
  final cubit = CounterCubit();
  
  // Access state
  print(cubit.state); // 0
  
  // Trigger state changes
  cubit.increment();
  print(cubit.state); // 1
  
  cubit.increment();
  print(cubit.state); // 2
  
  // Always close when done
  cubit.close();
}
```

### Observing Cubit Changes

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    print(change); // Change { currentState: 0, nextState: 1 }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
```

### Cubit with Complex State

```dart
// State class
class UserState {
  final String name;
  final int age;
  final bool isLoading;

  const UserState({
    required this.name,
    required this.age,
    required this.isLoading,
  });

  // CopyWith for immutability
  UserState copyWith({
    String? name,
    int? age,
    bool? isLoading,
  }) {
    return UserState(
      name: name ?? this.name,
      age: age ?? this.age,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Cubit
class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState(name: '', age: 0, isLoading: false));

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateAge(int age) {
    emit(state.copyWith(age: age));
  }

  Future<void> loadUser() async {
    emit(state.copyWith(isLoading: true));
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    emit(state.copyWith(
      name: 'John Doe',
      age: 30,
      isLoading: false,
    ));
  }
}
```

---

## Bloc

Bloc is the event-driven version that uses events to trigger state changes. Best for complex state management with multiple event types.

### Bloc Architecture

```
┌────────────────┐
│    UI Layer    │
│                │
│ add(Event)     │
└────────┬───────┘
         │
         │ Add Event
         ▼
┌──────────────────────┐
│    CounterBloc       │
│                      │
│  on<Increment>() {   │
│    emit(state + 1)   │
│  }                   │
└────────┬─────────────┘
         │
         │ emit()
         ▼
┌──────────────┐
│  New State   │
└──────────────┘
```

### Creating a Bloc

```dart
import 'package:bloc/bloc.dart';

// Define events (using sealed classes for exhaustiveness)
sealed class CounterEvent {}

final class CounterIncrementPressed extends CounterEvent {}
final class CounterDecrementPressed extends CounterEvent {}

// Define the Bloc
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    // Register event handlers
    on<CounterIncrementPressed>((event, emit) {
      emit(state + 1);
    });

    on<CounterDecrementPressed>((event, emit) {
      emit(state - 1);
    });
  }
}
```

### Using a Bloc (Pure Dart)

```dart
Future<void> main() async {
  // Create instance
  final bloc = CounterBloc();
  
  // Access state
  print(bloc.state); // 0
  
  // Add events
  bloc.add(CounterIncrementPressed());
  
  // Wait for next event loop iteration
  await Future.delayed(Duration.zero);
  
  print(bloc.state); // 1
  
  // Close when done
  await bloc.close();
}
```

### Observing Bloc Changes

```dart
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
  }

  @override
  void onEvent(CounterEvent event) {
    super.onEvent(event);
    print('Event: $event');
  }

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    print('Change: $change');
  }

  @override
  void onTransition(Transition<CounterEvent, int> transition) {
    super.onTransition(transition);
    print('Transition: $transition');
    // Transition {
    //   currentState: 0,
    //   event: CounterIncrementPressed,
    //   nextState: 1
    // }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('Error: $error');
    super.onError(error, stackTrace);
  }

  @override
  void onDone(CounterEvent event, [Object? error, StackTrace? stackTrace]) {
    super.onDone(event, error, stackTrace);
    print('Done: $event');
  }
}
```

### Bloc with Async Operations

```dart
// Events
sealed class TodoEvent {}
final class TodoLoadRequested extends TodoEvent {}
final class TodoAdded extends TodoEvent {
  final String title;
  TodoAdded(this.title);
}
final class TodoDeleted extends TodoEvent {
  final String id;
  TodoDeleted(this.id);
}

// State
class TodoState {
  final List<Todo> todos;
  final bool isLoading;
  final String? error;

  const TodoState({
    this.todos = const [],
    this.isLoading = false,
    this.error,
  });

  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
    String? error,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Model
class Todo {
  final String id;
  final String title;
  final bool isCompleted;

  const Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

// Bloc
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc({required this.repository}) : super(TodoState()) {
    on<TodoLoadRequested>(_onLoadRequested);
    on<TodoAdded>(_onTodoAdded);
    on<TodoDeleted>(_onTodoDeleted);
  }

  Future<void> _onLoadRequested(
    TodoLoadRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final todos = await repository.fetchTodos();
      emit(state.copyWith(
        todos: todos,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onTodoAdded(
    TodoAdded event,
    Emitter<TodoState> emit,
  ) async {
    try {
      final todo = await repository.addTodo(event.title);
      emit(state.copyWith(
        todos: [...state.todos, todo],
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onTodoDeleted(
    TodoDeleted event,
    Emitter<TodoState> emit,
  ) async {
    try {
      await repository.deleteTodo(event.id);
      emit(state.copyWith(
        todos: state.todos.where((t) => t.id != event.id).toList(),
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
```

---

## Flutter Widgets

### BlocProvider

Provides a Bloc/Cubit to the widget tree via dependency injection.

```dart
// Creating a new Bloc
BlocProvider(
  create: (context) => CounterCubit(),
  child: CounterPage(),
)

// Lazy vs Eager creation
BlocProvider(
  create: (context) => CounterCubit(),
  lazy: false, // Create immediately (default is true)
  child: CounterPage(),
)

// Providing existing Bloc to new route
BlocProvider.value(
  value: BlocProvider.of<CounterCubit>(context),
  child: DetailPage(),
)
```

### MultiBlocProvider

Merge multiple BlocProviders into one.

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<CounterCubit>(
      create: (context) => CounterCubit(),
    ),
    BlocProvider<TodoBloc>(
      create: (context) => TodoBloc(
        repository: context.read<TodoRepository>(),
      ),
    ),
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
    ),
  ],
  child: MyApp(),
)
```

### BlocBuilder

Rebuilds UI in response to state changes.

```dart
BlocBuilder<CounterCubit, int>(
  builder: (context, state) {
    return Text('Count: $state');
  },
)

// With buildWhen for fine-grained control
BlocBuilder<CounterCubit, int>(
  buildWhen: (previous, current) {
    // Only rebuild when count is even
    return current % 2 == 0;
  },
  builder: (context, state) {
    return Text('Even count: $state');
  },
)

// Specifying bloc explicitly
BlocBuilder<CounterCubit, int>(
  bloc: counterCubit, // Use specific instance
  builder: (context, state) {
    return Text('Count: $state');
  },
)
```

### BlocListener

Performs side effects in response to state changes (navigation, dialogs, etc.).

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      Navigator.pushNamed(context, '/home');
    } else if (state is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  },
  child: LoginForm(),
)

// With listenWhen for fine-grained control
BlocListener<CounterCubit, int>(
  listenWhen: (previous, current) {
    // Only listen when count reaches 10
    return current == 10;
  },
  listener: (context, state) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text('Count reached 10!'),
      ),
    );
  },
  child: Container(),
)
```

### MultiBlocListener

Merge multiple BlocListeners into one.

```dart
MultiBlocListener(
  listeners: [
    BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Handle auth state changes
      },
    ),
    BlocListener<TodoBloc, TodoState>(
      listener: (context, state) {
        // Handle todo state changes
      },
    ),
  ],
  child: MyWidget(),
)
```

### BlocConsumer

Combines BlocBuilder and BlocListener - rebuild UI AND perform side effects.

```dart
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    // Side effects
    if (state is AuthFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  },
  builder: (context, state) {
    // UI updates
    if (state is AuthLoading) {
      return CircularProgressIndicator();
    }
    if (state is AuthSuccess) {
      return Text('Welcome ${state.user.name}');
    }
    return LoginButton();
  },
)

// With listenWhen and buildWhen
BlocConsumer<CounterCubit, int>(
  listenWhen: (previous, current) => current % 5 == 0,
  listener: (context, state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Multiple of 5: $state')),
    );
  },
  buildWhen: (previous, current) => current % 2 == 0,
  builder: (context, state) {
    return Text('Even: $state');
  },
)
```

### BlocSelector

Selectively rebuild based on a filtered value from state.

```dart
// Only rebuild when user.name changes, not entire UserState
BlocSelector<UserCubit, UserState, String>(
  selector: (state) => state.user.name,
  builder: (context, name) {
    return Text('Hello, $name');
  },
)

// Example with complex selection
BlocSelector<TodoBloc, TodoState, List<Todo>>(
  selector: (state) {
    // Only return completed todos
    return state.todos.where((t) => t.isCompleted).toList();
  },
  builder: (context, completedTodos) {
    return Text('Completed: ${completedTodos.length}');
  },
)
```

### Accessing Bloc/Cubit

```dart
// Read (one-time access, no rebuild)
context.read<CounterCubit>().increment();

// Watch (subscribe to changes, rebuilds widget)
final count = context.watch<CounterCubit>().state;

// Select (subscribe to specific value)
final isPositive = context.select(
  (CounterCubit cubit) => cubit.state >= 0,
);

// Using BlocProvider.of
final cubit = BlocProvider.of<CounterCubit>(context);
cubit.increment();

// With listen parameter
final cubit = BlocProvider.of<CounterCubit>(context, listen: true);
```

### RepositoryProvider

Provides repositories to the widget tree.

```dart
// Single repository
RepositoryProvider(
  create: (context) => TodoRepository(),
  child: MyApp(),
)

// With dispose callback
RepositoryProvider(
  create: (context) => TodoRepository(),
  dispose: (repository) => repository.dispose(),
  child: MyApp(),
)

// Multiple repositories
MultiRepositoryProvider(
  providers: [
    RepositoryProvider<TodoRepository>(
      create: (context) => TodoRepository(),
    ),
    RepositoryProvider<UserRepository>(
      create: (context) => UserRepository(),
    ),
  ],
  child: MyApp(),
)

// Accessing repository
final repository = context.read<TodoRepository>();
```

---

## Best Practices

### 1. State Management Patterns

#### Use Sealed Classes for Events

```dart
// ✅ Good: Exhaustive pattern matching
sealed class CounterEvent {}
final class Increment extends CounterEvent {}
final class Decrement extends CounterEvent {}

// ❌ Bad: Can't guarantee all events are handled
abstract class CounterEvent {}
class Increment extends CounterEvent {}
class Decrement extends CounterEvent {}
```

#### Immutable State Classes

```dart
// ✅ Good: Immutable state with copyWith
class TodoState {
  final List<Todo> todos;
  final bool isLoading;

  const TodoState({
    this.todos = const [],
    this.isLoading = false,
  });

  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ❌ Bad: Mutable state
class TodoState {
  List<Todo> todos = [];
  bool isLoading = false;
}
```

#### Use Equatable for State Comparison

```dart
import 'package:equatable/equatable.dart';

class TodoState extends Equatable {
  final List<Todo> todos;
  final bool isLoading;

  const TodoState({
    this.todos = const [],
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [todos, isLoading];

  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
```

### 2. Bloc Organization

```
lib/
├── blocs/
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   └── todo/
│       ├── todo_bloc.dart
│       ├── todo_event.dart
│       └── todo_state.dart
├── cubits/
│   └── counter/
│       ├── counter_cubit.dart
│       └── counter_state.dart
├── models/
│   ├── todo.dart
│   └── user.dart
├── repositories/
│   ├── todo_repository.dart
│   └── auth_repository.dart
└── screens/
    ├── home_screen.dart
    └── todo_screen.dart
```

### 3. Global BlocObserver

```dart
class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}
```

### 4. Error Handling

```dart
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<TodoLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    TodoLoadRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    
    try {
      final todos = await repository.fetchTodos();
      emit(TodoLoaded(todos));
    } on NetworkException catch (e) {
      emit(TodoError('Network error: ${e.message}'));
    } on ServerException catch (e) {
      emit(TodoError('Server error: ${e.message}'));
    } catch (e) {
      emit(TodoError('Unexpected error: $e'));
      // Also call addError for BlocObserver
      addError(e, StackTrace.current);
    }
  }
}
```

### 5. Testing

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

void main() {
  group('CounterCubit', () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = CounterCubit();
    });

    tearDown(() {
      counterCubit.close();
    });

    test('initial state is 0', () {
      expect(counterCubit.state, 0);
    });

    blocTest<CounterCubit, int>(
      'emits [1] when increment is called',
      build: () => CounterCubit(),
      act: (cubit) => cubit.increment(),
      expect: () => [1],
    );

    blocTest<CounterCubit, int>(
      'emits [1, 2] when increment is called twice',
      build: () => CounterCubit(),
      act: (cubit) {
        cubit.increment();
        cubit.increment();
      },
      expect: () => [1, 2],
    );
  });
}
```

### 6. When to Use Cubit vs Bloc

**Use Cubit when:**
- Simple state management
- Straightforward state changes
- No need for event tracing
- Fewer actions/triggers
- Less boilerplate desired

**Use Bloc when:**
- Complex state management
- Need event history/tracing
- Multiple event types
- Advanced event transformations needed
- Better debugging requirements

---

## Examples

### Example 1: Counter App (Complete)

```dart
// counter_cubit.dart
import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(CounterApp());

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => CounterCubit(),
        child: CounterPage(),
      ),
    );
  }
}

// counter_page.dart
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: BlocBuilder<CounterCubit, int>(
        builder: (context, count) {
          return Center(
            child: Text(
              '$count',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            child: const Icon(Icons.add),
            onPressed: () => context.read<CounterCubit>().increment(),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'decrement',
            child: const Icon(Icons.remove),
            onPressed: () => context.read<CounterCubit>().decrement(),
          ),
        ],
      ),
    );
  }
}
```

### Example 2: Login Form with Validation

```dart
// login_state.dart
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isValid = false,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFailure = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        isValid,
        isSubmitting,
        isSuccess,
        isFailure,
        errorMessage,
      ];

  LoginState copyWith({
    String? email,
    String? password,
    bool? isValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// login_cubit.dart
import 'package:bloc/bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState());

  void emailChanged(String email) {
    emit(state.copyWith(
      email: email,
      isValid: _isFormValid(email, state.password),
    ));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: password,
      isValid: _isFormValid(state.email, password),
    ));
  }

  Future<void> submit() async {
    if (!state.isValid) return;

    emit(state.copyWith(isSubmitting: true));

    try {
      await _authRepository.login(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(
        isSubmitting: false,
        isSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        isFailure: true,
        errorMessage: e.toString(),
      ));
    }
  }

  bool _isFormValid(String email, String password) {
    return email.isNotEmpty &&
        email.contains('@') &&
        password.isNotEmpty &&
        password.length >= 6;
  }
}

// login_page.dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocProvider(
        create: (context) => LoginCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        if (state.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _EmailInput(),
            const SizedBox(height: 16),
            _PasswordInput(),
            const SizedBox(height: 24),
            _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state.email.isEmpty || state.email.contains('@')
                ? null
                : 'Invalid email',
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          obscureText: true,
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.password.isEmpty || state.password.length >= 6
                ? null
                : 'Password must be at least 6 characters',
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.isValid != current.isValid ||
          previous.isSubmitting != current.isSubmitting,
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValid && !state.isSubmitting
              ? () => context.read<LoginCubit>().submit()
              : null,
          child: state.isSubmitting
              ? CircularProgressIndicator()
              : Text('Login'),
        );
      },
    );
  }
}
```

### Example 3: Infinite Scroll List

```dart
// post.dart
class Post {
  final int id;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.title,
    required this.body,
  });
}

// post_event.dart
sealed class PostEvent {}
final class PostFetched extends PostEvent {}

// post_state.dart
enum PostStatus { initial, success, failure }

class PostState {
  final PostStatus status;
  final List<Post> posts;
  final bool hasReachedMax;

  const PostState({
    this.status = PostStatus.initial,
    this.posts = const [],
    this.hasReachedMax = false,
  });

  PostState copyWith({
    PostStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

// post_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;

  PostBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(PostState()) {
    on<PostFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onPostFetched(
    PostFetched event,
    Emitter<PostState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == PostStatus.initial) {
        final posts = await _postRepository.fetchPosts();
        return emit(
          state.copyWith(
            status: PostStatus.success,
            posts: posts,
            hasReachedMax: false,
          ),
        );
      }

      final posts = await _postRepository.fetchPosts(
        startIndex: state.posts.length,
      );

      emit(
        posts.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: PostStatus.success,
                posts: List.of(state.posts)..addAll(posts),
                hasReachedMax: false,
              ),
      );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }
}

// posts_list.dart
class PostsList extends StatefulWidget {
  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PostBloc>().add(PostFetched());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            return const Center(child: Text('Failed to fetch posts'));
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return const Center(child: Text('No posts'));
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.posts.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final post = state.posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            );
          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
```

---

## Resources

### Official Documentation
- **Bloc Library**: [bloclibrary.dev](https://bloclibrary.dev)
- **Bloc Package**: [pub.dev/packages/bloc](https://pub.dev/packages/bloc)
- **Flutter Bloc Package**: [pub.dev/packages/flutter_bloc](https://pub.dev/packages/flutter_bloc)

### Related Packages
- **bloc_test**: Testing utilities for Bloc
- **bloc_concurrency**: Event transformers for advanced use cases
- **hydrated_bloc**: Persist and restore Bloc state
- **replay_bloc**: Undo and redo functionality
- **equatable**: Value equality for state comparison

### Community
- **GitHub**: [github.com/felangel/bloc](https://github.com/felangel/bloc)
- **Discord**: [Discord community](https://discord.gg/bloc)

### Tutorials
- [Counter Tutorial](https://bloclibrary.dev/tutorials/flutter-counter)
- [Infinite List Tutorial](https://bloclibrary.dev/tutorials/flutter-infinite-list)
- [Login Tutorial](https://bloclibrary.dev/tutorials/flutter-login)
- [Weather App Tutorial](https://bloclibrary.dev/tutorials/flutter-weather)
- [Todo App Tutorial](https://bloclibrary.dev/tutorials/flutter-todos)

---

## Quick Reference

### Cubit Lifecycle
```
Constructor → emit() → onChange() → state updated
```

### Bloc Lifecycle
```
Constructor → add(event) → onEvent() → EventHandler
→ emit() → onTransition() → onChange() → state updated
→ onDone()
```

### Widget Selection Guide

| Widget | Purpose | Use Case |
|--------|---------|----------|
| BlocProvider | Provide Bloc/Cubit | Dependency injection |
| BlocBuilder | Rebuild UI | Display state |
| BlocListener | Side effects | Navigation, dialogs, snackbars |
| BlocConsumer | Both rebuild & side effects | Complex UI with side effects |
| BlocSelector | Selective rebuild | Performance optimization |
| RepositoryProvider | Provide repository | Data layer injection |

### Context Extensions

```dart
// Read - one-time access
context.read<MyBloc>()

// Watch - subscribe and rebuild
context.watch<MyBloc>()

// Select - subscribe to specific value
context.select((MyBloc bloc) => bloc.state.value)
```

---

**Last Updated**: February 2026  
**Package Versions**: bloc ^9.2.0 | flutter_bloc ^9.1.1
