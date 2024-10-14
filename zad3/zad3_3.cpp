#include <iostream>
#include <vector>
#include <queue>
#include <climits>

using namespace std;

int N = 6;

int main() {
	// {i, j, w}: i -> j with weight w
	int edges[5][3] = {
		{0, 1, 4},
		{0, 2, 1},
		{1, 3, 2},
		{2, 3, -5},
		{3, 4, 3}
	};

	for (const auto& edge : edges) {
		if (edge[2] < 0) {
			cout << "Algorytm Dijkstry nie jest w stanie znaleźć prawidłowych wyników.";
			return 0;
		}
	}

	cout << "Algorytm Dijkstry będzie w stanie znaleźć prawidłowe wyniki.";

	return 0;
}