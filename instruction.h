using namespace std;

string decimalToBinary(int decimalValue);
string regToBinary(string reg);

class Instruction {
public:
  string instruction;
  string opBinary;
  string opString;
  int Rdest;
  int Rsrc;
  int imm;

  Instruction(string op, string reg1, string reg2) {
    if(op.compare("ADD")) {
      instruction += "0000";
      instruction += regToBinary(reg1);
      cout << instruction << endl;
    }
  }
};

string decimalToBinary(int decimalValue, int length) {
  string binary = "";
  int conversionValue = decimalValue;

  while(conversionValue > 0) {
    binary += to_string(conversionValue % 2);
    conversionValue = conversionValue / 2;
  }

  // add leading zeroes to the binary number until it reaches desired length
  while(binary.size() < 4) {
    binary += "0";
  }

  // the while loop outputs the binary in the wrong direction
  reverse(binary.begin(), binary.end());

  return binary;
}

string regToBinary(string reg) {
  int regVal = stoi(reg.substr(1, reg.size()));
  return decimalToBinary(regVal, 4);
}
