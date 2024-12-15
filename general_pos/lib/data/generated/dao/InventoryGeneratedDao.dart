import 'package:sqflite/sqflite.dart';
import '../../all.dart';
abstract class InventoryGeneratedDao implements IMVCDao<Inventory>{ 
		final Database db=getIt<Database>();

Future<int> insert(Inventory data){
	return this.db.insert("Inventory",data.toJson());
}

Future<int> insertWithoutDbAuto(Inventory data){return this.db.insert("Inventory",data.toJsonWithoutDbAuto());
}

Future<void> delete(int id)async{

await this.db.delete("Inventory",where:"id=$id");
}

Future<Inventory?> read(int id)async{List t =await db.query("Inventory", where: "id=$id");
if (t.length == 1) {
return Inventory.fromJson(t[0]);
}return null;}
Future<List<Inventory>> readAll() async {List tmp = await db.query("Inventory");return tmp.map((value) => Inventory.fromJson(value)).toList();
}
Future<List<Inventory>> searchWith_nameToShowInVoucher(String nameToShowInVoucher) async {List tmp=await db.query('Inventory',where:"nameToShowInVoucher=\"$nameToShowInVoucher\"");return tmp.map((value)=>Inventory.fromJson(value)).toList();
}
Future<List<Inventory>> searchWith_qty(int qty) async {List tmp=await db.query('Inventory',where:"qty=$qty");return tmp.map((value)=>Inventory.fromJson(value)).toList();
}
Future<List<Inventory>> searchWith_SKU(String SKU) async {List tmp=await db.query('Inventory',where:"SKU=\"$SKU\"");return tmp.map((value)=>Inventory.fromJson(value)).toList();
}
Future<List<Inventory>> searchWith_UPC(String UPC) async {List tmp=await db.query('Inventory',where:"UPC=\"$UPC\"");return tmp.map((value)=>Inventory.fromJson(value)).toList();
}

}
