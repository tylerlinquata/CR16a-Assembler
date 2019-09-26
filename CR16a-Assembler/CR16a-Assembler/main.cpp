//
//  main.cpp
//  CR16a-Assembler
//
//  Created by Tyler Linquata on 9/26/19.
//  Copyright © 2019 Tyler Linquata. All rights reserved.
//

#include <iostream>
#include <boost/tokenizer.hpp>
#include <string>

using namespace std;
using namespace boost;


int main(int argc, const char * argv[]) {
    string instruction;
    
    string s = "This is,  a test";

    while(instruction.compare("exit") != 0) {
        cout << "Enter a CR16 instruction: ";
        getline(cin, instruction);
        tokenizer<> tok(instruction);
        for(tokenizer<>::iterator beg=tok.begin(); beg!=tok.end(); ++beg){
            cout << *beg << "\n";
        }
        
    }

    
//     TODO recieve instructions from commandline (for now)
//     TODO recieve instructions from .asm file
//     TODO tokenize
//     TODO convert to binary
    
    
    
    
    
    
    return 0;
}
