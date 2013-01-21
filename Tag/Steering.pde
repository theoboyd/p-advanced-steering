/*
 * A Steering Behaviour
 */
abstract class Steering {
  
  // The steered agent
  Agent agent;
  // Relative weight in sum of all steering forces
  float weight;
  // Is the behaviour switched on?
  boolean active;
  
  // Initialisation
  Steering(Agent a) {
   agent = a;
   weight = 1;
   active = true;
  }
  
  // Get the current steering force for this behaviour
  PVector getForce() {
    if (active) {
      // Actual force is calculated in subclass
      PVector f = calculateRawForce();
      f.mult(weight); // Weight the result
      return f;
    } else {
      // No force if this behaviour is not active
      return new PVector(0,0); 
    }
  }

  // The actual force calculation
  abstract PVector calculateRawForce();
  
  // Draw any associated objects
  abstract void draw();
}
