import {RequestHandler} from "express";
import {RequestHeader} from "../const/consts";
const jwt = require("jsonwebtoken");

const validateJWTToken = (jwtToken,res, next) => {
    try {
        jwt.verify(jwtToken, process.env.TOKEN_KEY);
    } catch (e) {
        res.status(401)
        next(e)
    }
}
export const authMiddleware: RequestHandler = (req, res, next) => {
    let apiKeyVariable = req.headers[RequestHeader.X_PARSE_REST_API_KEY] == process.env.VALID_API_KEY;
    let jwtToken = req.headers[RequestHeader.X_JWT_KWY];
    if (!apiKeyVariable || !jwtToken) {
        let error = new Error('Not Authorized');
        res.status(401);
        return next(error);
    }


    validateJWTToken(jwtToken,res,next);
    next();
};

