// packages import 
const express = require("express");
const mongoose = require('mongoose'); 
const adminRouter = require("./routes/admin");

// files imports
const authRouter = require("./routes/auth");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");

// constant db
const db = "mongodb://faisal:faisal@ac-4f2vfg4-shard-00-00.rhp0q9d.mongodb.net:27017,ac-4f2vfg4-shard-00-01.rhp0q9d.mongodb.net:27017,ac-4f2vfg4-shard-00-02.rhp0q9d.mongodb.net:27017/?ssl=true&replicaSet=atlas-ywsccj-shard-0&authSource=admin&retryWrites=true&w=majority";
// port constant
const PORT  = 3000;
// app initialization
const app = express();
//middleware
app.use(express.json())
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

// database connection
mongoose.set('strictQuery', true);
mongoose.connect(db).then(()=>{
    console.log('Connected Succesffully');
}).catch( (e)=> console.log(e));

//listening app
app.listen(PORT,"0.0.0.0",()=>{
    console.log(`Connected at port ${PORT}`);
});    