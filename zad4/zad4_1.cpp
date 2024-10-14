#include <iostream>
#include <stack>
#include <unordered_map>


using namespace std;

int main() {
	string exp = ""; // expression
	cin >> exp;

	stack<char> s;
	for (const char& c : exp) {
		if (c != '(' && c != '{' && c != '[' && c != ')' && c != '}' && c != ']') continue;

		if (c == '(' || c == '{' || c == '[') { 
            s.push(c); 
        } else { 
            if (s.empty() || 
                (c == ')' && s.top() != '(') || 
                (c == '}' && s.top() != '{') ||
                (c == ']' && s.top() != '[')) {
                s.push('\0'); // Expression not valid
				break;
            }
            s.pop(); 
        }
	}

	cout << (s.empty() ? "Nawiasy są poprawnie zagnieżdżone.\n" : "Nawiasy nie są poprawnie zagnieżdżone.\n");

	return 0;
}