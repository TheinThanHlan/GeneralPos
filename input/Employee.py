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
            "name": "user",
            "type": "User",
            "default_value": "",
            "optional": False,
            "constraints": "not null",
            "dbAutoValue": False,
            "map": "OneToOne",
        },
    ],
}