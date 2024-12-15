import 'package:sqflite/sqflite.dart';
import '../all.dart';

class VoucherDao extends VoucherGeneratedDao {
  Future<int> createNewVoucher(Voucher data) {
    return db.insert('Voucher', {
      'name': data.name,
      'status': 1,
      'table': data.table?.id,
      'type': data.type.id
    });
  }

  Future<List<Voucher>> searchWith_table_name_like(String table_name) async {
    String sql =
        """Select v.name as vName,v.id as vId,v.totalPrice,v.discount,v.openedTime,vs.id as vsId,vs.name as vsName,st.id as stId,st.name as stName,vt.id as vtId,vt.name as vtName
           from Voucher as v
           INNER JOIN ServingTable AS st ON v.'table'=st.id
           INNER JOIN VoucherType as vt on v.type=vt.id
           INNER JOIN VoucherStatus as vs on v.status=vs.id
           where v.status!=3 and st.name like "%$table_name%" order by st.name;
     ;""";
    List tmp = await db.rawQuery(sql);
    //print(tmp);
    return tmp.map((a) {
      return Voucher(
          id: a['vId'],
          name: a['vName'],
          openedTime: DateTime.parse(a['openedTime']),
          totalPrice: a["totalPrice"],
          discount: a["discount"],
          status: VoucherStatus(name: a['vsName'], id: a['vsId']),
          table: ServingTable(name: a['stName'], id: a["stId"]),
          type: VoucherType(id: a["vtId"], name: a["vtName"]));
    }).toList();
  }

  Future<List<Voucher>> search(Voucher voucher) async {
    String sql = """
        Select v.name as vName,v.id as vId,v.totalPrice,v.discount,v.openedTime,vs.id as vsId,vs.name as vsName,st.id as stId,st.name as stName,vt.id as vtId,vt.name as vtName
           from Voucher as v
           LEFT JOIN ServingTable AS st ON v.'table'=st.id
           INNER JOIN VoucherType as vt on v.'type'=vt.id
           INNER JOIN VoucherStatus as vs on v.status=vs.id
           where
           v.status!=3
           and vtId=${voucher.type.id}
           and (stName is null or stName like '%${voucher.table!.name}%')
          order by v.openedTime DESC;
           """;
    List tmp = await db.rawQuery(sql);
    return tmp.map((a) {
      return Voucher(
          id: a['vId'],
          name: a['vName'] ?? "",
          openedTime: DateTime.parse(a['openedTime']),
          totalPrice: a["totalPrice"],
          discount: a["discount"],
          status: VoucherStatus(name: a['vsName'], id: a['vsId']),
          table: ServingTable(name: a['stName'] ?? "", id: a["stId"]),
          type: VoucherType(id: a["vtId"], name: a["vtName"]));
    }).toList();
  }

  Future<List<Voucher>> readClosedVouchers() async {
    String sql =
        """Select v.name as vName,v.id as vId,v.totalPrice,v.discount,v.openedTime,v.closedTime,vs.id as vsId,vs.name as vsName,st.id as stId,st.name as stName ,vt.id as vtId,vt.name as vtName
           from Voucher as v
           Left JOIN ServingTable AS st ON v.'table'=st.id
           INNER JOIN VoucherType as vt on v.'type'=vt.id
           INNER JOIN VoucherStatus as vs on v.status=vs.id
           where v.status=3 order by vId


     ;""";

    List tmp = await db.rawQuery(sql);
    return tmp.map((a) {
      return Voucher(
          id: a['vId'],
          name: a['vName'],
          openedTime: DateTime.parse(a['openedTime']),
          closedTime: DateTime.parse(a['closedTime']),
          totalPrice: a["totalPrice"],
          discount: a["discount"],
          status: VoucherStatus(name: a['vsName'], id: a['vsId']),
          table: ServingTable(name: a['stName'] ?? "", id: a["stId"]),
          type: VoucherType(id: a["vtId"], name: a["vtName"]));
    }).toList();
  }

  Future<int> readLastOpenVoucherNumberOfTable(ServingTable table) async {
    final tmp = await db.rawQuery(
        "select Max(Cast(v.'name' as int)) largestName from 'Voucher' v where v.'status'!=3 And v.'table'=${table.id};");
    return Sqflite.firstIntValue(tmp) ?? 0;
  }

  Future<int> closeVoucher(Voucher voucher) async {
    return db.update("'Voucher'", {'status': 3}, where: "id=${voucher.id}");
  }

  Future<int> closeVoucherIfAllOrderStatusIs(
      Voucher voucher, int orderStatusId) async {
    String sql = """
      Select o.id from 'Order' o
      inner join '#_#_#Order_OrderStatus' oos on oos.orderId=o.id
      where o.voucher=${voucher.id} and oos.orderStatusId!=${orderStatusId};
    """;
    List output = await db.rawQuery(sql);
    if (output.isEmpty) {
      return db.update("'Voucher'", {'status': 3}, where: "id=${voucher.id}");
    } else {
      return 0;
    }
  }

  Future<int> getTotalPrice(Voucher voucher) async {
    String sql = """
    select
    SUM(o.qty*pp.price)  totalPrice
    from 'Order' o
    inner join 'Inventory' i on o.item=i.id
    inner join 'ProductPrice' pp on pp.id=i.currentPrice
    where o.voucher=${voucher.id}
    Group By o.voucher

    """;
    final tmp = await db.rawQuery(sql);
    int totalPrice =
        tmp.first['totalPrice'] != null ? tmp.first['totalPrice'] as int : 0;
    return totalPrice;
  }
}
