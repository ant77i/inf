#include <iostream>
#include <sstream>
#include <stack>
#include <vector>
#include <string>
#include <stdexcept>
#include <cmath>
#include <memory>

using namespace std;

class Token {
public:
    virtual string toString() const = 0;
    virtual ~Token() = default;
};

class NumberToken : public Token {
private:
    double value;
public:
    explicit NumberToken(double val) : value(val) {}
    double getValue() const { return value; }

    string toString() const override {
        return to_string(value);
    }
};

class OperatorToken : public Token {
private:
    char op;
public:
    explicit OperatorToken(char oper) : op(oper) {}

    double apply(double a, double b) const {
        switch (op) {
            case '+': return a + b;
            case '-': return a - b;
            case '*': return a * b;
            case '/':
                if (b == 0.0)
                    throw runtime_error("Dzielenie przez zero");
                return a / b;
            case '^': return pow(a, b);
            default:
                throw runtime_error(string("Nieznany operator: ") + op);
        }
    }

    char getOperator() const { return op; }

    string toString() const override {
        return string(1, op);
    }
};

class Tokenizer {
public:
    vector<unique_ptr<Token>> tokenize(const string& input) {
        vector<unique_ptr<Token>> tokens;
        istringstream iss(input);
        string part;

        while (iss >> part) {
            if (isdigit(part[0]) || (part[0] == '-' && part.size() > 1)) {
                tokens.push_back(make_unique<NumberToken>(stod(part)));
            } else if (part.size() == 1 && string("+-*/^").find(part[0]) != string::npos) {
                tokens.push_back(make_unique<OperatorToken>(part[0]));
            } else {
                throw runtime_error("Nieprawidłowy token: " + part);
            }
        }

        return tokens;
    }
};

class ONPEvaluator {
public:
    double evaluate(const vector<unique_ptr<Token>>& tokens) {
        stack<double> stack;

        for (const auto& token : tokens) {
            if (auto number = dynamic_cast<NumberToken*>(token.get())) {
                stack.push(number->getValue());
            } else if (auto op = dynamic_cast<OperatorToken*>(token.get())) {
                if (stack.size() < 2)
                    throw runtime_error("Za mało operandów dla operatora: " + op->toString());

                double b = stack.top(); stack.pop();
                double a = stack.top(); stack.pop();

                double result = op->apply(a, b);
                stack.push(result);
            } else {
                throw runtime_error("Nieznany typ tokena");
            }
        }

        if (stack.size() != 1)
            throw runtime_error("Niepoprawne wyrażenie ONP");

        return stack.top();
    }
};

class ONPApplication {
public:
    void run() {
        try {
            cout << "Podaj wyrażenie ONP: ";
            string input;
            getline(cin, input);

            Tokenizer tokenizer;
            auto tokens = tokenizer.tokenize(input);

            ONPEvaluator evaluator;
            double result = evaluator.evaluate(tokens);

            cout << "Wynik: " << result << endl;
        } catch (const exception& ex) {
            cerr << "Błąd: " << ex.what() << endl;
        }
    }
};

int main() {
    ONPApplication app;
    app.run();
    return 0;
}
