# TypeScript Applications

* Run `npm start` for TypeScript execution and REPL (read–eval–print loop).

## Backend with Node/Express (I)
TypeScript is the ideal language for full-stack web development as it can be used on a server side as well as on a client side. We start with the server-side where we will become familiar with one of the most popular backend options; Node combined with Express.

First, we will see how to setup and start an HTTP Server with Node and Express, which listens for web requests.

Second, we will talk about routs and define a couple of routs to respond to client requests. We will cover the four fundamental routing methods: GET, POST, PATCH and DELETE to retrieve, send, update and delete data.
* GET Request for retrieving data from the Server
* POST Request for sending data to the server
* PATCH Request for updating existing data
* DELETE Request for deleting data

In this context, we will see how to read data sent from the client and how to test routs with POSTMAN.

### Server Setup

server.ts is our main file and will contain the code to setup and start the express server.

* Install express with `npm install express -S`. 
* Install types for express as a development dependency with `npm install @types/express -D`

* Update server.ts to import express.

```TypeScript
import * as express from "express";
```

* Initialize a new express application called app. This is done by invoking express with empty parameter 
brackets.

```TypeScript
const app = express();
```

* Start the server with app.listen which requires the two arguments port and hostname, and a third 
optional argument callback. The callback function is like a completion handler and could be used to log 
the start of the server to the console.

```TypeScript
app.listen(8091, "localhost", () => console.log("Server started..."));
```

Now if you `npm start` and open the browser, and then submit your request to http://localhost:8091, the 
message sent back from the browser is "Cannot GET" followed by a slash "/", it shows that the server is 
running but no get route was defined to handle the request to the home path represented by the empty slash. 

Before writing a couple of routs to respond to user request, lets improve the testing process which is quiet 
tedious at the moment, every time we change the code and want to check if it works we have to save the file,
stop the server, restart it and switch over to the browser. To simplify that, we use a module called 
nodemon which we install as development dependency. nodemon allows us to restart script automaticlly when 
files in the specified directory change.

* Install nodemon as a development dependency with `npm install nodemon -D`

* Now we need to update package.json to use a new script for start. So, rename the current start script to start_server and add a new script start to call `nodemon` followed by three parameters: `-e` for the file extensions to monitor, in our case, we want to look for TypeScript files, `-w` for the folder where we want to watch for changes, in our case, the root directory and `-x` for the script we want to execute `start_server`.

```JSON
"start_server": "node_modules/.bin/ts-node server.ts",
"start": "nodemon -e ts -w ./ -x npm run start_server"
```
* Now when running an `npm start` the server is restarted every time we save a TypeScript file in the root directory.

### GET Request

* In order to define how to respond the client request, we need to add a get rout for the home path. For that, call app.route with the slash as it's parameter (the home path) followed by the route type, in this case, a get route with a completion handler, in this context, call request handler as argument. Every request handler has three parameters: a request, response object and a next function. We use the response object to determine how to respond to the user request. The simplest way to respond is to send a text message to the client.

```TypeScript
app.route("/").get((req, res, next) => {
    res.send("Home");
});
```

* We can also define a get route for another path. For example, a get route for "/products" or "/products/229".

```TypeScript
app.route("/products").get((req, res, next) => {
    res.send("Get all products.");
});

app.route("/products/229").get((req, res, next) => {
    res.send("Details for Product with ID: 229");
});
```

* Since it doesn't make sense to define a get route for each individual product, we use a route parameter 
for the product ID instead of a concreate product ID. A route parameter starts with a semicolon ":" and is 
made available in the request object params property. Now verify that we get the response for any product ID

```TypeScript
app.route("/products/:productID").get((req, res, next) => {
    res.send("Details for Product with ID: " + req.params.productID);
});
```

### POST Request

Besides get, express support more than 20 other routing methods. The most important ones are the four methods: GET, POST, PATCH and DELETE to retrieve, send, update and delete data. By submitting a web request from the browser's address bar, we always send a get request, we can't send other requests by this way. For testing the other routing methods, we use a tool called POSTMAN. To install POSTMAN go to the [website](https://www.getpostman.com/), download it and run through the setup steps.

By a post request, data is sent from the client to the server. A Typical use case is a web form. After a user fill out a form and press send, the entered data is sent in a body of a post request to the server. we can simulate that by POSTMAN. Open POSTMAN and do the following:

* Select the body tab below the request bar and there choose the second option; x-www-form-urlencoded.
* Into the key-value table add some property, for example, productName and a related data, i.e. MackBook Pro 2015.
* Unfortunately express doesn't provide the data in a way that we can easily access by the request object. To provide the data directly in the request object, its common to use the node module body parser, so install it by an `npm install body-parser -S`. And import the module under the name bodyparser. 

```TypeScript
import * as bodyparser from "body-parser"
```

* The body-parser module contains actually four different parsers: For urlencoded, JSON, RAW and text data. Here we make use of the urlencoded parser stored in a constant urlParser. For initializing we need to provide the property extended which we set to false. For more information about the bodyparser module and related modules, take a look at the bodyparser documentation on GitHub.

```TypeScript
const urlParser = bodyparser.urlencoded({extended: false});
```
* Now use the urlParser before our own custom request handler, then the body-parser is executed first and it provides the data sent in a body property after request object. So, we can use it in our own handler to send it back to the client.

```TypeScript
app.route("/products").post(urlParser, (req, res, next) => {
    res.send("Post new product.");
    /* Simply, log the content of request body to the console. */
    console.log(req.body);
});
```
### PATCH Request

The patch method allows us partial modifications to certain data items. Whereas post requires the complete set of properties of the data item included in the request, for patch its ok to include just some of the properties of the item. Then the server is responsible to update the given properties of the respective data item in a database.

For a simple example, define a patch route on a single product item. And inform the client that the product item was updated with the ID provided by the routing parameters.

```TypeScript
app.route("/products/:productID").patch(urlParser, (req, res, next) => {
    res.send("Update product with ID: " + req.params.productID);
    /* Simply, log the content of request body to the console. */
    console.log(req.body);
});
```
### DELETE Request

The delete method can be easily done as following

```TypeScript
app.route("/products/:productID").delete((req, res, next) => {
    res.send("Delete Product with ID: " + req.params.productID);
});
```

## Backend with Node/Express (II)

While dealing with routing in part (I), we already got to know some of the fundamental concepts of express though we didn't make it explicit. Now In part (II) we take a closer look at these concepts, in particular, the Request-Response-Cycle and the Express Middleware pattern.

After these foundations we briefly discuss two ways the server could respond to the client (Strategies for Rendering Websites). The first strategy: The server sends the final HTML ready to display (Server-side Rendering). the second Strategy: The server sends the pure data (Raw Data i.e. JSON, XML) and leave the responsibility for the presentation to the client (Client-side Rendering).

In the second scenario, which becomes more and more popular, we need a common structure to exchange data. The JSON and XML formats are available for that. And since JSON is generally preferred in a JavaScript and TypeScript setting, we will show how to use JSON in express.

Finally, we will see how to refactor the code for more structure so it remains readable and easily extensible.

### The Request-Response-Cycle and the Express Middleware

Express makes extensive use of what is called middleware functions. The bodyParser in our own custom request handler are examples of middleware functions.

```TypeScript
app.route("/products").post(urlParser, (req, res, next) => {
    res.send("Post new product.");
    /* Simply, log the content of request body to the console. */
    console.log(req.body);
});
```

Observe, by hovering over one of the routing methods that these methods accept a list of request handlers, i.e. middleware functions as input. Each middleware function has the same pattern, it has full access to the request as well as the response object and also may use the next function. The reason is that routing is not a linear process where we start with a request as input and return a response as output, instead we have a Request-Response-Cycle allowing to run multiple request handler sequentially with all the data request and response available for modification. We break the cycle by stopping it, i.e. by omitting the call to the next function or sending a response back to the client.

To get a better understating about these concepts, we write our own middleware function used to log requests from the client, for that define a constant logRequest of type RequestHandler and assign it a function with three parameters representing the request, response object and the next function. Then log the request method such as GET or POST to an end point such as "/products". also Make sure to import RequestHandler from express.


```TypeScript
import { RequestHandler } from "express";

const logRequest : RequestHandler = (req, res, next) => {
    console.log(req.method + " Request: " + req.url);
};
```

In order to test our logRequest handler, add it to the list of request handlers of the GET method to the end point "/products". Also add it in front of the urlParser; to the list of request handlers of the POST method to the end point "/products".

```TypeScript
app.route("/products").get(logRequest, (req, res, next) => {
    res.send("Get all products.");
});

app.route("/products").post(logRequest, urlParser, (req, res, next) => {
    res.send("Post new product.");
    console.log(req.body);
});
```
Then go to POSTMAN and check that we don't get a message back anymore. On the other hand, the logging of the requests to the console worked. Obviously, our logRequest handler was executed but not the subsequent handlers on the list. The reason is that we forgot to call the next function within the logRequst handler and that breaks the Request-Response-Cycle. To fix that issue, add a call to next within the handler.

```TypeScript
const logRequest : RequestHandler = (req, res, next) => {
    console.log(req.method + " Request: " + req.url);
    next();
});
```