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
#include <map>
using namespace std;

const int SEQUENCE_LENGTH = 10;
typedef bitset<SEQUENCE_LENGTH> Sequence;

class Container {
	
public:
	Container(bitset<SEQUENCE_LENGTH> genotype);
	int getCount();
	void addGenotype(Sequence g);
	void removeGenotype(Sequence g);
	Sequence mutateSequence(Sequence parent);
	
private:
	Sequence containerSequence;
	int hammingDistance(Sequence seq1, Sequence seq2);
	Sequence shuffleSequence(Sequence seq, int bits);
	map<Sequence, int> genotype;
};






#endif /* defined(__Simulation__container__) */
