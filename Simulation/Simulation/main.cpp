//
//  main.cpp
//  Simulation
//
//  Created by Travis A. Ebesu on 7/19/13.
//  Copyright (c) 2013 Travis A. Ebesu. All rights reserved.
//
/*
	Notes: 
		* Virus Sequence and Drug Sequence are const set in Container and Environment header files
		* Due to time constraints many methods/vars/includes are unused or quick and dirty
		* Boost library is required for binomial distributions (the newest std may have this)
 */

#include <iostream>
#include <time.h>
#include "container.h"
#include "Environment.h"
using namespace std;

double elapsed(clock_t begin)
{
	clock_t end = clock();
	return double(end - begin) / CLOCKS_PER_SEC;
}



int main(int argc, const char * argv[])
{
	float deathRate, replicationRate, mutationRate, movementRate, fitness, drugStrength;
	string file;
	
	int start, max;
	if (argc == 8) {
		deathRate = atof(argv[1]);
		replicationRate = atof(argv[2]);
		movementRate =atof(argv[3]);
		mutationRate = atof(argv[4]);
		fitness = atof(argv[5]);			// Increase death rate by up to 10%
		drugStrength = atof(argv[6]);		// Drug containers increase, deathRate by drugStrength%  and Decrease for replication rate
		file = argv[7];
		clock_t begin = clock();

		Environment env(8);
		
		env.setDeathRate(deathRate);
		env.setReplicationRate(replicationRate);
		env.setMovementRate(movementRate);
		env.setMutationRate(mutationRate);
		env.setFitness(fitness);
		env.setDrugStrength(drugStrength);
		env.setOutputFile(file, true);
		
		env.run();
		
		cout << "\n\nTotal Elapsed: " << elapsed(begin) <<endl;
	}
	else if (argc == 10)
	{
	
		cout << "Start X with max Y\n\n" ;
		clock_t begin = clock();

		deathRate = atof(argv[1]);
		replicationRate = atof(argv[2]);
		movementRate =atof(argv[3]);
		mutationRate = atof(argv[4]);
		fitness = atof(argv[5]);			// Increase death rate by up to 10%
		drugStrength = atof(argv[6]);		// Drug containers increase, deathRate by drugStrength%  and Decrease for replication rate
		file = argv[7];
		start = atoi(argv[8]);
		max = atoi(argv[9]);
			
		Environment env(8);
		env.setDeathRate(deathRate);
		env.setReplicationRate(replicationRate);
		env.setMovementRate(movementRate);
		env.setMutationRate(mutationRate);
		env.setFitness(fitness);
		env.setDrugStrength(drugStrength);
		env.setOutputFile(file, true);
		env.run(start, max);
		
		
		
		cout << "\n\nTotal Elapsed: " << elapsed(begin) << endl;
		
	}
	else
		cout << "ERROR - check arguments\n";

    return 0;
}

