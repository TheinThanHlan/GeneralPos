import 'package:general_pos/views/Components/OCDialog/OCDialogInject.dart';
import 'package:general_pos/views/Components/PrintVoucher/PrintVoucherInject.dart';
import 'package:general_pos/views/Manage/ManageInject.dart';
import 'package:general_pos/views/ManageCategory/ManageCategoryInject.dart';
import 'package:general_pos/views/ManageProductTemplate/ManageProductTemplateInject.dart';
import 'package:general_pos/views/ManagePropertyNames/ManagePropertyNamesInject.dart';
import 'package:general_pos/views/SideBar/SideBarInject.dart';
import "package:general_pos/views/ManageInventory/ManageInventoryInject.dart";
import "package:general_pos/views/Sales/SalesInject.dart";
import "package:general_pos/views/ManageTable/ManageTableInject.dart";
import "package:general_pos/views/VoucherHistory/VoucherHistoryInject.dart";
import 'package:general_pos/views/Buy/BuyInject.dart';
import 'package:general_pos/views/Ordering/all.dart';
import './GlobalConfig.dart';
import './GlobalUtils.dart';
import './MVCDatabaseProvider.dart';
import 'package:get_it/get_it.dart';
import '../data/InjectData.dart';

final GetIt getIt = GetIt.I;
Future<void> init_injection_container() async {
  getIt.registerSingleton(await MVCDatabaseProvider().getDatabase());
  getIt.registerSingleton(GlobalConfig());
  getIt.registerSingleton(GlobalUtils());

  injectData(getIt);
  await initComponents();
  await initPages();
}

Future<void> initPages() async {
  injectOrdering(getIt);
  injectBuy(getIt);
  injectVoucherHistory(getIt);
  injectSales(getIt);
  injectManageInventory(getIt);
  //injectManageProductTemplate(getIt);
  injectManageCategory(getIt);
  injectManagePropertyNames(getIt);
  injectManageTable(getIt);
  injectManage(getIt);
  injectSideBar(getIt);
}

Future<void> initComponents() async {
  injectOCDialog(getIt);
  injectPrintVoucher(getIt);
}
