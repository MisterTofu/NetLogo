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

//typedef bitset<SEQUENCE_LENGTH> Sequence;

class Container {
	
public:
	Container(bitset<SEQUENCE_LENGTH>  genotype);
	int getCount();
	void addGenotype(bitset<SEQUENCE_LENGTH>  g);
	void removeGenotype(bitset<SEQUENCE_LENGTH>  g);
	bitset<SEQUENCE_LENGTH>  mutateSequence(bitset<SEQUENCE_LENGTH>  parent);
	void print();
private:
	bitset<SEQUENCE_LENGTH> containerSequence;
	int hammingDistance(bitset<SEQUENCE_LENGTH> seq1, bitset<SEQUENCE_LENGTH> seq2);
	map<string, int> genotype;
};






#endif /* defined(__Simulation__container__) */
