require('dotenv').config();
const user  = process.env("MONGO_INITDB_ROOT_USERNAME");
const password = process.env("MONGO_INITDB_ROOT_PASSWORD");
const db = process.env("MONGO_INITDB_DATABASE");
db.createUser(
    {
        user: user,
        pwd:  password,
        roles:[
            {
                role: "dbOwner",
                db:  db
            }
        ]
    }
);