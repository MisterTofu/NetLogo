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

using namespace std;

const int SEQUENCE_LENGTH = 10;



class Container {
	
public:
	Container(bitset<SEQUENCE_LENGTH>  genotype);
	Container();
	
	int getCount();
	int getCount(bitset<SEQUENCE_LENGTH> g);
	void addGenotype(bitset<SEQUENCE_LENGTH>  g);
	void removeGenotype(bitset<SEQUENCE_LENGTH>  g);
	bitset<SEQUENCE_LENGTH>  mutateSequence(bitset<SEQUENCE_LENGTH>  parent, float mutation);
	void print();
	void death(float death, float, float, float);
	void replicate(float replication, float mutation);
	void setSequence(bitset<SEQUENCE_LENGTH> g);
	bitset<SEQUENCE_LENGTH> getSequence();
	map<string, int> genotype;
	map<string, int> hamming;
	
private:
	bitset<SEQUENCE_LENGTH> containerSequence;
	bitset<SEQUENCE_LENGTH> mutate(float prob);
	int hammingDistance(bitset<SEQUENCE_LENGTH> seq1, bitset<SEQUENCE_LENGTH> seq2);

};






#endif /* defined(__Simulation__container__) */
