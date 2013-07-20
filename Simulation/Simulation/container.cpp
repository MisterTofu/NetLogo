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
//	genotype.insert( pair<string, int>(g.to_string(), 1));
	srand ((unsigned)time(NULL));
}

Container::Container()
{
	
}




void Container::replicate(float replication, float mutation)
{
	map<string, int>::iterator it;
	for (it=genotype.begin(); it!=genotype.end(); ++it)
	{
		if ((rand() % 100 + 1) < replication)
		{
			addGenotype(mutateSequence(bitset<SEQUENCE_LENGTH>(string(it->first)), mutation));
		}
	}
}

int Container::getCount(bitset<SEQUENCE_LENGTH> g)
{
	map<string, int>::iterator it;
	it = genotype.find(g.to_string());
	if (it != genotype.end()) //found element
		return genotype[g.to_string()];
	else
		return -1;
}



bitset<SEQUENCE_LENGTH> Container::mutateSequence(bitset<SEQUENCE_LENGTH> parent, float mutation)
{
	for (int i = 0; i < parent.size(); i++)
	{
		if((rand() % 100 + 1) < mutation) {
			parent[i] = rand() % 2;
		}
	}
	return parent;
}


void Container::setSequence(bitset<SEQUENCE_LENGTH> g)
{
	containerSequence = g;
}

void Container::addGenotype(bitset<SEQUENCE_LENGTH> g)
{
	map<string, int>::iterator it;
	it = genotype.find(g.to_string());
	if (it != genotype.end()) //found element
		genotype[g.to_string()] = genotype[g.to_string()] + 1;
	else
	{
		genotype[g.to_string()] = 1;
		hamming[g.to_string()] = hammingDistance(containerSequence, g);
	}
	
}


// Assume sequence exists
void Container::removeGenotype(bitset<SEQUENCE_LENGTH> g)
{
	map<string, int>::iterator it;
	it = genotype.find(g.to_string());
	if(it != genotype.end()) //we have the element
	{
		
		if (it->second == 1) {
			genotype.erase(g.to_string()); // only one element, erase entry
			hamming.erase(g.to_string());
		}
		else
			genotype[g.to_string()] =  genotype[g.to_string()] - 1; // decrement entry
	}
	
}


int	Container::getCount()
{
	int count = 0;
	map<string, int>::iterator it;
	for (it=genotype.begin(); it!=genotype.end(); ++it)
		count += it->second;
	return count;
}

bitset<SEQUENCE_LENGTH> Container::getSequence()
{
	return containerSequence;
}

void Container::print()
{
	
	int width = SEQUENCE_LENGTH * 1.5 + 2;
	cout <<"=======================================\n\nContainer: " << containerSequence
	<< setw(width) << "Total: " << getCount() << endl;
	
	cout << setw(width+9) << "Sequence" << setw(width) << "Integer" << setw(width)<< "Hamming" <<setw(width)<<"Count\n";
	map<string, int>::iterator it;
	for (it=genotype.begin(); it!=genotype.end(); ++it)
	{
		cout << "Sequence: " <<setw(width) << it->first
		<< setw(width) << bitset<SEQUENCE_LENGTH> (string(it->first)).to_ullong()
		<< setw(width) << hamming[string(it->first)] << setw(width) << it->second << endl;
	}
	cout << endl;
}


int Container::hammingDistance(bitset<SEQUENCE_LENGTH> seq1, bitset<SEQUENCE_LENGTH> seq2)
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