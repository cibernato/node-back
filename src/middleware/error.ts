import {ErrorRequestHandler, RequestHandler} from "express";

export const errorHandler: ErrorRequestHandler = (err, req, res, next) => {
    if (res.statusCode != 200) {
        res.send("ERROR")
    }
    next(err)
};

export const notFoundHandler: RequestHandler = ( req, res, next) => {
    res.status(404).send('ERROR');
};
