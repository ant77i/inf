#include <iostream>
#include <stack>
#include <string>

int main() {
    std::stack<int> Czarownica;

    Czarownica.push(1);
    Czarownica.push(2);
    Czarownica.push(20);

    std::cout << "Pierwsza czarownica na stos: " << Czarownica.top() << '\n';

    Czarownica.pop();

    std::cout << "Zdjęcie pierwszego elementu z góry stosu: " << Czarownica.top() << '\n'; 
    std::cout << "Rozmiar stosu: " << Czarownica.size() << '\n';

    //--------------------------------------------------------------//

    std::stack<char> stosZnakow;
    std::string input = "";

    std::cout << "Podaj ciąg znaków: ";
    std::getline(std::cin, input);

    for (const char& c : input) {
        stosZnakow.push(c);
    }

    std::string odwrocony = "";

    while (!stosZnakow.empty()) {
        odwrocony += stosZnakow.top();
        stosZnakow.pop();
    }

    std::cout << "Odwrócony ciąg znaków: " << odwrocony << '\n';
    
}

/*
auto init = []() {
    std::ios_base::sync_with_stdio(0);
    std::cin.tie(0);
    std::cout.tie(0);
    return 'c';
}();
*/