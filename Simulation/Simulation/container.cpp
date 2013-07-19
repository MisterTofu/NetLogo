//
//  container.cpp
//  Simulation
//
//  Created by Travis on 7/19/13.
//  Copyright (c) 2013 Travis. All rights reserved.
//

#include "container.h"


Container::Container(bitset<SEQUENCE_LENGTH> g)
{
	containerSequence = g;
}

int	Container::getCount()
{
	int count = 0;
	map<Sequence, int>::iterator it;
	for (it=genotype.begin(); it!=genotype.end(); ++it)
		//std::cout << it->first << " => " << it->second << '\n';
		count += it->second;
	return count;
}

void Container::addGenotype(Sequence g)
{
	pair<map<Sequence,int>::iterator,bool> ret;
	ret = genotype.insert(pair<Sequence, int>(g, 1));
	if (ret.second == false) {
		// element already exists, increment by 1
		genotype[g] = genotype[g] + 1;
	}
}


// Assume sequence exists
void Container::removeGenotype(Sequence g)
{
	if(genotype[g] == 1)
		genotype.erase(g); // only one element, erase entry
	else
		genotype[g] = genotype[g] - 1; // decrement entry
}

//Sequence Container::mutateSequence(Sequence parent)
//{
//	
//}


int Container::hammingDistance(Sequence seq1, Sequence seq2)
{
	int distance = 0;
	assert(seq1.size() != seq2.size());
	for (int i = 0; i < seq1.size(); i++) {
		if ((seq1[i] ^ seq2[i]) == 1) { //different
			distance++;
		}
	}
	return distance;
}