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
#include <vector>
using namespace std;

const int SEQUENCE_LENGTH = 10;



class Container {
	
public:
	Container(string seq);
	Container();
	void setContainerSequence(string g);
	int getCount();
	int getCount(string g);
	int getHammingDistance(string g);
	void addGenotype(string  g);
	void removeGenotype(string g);
	vector<string> getAllGenotypes();
	bitset<SEQUENCE_LENGTH> toBits(string bits);
	string getContainerSequence();
	
	
	bitset<SEQUENCE_LENGTH>  mutateSequence(bitset<SEQUENCE_LENGTH>  parent, float mutation);
	void print();
	void death(float death, float, float, float);
	void replicate(float replication, float mutation);
	
	

	
private:
	map<string, int> genotype;
	map<string, int> hamming;
	string containerSequence;
	int hammingDistance(bitset<SEQUENCE_LENGTH> seq1, bitset<SEQUENCE_LENGTH> seq2);
	int count;
	
	
	bitset<SEQUENCE_LENGTH> mutate(float prob);

};






#endif /* defined(__Simulation__container__) */
