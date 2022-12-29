const express = require("express");
const bodyParser = require("body-parser");

const app = express();

// parse requests of content-type - application/json
app.use(bodyParser.json());

// parse requests of content-type - application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }));

// simple route
app.get("/", (req, res) => {
  res.json({ message: "Version : V-09 [ 29-12-20 ] YH84 \
            PUT /google_account/activate/:customerId5 ; /google_account/update/:customerId4 ; GET  /van/1 ;   GET /van/ran ; GET  /van/count   ; PUT /van/reset_all ; PUT /van/update/1  ; GET /van/ran ; GET  /van/count   ; GET /google_account/active ; GET  /nor/1 ;   GET /nor/ran ; GET  /nor/count   ; PUT /nor/reset_all ; PUT /nor/update/1  " });
});

require("./app/routes/customer.routes.js")(app);

// set port, listen for requests
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});
