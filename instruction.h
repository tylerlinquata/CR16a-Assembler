using namespace std;

string decimalToBinary(int decimalValue);

class Instruction {
public:
  string instruction;
  string opBinary;
  string opString;
  int reg1;
  int reg2;
  int imm;

  void setOpcode(string op) {
    opString = op;
    if(op.compare("ADD")) {
      opBinary = "0000";
    }
    else {
      opBinary = "1111";
    }
  }
};

string decimalToBinary(int decimalValue) {
  string binary = "";

  while(decimalValue > 0) {
    binary += decimalValue % 2;
    decimalValue = decimalValue / 2;
  }

  return binary;
}
