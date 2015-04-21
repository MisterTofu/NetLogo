#[Netlogo](http://ccl.northwestern.edu/netlogo/)
Agent based modeling repository

Reimplementation of VirusContainer2 was done in C++, see simulation


##Models 
* Simulation (C++)
	* Virus Container 2, headless, pretty much the same as Virus Container 2 just implemented in C++
	* Due to time constraints, it was written very quick and dirty
* Virus Container 2
	* Optimized and segregated in to container and virus genotypes files
	* High use of dict and random generators created a lot of problems
	* Works fine on small scale
* Virus Container
	* Parts of Virus Spread/Cell and expanded for more practical problems
* Find Food Source
       * Generates food and makes the wolf chase the closests food
* Prey Predator
       * Expands on food source model and implements moving food (prey)
* Virus Spread
	* Begining to develop this model for my research simulation, creating basic elements
* Virus Cell
	* Expands on virus spread, but uses containers or cells as starting points for infections


##Dependencies
* [Graphics](http://evolve.lse.ac.uk/NetLogo/extensions/Simulations-NetLogo%20Extensions.php)



[![Analytics](https://ga-beacon.appspot.com/UA-62086129-1/NetLogo/readme?pixel)](https://github.com/igrigorik/ga-beacon)
