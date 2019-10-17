using namespace std;

string decimalToBinary(int decimalValue);
string decimalToSignExtendedBinary(int decimalValue, int length);
string regToBinary(string reg);
string buildInstruction(string op, string reg1, string reg2);

class Instruction {
public:
  string instruction;

  Instruction(string op, string val1, string val2) {
      instruction = buildInstruction(op, val1, val2);
  }
  Instruction(string op, string val1) {
    instruction = buildInstruction(op, val1, "");
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
  int conversionValue = abs(decimalValue);

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

// builds an instruction string
string buildInstruction(string op, string val1, string val2) {
  string instruction = "";
  if(!op.compare("ADD")) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0101";
    instruction += regToBinary(val1);
  }
  else if(!op.compare("ADDI")) {
    instruction += "0101";
    instruction += regToBinary(val2);
    instruction += decimalToSignExtendedBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(!op.compare("ADDU")) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0110";
    instruction += regToBinary(val1);
  }
  else if(!op.compare("ADDC")) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0111";
    instruction += regToBinary(val1);
  }
  else if(!op.compare("MUL")) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "1110";
    instruction += regToBinary(val1);
  }
  else if(!op.compare("MULI")) {
    instruction += "1110";
    instruction += regToBinary(val2);
    instruction += decimalToSignExtendedBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(!op.compare("SUB")) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "1001";
    instruction += regToBinary(val1);
  }
  else if(!op.compare("SUBI")) {
    instruction += "1001";
    instruction += regToBinary(val2);
    instruction += decimalToSignExtendedBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(!op.compare("SUBC")) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "1010";
    instruction += regToBinary(val1);
  }
  else if(!op.compare("SUBCI")) {
    instruction += "1010";
    instruction += regToBinary(val2);
    instruction += decimalToSignExtendedBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(!op.compare("CMP")) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "1011";
    instruction += regToBinary(val1);
  }
  else if(!op.compare("CMPI")) {
    instruction += "1011";
    instruction += regToBinary(val2);
    instruction += decimalToSignExtendedBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(!op.compare("AND")) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0001";
    instruction += regToBinary(val1);
  }
  else if(!op.compare("ANDI")) {
    instruction += "0001";
    instruction += regToBinary(val2);
    instruction += decimalToBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(!op.compare("OR")) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0010";
    instruction += regToBinary(val1);
  }
  else if(!op.compare("ORI")) {
    instruction += "0010";
    instruction += regToBinary(val2);
    instruction += decimalToBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(!op.compare("XOR")) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0011";
    instruction += regToBinary(val1);
  }
  else if(!op.compare("XORI")) {
    instruction += "0011";
    instruction += regToBinary(val2);
    instruction += decimalToBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(!op.compare("LOAD")) {
    instruction += "0100";
    instruction += regToBinary(val1);
    instruction += "0000";
    instruction += regToBinary(val2);
  }
  else if(!op.compare("STOR")) {
    instruction += "0100";
    instruction += regToBinary(val1);
    instruction += "0100";
    instruction += regToBinary(val2);
  }

  // TODO all instructions past LSH

  cout << instruction << endl;
  return instruction;
}
