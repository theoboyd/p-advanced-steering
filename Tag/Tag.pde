/*
 *
 * The TagDemo sketch
 *
 */

ArrayList agents; // The tag-playing agents with multiple possible behaviours
//ArrayList evadings; // The Evade behaviours
//ArrayList wanderings; // The Wander behaviours
Seek seek; // Regular steering behaviours
Pursue pursue;
Flee flee;
Evade evade;
Wander wander;
WallAvoid wallavoid;

boolean pause; // Are we paused?
boolean showInfo; // Is this information panel being displayed?
boolean controlHunter = true; // Are we controlling the hunter agent? (Otherwise the prey agent)
boolean hunterSeeking = true; // Is the hunter using Seek? (Otherwise Pursue)
boolean preyFleeing = true; // Is the hunter using Flee? (Otherwise Evade)
float timeToTargetK = 1; // Time to target K value for Pursue and Evade
static int preyCaught = 0;
int whoIsIt = 1; // The agent number that is "it"
int whoIsVictim = 2; // The agent number that is the victim
int maxAgents = 10; // Constant for number of agents
int waitLimit = 30; // Time to allow victims to flee
int waitTime = waitLimit;
boolean itWaiting = true;

// Initialisation
void setup() {
  size(1000, 600); // Large display window
  pause = false;
  showInfo = true;
  
  // Create the agents
  agents = new ArrayList();
  /*Agent agent1; Agent agent2; Agent agent3; Agent agent4; Agent agent5;
  agent1 = new Agent(10, 10, randomPoint()); agent2 = new Agent(10, 10, randomPoint());
  agent3 = new Agent(10, 10, randomPoint()); agent4 = new Agent(10, 10, randomPoint());
  agent5 = new Agent(10, 10, randomPoint());
  agents.add(agent1); agents.add(agent2); agents.add(agent3); agents.add(agent4); agents.add(agent5);

  // Create the repeated behaviours
  Evade evade1; Evade evade2; Evade evade3; Evade evade4; Evade evade5;
  evadings.add(evade1); agents.add(evade2); agents.add(evade3); agents.add(evade4); agents.add(evade5);
  
  // Wander behaviours to add realism and edge avoidance
  Wander wander1; Wander wander2; Wander wander3; Wander wander4; Wander wander5;
  wanderings.add(wander1); agents.add(wander2); agents.add(wander3); agents.add(wander4); agents.add(wander5);
  */
  
  setBehaviours();

  smooth(); // Anti-aliasing on
}

void setBehaviours() {
  // Set and add the behaviours
  
  ArrayList positions = new ArrayList();
  for (int i = 0; i < maxAgents; i++) {
    // Collect existing positions
    try {
      Agent curr = (Agent)agents.get(i); 
      PVector newPosition = curr.position;
      positions.add(newPosition);
    }
    catch (Exception e) {
      // Position / agent does not exist yet
    }
  }
  agents.clear();
  for (int i = 0; i < maxAgents; i++) {
    PVector newPosition;
    try {
      // Try to get its old position, if it existed before
      if (i == whoIsIt - 1) {
        newPosition = (PVector)positions.get(i);
      } else {
        /*
        // Damped offset to unstick agents
        float offsetx = random(0, 30);
        float offsety = random(0, 30);
        PVector dampedOffset = PVector.add((PVector)positions.get(i), new PVector(offsetx, offsety));
        if (dampedOffset.x >= width) dampedOffset.x = width - 1;
        if (dampedOffset.y >= height) dampedOffset.y = height - 1;
        if (dampedOffset.x <= 0) dampedOffset.x = 0;
        if (dampedOffset.y <= 0) dampedOffset.y = 0;
        */
        newPosition = randomPoint(); //dampedOffset; //(PVector)positions.get(i);
      }
    } catch (Exception e) {
      // Otherwise it's a new agent, give it a new position
      newPosition = randomPoint();
    }
    Agent newAgent = new Agent(10, 10, newPosition);
    agents.add(newAgent);
  }
  
  for (int i = 0; i < maxAgents; i++) {
    Agent curr = (Agent)agents.get(i);
    curr.behaviours.clear();  // Remove the old behaviours
    if (i == whoIsIt - 1) {
      // "It" agent should hunt
      
      // Randomly choose Seek or Pursue (for a more interesting game)
      float randChoice = random(0, 1);
      boolean chooseSeek = (randChoice < 0.5);
      if (chooseSeek) {
        Agent victim = (Agent)agents.get(whoIsVictim - 1);
        seek = new Seek(curr, victim.position, 10);
        curr.behaviours.add(seek);
      } else {
        pursue = new Pursue(curr, (Agent)agents.get(whoIsVictim - 1), 10, timeToTargetK);
        curr.behaviours.add(pursue);
      }
    } else if (i == whoIsVictim - 1) {
      // Victim should escape
      
      // Randomly choose Flee or Evade (for a more interesting game)
      float randChoice = random(0, 1);
      boolean chooseFlee = (randChoice < 0.5);
      if (chooseFlee) {
        flee = new Flee(curr, (Agent)agents.get(whoIsIt - 1), 10);
        curr.behaviours.add(flee);
      } else {
        evade = new Evade(curr, (Agent)agents.get(whoIsIt - 1), 10, timeToTargetK);
        curr.behaviours.add(evade);
      }
    } else {
      // Others should wander to assist with wall avoidance and to add realism
      
      wallavoid = new WallAvoid(curr, randomPoint(), 10);
      //wander = new Wander(curr, randomPoint(), 10);
      curr.behaviours.add(wallavoid);
      //curr.behaviours.add(wander);
      
      // Also avoid "it" agent
      evade = new Evade(curr, (Agent)agents.get(whoIsIt - 1), 10, timeToTargetK);
      curr.behaviours.add(evade);
    }
  }
}

// Pick a random point in the display window
PVector randomPoint() {
  return new PVector(random(width), random(height));
}

// The draw loop
void draw() {
  // Clear the display
  background(255);
  
  // Move forward one step in steering simulation
  if (!pause) {
    for (int i = 0; i < maxAgents; i++) {
      Agent curr = (Agent)agents.get(i);
      curr.update();
    }
  }
  
  // Draw the agents, with different colours
  color cLine = #000000;
  for (int i = 0; i < maxAgents; i++) {
    Agent curr = (Agent)agents.get(i);
    curr.draw(cLine, getColour(i));
  }

  Agent it = (Agent)agents.get(whoIsIt - 1);
  Agent victim = (Agent)agents.get(whoIsVictim - 1);
  if (PVector.dist(it.position, victim.position) <= 10) {
    // Prey was caught
    preyCaught++;
    
    // Change "it" and victim;
    
    // Set the victim to the caught agent
    whoIsIt = whoIsVictim;
    
    // Attempt to choose a nearby victim
    float closestAgentDistance = 2 * width;
    int closestAgent = whoIsIt;
    for (int i = 0; i < maxAgents; i++) {
      // Find nearest victim
      if (i != whoIsIt - 1) {
        float distToIt = PVector.dist(it.position, ((Agent)agents.get(i)).position);
        if (distToIt < closestAgentDistance) {
          closestAgent = i + 1;
        }
      }
    }
    
    whoIsVictim = closestAgent;
    
    /*
    // Otherwise...
    // Choose a random victim that is not the "it" agent
    whoIsVictim = floor(random(1, maxAgents - 1)); // From 1 to <= 6, rounded down
    if (whoIsVictim == whoIsIt) { 
      // Shift along...
      whoIsVictim = (((whoIsVictim + 1) % maxAgents) + 1);
    }
    */
    
    /*
    // Give some time for the agents to flee
    if (waitTime < 1) {
      // Resume movement
      waitTime = waitLimit;
      itWaiting = false;
    } else {
      it.velocity = new PVector(0, 0);
      itWaiting = true;
      waitTime--;
    }
    */
    // Move agents away and
    // set behaviours
    setBehaviours();
  }
  
  // Draw the information panel
  if (showInfo) drawInfoPanel();
}
  
// Draw the information panel!
void drawInfoPanel() {
  pushStyle(); // Push current drawing style onto stack
  fill(0);
  text("1 - toggle display", 10, 20);
  text("2 - toggle annotation", 10, 35);
  text("Space - play/pause", 10, 50);
  text("Number of agents (q/a) = " + maxAgents, 10, 65);
  text("The red agent is 'it'", 10, 80);
  text("A victim has been caught " + preyCaught + " times", 10, 95);
  popStyle(); // Retrieve previous drawing style
}

/*
 * Input handlers
 */

// Key pressed
void keyPressed() {
  if (key == ' ') {
    pause = !pause;
  } else if (key == '1' || key == '!') {
    showInfo = !showInfo;

  } else if (key == '2' || key == '@') {
    for (int i = 0; i < maxAgents; i++) {
      Agent curr = (Agent)agents.get(i);
      curr.toggleAnnotate();
    }
  } else if (key == 'q' || key == 'Q') {
    boolean oldpause = pause;
    pause = true; // Pause and recreate agents
    maxAgents++;
    setBehaviours();
    pause = oldpause; // Restore to whatever value pause was set to
  } else if (key == 'a' || key == 'A') {
    boolean oldpause = pause;
    pause = true; // Pause and recreate agents
    maxAgents--;
    if (maxAgents < 4) maxAgents = 4;
    setBehaviours();
    pause = oldpause; // Restore to whatever value pause was set to
  }
}

color getColour(int index) {
  color cNormal = #FF2222;
  color cIt = #2222FF;
  color cVictim = #6666FF;
  if (index == whoIsIt - 1) {
    return cNormal;
  } else if (index == whoIsVictim - 1) {
    return cVictim;
  } else {
    return cIt;
  }
}
