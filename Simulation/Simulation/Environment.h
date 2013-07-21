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
#include <ctime>
#include <random>
#include <boost/random.hpp>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/uniform_int_distribution.hpp>
#include <fstream>
using namespace std;

struct Virus {
	string genotype;
	int container;
};

const int DRUG_LENGTH = 5;

class Environment {
	
public:
	Environment(int size);
	~Environment();
	void setOutputFile(string);
	void setDeathRate(float);
	void setReplicationRate(float);
	void setMovementRate(float);
	void setMutationRate(float);
	void setFitness(float);
	void setDrugStrength(float);
	void run();
	double getEntropy();
	void generateAdjacentContainers();
	void print();
	void printGenotypes();
	void start();
		int hammingDistance(bitset<SEQUENCE_LENGTH> seq1, bitset<SEQUENCE_LENGTH> seq2);
	
	vector<string> partitonBits(string seq);
private:
	
	/* */
	
	vector<vector<int>> adjacentContainers; //adjacent containers is not constant for each container
	vector<vector<int>> constraints;
	vector<Container> grid;
	int cSize;
	int generation;
	int gridCount;
	float deathRate;
	float replicationRate;
	float movementRate;
	float mutationRate;
	float fitness;
	string mutate(string seq);
	int totalPopulation;
	int currentPopulation;
	float drugStrength;
	int drugLength;
	int drugContainersCount;
	void initialize();
	void writeToFile();
	map<string, int> getTotalGenotypeCounts();
	/* Functions */
	
	bitset<SEQUENCE_LENGTH> randomBits();
	string randomBits_s();
	int binomial(int trials, float probability);
	float random(float start, float end);
	int randomInteger(int, int);
	ofstream output;

};



#endif /* defined(__Simulation__Environment__) */
