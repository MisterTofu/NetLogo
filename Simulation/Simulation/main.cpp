//
//  main.cpp
//  Simulation
//
//  Created by Travis on 7/19/13.
//  Copyright (c) 2013 Travis. All rights reserved.
//

#include <stdio.h>
#include <iostream>
#include <time.h>
#include <stdlib.h>     /* srand, rand */
#include "container.h"
#include "Environment.h"
#include <ctime>
using namespace std;

double elapsed(clock_t begin)
{
	clock_t end = clock();
	return double(end - begin) / CLOCKS_PER_SEC;
}

int main(int argc, const char * argv[])
{

	clock_t begin = clock();
	
	Environment env = Environment(8);	
	for (int i = 0; i < 30; i++) {
		clock_t start = clock();
		env.start();
//		cout << "Generation: " << i <<"\t\tElapsed: " << setprecision(10) << elapsed(start) <<"\t\tTotal: " << elapsed(begin) << endl;
	}
	env.print();
//	bitset<10> t1,t2;
//	string x = t1.to_string();
//		t2.flip();
//	cout << env.hammingDistance(t1, t2) << endl;
//	bitset<10> t3 ((string(x)));
//	cout << env.hammingDistance(t3, t2) << endl;
	
	cout << "\n\nTotal Elapsed: " << elapsed(begin);

    return 0;
}


