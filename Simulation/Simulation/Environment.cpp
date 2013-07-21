//
//  Environment.cpp
//  Simulation
//
//  Created by Travis on 7/19/13.
//  Copyright (c) 2013 Travis. All rights reserved.
//


/*
 
	NOTE: Target and start containers are hardwired
 
 */

#include "Environment.h"

// Create x by x containers
Environment::Environment(int size)
{
	
//	deathRate = 0.10;
//	replicationRate = 0.50;
//	movementRate = 0.50;
//	mutationRate = 0.10;
//	fitness = 0.10;				// Increase death rate by up to 10%
//	drugStrength = 0.10;		// Drug containers increase, deathRate by drugStrength%  and Decrease for replication rate
//	
//	ofstream output;

	cSize = size;
	gridCount = size * size;
	generateAdjacentContainers();
	grid.assign(gridCount, Container());
	srand ((unsigned)time(NULL));
	drugContainersCount = 0;
	// drug sequence
	bitset<DRUG_LENGTH> drug;
	int randomNum = rand() % DRUG_LENGTH;
	for (int i = 0; i < randomNum; i++)
		drug.flip(rand() % DRUG_LENGTH);
	generation = 0;

	for (int x = 0; x < gridCount; x++)
	{
		grid[x].setContainerSequence(randomBits_s());
		vector<string> temp = partitonBits(grid[x].getContainerSequence());
		for (int i = 0; i < temp.size(); i++) {
			if ((drug ^
				 bitset<DRUG_LENGTH> (string(temp[i]))).none()) {
				grid[x].setDrugContainer(true);
				drugContainersCount++;
				drugContainersList += to_string(x) + " ";
				break;
			}
		}
	}
	
	// initialize first virus
	grid[0].addGenotype(randomBits_s());
	totalPopulation = 1;
	currentPopulation = 1;
}

Environment::~Environment()
{
	if (append)
		output << endl << endl << endl << endl;
	output.close();
}

void Environment::setOutputFile(string fileName, bool appendFile)
{
	append = appendFile;
	if (appendFile)
		output.open(fileName, ios_base::app);
	else
		output.open(fileName);
	
	output << "Death Rate,Replication Rate,Movement,Mutation,Fitness,Drug Strength,Drug Bit Length,Drug Containers,Drug Container Numbers,Virus Sequence Length" << endl
	<< setprecision(10)
	<< deathRate <<"," << replicationRate <<"," << movementRate <<"," << mutationRate <<"," << fitness <<"," << drugStrength <<"," << DRUG_LENGTH <<"," << drugContainersCount <<"," << drugContainersList <<"," <<SEQUENCE_LENGTH << endl << endl;
	
	string cont;
	for (int i = 0; i < gridCount; i++)
		cont += ",,Container: " + to_string(i) + ",Virus Counts,Entropy,Drug Container";
	
	output << "Generation,Virus Counts,Total Virus Counts,Dead,Death%,Entropy,InfectedContainers" << cont;
}

void Environment::writeToFile()
{
	int infected = 0;
	for (int i = 0; i < gridCount; i++) {
		if (grid[i].infected())
			infected++;
	}
	
	string cont;
	for (int i = 0; i < gridCount; i++)
		cont += ",," + to_string(i) + "," + to_string(grid[i].getCount()) + "," + to_string(grid[i].getEntropy()) + "," + grid[i].infectedOutput();
//		Virus Counts,Dead,Entropy,Drug Container";
	
	float dead = (float(totalPopulation - currentPopulation));
	double death = double(dead / totalPopulation) * 100.0;
	output << generation << ","
			<< currentPopulation << ","
			<< totalPopulation << ","
			<< dead << ","
			<< death << ","
			<< getEntropy() << ","
			<< infected
			<< cont
			<< endl;
//	output << "Writing this to a file.\n";
}


double Environment::getEntropy()
{
	map<string,int> total = getTotalGenotypeCounts();
	double result = 0.0;
	map<string, int>::iterator it;
	for (it = total.begin(); it != total.end(); ++it) {
		double px = (double)it->second / (double)currentPopulation;
		result += (px * (double)log2(px));
	}
	return (result * -1);
}


map<string, int> Environment::getTotalGenotypeCounts()
{
	map<string, int> genotype;
	map<string, int>::iterator it;
	for (int i = 0; i < gridCount; i++) { // go thru each container
		if (grid[i].getCount() > 0) {
			// get all the genotypes and interate through them
			vector<string> temp = grid[i].getAllGenotypes();
			for(int j = 0; j < temp.size(); j++)
			{
				// check if element exists
				it = genotype.find(temp[j]);
				if (it != genotype.end()) //already have elemtn, update
					genotype[temp[j]] = genotype[temp[j]] + 				grid[i].getCount(temp[j]);
				else // new element, insert it
					genotype.insert(pair<string, int>(temp[j],grid[i].getCount(temp[j])));
			}
		}
	}
	return genotype;
}


double Environment::elapsed(clock_t begin)
{
	clock_t end = clock();
	return double(end - begin) / CLOCKS_PER_SEC;
}


void Environment::run()
{
	//check count, check if target container infected
	while (currentPopulation > 0 and !grid[63].infected()) {
		start();
		clock_t begin = clock();
		int sum = 0;
		for(int i =0; i < gridCount; i++)
			sum += grid[i].infected();

		writeToFile();
		generation++;
		cout << "Generation: " << generation << "\t\tInfected: " << sum <<"\t\tTime: " << elapsed(begin) << endl;
	}
	
}


void Environment::setDeathRate(float r)
{
	assert(r <= 1);
	deathRate = r;
}


void Environment::setReplicationRate(float r)
{
	assert(r <= 1);
	replicationRate = r;
}

void Environment::setMutationRate(float r)
{
	assert(r <= 1);
	mutationRate = r;
}

void Environment::setMovementRate(float r)
{
	assert(r <= 1);
	movementRate = r;
}


void Environment::setFitness(float r)
{
	assert(r <= 1);
	fitness = r;
}

void Environment::setDrugStrength(float r)
{
	assert(r <= 1);
	drugStrength = r;
}

vector<string> Environment::partitonBits(string seq)
{
	vector<string> result;
	for (int i = 0; i < (SEQUENCE_LENGTH - DRUG_LENGTH + 1); i++)
	{
		result.push_back(seq.substr(i, DRUG_LENGTH));
	}
	return result;
}

void Environment::start()
{

	// implement adding, drug probability
	// Also optimization is needed 
	vector<string> genotypes;
	vector<Virus> moving;
	float dr = 0.0, rr = 0.0, fit = 0.0, drugD, drugR;

	for (int i = 0; i < gridCount; i++) {
		
		if (grid[i].getCount() > 0) {
			//iterate over each genotype
			genotypes = grid[i].getAllGenotypes();
			

	 // Determining whether to add drug effect

			if (grid[i].isDrugContainer()) {
				drugD = deathRate * drugStrength;
				drugR = replicationRate * drugStrength;
			}
			else{
				drugD = 0.0;
				drugR = 0.0;
			}

	
			
			for(int j = 0; j < genotypes.size(); j++)
			{
	 // Calculating fitness and drugs
				int hd = grid[i].getHammingDistance(genotypes[j]);
				fit = (float)hd / (float)SEQUENCE_LENGTH * fitness;
				dr = (deathRate * fit) + drugD;
				rr = (replicationRate * fit) + drugR;
				
				//	Get a binomial distribution to estimate, dead instead of individual probabilities
				
				int d = binomial(grid[i].getCount(genotypes[j]), (deathRate + dr));
				for(int x = 0; x < d; x++)
				{
					
					grid[i].removeGenotype(genotypes[j]);
					currentPopulation--;
				}
				
				
	 // binomial for replication
				int m = grid[i].getCount(genotypes[j]);
				int r = binomial(grid[i].getCount(genotypes[j]), (replicationRate - rr));
				m -= r;
				
				for(int x = 0; x < r; x++)
				{
					grid[i].addGenotype(mutate(genotypes[j]));
					totalPopulation++;
					currentPopulation++;
				}
			
			 // remaining binomal distrubiton for movement 
				m = binomial(m, (movementRate));
				for(int x = 0; x < m; x++)
				{
					grid[i].removeGenotype(genotypes[j]);
					Virus virus;

					virus.container = adjacentContainers[i][rand() % unsigned(adjacentContainers[i].size())];
					virus.genotype = genotypes[j];
					moving.push_back(virus);
				}
					
			}
		}
		genotypes.clear();
	}
	
	// Maps are mutable
	for (int i = 0; i < moving.size(); i++)
		grid[moving[i].container].addGenotype(moving[i].genotype);
}

string Environment::mutate(string seq)
{
	bitset<SEQUENCE_LENGTH> bits (seq);
	for (int x = 0; x < bits.size(); x++) {
		if ((rand() % 101) < mutationRate) {
			bits[x] = (rand() % 2);
		}
	}
	return bits.to_string();
}

string Environment::randomBits_s()
{
	return randomBits().to_string();
}



bitset<SEQUENCE_LENGTH> Environment::randomBits()
{
	bitset<SEQUENCE_LENGTH> t;
	int randomNum = rand() % SEQUENCE_LENGTH;
	for (int i = 0; i < randomNum; i++)
		t.flip(rand() % SEQUENCE_LENGTH);
	return t;
}


void Environment::generateAdjacentContainers()
{
	int edge;
	float row;
	vector<int> temp;
	vector<int> tempConstraints;
	for(int x = 0; x < gridCount; x++)
	{
		edge = x % cSize;
		row = floor(float(x / cSize));
		//Check left
		if (edge != 0 and x > 0)
			temp.push_back(x - 1);
		
		//check right
		if(edge != (cSize - 1) and x < gridCount)
			temp.push_back(x + 1);
		
		//up
		if (row != 0)
			temp.push_back(x - cSize);
		
		//down
		if (row != (cSize - 1))
			temp.push_back(x + cSize);
		
		for(int i = 0; i < temp.size(); i++)
		{
			if (temp[i] < x) {
				tempConstraints.push_back(temp[i]);
			}
		}
		adjacentContainers.push_back(temp);
		constraints.push_back(tempConstraints);
		temp.erase(temp.begin(), temp.end());
		tempConstraints.erase(tempConstraints.begin(), tempConstraints.end());
	}
}



void Environment::print()
{
	bool adjacent = false;
	bool constr = false;
	bool contSeq = 1;
	if (adjacent){
		for( int x = 0; x < adjacentContainers.size(); x++)
		{
			cout << "Container: " << x  << "\n\t\t";
			for(int y = 0; y < adjacentContainers[x].size(); y++)
				cout << adjacentContainers[x][y] << "   ";
			cout << endl;
		}
	}
	
	if(constr){	
		for( int x = 0; x < constraints.size(); x++)
		{
			cout << "Container: " << x  << "\n\t\t";
			for(int y = 0; y < constraints[x].size(); y++)
				cout << constraints[x][y] << "   ";
			cout << endl;
		}
	}
	
	if (contSeq) {
		int infected = 0;
		for (int i = 0; i < gridCount; i++) {
			if (grid[i].getCount() > 0) {
				cout << "=========================" << endl
					<< "Container: " << i << endl << endl;
				grid[i].print();
				infected++;
			}

		}
		float dead = (float(totalPopulation - currentPopulation));
		double death = double(dead / totalPopulation) * 100.0;
		cout << "\n\n====================" << endl;
		cout << "Current Population: " << currentPopulation
		<< " / " << totalPopulation  << endl
		<< "Dead: " << dead << endl
		<< "Death Rate: " << setprecision(8) << death << endl
		<< "Infected Containers: " << infected;
		cout << "\nDrug Containers: " << drugContainersCount << endl;
	}
}

int Environment::binomial(int trials, float probability)
{
	std::random_device rd;
    std::mt19937 gen(rd());
    std::binomial_distribution<> d(trials, probability);
	return d(gen);
}

int Environment::hammingDistance(bitset<SEQUENCE_LENGTH> seq1, bitset<SEQUENCE_LENGTH> seq2)
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
