
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:owod_functionnalities/core/common/cubits/menu/menu_cubit.dart';
import 'package:owod_functionnalities/features/blog/presentation/pages/blog_page.dart';
import 'package:owod_functionnalities/features/messagerie/presentation/pages/chat_list_screen.dart';

import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'core/theme/theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/blog/presentation/bloc/blog_bloc.dart';
import 'features/blog/presentation/pages/add_new_blog_page.dart';
import 'features/messagerie/data/models/chat_model.dart';
import 'features/messagerie/presentation/bloc/message_bloc.dart';
import 'features/messagerie/presentation/pages/message_screen.dart';
import 'init_dependency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
      BlocProvider(create: (_) => serviceLocator<MenuCubit>()),

      BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
      BlocProvider(create: (_) => serviceLocator<MessageBloc>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String initialRoute = '/login'; // Default route is login

  @override
  void initState() {
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Architecture',
      theme: AppTheme.lightTheme,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          return isLoggedIn ? const ChatListScreen() : const LoginPage();
        },
      ),
      routes: {
        '/login': (ctx) => const LoginPage(),
        '/signup': (ctx) => const SignupPage(),
        '/add_new_blog': (ctx) => const AddNewBlogPage(),
        '/blog': (ctx) => BlogPage(),
        '/chats' : (ctx)=>const ChatListScreen()
      },
        onGenerateRoute: (settings) {
          if (settings.name == '/messages') {

            final args = settings.arguments as ChatModel?;
            print(args);
            return MaterialPageRoute(
              builder: (context) {
                return MessagesScreen(chat: args);
              },
            );
          }
          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
    );

  }
}
