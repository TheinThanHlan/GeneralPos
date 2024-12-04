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
            "name": "name",
            "type": "String",
            "default_value": "",
            "optional": False,
            "constraints": "not null unique",
            "dbAutoValue": False,
            "map": "",
        },
    ],
}
