import * as express from  "express"
import { RequestHandler } from "express";
const app = express();

import * as bodyparser from "body-parser"
const urlParser = bodyparser.urlencoded({extended: false});
const jsonParser = bodyparser.json();

const logRequest : RequestHandler = (req, res, next) => {
    console.log(req.method + " Request: " + req.url);
    next();
};

app.use(logRequest);

interface User {
    firstname: string
    lastname: string
}

const user : User = {
    firstname : "Robert",
    lastname : "Jones"
}

const userJSON = JSON.stringify(user);
console.log(userJSON);

const parsedUser = JSON.parse(userJSON) as User;
console.log(parsedUser);

/**
 * GET
 */
app.route("/").get((req, res, next) => {
    // res.send("Home");
    res.render("index.ejs", {user: user});
});

app.route("/products").get((req, res, next) => {
    res.send("Get all products.");
});

app.route("/products/229").get((req, res, next) => {
    res.send("Details for Product with ID: 229");
});

app.route("/products/:productID").get((req, res, next) => {
    res.send("Details for Product with ID: " + req.params.productID);
});

/**
 * POST
 */
app.route("/products").post(jsonParser, (req, res, next) => {
    res.send("Post new product.");
    console.log(req.body);
});

/**
 * PATCH
 */
app.route("/products/:productID").patch(jsonParser, (req, res, next) => {
    res.send("Update product with ID: " + req.params.productID);
    console.log(req.body);
});

/**
 * DELETE
 */
app.route("/products/:productID").delete((req, res, next) => {
    res.send("Delete Product with ID: " + req.params.productID);
});

app.listen(8091, "localhost", () => console.log("Server started..."));