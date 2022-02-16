require('dotenv').config()
const express = require("express");
const {setupRoutes} = require("./src/api");
const app = express();

setupRoutes(app);

module.exports = app;
