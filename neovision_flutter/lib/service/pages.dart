import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:neovision_flutter/controllers/auth_controller.dart';
import 'package:neovision_flutter/controllers/recon_controller.dart';
import 'package:neovision_flutter/controllers/session_controller.dart';
import 'package:neovision_flutter/controllers/sessions_controller.dart';
import 'package:neovision_flutter/controllers/subordinate_controller.dart';
import 'package:neovision_flutter/pages/auth_page.dart';
import 'package:neovision_flutter/pages/create_recon_page.dart';
import 'package:neovision_flutter/pages/create_session_page.dart';
import 'package:neovision_flutter/pages/home_page.dart';
import 'package:neovision_flutter/pages/main_map_page.dart';
import 'package:neovision_flutter/pages/map_page.dart';
import 'package:neovision_flutter/pages/recons_page.dart';
import 'package:neovision_flutter/pages/sessionArPage.dart';
import 'package:neovision_flutter/pages/session_page.dart';
import 'package:neovision_flutter/pages/sessions_page.dart';
import 'package:neovision_flutter/pages/spec/access_page.dart';
import 'package:neovision_flutter/pages/spec/loading_page.dart';
import 'package:neovision_flutter/pages/spec/not_found_page.dart';
import 'package:neovision_flutter/pages/spec/oops_page.dart';
import 'package:neovision_flutter/pages/subordinate_page.dart';

Future<String> getInitialRoute() async {
  final token = await const FlutterSecureStorage().read(key: 'token');
  return token == null ? AuthPage.id : LoadingPage.id;
}

GetPage kUKNOWNROUTE = GetPage(
    name: NotFoundPage.id, page: () => const NotFoundPage(), arguments: []);

List<GetPage<dynamic>> kPAGES = [
  GetPage(
      name: AuthPage.id,
      page: () => const AuthPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(
          () => AuthController(),
        );
      })),
  GetPage(
    name: HomePage.id,
    page: () => const HomePage(),
    binding: BindingsBuilder(
      () {
        Get.put(SessionsController());
        Get.put(SubordinateController());
      },
    ),
  ),
  GetPage(name: SessionsPage.id, page: () => const SessionsPage()),
  GetPage(
      name: SessionPage.id,
      page: () => const SessionPage(),
      binding: BindingsBuilder(() => Get.lazyPut(() => SessionController()))),
  GetPage(name: SessionArPage.id, page: () => const SessionArPage()),
  GetPage(name: ReconsPage.id, page: () => const ReconsPage()),
  GetPage(
    name: CreateReconPage.id,
    page: () => const CreateReconPage(),
    binding: BindingsBuilder(() => Get.lazyPut(() => ReconController())),
  ),
  GetPage(name: CreateSessionPage.id, page: () => const CreateSessionPage()),
  GetPage(name: SubordinatePage.id, page: () => const SubordinatePage()),
  GetPage(name: MapPage.id, page: () => const MapPage()),
  GetPage(name: MainMapPage.id, page: () => const MainMapPage()),
  GetPage(name: NotFoundPage.id, page: () => const NotFoundPage()),
  GetPage(name: OopsPage.id, page: () => const OopsPage()),
  GetPage(name: AccessPage.id, page: () => const AccessPage()),
  GetPage(name: LoadingPage.id, page: () => const LoadingPage()),
];
