//
//  container.cpp
//  Simulation
//
//  Created by Travis on 7/19/13.
//  Copyright (c) 2013 Travis. All rights reserved.
//
//	 bitset<10> third (string("01011"))

#include "container.h"


Container::Container(bitset<SEQUENCE_LENGTH>  g)
{
	containerSequence = g;
	genotype.insert( pair<string, int>(g.to_string(), 1));
}


void Container::addGenotype(bitset<SEQUENCE_LENGTH> g)
{
	map<string, int>::iterator it;
	it = genotype.find(g.to_string());
	if (it != genotype.end()) //found element
		genotype[g.to_string()] = genotype[g.to_string()] + 1;
	else
		genotype[g.to_string()] = 1;
	
}


// Assume sequence exists
void Container::removeGenotype(bitset<SEQUENCE_LENGTH> g)
{
	if(genotype[g.to_string()] == 1)
		genotype.erase(g.to_string()); // only one element, erase entry
	else
		genotype[g.to_string()] =  genotype[g.to_string()] - 1; // decrement entry
}


int	Container::getCount()
{
	int count = 0;
	map<string, int>::iterator it;
	for (it=genotype.begin(); it!=genotype.end(); ++it)
		count += it->second;
	return count;
}



void Container::print()
{
	cout << "Container: " << containerSequence <<"\t\tTotal: " << getCount() << endl << "\t\tSequence\t\tInteger\t\tCount\n";
	map<string, int>::iterator it;
	for (it=genotype.begin(); it!=genotype.end(); ++it)
	{
		cout << "Sequence: " << it->first << setw(SEQUENCE_LENGTH) << bitset<SEQUENCE_LENGTH> (string(it->first)).to_ullong() << setw(SEQUENCE_LENGTH) << it->second << endl;
	}
}


int Container::hammingDistance(bitset<SEQUENCE_LENGTH> seq1, bitset<SEQUENCE_LENGTH> seq2)
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