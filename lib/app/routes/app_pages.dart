import 'package:get/get.dart';

import '../modules/add_pegawai/bindings/add_pegawai_binding.dart';
import '../modules/add_pegawai/views/add_pegawai_view.dart';
import '../modules/all_presensi/bindings/all_presensi_binding.dart';
import '../modules/all_presensi/views/all_presensi_view.dart';
import '../modules/detail_presensi/bindings/detail_presensi_binding.dart';
import '../modules/detail_presensi/bindings/detail_presensi_binding.dart';
import '../modules/detail_presensi/views/detail_presensi_view.dart';
import '../modules/detail_presensi/views/detail_presensi_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/reset/bindings/reset_binding.dart';
import '../modules/reset/views/reset_view.dart';
import '../modules/update_profile/bindings/update_profile_binding.dart';
import '../modules/update_profile/views/update_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => HomeView(),
        binding: HomeBinding(),
        transition: Transition.fadeIn //animasi ketika pindah halaman ke home
        ),
    GetPage(
      name: _Paths.ADD_PEGAWAI,
      page: () => AddPegawaiView(),
      binding: AddPegawaiBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.RESET,
      page: () => ResetView(),
      binding: ResetBinding(),
    ),
    GetPage(
        name: _Paths.PROFILE,
        page: () => ProfileView(),
        binding: ProfileBinding(),
        transition: Transition.fadeIn //animasi ketika pindah halaman ke profile
        ),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PRESENSI,
      page: () => const DetailPresensiView(),
      binding: DetailPresensiBinding(),
      children: [
        GetPage(
          name: _Paths.DETAIL_PRESENSI,
          page: () => const DetailPresensiView(),
          binding: DetailPresensiBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.ALL_PRESENSI,
      page: () =>  AllPresensiView(),
      binding: AllPresensiBinding(),
    ),
  ];
}
