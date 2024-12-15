import 'package:sqflite/sqflite.dart';
import '../all.dart';

class ProductTemplateDao extends ProductTemplateGeneratedDao {
  Future<Map<int, ProductTemplate>> readAllWithSearch(
      {String search = ''}) async {
    Map<int, ProductTemplate> output = {};
    List tmp = await db.query("ProductTemplate",
        where: "name like ('%$search%')", orderBy: "name");
    tmp.forEach((a) {
      output[(a["id"])] = ProductTemplate.fromJson(a);
    });
    return output;
  }

  Future<List<ProductTemplate>> readWhereInventoryExists() async {
    List<ProductTemplate> output = [];
    String sql = """
      Select distinct pt.* from 'ProductTemplate' pt
      Inner Join 'Inventory' i on  pt.id=i.productTemplate;
    """;
    List tmp = await db.rawQuery(sql);
    tmp.forEach((a) {
      output.add(ProductTemplate.fromJson(a));
    });
    return output;
  }

  Future<List<ProductTemplate>> searchWithName(String name) async {
    List tmp = await db.query("ProductTemplate", where: "name='$name'");
    return tmp.map((value) => ProductTemplate.fromJson(value)).toList();
  }

  Future<int> insertWithCategory(ProductTemplate productTemplate) async {
    int productTemplateId = await this.insertWithoutDbAuto(productTemplate);
    productTemplate.categories!.forEach((a) {
      db.insert("'#_#_#ProductTemplate_ProductCategory'",
          {'productTemplateId': productTemplateId, "productCategoryId": a.id});
    });
    return productTemplateId;
  }

  Future<void> delete(int id) async {
    await this.db.delete("'#_#_#ProductTemplate_ProductCategory'",
        where: "productTemplateId=$id");
    super.delete(id);
  }

  Future<Map<int, ProductTemplate>> readAllWithSearch_fetchInventory(
      {String search = ''}) async {
    Map<int, ProductTemplate> productTemplate =
        await getIt<ProductTemplateDao>().readAllWithSearch(search: search);

    for (var a in productTemplate.entries) {
      String sql = """select
      i.id as iId,
      i.qty as iQty,
      i.sku as iSku,
      i.upc as iUpc,
      pp.id as ppId,
      pp.price as ppPrice
      from Inventory as i
      left join ProductPrice as pp on pp.id=i.currentPrice where i.productTemplate=${a.key}
      """;
      List tmp1 = await db.rawQuery(sql);
      try {
        a.value.ListOfInventory_mappedBy_productTemplate = tmp1.map((b) {
          return Inventory(
            id: b['iId'],
            qty: b['iQty'],
            SKU: b['iSku'],
            UPC: b['iUpc'],
            currentPrice: ProductPrice(
              id: b['ppId'],
              price: b['ppPrice'] ?? 0,
            ),
          );
        }).toList();
      } catch (e) {
        print(e);
      }
      for (var b in a.value.ListOfInventory_mappedBy_productTemplate!) {
        b.productProperties =
            await getIt<ProductPropertyDao>().readFromInventoryId(b.id!);
      }
    }
    return productTemplate;
  }
}
