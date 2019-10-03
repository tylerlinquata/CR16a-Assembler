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
      opBinary = decimalToBinary(4);
    }
    else {
      opBinary = decimalToBinary(4);
    }
  }
};

string decimalToBinary(int decimalValue) {
  string binary = "";
  int conversionValue = decimalValue;

  while(conversionValue > 0) {
    binary += to_string(conversionValue % 2);
    conversionValue = conversionValue / 2;
  }

  // the while loop outputs the binary in the wrong direction
  reverse(binary.begin(), binary.end());

  return binary;
}
