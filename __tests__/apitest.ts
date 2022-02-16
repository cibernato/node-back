const request = require("supertest");
const app = require("../app");

describe("Test the root path", () => {
    test("It should response the GET method with 404", done => {
        request(app)
            .get("/")
            .then(response => {
                expect(response.statusCode).toBe(404);
                done();
            });
    });
});
describe("Test not existing path", () => {
    test("It should response the GET method without credentials", done => {
        request(app)
            .get("/asdf")
            .then(response => {
                expect(response.statusCode).toBe(404);
                done();
            });
    });
    test("It should response the GET method wit credentials", done => {
        request(app)
            .get("/asdf")
            .set('x-parse-rest-api-key', "asdf")
            .then(response => {
                expect(response.statusCode).toBe(404);
                done();
            });
    });
});
describe("Test /DevOps", () => {
    test("It should response the GET method 404", done => {
        request(app)
            .get("/DevOps")
            .then(response => {
                expect(response.statusCode).toBe(404);
                done();
            });
    });
    test("It should response the POST method with invalid credentials", done => {
        request(app)
            .post("/DevOps")
            .then(response => {
                expect(response.statusCode).toBe(401);
                done();
            });
    });

    test("It should response the POST method with invalid apikey", done => {
        request(app)
            .post("/DevOps")
            .set('x-parse-rest-api-key', "asdf")
            .set('x-jwt-kwy', "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJpYXQiOjE2NDUwMzE2MjcsImV4cCI6MTY0NTAzODgyN30.jtHx-fnhK6S3V6mYSUJkRTUCQm2LfHALZWbq3YwBBj4")
            .send({
                "message": "This is a test",
                "to": "Juan Pereza",
                "from": "Rita Asturia",
                "timeToLifeSec": 45
            })
            .then(response => {
                expect(response.statusCode).toBe(401);
                done();
            });
    });

    test("It should response the POST method with valid credentials", done => {
        request(app)
            .post("/DevOps")
            .set('x-parse-rest-api-key', "2f5ae96c-b558-4c7b-a590-a501ae1c3f6c")
            .set('x-jwt-kwy', "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJpYXQiOjE2NDUwMzQxMzEsImV4cCI6MTY3NjU5MTczMX0.sR3_RO6J_ol26IWLw_MRkCFSXmB0eiltJFVyFXJMqII")
            .send({
                "message": "This is a test",
                "to": "Juan Pereza",
                "from": "Rita Asturia",
                "timeToLifeSec": 45
            })
            .then(response => {
                expect(response.statusCode).toBe(200);
                done();
            });
    });

    test("It should response the POST method with invalid token", done => {
        request(app)
            .post("/DevOps")
            .set('x-parse-rest-api-key', "2f5ae96c-b558-4c7b-a590-a501ae1c3f6c")
            .set('x-jwt-kwy', "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXfVCJ9.eyJ1c2VyX2lkIjoxLCJpYXQiOjE2NDUwMzI1NDYsImV4cCI6MTY0NTAzMjg0Nn0.BhqazW85qa0T2Oled67YyQ7Y7ZHhIuYRogwuTgyKAlg")
            .send({
                "message": "This is a test",
                "to": "Juan Pereza",
                "from": "Rita Asturia",
                "timeToLifeSec": 45
            })
            .then(response => {
                expect(response.statusCode).toBe(401);
                done();
            });
    });
});
describe("Test /token", () => {
    test("It should response the GET method 200", done => {
        request(app)
            .get("/token")
            .then(response => {
                expect(response.statusCode).toBe(200);
                expect(response.body).toHaveProperty("token");
                done();
            });
    });

});



