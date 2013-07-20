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
	
	deathRate = 0.10;
	replicationRate = 0.50;
	movementRate = 0.50;
	mutationRate = 0.10;
	fitness = 0.10;				// Increase death rate by up to 10%
	drugStrength = 0.10;

	// drug sequence
	bitset<DRUG_LENGTH> drug;
	int randomNum = rand() % DRUG_LENGTH;
	for (int i = 0; i < randomNum; i++)
		drug.flip(rand() % DRUG_LENGTH);


	for (int x = 0; x < gridCount; x++)
	{
		grid[x].setContainerSequence(randomBits_s());
		vector<string> temp = partitonBits(grid[x].getContainerSequence());
		for (int i = 0; i < temp.size(); i++) {
			if ((drug ^
				 bitset<DRUG_LENGTH> (string(temp[i]))).none()) {
				drugContainers.push_back(0);
				break;
			}
		}
	}
	
	// initialize first virus
	grid[0].addGenotype(randomBits_s());
	totalPopulation = 1;
	currentPopulation = 1;
}

vector<string> Environment::partitonBits(string seq)
{
	vector<string> result;
	for (int i = 0; i < (SEQUENCE_LENGTH - DRUG_LENGTH + 1); i++)
	{
		result.push_back(seq.substr(i, DRUG_LENGTH));
	}
	return result;
}

void Environment::start()
{
	// implement adding, drug probability
	// Also optimization is needed 
	vector<string> genotypes;
	vector<Virus> moving;
	float dr = 0.0, rr = 0.0, fit = 0.0;

	for (int i = 0; i < gridCount; i++) {
		for (int k = 0; k < drugContainers.size(); k++) {
			if (drugContainers[k] == i) {
//				drugD = deathRate * drugStrength;
//				drugR = replicationRate * drugStrength;
				break;
			}
		}
		if (grid[i].getCount() > 0) {
			//iterate over each genotype
			genotypes = grid[i].getAllGenotypes();
			for(int j = 0; j < genotypes.size(); j++)
			{
				int hd = grid[i].getHammingDistance(genotypes[j]);
				fit = (float)hd / (float)SEQUENCE_LENGTH * fitness;
				dr = deathRate * fit + deathRate * drugStrength;
				rr = replicationRate * fit;
				int d = binomial(grid[i].getCount(genotypes[j]), (deathRate + dr));
				for(int x = 0; x < d; x++)
				{
					
					grid[i].removeGenotype(genotypes[j]);
					currentPopulation--;
				}
				
				int m = grid[i].getCount(genotypes[j]);
				int r = binomial(grid[i].getCount(genotypes[j]), (replicationRate - rr));
				m -= r;
				
				for(int x = 0; x < r; x++)
				{
					grid[i].addGenotype(mutate(genotypes[j]));
					totalPopulation++;
					currentPopulation++;
				}
			
				m = binomial(m, (movementRate / 100));
					
				for(int x = 0; x < m; x++)
				{
					grid[i].removeGenotype(genotypes[j]);
					Virus virus;

					virus.container = adjacentContainers[i][rand() % unsigned(adjacentContainers[i].size())];
					virus.genotype = genotypes[j];
					moving.push_back(virus);
				}
					
			}
		}
		genotypes.clear();
	}
	
	// Maps are mutable
	for (int i = 0; i < moving.size(); i++)
		grid[moving[i].container].addGenotype(moving[i].genotype);
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
	bool contSeq = 1;
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
		int infected = 0;
		for (int i = 0; i < gridCount; i++) {
			if (grid[i].getCount() > 0) {
				cout << "=========================" << endl
					<< "Container: " << i << endl << endl;
				grid[i].print();
				infected++;
			}

		}
		float dead = (float(totalPopulation - currentPopulation));
		double death = double(dead / totalPopulation) * 100.0;
		cout << "\n\n====================" << endl;
		cout << "Current Population: " << currentPopulation
		<< " / " << totalPopulation  << endl
		<< "Dead: " << dead << endl
		<< "Death Rate: " << setprecision(8) << death << endl
		<< "Infected Containers: " << infected;
		cout << "\nDrug Containers: " << drugContainers.size() << endl;
	}
}

int Environment::binomial(int trials, float probability)
{
	std::random_device rd;
    std::mt19937 gen(rd());
    std::binomial_distribution<> d(trials, probability);
	return d(gen);
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
