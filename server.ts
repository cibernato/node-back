import * as express from  "express"
import { setupRoutes } from './api/api';
const app = express();

setupRoutes(app);

app.listen(8091, "localhost", () => console.log("Server started..."));