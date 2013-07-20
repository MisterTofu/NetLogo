//
//  container.cpp
//  Simulation
//
//  Created by Travis on 7/19/13.
//  Copyright (c) 2013 Travis. All rights reserved.
//
//	 bitset<10> third (string("01011"))

#include "container.h"


Container::Container(string seq)
{
	containerSequence = seq;
	srand ((unsigned)time(NULL));
	count = 0;
}

Container::Container()
{
	srand ((unsigned)time(NULL));
	count = 0;
}


void Container::addGenotype(string g)
{
	map<string, int>::iterator it;
	it = genotype.find(g);
	if (it != genotype.end()) //found element
		genotype[g] = genotype[g] + 1;
	else
	{
		genotype.insert(pair<string, int>(g, 1));
		hamming[g] = hammingDistance(toBits(containerSequence), toBits(g));
	}
	count++;
}


// Doesn't remove hamming distance, not exactly important unless memory is needed
void Container::removeGenotype(string g)
{
	map<string, int>::iterator it;
	it = genotype.find(g);
	if(it != genotype.end()) //we have the element
	{
		if (it->second == 1)
			genotype.erase(g); // only one element, erase entry
		else
			genotype[g] =  genotype[g] - 1; // decrement entry
	}
	count--;
}

vector<string> Container::getAllGenotypes()
{
	vector<string> result;
	if (getCount() > 0) {
		map<string, int>::iterator it;
		for (it = genotype.begin(); it != genotype.end(); ++it)
			result.push_back(it->first);
	}
	return result;
}

void Container::setContainerSequence(string seq)
{
	containerSequence = seq;
}

int	Container::getCount()
{
	return count;
}


int Container::getHammingDistance(string g)
{
	map<string, int>::iterator it;
	it = hamming.find(g);
	if(it != hamming.end()) //we have the element
		return it->second;
	return 0;
}


int Container::getCount(string g)
{
	map<string, int>::iterator it;
	it = genotype.find(g);
	if(it != genotype.end()) //we have the element
		return it->second;
	return 0;
}


string Container::getContainerSequence()
{
	return containerSequence;
}


bitset<SEQUENCE_LENGTH> Container::toBits(string bits)
{
	bitset<SEQUENCE_LENGTH> mybits (bits);
	return mybits;
}


void Container::print()
{
	int width = SEQUENCE_LENGTH * 2;
	cout << "======================================="
			<< endl << endl
			<< "Container: " << containerSequence
			<< setw(width)
			<< "Total: " << getCount() << endl
	
			<< setw(width+9) << "Sequence"
			<< setw(width) << "Integer"
			<< setw(width) << "Count" << endl;
	
	map<string, int>::iterator it;
	for (it=genotype.begin(); it!=genotype.end(); ++it)
	{
		cout << "Sequence: "
			<<setw(width) << it->first
			<< setw(width) << toBits(it->first).to_ullong()
			<< setw(width) << it->second << endl;
	}
	cout << endl;
}


/********************************


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








int	Container::getCount()
{
	int count = 0;
	map<string, int>::iterator it;
	for (it=genotype.begin(); it!=genotype.end(); ++it)
		count += it->second;
	return count;
}





*/
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