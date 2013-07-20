//
//  Environment.cpp
//  Simulation
//
//  Created by Travis on 7/19/13.
//  Copyright (c) 2013 Travis. All rights reserved.
//

#include "Environment.h"


// Create x by x containers
Environment::Environment(int size)
{
	cSize = size;
	gridCount = size * size;
	generateAdjacentContainers();
	grid.assign(gridCount, Container());
	srand ((unsigned)time(NULL));
	
	for (int x = 0; x < gridCount; x++)
		grid[x].setSequence(randomBits());
	
	
	deathRate = 50.0;
	replicationRate = 50.0;
	mutationRate = 1.0;
	fitness = 10.0;
}

void Environment::start()
{
	grid[gridCount-1].addGenotype(randomBits());
//	grid[gridCount-1].print();

	map<string, int>::iterator it;
	for(int i = 0; i < 5; i++)
	{
//		grid[i].print();
		bitset<SEQUENCE_LENGTH> t = randomBits();
		grid[i].addGenotype(randomBits());
		grid[i].addGenotype(randomBits());
		grid[i].addGenotype(randomBits());
		grid[i].addGenotype(t);
		grid[i].removeGenotype(t);
//		grid[i].print();
	}
	
//	for(int i = 0; i < 5; i++)
//	{
//		if (grid[i].getCount() > 0) {
//			for(it = grid[i].genotype.begin(); it != grid[i].genotype.end(); ++it)
//			{
//				//first: sequence, second: counts
//				if((rand() % 100 + 1) < deathRate) {
////					grid[i].print();
//					bitset<SEQUENCE_LENGTH> bits (string(it->first));
//					cout << bits << endl;
//					grid[i].removeGenotype(bits);
////					grid[i].print();
//				}
//			}
//		}
//	}

}


bitset<SEQUENCE_LENGTH> Environment::randomBits()
{
	bitset<SEQUENCE_LENGTH> t;
	int randomNum = rand() % SEQUENCE_LENGTH;
	for (int i = 0; i < randomNum; i++)
		t.flip(rand() % SEQUENCE_LENGTH);
	return t;
}



void Environment::generateAdjacentContainers()
{
	int edge;
	float row;
	vector<int> temp;
	vector<int> tempConstraints;
	for(int x = 0; x < gridCount; x++)
	{
		edge = x % cSize;
		row = floor(float(x / cSize));
		//Check left
		if (edge != 0 and x > 0)
			temp.push_back(x - 1);
		
		//check right
		if(edge != (cSize - 1) and x < gridCount)
			temp.push_back(x + 1);
		
		//up
		if (row != 0)
			temp.push_back(x - cSize);
		
		//down
		if (row != (cSize - 1))
			temp.push_back(x + cSize);
		
		for(int i = 0; i < temp.size(); i++)
		{
			if (temp[i] < x) {
				tempConstraints.push_back(temp[i]);
			}
		}
		adjacentContainers.push_back(temp);
		constraints.push_back(tempConstraints);
		temp.erase(temp.begin(), temp.end());
		tempConstraints.erase(tempConstraints.begin(), tempConstraints.end());
	}
}

void Environment::print()
{
	bool adjacent = false;
	bool constr = false;
	bool contSeq = 0;
	if (adjacent){
		for( int x = 0; x < adjacentContainers.size(); x++)
		{
			cout << "Container: " << x  << "\n\t\t";
			for(int y = 0; y < adjacentContainers[x].size(); y++)
				cout << adjacentContainers[x][y] << "   ";
			cout << endl;
		}
	}
	
	if(constr){	
		for( int x = 0; x < constraints.size(); x++)
		{
			cout << "Container: " << x  << "\n\t\t";
			for(int y = 0; y < constraints[x].size(); y++)
				cout << constraints[x][y] << "   ";
			cout << endl;
		}
	}
	
	if (contSeq) {
		for (int i = 0; i < gridCount; i++) {
			if(grid[i].getSequence().count() > 0)
				cout <<i << ":\t"<< grid[i].getSequence() << endl;
		}
	}
}


int Environment::hammingDistance(bitset<SEQUENCE_LENGTH> seq1, bitset<SEQUENCE_LENGTH> seq2)
{
	int distance = 0;
	assert(seq1.size() == seq2.size());
	for (int i = 0; i < seq1.size(); i++) {
		if ((seq1[i] ^ seq2[i]) == 1) { //different
			distance++;
		}
	}
	return distance;
}
