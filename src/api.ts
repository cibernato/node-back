import {Express} from "express";
import * as bodyparser from "body-parser"
import {errorHandler, notFoundHandler} from "./middleware/error";
import {setupDevOpsController} from "./controllers/devops.controller";
import {setupTokenController} from "./controllers/token.controller";

const jsonParser = bodyparser.json();

export function setupRoutes(app: Express) {

    setupTokenController(app, jsonParser);
    setupDevOpsController(app, jsonParser);

    app.use(errorHandler);
    app.use(notFoundHandler);

}
