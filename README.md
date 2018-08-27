# TypeScript Applications

* Run `npm start` and open the browser, then submit your request to http://localhost:8091.

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

Now if you `npm start` and open the browser, and then submit your request to http://localhost:8091, the message sent back from the browser is "Cannot GET" followed by a slash "/", it shows that the server is running but no get route was defined to handle the request to the home path represented by the empty slash. 

Before writing a couple of routs to respond to user request, lets improve the testing process which is quiet tedious at the moment, every time we change the code and want to check if it works we have to save the file, stop the server, restart it and switch over to the browser. To simplify that, we use a module called nodemon which we install as development dependency. nodemon allows us to restart script automaticlly when files in the specified directory change.

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

On the right side, you can see the request builder with a dropdown for the various routing methods, and next to it an input field for the requested URL.

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

Since we want to log any request not just the Get and Post requests to the end point "/products", we would need to add the logRequest handler in all the routes, which is obviously somewhat awkward. But fortunately, we don't need to do that, instead write app.use followed by the middleware function we want to use in all routes. Then logging should work for all routes.

```TypeScript
app.use(logRequest);
```

### Strategies for Rendering Websites

Basically, there are two different approaches, Server-side Rendering of HTML which is the traditional and still most common approach, and the more modern way of Client-side Rendering which is rapidly gain the importance recently and its driven by powerful client-side TypeScript/JavaScript frameworks such as angular or react.

#### Server-side Rendering

Server-side Rendering works as follows: HTML templates created with certain template engines are placed on the server. And the client request is answered by plugging additional data into these templates and sending the resulting html to the browser for display.

There are various template engines available like jade or ejs. Here we will use ejs for a quick illustration.
For that first install ejs by `npm install ejs -S`. Additionally, install types for ejs as a development dependency by `npm install @types/ejs -D`. ejs assumes that your templates are located in "views" folder. So, let's create the folder "views" under the root directory. In that folder, create a file "index.ejs", and open it to add some simple HTML.

For rendering the ejs replace the "send" method by the "render" method in home route. The method render takes one required argument and two optional arguments. For now, we need the required parameter which is the name of the template file under the views folder.

```TypeScript
app.route("/").get((req, res, next) => {
    // res.send("Home");
    res.render("index.ejs");
});
```

Now go to the browser and send a request to the [Home path](http://localhost:8091). In case of ejs, the template is just an extension of HTML. So, as in our example we can store pure HTML as an ejs template. Usually however we will have some dynamic elements on our website, for instance we could greet the user with "welcome" followed by the user's first name when the user is logged in. To demonstrate that, add an interface user above the home route with a firstname and a lastname.

```TypeScript
interface User {
    firstname: string
    lastname: string
}
```

And create a constant "user" of type User with dummy User data.

```TypeScript
const user : User = {
    firstname : "Robert",
    lastname : "Jones"
}
```

To inject this data into the template we use the second parameter of the "render" method. There we can add an object of key-value pairs of any type, so we could provide the user data under the key "user".

```TypeScript
app.route("/").get((req, res, next) => {
    // res.send("Home");
    res.render("index.ejs", {user: user});
});
```
With that key we can get access to the user object within the template. In order to insert injected data in the ejs template, we have a special tag with a % sign followed by an = sign, within that tag add user.firstname to access the firstname of the user for the greeting.

```HTML
<h1>Welcome <%= user.firstname %>!</h1>
```

#### Client-side Rendering

When opting for Client-side Rendering, Front-end frameworks like Angular or React take over the responsibility to render the HTML files. So, all what we need to do on the server is to send the raw data requested by the client.

Two different formats for exchanging raw data in this context; XML and JSON. Compared to XML, JSON is more practical, especially when used with JavaScript or TypeScript. JSON which stands for JavaScript Object Notation looks in fact quite similar to a JavaScript or TypeScript object. Take a look at the file tsconfig.json and observe that the difference to the Object Notation is that the property names as well as the primitive values are set within quotation marks. Moreover, objects as members are resolved by adding the content within curly braces as in the case of the property "compilerOptions". And arrays are written as usual by listing the elements within square brackets as in the case of the property "files".

TypeScript’s object can be converted easily to JSON and vice versa. For example, we could create a JSON expressed as a string by applying the JSON’s stringy method on the user object.

```TypeScript
const userJSON = JSON.stringify(user);
console.log(userJSON); // Check that by printing userJSON to the console.
```

For the opposite direction, create a constant parsedUser by the JSON's pares method on the JSON string userJSON and cast it as a User object.

```TypeScript
const parsedUser = JSON.parse(userJSON) as User;
console.log(parsedUser) // Observe that the parsedUser is equal to the original user object
```

Now, Let's replace urlencoded data by JSON data as format for the data sent by the client. As a first step, create a JSON parser by calling the JSON method on bodyParser.

```TypeScript
const jsonParser = bodyparser.json();
```

Then replace urlParser by jsonParser in all routes.

```TypeScript
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
```

After that, switch over to POSTMAN, create a post request to end point "/products", but now choose raw option as body format, and select JSON in the dropdown list. Then insert some JSON data.

```JSON
{
    "productName" : "MacBook Pro 2015"
}
```

After sending the request, verify in VSCode that the data still provided correctly in the body property of the request object.

### Code Refactoring (Code Organization)

You may observe, even in a simple example that the main file server.ts has already become quite long and loaded with different tasks. To reorganize the code, we could move routing part to a separate module. For that, create a folder "api" under root and in that folder create a file "api.ts". Now move all the code related to routing to this new file. There we could export a function which initializes all the routes. let’s call the function setupRoutes and provide the parameter app of type express as input. Move all routes defenetions to this function. Also add Express to the list of imports from express at the top of the file.

```TypeScript
import { RequestHandler, Express } from "express";

export function setupRoutes(app : Express) {

    // Move all routes defenetions to this function

}
```

Now, in the main file server.ts, first import setupRoutes from the api file. And call the function with app as parameter.

```TypeScript
import { setupRoutes } from './api/api';

setupRoutes(app);
```

Check now in POSTMAN. Of course, we could go on to make our code more modular by placing each request handler in its own module.