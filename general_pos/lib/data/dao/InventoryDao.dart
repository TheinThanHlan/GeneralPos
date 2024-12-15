import 'package:sqflite/sqflite.dart';
import '../all.dart';

class InventoryDao extends InventoryGeneratedDao {
  Future<int> insert(Inventory inventory) async {
    int priceId = await db
        .insert("ProductPrice", {'price': inventory.currentPrice.price});
    int id = await db.insert("Inventory", {
      "productTemplate": inventory.productTemplate!.id,
      'qty': inventory.qty,
      'SKU': inventory.SKU,
      'UPC': inventory.UPC,
      'currentPrice': priceId,
    });
    await db.update("ProductPrice", {"Inventory_mappedBy_prices": id},
        where: "id=$priceId");

    for (var a in inventory.productProperties!) {
      await db.insert("'#_#_#Inventory_ProductProperty'",
          {"productPropertyId": a.id, "inventoryId": id});
    }
    ;
    return id;
  }

  Future<Map<int, Inventory>> searchWithName_like(String name) async {
    String sql = "";
    sql = """
  select
  i.id as iId,
  i.UPC as iUPC,
  i.SKU as iSKU,
  pt.id as ptId,pt.name as ptName,
  pp.'price' as ppCurrentPrice


  from Inventory i
  inner join ProductTemplate pt on pt.id=i.productTemplate
  inner join ProductPrice pp on pp.id=i.currentPrice
  where pt.name like('%$name%') and ppCurrentPrice!=0 order by iId,ptName
  """;
    List tmp = await db.rawQuery(sql);
    Map<int, Inventory> output = {};
    for (var a in tmp) {
      output[a['iId']] = Inventory(
        id: a['iId'],
        UPC: a['iUPC'],
        SKU: a['iSKU'],
        currentPrice: ProductPrice(price: a["ppCurrentPrice"]),
        qty: 0,
        productTemplate: ProductTemplate(name: a['ptName']),
        productProperties:
            await getIt<ProductPropertyDao>().readFromInventoryId(a['iId']),
      );
    }
    ;
    return output;
  }

  Future<List<Inventory>> readFromProductTemplateId(int id) async {
    String sql = """
  select i.id as iId,
 i.SKU as iSKU,
  i.UPC as iUPC,
  pt.id as ptId,pt.name as ptName,
  pp.'price' as ppCurrentPrice

  from Inventory i
  inner join ProductTemplate pt on pt.id=i.productTemplate
  left join ProductPrice pp on pp.id=i.currentPrice
  where pt.id = $id order by ppCurrentPrice desc
  """;
    List tmp = await db.rawQuery(sql);
    List<Inventory> output = [];
    for (var a in tmp) {
      output.add(Inventory(
        id: a['iId'],
        SKU: a['iSKU'],
        UPC: a['iUPC'],
        currentPrice: ProductPrice(price: a["ppCurrentPrice"] ?? 0),
        qty: 0,
        productTemplate: ProductTemplate(name: a['ptName']),
        productProperties:
            await getIt<ProductPropertyDao>().readFromInventoryId(a['iId']),
      ));
    }

    return output;
  }

  Future<void> delete(int id) async {
    await db.update("Inventory", {'currentPrice': null}, where: "id=$id");
    await this
        .db
        .delete("ProductPrice", where: "Inventory_mappedBy_prices=$id");
    await this
        .db
        .delete("'#_#_#Inventory_ProductProperty'", where: "inventoryId=$id");
    await this.db.delete("Inventory", where: "id=$id");
  }

  Future<List<Inventory>> readLike(Inventory inventory) async {
    String sql = """
  select i.id as iId,
 i.SKU as iSKU,
  i.UPC as iUPC,
  pt.id as ptId,pt.name as ptName,
  pp.'price' as ppCurrentPrice

  from Inventory i
  inner join ProductTemplate pt on pt.id=i.productTemplate
  left join ProductPrice pp on pp.id=i.currentPrice
  where pt.id = ${inventory.productTemplate!.id} order by ppCurrentPrice desc
  """;
    List tmp = await db.rawQuery(sql);
    List<Inventory> output = [];
    for (var a in tmp) {
      output.add(Inventory(
        id: a['iId'],
        SKU: a['iSKU'],
        UPC: a['iUPC'],
        currentPrice: ProductPrice(price: a["ppCurrentPrice"] ?? 0),
        qty: 0,
        productTemplate: ProductTemplate(name: a['ptName']),
        productProperties:
            await getIt<ProductPropertyDao>().readFromInventoryId(a['iId']),
      ));
    }

    return output;
  }
}
