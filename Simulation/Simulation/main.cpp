//
//  main.cpp
//  Simulation
//
//  Created by Travis on 7/19/13.
//  Copyright (c) 2013 Travis. All rights reserved.
//

#include <stdio.h>
#include <iostream>
#include <time.h>
#include <stdlib.h>     /* srand, rand */
#include "container.h"
#include "Environment.h"
#include <ctime>
#include <boost/timer.hpp>
using namespace std;

double elapsed(clock_t begin)
{
	clock_t end = clock();
	return double(end - begin) / CLOCKS_PER_SEC;
}

/*	Number of Drug Bits are set as a constant
 *			set in Environment.h
 *
 */



double getEntropy()
{
	double result = 0.0;
	int total = 5;
	if (total > 0)
	{
		double px;
		map<string, int>::iterator it;
//		for (it = genotype.begin(); it != genotype.end(); ++it)
//		{
			px = 3.0 / (double)total;
		cout << px << endl;
			result += (px * log2(px));
		cout << result << endl;
		px = 2 / (double)total;
				cout << px << endl;
		result += (px * log2(px));
				cout << result << endl;
//		}
	}
	return (result * -1);
}

int main(int argc, const char * argv[])
{
	float deathRate, replicationRate, mutationRate, movementRate, fitness, drugStrength;
	string file;
	
		cout << argv[0] << endl;
	
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
	else
	{
		
		if (argc > 1) {
			file = argv[1];
		
		int sum = 0;
		clock_t begin = clock();
		

		deathRate = 0.1;
		replicationRate = 0.50;
		movementRate = 0.5;

		
		
		
		for (drugStrength = 0.0; drugStrength < 0.21; drugStrength+=0.05)
		{
			for(mutationRate = 0.01; mutationRate <= 0.1; mutationRate+=0.04)
			{
				if (mutationRate > 0.06)
					mutationRate = 0.10;
				for(fitness = 0.01; fitness <= 0.10; fitness+=0.04)
				{
					sum++;
					cout << "Starting Iteration: " << sum << endl << endl;
					if(fitness > 0.06)
						fitness = 0.10;
					
					Environment env(8);
					env.setDeathRate(deathRate);
					env.setReplicationRate(replicationRate);
					env.setMovementRate(movementRate);
					env.setOutputFile(file, true);
					env.setMutationRate(mutationRate);
					env.setFitness(fitness);
					env.setDrugStrength(drugStrength);
					env.run();
					
					cout << "\n\n\nIteration: " << sum << "\t\t" << "Total Time Elapsed: "  << elapsed(begin) << endl;
				}
			}
		}
		
			cout << "\n\nTotal Elapsed: " << elapsed(begin) << endl;
		}
	}
    return 0;
}

/*
 string elapsed_s(clock_t begin)
 {
 string result;
 clock_t end = clock();
 double seconds = (end - begin) / CLOCKS_PER_SEC;
 
 
 
 
 return result;
 }
 
 string GroupDigits(long long n)
 {
 bool negative = (n < 0);
 if (negative) n *= -1; // think positive!
 
 // convert the integer into a string.
 ostringstream result;
 result << n;
 string number = result.str();
 
 // format it to include comma seperators
 int length = number.length(), i;
 string formatted = "";
 
 for (i = length - 3; i >= 0; i -= 3)
 if (i > 0 )
 formatted = ',' + number.substr(i, 3) + formatted;
 else
 formatted = number.substr(i, 3) + formatted;
 if (i < 0)
 formatted = number.substr(0, 3 + i) + formatted;
 if (negative)
 formatted = "-" + formatted;
 
 return formatted;
 }
 */

