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
		grid[x].setContainerSequence(randomBits().to_string());
	
	
	deathRate = 10.0;
	replicationRate = 50.0;
	movementRate = 50.0;
	mutationRate = 1.0;
	fitness = 10.0;
	totalPopulation = 0;
	currentPopulation = 0;
}

void Environment::start()
{
	grid[0].addGenotype(randomBits_s());
	totalPopulation++;
	currentPopulation++;
//	for(int j = 0; j < 20; j++)
		vector<string> genotypes;
		vector<Virus> moving;
		for (int i = 0; i < gridCount; i++) {
			genotypes = grid[i].getAllGenotypes();
			//iterate over each genotype
			for (int j = 0; j < genotypes.size(); j++) {
				// Iterate over the counts of each genotype, repeat only
				for(int k = 0;  k < grid[i].getCount(genotypes[j]); k++)
				{
					// Die
					if ((rand() % 101) < deathRate) {
						grid[i].removeGenotype(genotypes[j]);
						currentPopulation--;
					}
					else
					{
						if ((rand() % 101) < replicationRate) {
							grid[i].addGenotype(mutate(genotypes[j]));
							totalPopulation++;
							currentPopulation++;
						}
						else if((rand() % 101) < replicationRate) {
							grid[i].removeGenotype(genotypes[j]);
							Virus virus;
							virus.container =adjacentContainers[i][(rand() % adjacentContainers[i].size())];
							virus.genotype = genotypes[j];
							moving.push_back(virus);
						}
					}
				}
			}
			genotypes.clear();
		}

	// Maps are mutable
	for (int i = 0; i < moving.size(); i++) {
		grid[moving[i].container].addGenotype(moving[i].genotype);
	}
}

string Environment::mutate(string seq)
{
	bitset<SEQUENCE_LENGTH> bits (seq);
	for (int x = 0; x < bits.size(); x++) {
		if ((rand() % 101) < mutationRate) {
			bits[x] = (rand() % 2);
		}
	}
	return bits.to_string();
}

//bitset<SEQUENCE_LENGTH> Environment::toBits(string bits)
//{
//	bitset<SEQUENCE_LENGTH> mybits (bits);
//	return mybits;
//}

string Environment::randomBits_s()
{
	return randomBits().to_string();
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
	bool contSeq = true;
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
//			if (grid[i].getCount() > 0) {
				cout << "Container: " << i << endl;
				grid[i].print();
//			}

		}
		float dead = (float(totalPopulation - currentPopulation));
		double death = double(dead / totalPopulation) * 100.0;
		cout << "Total Population: " << totalPopulation << endl
			<< "Current Population: " << currentPopulation << endl
			<< "Dead: " << dead << endl
			<< "Death Rate: " << setprecision(8) << death;
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
