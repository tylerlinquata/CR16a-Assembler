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
  if(op.compare("ADD") == 0) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0101";
    instruction += regToBinary(val1);
  }
  else if(op.compare("ADDI") == 0) {
    instruction += "0101";
    instruction += regToBinary(val2);
    instruction += decimalToSignExtendedBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(op.compare("ADDU") == 0) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0110";
    instruction += regToBinary(val1);
  }
  else if(op.compare("ADDC") == 0) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0111";
    instruction += regToBinary(val1);
  }
  else if(op.compare("MUL") == 0) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "1110";
    instruction += regToBinary(val1);
  }
  else if(op.compare("MULI") == 0) {
    instruction += "1110";
    instruction += regToBinary(val2);
    instruction += decimalToSignExtendedBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(op.compare("SUB") == 0) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "1001";
    instruction += regToBinary(val1);
  }
  else if(op.compare("SUBI") == 0) {
    instruction += "1001";
    instruction += regToBinary(val2);
    instruction += decimalToSignExtendedBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(op.compare("SUBC") == 0) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "1010";
    instruction += regToBinary(val1);
  }
  else if(op.compare("SUBCI") == 0) {
    instruction += "1010";
    instruction += regToBinary(val2);
    instruction += decimalToSignExtendedBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(op.compare("CMP") == 0) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "1011";
    instruction += regToBinary(val1);
  }
  else if(op.compare("CMPI") == 0) {
    instruction += "1011";
    instruction += regToBinary(val2);
    instruction += decimalToSignExtendedBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(op.compare("AND") == 0) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0001";
    instruction += regToBinary(val1);
  }
  else if(op.compare("ANDI") == 0) {
    instruction += "0001";
    instruction += regToBinary(val2);
    instruction += decimalToBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(op.compare("OR") == 0) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0010";
    instruction += regToBinary(val1);
  }
  else if(op.compare("ORI") == 0) {
    instruction += "0010";
    instruction += regToBinary(val2);
    instruction += decimalToBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  else if(op.compare("XOR") == 0) {
    instruction += "0000";
    instruction += regToBinary(val2);
    instruction += "0011";
    instruction += regToBinary(val1);
  }
  else if(op.compare("XORI") == 0) {
    instruction += "0011";
    instruction += regToBinary(val2);
    instruction += decimalToBinary(stoi(val1.substr(1, val1.size())), 8);
  }
  // TODO all instructions past LSH

  cout << instruction << endl;
  return instruction;
}
