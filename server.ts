import * as express from  "express"
const app = express();

import * as bodyparser from "body-parser"
const urlParser = bodyparser.urlencoded({extended: false});

/**
 * GET
 */
app.route("/").get((req, res, next) => {
    res.send("Home");
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
app.route("/products").post(urlParser, (req, res, next) => {
    res.send("Post new product.");
    console.log(req.body);
});

/**
 * PATCH
 */
app.route("/products/:productID").patch(urlParser, (req, res, next) => {
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