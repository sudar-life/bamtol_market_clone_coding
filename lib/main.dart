import 'package:bamtol_market_app/firebase_options.dart';
import 'package:bamtol_market_app/src/app.dart';
import 'package:bamtol_market_app/src/chat/controller/chat_controller.dart';
import 'package:bamtol_market_app/src/chat/controller/chat_list_controller.dart';
import 'package:bamtol_market_app/src/chat/page/chat_list_page.dart';
import 'package:bamtol_market_app/src/chat/page/chat_page.dart';
import 'package:bamtol_market_app/src/chat/repository/chat_repository.dart';
import 'package:bamtol_market_app/src/common/controller/authentication_controller.dart';
import 'package:bamtol_market_app/src/common/controller/common_layout_controller.dart';
import 'package:bamtol_market_app/src/common/controller/data_load_controller.dart';
import 'package:bamtol_market_app/src/common/repository/cloud_firebase_storage_repository.dart';
import 'package:bamtol_market_app/src/home/controller/home_controller.dart';
import 'package:bamtol_market_app/src/home/page/home_page.dart';
import 'package:bamtol_market_app/src/product/detail/controller/product_detail_controller.dart';
import 'package:bamtol_market_app/src/product/detail/page/product_detail_view.dart';
import 'package:bamtol_market_app/src/product/repository/product_repository.dart';
import 'package:bamtol_market_app/src/product/write/controller/product_write_controller.dart';
import 'package:bamtol_market_app/src/product/write/page/product_write_page.dart';
import 'package:bamtol_market_app/src/root.dart';
import 'package:bamtol_market_app/src/splash/controller/splash_controller.dart';
import 'package:bamtol_market_app/src/user/login/controller/login_controller.dart';
import 'package:bamtol_market_app/src/user/login/page/login_page.dart';
import 'package:bamtol_market_app/src/user/repository/authentication_repository.dart';
import 'package:bamtol_market_app/src/user/repository/user_repository.dart';
import 'package:bamtol_market_app/src/user/signup/controller/signup_controller.dart';
import 'package:bamtol_market_app/src/user/signup/page/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/common/controller/bottom_nav_controller.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    return GetMaterialApp(
      title: '당근마켓 클론코딩',
      initialRoute: '/',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color(0xff212123),
          titleTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xff212123),
      ),
      initialBinding: BindingsBuilder(() {
        var authenticationRepository =
            AuthenticationRepository(FirebaseAuth.instance);
        var user_repository = UserRepository(db);
        Get.put(authenticationRepository);
        Get.put(user_repository);
        Get.put(CommonLayoutController());
        Get.put(ProductRepository(db));
        Get.put(ChatRepository(db));
        Get.put(BottomNavController());
        Get.put(SplashController());
        Get.put(DataLoadController());
        Get.put(AuthenticationController(
          authenticationRepository,
          user_repository,
        ));
        Get.put(CloudFirebaseRepository(FirebaseStorage.instance));
        Get.lazyPut<ChatListController>(
          () => ChatListController(
            Get.find<ChatRepository>(),
            Get.find<ProductRepository>(),
            Get.find<UserRepository>(),
            Get.find<AuthenticationController>().userModel.value.uid ?? '',
          ),
          fenix: true,
        );
      }),
      getPages: [
        GetPage(name: '/', page: () => const App()),
        GetPage(
            name: '/home',
            page: () => const Root(),
            binding: BindingsBuilder(() {
              Get.put(HomeController(Get.find<ProductRepository>()));
            })),
        GetPage(
            name: '/login',
            page: () => const LoginPage(),
            binding: BindingsBuilder(() {
              Get.lazyPut<LoginController>(
                  () => LoginController(Get.find<AuthenticationRepository>()));
            })),
        GetPage(
          name: '/signup/:uid',
          page: () => const SignupPage(),
          binding: BindingsBuilder(
            () {
              Get.create<SignupController>(
                () => SignupController(Get.find<UserRepository>(),
                    Get.parameters['uid'] as String),
              );
            },
          ),
        ),
        GetPage(
          name: '/product/write',
          page: () => ProductWritePage(),
          binding: BindingsBuilder(
            () {
              Get.put(ProductWriteController(
                Get.find<AuthenticationController>().userModel.value,
                Get.find<ProductRepository>(),
                Get.find<CloudFirebaseRepository>(),
              ));
            },
          ),
        ),
        GetPage(
          name: '/product/detail/:docId',
          page: () => ProductDetailView(),
          binding: BindingsBuilder(
            () {
              Get.put(ProductDetailController(
                Get.find<ProductRepository>(),
                Get.find<ChatRepository>(),
                Get.find<AuthenticationController>().userModel.value,
              ));
            },
          ),
        ),
        GetPage(
          name: '/chat/:docId/:ownerUid/:customerUid',
          page: () => const ChatPage(),
          binding: BindingsBuilder(
            () {
              Get.put(ChatController(
                Get.find<ChatRepository>(),
                Get.find<UserRepository>(),
                Get.find<ProductRepository>(),
              ));
            },
          ),
        ),
        GetPage(
          name: '/chat-list',
          page: () => const ChatListPage(useBackBtn: true),
        ),
      ],
    );
  }
}
