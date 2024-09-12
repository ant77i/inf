#include <iostream>
#include <stack>

int main() {
    std::string input = "";
    std::cout << "Podaj słowo: " << '\n';
    std::cin >> input;

    std::stack<char> s;
    for (const char& c : input) {
        s.push(c);
    }

    std::string reversed = "";
    while (!s.empty()) {
        reversed += s.top();
        s.pop();
    }

    if (input == reversed) {
        std::cout << "Słowo jest palindromem\n";
    } else {
        std::cout << "Słowo nie jest palindromem\n";
    }

    return 0;
}