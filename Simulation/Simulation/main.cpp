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

using namespace std;


int main(int argc, const char * argv[])
{

	bitset<10> t,t2;
	/* initialize random seed: */
//	srand (time(NULL));
//	
//	/* generate secret number between 1 and 10: */
//	int random = rand() % 10;
//	for (int x = 0; x < random; x++)
//	{
//		t.flip(rand() % 10);
//		t2.flip(rand() % 10);
//	}
//	
//	cout << "t1: " << t << "\nt2: " << t2 << "   " << (t ^ t2) << "\n   " << (t & t2) << "\n   " << (t | t2);
	
//	Container c1 = Container(t);
//	c1.addGenotype(t.flip());
//	c1.print();
//	
//	c1.removeGenotype(t);
//	c1.print();

	
	Environment env = Environment(8);
	env.start();
	env.print();

	
    return 0;
}

