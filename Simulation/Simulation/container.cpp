//
//  container.cpp
//  Simulation
//
//  Created by Travis on 7/19/13.
//  Copyright (c) 2013 Travis. All rights reserved.
//

#include "container.h"


Container::Container(string seq)
{
	containerSequence = seq;
	srand ((unsigned)time(NULL));
	count = 0;
	totalcount = 0;
	drugContainer = false;
}

Container::Container()
{
	srand ((unsigned)time(NULL));
	count = 0;
	totalcount = 0;
	drugContainer = false;
}

// Shannon Entropy, Sum of probability * log probability
double Container::getEntropy()
{
	double result = 0.0;
	int total = getCount();
	if (total > 0)
	{
		double px;
		map<string, int>::iterator it;
		for (it = genotype.begin(); it != genotype.end(); ++it)
		{
			px = (double)it->second / (double)total;
			result += (px * (double)log2(px));
		}
	}
	return (result * -1);
}


bool Container::infected()
{
	return count > 0;
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
		hamming.insert(pair<string,int>(g, hammingDistance(toBits(containerSequence), toBits(g))));
	}
	count++;
}

string Container::infectedOutput()
{
	if (infected())
		return "Y";
	return "N";
}

bool Container::isDrugContainer()
{
	return drugContainer;
}

void Container::setDrugContainer(bool drug, string drugSequence)
{
	drugContainer = drug;
	DrugSequence = drugSequence;
}



int Container::getTotalCount()
{
	return totalcount;
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

bitset<SEQUENCE_LENGTH> Container::getContainerSequenceBits()
{
	return toBits(containerSequence);
}

string Container::getContainerSequence()
{
	return containerSequence;
}


bitset<SEQUENCE_LENGTH> Container::toBits(string bits)
{
	bitset<SEQUENCE_LENGTH> mybits ((string(bits)));
	return mybits;
}


void Container::print()
{
	int width = SEQUENCE_LENGTH * 2;
	cout
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
			<< setw(width) << toBits(it->first).to_ulong()
			<< setw(width) << it->second << endl;
	}
}


int Container::hammingDistance(bitset<SEQUENCE_LENGTH> seq1, bitset<SEQUENCE_LENGTH> seq2)
{
	assert(seq1.size() == seq2.size());
	return (seq1 ^ seq2).count();
}