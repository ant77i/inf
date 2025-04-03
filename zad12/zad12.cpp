#include <iostream>
#include <vector>
#include <stack>
#include <queue>
#include <map>
#include <cctype>
#include <memory>
#include <stdexcept>
#include <cmath>

struct Token {
    enum Type { NUMBER, OPERATOR, PARENTHESIS } type;
    std::string value;
};

class InfixToPostfixConverter {
public:
    std::vector<Token> convert(const std::vector<Token>& tokens) {
        std::vector<Token> output;
        std::stack<Token> operators;
        std::map<std::string, int> precedence = {{"+", 1}, {"-", 1}, {"*", 2}, {"/", 2}, {"^", 3}};
        std::map<std::string, bool> rightAssociative = {{"^", true}};

        for (const Token& token : tokens) {
            if (token.type == Token::NUMBER) {
                output.push_back(token);
            } else if (token.type == Token::OPERATOR) {
                while (!operators.empty() && operators.top().type == Token::OPERATOR &&
                       ((rightAssociative[token.value] && precedence[token.value] < precedence[operators.top().value]) ||
                        (!rightAssociative[token.value] && precedence[token.value] <= precedence[operators.top().value]))) {
                    output.push_back(operators.top());
                    operators.pop();
                }
                operators.push(token);
            } else if (token.value == "(") {
                operators.push(token);
            } else if (token.value == ")") {
                while (!operators.empty() && operators.top().value != "(") {
                    output.push_back(operators.top());
                    operators.pop();
                }
                if (!operators.empty() && operators.top().value == "(") {
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

std::vector<Token> tokenize(const std::string& expression) {
    std::vector<Token> tokens;
    std::string num;
    for (size_t i = 0; i < expression.size(); ++i) {
        if (std::isdigit(expression[i])) {
            num += expression[i];
        } else {
            if (!num.empty()) {
                tokens.push_back({Token::NUMBER, num});
                num.clear();
            }
            if (expression[i] == ' ') continue;
            if (std::string("+-*/^()").find(expression[i]) != std::string::npos) {
                tokens.push_back({expression[i] == '(' || expression[i] == ')' ? Token::PARENTHESIS : Token::OPERATOR, std::string(1, expression[i])});
            }
        }
    }
    if (!num.empty()) tokens.push_back({Token::NUMBER, num});
    return tokens;
}

void printTokens(const std::vector<Token>& tokens) {
    for (const auto& token : tokens) {
        std::cout << token.value << " ";
    }
    std::cout << std::endl;
}

class ONPApplication {
public:
    void run() {
        while (true) {
            std::cout << "Enter an infix expression (or 'exit' to quit): ";
            std::string expression;
            std::getline(std::cin, expression);
            if (expression == "exit") break;
            try {
                std::vector<Token> tokens = tokenize(expression);
                InfixToPostfixConverter converter;
                std::vector<Token> postfix = converter.convert(tokens);
                printTokens(postfix);
                double result = evaluate(postfix);
                std::cout << "Result: " << result << std::endl;
            } catch (const std::exception& e) {
                std::cerr << "Error: " << e.what() << std::endl;
            }
        }
    }

private:
    double evaluate(const std::vector<Token>& tokens) {
        std::stack<double> values;
        for (const auto& token : tokens) {
            if (token.type == Token::NUMBER) {
                values.push(std::stod(token.value));
            } else if (token.type == Token::OPERATOR) {
                if (values.size() < 2) throw std::runtime_error("Invalid expression");
                double b = values.top(); values.pop();
                double a = values.top(); values.pop();
                if (token.value == "+") values.push(a + b);
                else if (token.value == "-") values.push(a - b);
                else if (token.value == "*") values.push(a * b);
                else if (token.value == "/") {
                    if (b == 0) throw std::runtime_error("Division by zero");
                    values.push(a / b);
                }
                else if (token.value == "^") values.push(std::pow(a, b));
            }
        }
        if (values.size() != 1) throw std::runtime_error("Invalid expression");
        return values.top();
    }
};

int main() {
    ONPApplication app;
    app.run();
    return 0;
}
