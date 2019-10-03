using namespace std;

string decimalToBinary(int decimalValue);
string decimalToSignExtendedBinary(int decimalValue, int length);
string regToBinary(string reg);
string buildInstruction(string op, string reg1, string reg2);

class Instruction {
public:
  string instruction;

  Instruction(string op, string reg1, string reg2) {
      buildInstruction(op, reg1, reg2);
  }
};

// converts decimal numbers to binary numbers of a specified length
string decimalToBinary(int decimalValue, int length) {
  string binary = "";
  int conversionValue = decimalValue;

  // TODO check if int is too big

  while(conversionValue > 0) {
    binary += to_string(conversionValue % 2);
    conversionValue = conversionValue / 2;
  }

  // add leading zeroes to the binary number until it reaches desired length
  while(binary.size() < length) {
    binary += "0";
  }

  // the while loop outputs the binary in the wrong direction
  reverse(binary.begin(), binary.end());

  return binary;
}

// converts decimal numbers to sign extended binary numbers of a specfied length
string decimalToSignExtendedBinary(int decimalValue, int length) {
  string binary = "";
  int conversionValue = decimalValue;

  // TODO check if int is too big

  while(conversionValue > 0) {
    binary += to_string(conversionValue % 2);
    conversionValue = conversionValue / 2;
  }

  // sign extend the binary number until it reaches desired length
  while(binary.size() < length) {
    if(decimalValue < 0) {
          binary += "1";
    }
    else {
      binary += "0";
    }
  }

  // the while loop outputs the binary in the wrong direction
  reverse(binary.begin(), binary.end());

  return binary;
}

// converts a register to it's binary representation
string regToBinary(string reg) {
  int regVal = stoi(reg.substr(1, reg.size()));
  return decimalToBinary(regVal, 4);
}

//
string buildInstruction(string op, string reg1, string reg2) {
  string instruction = "";
  if(op.compare("ADD") == 0) {
    instruction += "0000";
    instruction += regToBinary(reg1);

    // check if the instruction is I type
    if(reg2[0] == 'R') {
      instruction += "0101";
      instruction += regToBinary(reg2);
    }
    else if(reg2[0] == '$') {
      instruction += decimalToSignExtendedBinary(stoi(reg1.substr(1, reg1.size())), 8);
    }

    cout << instruction << endl;
  }
  return instruction;
}
