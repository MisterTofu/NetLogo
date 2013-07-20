//
//  Environment.h
//  Simulation
//
//  Created by Travis on 7/19/13.
//  Copyright (c) 2013 Travis. All rights reserved.
//

#ifndef __Simulation__Environment__
#define __Simulation__Environment__

#include "container.h"
#include <vector>
#include <cmath>
#include <list>
using namespace std;

class Environment {
	
public:
	Environment(int size);


	void generateAdjacentContainers();
	void print();
	
	void start();
private:
	int hammingDistance(bitset<SEQUENCE_LENGTH> seq1, bitset<SEQUENCE_LENGTH> seq2);
	vector<Container> grid;
	int cSize;
	int gridCount;
	float deathRate;
	float replicationRate;
	float movementRate;
	float mutationRate;
	float fitness;

	bitset<SEQUENCE_LENGTH> randomBits();
	vector<vector<int>> adjacentContainers; //adjacent containers is not constant for each container
	vector<vector<int>> constraints;
	
};



#endif /* defined(__Simulation__Environment__) */
