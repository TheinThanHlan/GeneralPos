import 'package:sqflite/sqflite.dart';
import '../../all.dart';
abstract class VoucherTypeGeneratedDao implements IMVCDao<VoucherType>{ 
		final Database db=getIt<Database>();

Future<int> insert(VoucherType data){
	return this.db.insert("VoucherType",data.toJson());
}

Future<int> insertWithoutDbAuto(VoucherType data){return this.db.insert("VoucherType",data.toJsonWithoutDbAuto());
}

Future<void> delete(int id)async{

await this.db.delete("VoucherType",where:"id=$id");
}

Future<VoucherType?> read(int id)async{List t =await db.query("VoucherType", where: "id=$id");
if (t.length == 1) {
return VoucherType.fromJson(t[0]);
}return null;}
Future<List<VoucherType>> readAll() async {List tmp = await db.query("VoucherType");return tmp.map((value) => VoucherType.fromJson(value)).toList();
}
Future<List<VoucherType>> searchWith_name(String name) async {List tmp=await db.query('VoucherType',where:"name=\"$name\"");return tmp.map((value)=>VoucherType.fromJson(value)).toList();
}
Future<List<VoucherType>> searchWith_name_like(String name) async {List tmp=await db.query('VoucherType',where:"name like \"%$name%\"");return tmp.map((value)=>VoucherType.fromJson(value)).toList();
}

}
