import {authMiddleware} from "../middleware/auth";
import {MessagePayLoad} from "../interfaces/messagePayLoad";
import {MessageResponse} from "../interfaces/messageResponse";

export const setupDevOpsController = (app, jsonParser) => {
    // app.use(authMiddleware);

    app.route("/DevOps").post(jsonParser, authMiddleware, (req, res, next) => {
        let body: MessagePayLoad = <MessagePayLoad>req.body;
        const message: MessageResponse = {message: `Hello ${body.to} your message will be send`};
        res.send(message);
    });
}
