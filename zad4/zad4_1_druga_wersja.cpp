#include <iostream>
#include <string>
#include <algorithm>

using namespace std;

int main() {
    string exp = "";
    cin >> exp;

    string reversed = exp;
    reverse(reversed.begin(), reversed.end());

    cout << exp << '\n' << reversed << '\n';

    if (exp == reversed) {
        cout << "Nawiasy są poprawnie zagnieżdżone.\n";
    } else {
        cout << "Nawiasy nie są poprawnie zagnieżdżone.\n";
    }
}