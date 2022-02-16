const jwt = require("jsonwebtoken");

export const setupTokenController = (app, jsonParser) => {
    app.route("/token").get(jsonParser, (req, res, next) => {
        const token = jwt.sign(
            {user_id: 1},
            process.env.TOKEN_KEY,
            {
                expiresIn: "1y",
            }
        );
        res.send({token: token})
    });
}
