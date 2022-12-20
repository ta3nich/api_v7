module.exports = app => {
  const customers = require("../controllers/customer.controller.js");

  
  //////////////////////////////  GOOGLE  //////////////////////////////////////////

  app.get("/google_account/active", customers.get_active_google);
  app.get("/google_account_van/active", customers.get_active_google_van);
//////////////////////////////////////////////////////////////////////////////////
  app.put("/google_account/update/:customerId4", customers.update_gc_acc);
  app.put("/google_account/update_van/:customerId6", customers.update_gc_acc_van);

  app.put("/google_account/activate/:customerId5", customers.active_gc_acc);
  app.put("/google_account/activate_van/:customerId8", customers.active_gc_acc_van);


  //////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////
  // GET RANDOM CONFIG
  app.get("/van/ran", customers.get_random_van);
  // SELECT COUNT(*) FROM product_details;

  //COUNT LEFT CONFIG
  app.get("/van/count", customers.config_left_van);

  // Retrieve a single Customer with customerId
  app.get("/van/:customerId3", customers.findOne_van);

  //update VANISH CONFIG
  app.put("/van/update/:customerId3", customers.update_van);

  //Reset all Config set used=y
  app.put("/van/reset_all", customers.reset_all_van);
  /////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////
  // GET RANDOM CONFIG
  app.get("/nor/ran", customers.get_random);
  // SELECT COUNT(*) FROM product_details;

  //COUNT LEFT CONFIG
  app.get("/nor/count", customers.config_left);

  // Retrieve a single Customer with customerId
  app.get("/nor/:customerId2", customers.findOne_nord);

  //COUNT LEFT CONFIG
  app.put("/nor/update/:customerId", customers.update_nord);

  //Reset all Config set used=y
  app.put("/nor/reset_all", customers.reset_all_nord);
  /////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////

  // Create a new Customer
  app.post("/customers", customers.create);

  // Retrieve all Customers
  app.get("/customers", customers.findAll);

  // Retrieve a single Customer with customerId
  app.get("/customers/:customerId", customers.findOne);


  // Update a Customer with customerId
  app.put("/customers/:customerId", customers.update);

  // Delete a Customer with customerId
  app.delete("/customers/:customerId", customers.delete);

  // Create a new Customer
  app.delete("/customers", customers.deleteAll);
};
