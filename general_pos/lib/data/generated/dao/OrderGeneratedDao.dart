import 'package:sqflite/sqflite.dart';
import '../../all.dart';
abstract class OrderGeneratedDao implements IMVCDao<Order>{ 
		final Database db=getIt<Database>();

Future<int> insert(Order data){
	return this.db.insert("Order",data.toJson());
}

Future<int> insertWithoutDbAuto(Order data){return this.db.insert("Order",data.toJsonWithoutDbAuto());
}

Future<void> delete(int id)async{

await this.db.delete("Order",where:"id=$id");
}

Future<Order?> read(int id)async{List t =await db.query("Order", where: "id=$id");
if (t.length == 1) {
return Order.fromJson(t[0]);
}return null;}
Future<List<Order>> readAll() async {List tmp = await db.query("Order");return tmp.map((value) => Order.fromJson(value)).toList();
}
Future<List<Order>> searchWith_orderDateTime(DateTime orderDateTime) async {List tmp=await db.query('Order',where:"orderDateTime=$orderDateTime");return tmp.map((value)=>Order.fromJson(value)).toList();
}
Future<List<Order>> searchWith_qty(int qty) async {List tmp=await db.query('Order',where:"qty=$qty");return tmp.map((value)=>Order.fromJson(value)).toList();
}
Future<List<Order>> searchWith_totalBuyPrice(double totalBuyPrice) async {List tmp=await db.query('Order',where:"totalBuyPrice=$totalBuyPrice");return tmp.map((value)=>Order.fromJson(value)).toList();
}

}
