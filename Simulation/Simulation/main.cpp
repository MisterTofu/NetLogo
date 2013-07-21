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

/*	Number of Drug Bits are set as a constant
 *			set in Environment.h
 *
 */
float deathRate = 0.00;
float replicationRate = 0.20;
float movementRate = 0.80;
float mutationRate = 0.10;
float fitness = 0.00;				// Increase death rate by up to 10%
float drugStrength = 0.00;		// Drug containers increase, deathRate by drugStrength%  and Decrease for replication rate


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

	clock_t begin = clock();
//	Environment(8, "hello") env;

	Environment env(8);
	
	env.setDeathRate(deathRate);
	env.setReplicationRate(replicationRate);
	env.setMovementRate(movementRate);
	env.setMutationRate(mutationRate);
	env.setFitness(fitness);
	env.setDrugStrength(drugStrength);
	env.setOutputFile("test.csv");
	
	env.run();
	
//	for (int i = 0; i < 1; i++) {
//		clock_t start = clock();
//		env.start();
//		cout << "Generation: " << i <<"\t\tElapsed: " << setprecision(10) << elapsed(start) <<"\t\tTotal: " << elapsed(begin) << endl;
//	}
//	env.print();
	
	
//	cout << getEntropy() << endl;
	
	
	
//	bitset<10> t1,t2;
//	string x = t1.to_string();
//		t2.flip();
//	cout << env.hammingDistance(t1, t2) << endl;
//	bitset<10> t3 ((string(x)));
//	cout << env.hammingDistance(t3, t2) << endl;
	
	cout << "\n\nTotal Elapsed: " << elapsed(begin);

    return 0;
}


