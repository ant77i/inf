#include <iostream>
#include <queue>
#include <stack>
#include <vector>

using namespace std;

int main() {
	vector<int> v = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
	};

	queue<int> Q;
	stack<int> S;

	cout << "Kolejka przed odwróceniem: \n";
	for (const int& num : v) {
		Q.push(num);
		cout << num << ' ';
	}

	while (!Q.empty()) {
		S.push(Q.front());
		Q.pop();
	} 

	while (!S.empty()) {
		Q.push(S.top());
		S.pop();
	}

	cout << "\nKolejka po odwróceniu: \n";
	while (!Q.empty()) {
		cout << Q.front() << ' ';
		Q.pop();
	}

	return 0;
}