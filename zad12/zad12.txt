#include <iostream>
#include <vector>
#include <stack>
#include <queue>
#include <sstream>
#include <map>
#include <cmath>

using namespace std;

/*

        Zad 1.

*/

enum class TokenType { NUMBER, OPERATOR, LEFT_PAREN, RIGHT_PAREN };

struct Token {
    TokenType type;
    string value;
};

class InfixToPostfixConverter {
public:
    vector<Token> convert(const vector<Token>& tokens) {
        vector<Token> output;
        stack<Token> operators;

        map<string, int> precedence = {{"+", 1}, {"-", 1}, {"*", 2}, {"/", 2}, {"^", 3}};
        map<string, bool> rightAssociative = {{"^", true}};

        for (const auto& token : tokens) {
            if (token.type == TokenType::NUMBER) {
                output.push_back(token);
            } else if (token.type == TokenType::OPERATOR) {
                while (!operators.empty() && operators.top().type == TokenType::OPERATOR) {
                    auto topOp = operators.top();
                    if ((rightAssociative[token.value] && precedence[token.value] < precedence[topOp.value]) ||
                        (!rightAssociative[token.value] && precedence[token.value] <= precedence[topOp.value])) {
                        output.push_back(topOp);
                        operators.pop();
                    } else {
                        break;
                    }
                }
                operators.push(token);
            } else if (token.type == TokenType::LEFT_PAREN) {
                operators.push(token);
            } else if (token.type == TokenType::RIGHT_PAREN) {
                while (!operators.empty() && operators.top().type != TokenType::LEFT_PAREN) {
                    output.push_back(operators.top());
                    operators.pop();
                }
                if (!operators.empty() && operators.top().type == TokenType::LEFT_PAREN) {
                    operators.pop();
                }
            }
        }
        while (!operators.empty()) {
            output.push_back(operators.top());
            operators.pop();
        }
        return output;
    }
};

/*

        Zad 2.

*/

class ExpressionConverterApp {
public:
    
    vector<Token> tokenize(const string& expr) {
        vector<Token> tokens;
        istringstream iss(expr);
        string item;
        while (iss >> item) {
            if (isdigit(item[0])) {
                tokens.push_back({TokenType::NUMBER, item});
            } else if (item == "(" ) {
                tokens.push_back({TokenType::LEFT_PAREN, item});
            } else if (item == ")") {
                tokens.push_back({TokenType::RIGHT_PAREN, item});
            } else {
                tokens.push_back({TokenType::OPERATOR, item});
            }
        }
        return tokens;
    }
};

/*

        Zad. 3

*/

class ONPElement {
public:
    virtual ~ONPElement() = default;
    virtual string toString() const = 0;
};

class NumberElement : public ONPElement {
    double value;
public:
    NumberElement(double val) : value(val) {}
    string toString() const override { return to_string(value); }
};

class OperatorElement : public ONPElement {
    char op;
public:
    OperatorElement(char oper) : op(oper) {}
    string toString() const override { return string(1, op); }
};

/*

        Zad. 4

*/

class ONPEvaluator {
public:
    double evaluate(const vector<Token>& postfix) {
        stack<double> stack;
        for (const auto& token : postfix) {
            if (token.type == TokenType::NUMBER) {
                stack.push(stod(token.value));
            } else if (token.type == TokenType::OPERATOR) {
                double b = stack.top(); stack.pop();
                double a = stack.top(); stack.pop();
                if (token.value == "+") stack.push(a + b);
                else if (token.value == "-") stack.push(a - b);
                else if (token.value == "*") stack.push(a * b);
                else if (token.value == "/") {
                    if (b == 0) throw runtime_error("Division by zero");
                    stack.push(a / b);
                }
                else if (token.value == "^") stack.push(pow(a, b));
            }
        }
        return stack.top();
    }
};

class ONPApplication {
public:
    void run() {
        string expression;

        cout << "Wpisz wyrażenie: ";
        getline(cin, expression);
        vector<Token> tokens = ExpressionConverterApp().tokenize(expression);
        InfixToPostfixConverter converter;
        vector<Token> postfix = converter.convert(tokens);
        ONPEvaluator evaluator;
        try {
            double result = evaluator.evaluate(postfix);
            for (const auto& token : postfix) {
                cout << token.value << " ";
            }
            cout << "\nRówna się: " << result << endl;
        } catch (const exception& e) {
            cerr << "Błąd: " << e.what() << endl;
        }
    }
};

int main() {
    ONPApplication app;
    app.run();
    return 0;
}