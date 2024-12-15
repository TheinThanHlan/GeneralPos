{
    "unique_constraints": [],
    "variables": [
        {
            "name": "id",
            "type": "long",
            "default_value": 0,
            "optional": True,
            "constraints": "not null primary key",
            "dbAutoValue": True,
            "map": "",
        },
        {
            "name": "nameToShowInVoucher",
            "type": "String",
            "default_value": "",
            "optional": True,
            "constraints": "",
            "dbAutoValue": False,
            "map": "",
        },
        {
            "name": "productTemplate",
            "type": "ProductTemplate",
            "default_value": "",
            "optional": True,
            "constraints": "not null",
            "dbAutoValue": False,
            "map": "ManyToOne",
        },
        {
            "name": "qty",
            "type": "int",
            "default_value": 0,
            "optional": False,
            "constraints": "not null",
            "dbAutoValue": False,
            "map": "",
        },
        {
            "name": "SKU",
            "type": "String",
            "default_value": "",
            "optional": True,
            "constraints": "unique",
            "dbAutoValue": False,
            "map": "",
        },
        {
            "name": "UPC",
            "type": "String",
            "default_value": "",
            "optional": True,
            "constraints": "unique",
            "dbAutoValue": False,
            "map": "",
        },
        {
            "name": "productProperties",
            "type": "List<ProductProperty>",
            "default_value": "",
            "optional": True,
            "constraints": "not null",
            "dbAutoValue": False,
           "map": "ManyToMany",
          # "map": "OneToMany",
        },
        {
            "name": "prices",
            "type": "List<ProductPrice>",
            "default_value": "",
            "optional": True,
            "constraints": "",
            "dbAutoValue": False,
            "map": "OneToMany",
        },
        {
            "name": "currentPrice",
            "type": "ProductPrice",
            "default_value": "",
            "optional": False,
            "constraints": "",
            "dbAutoValue": False,
            "map": "OneToOne",
        }
    ],
}
