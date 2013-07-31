//
//  container.h
//  Simulation
//
//  Created by Travis on 7/19/13.
//  Copyright (c) 2013 Travis. All rights reserved.
//

#ifndef __Simulation__container__
#define __Simulation__container__

#include <iostream>
#include <bitset>
#include <assert.h>
#include <string.h>
#include <iomanip>
#include <map>
#include <cmath>
#include <vector>
using namespace std;

const int SEQUENCE_LENGTH = 10;



class Container {
	
public:
	// Set sequence, from string to bitset
	Container(string seq);
	
	// Initialize
	Container();
	
	// Set sequence
	void setContainerSequence(string g);
	
	// Gets count of living viruses in container
	int getCount();
	
	// Gets count of given genotype
	int getCount(string g);
	
	
	// Gets total count of all viruses created
	int getTotalCount();
	
	// Gets hamming distance of given genotype
	int getHammingDistance(string g);
	
	// Input: Bitsequence as string, must be SEQUENCE_LENGTH
	// Adds the genotype to the map and keeps count
	void addGenotype(string g);
	
	// Same as add but removes it
	void removeGenotype(string g);
	
	// Returns a vector of all genotypes
	vector<string> getAllGenotypes();
	
	// Gets the current shanon entrophy
	double getEntropy();
	
	// Returns true if container is infected with a virus
	bool infected();
	
	
	// Returns containers sequence as a string
	string getContainerSequence();
	
	// Returns containers sequence as bitset
	bitset<SEQUENCE_LENGTH> getContainerSequenceBits();
	
	
	// Set this container as a drug container
	// Input: true if drugcontainer, drug bit sequence as a string
	// Setting false will remove it from being a drug container
	void setDrugContainer(bool drug, string drugSequence);
	
	// Returns if this is set as a drug container
	bool isDrugContainer();

	// Debug Printing	
	void print();
	
private:
	// Returns Y if infected, else N
	string infectedOutput();
	
	// Converts string to bitset
	bitset<SEQUENCE_LENGTH> toBits(string bits);
	
	// Calculate hamming distance between two bitsets
	int hammingDistance(bitset<SEQUENCE_LENGTH> seq1, bitset<SEQUENCE_LENGTH> seq2);
		
	// map of all genotypes and their counts
	map<string, int> genotype;
	
	// map of hamming distance between genotype and container sequence
	map<string, int> hamming;
	
	string containerSequence;
	int count;
	int totalcount;
	bool drugContainer;
	string DrugSequence;
};


#endif /* defined(__Simulation__container__) */
