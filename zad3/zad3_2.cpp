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
		{2, 3, 5},
		{3, 4, 3}
	};

	vector<int> distance(N, INT_MAX);
	vector<vector<pair<int, int>>> neighbours(N, vector<pair<int, int>>());

	for (const auto& edge : edges) {
		neighbours[edge[0]].push_back({edge[1], edge[2]});
		neighbours[edge[1]].push_back({edge[0], edge[2]});
	}

	priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pQ;

	int START = 0;


	pQ.push({0, START});
	distance[START] = 0;

	while (!pQ.empty()) {
		int curr = pQ.top().second;
		pQ.pop();

		for (const auto& neighbour : neighbours[curr]) {
			int currN = neighbour.first;
			int weight = neighbour.second;

			if (distance[currN] > distance[curr] + weight) {
				distance[currN] = distance[curr] + weight;
				pQ.push({distance[currN], currN});
			}
		}
	}

	cout << "Odległośc wszystkich punktów od początku (" << START << ")\n";
	for (int i = 0; i < N; i++) {
		cout << "Punkt: " << i << "\t";

		if (distance[i] == INT_MAX) {
			cout << "Nie da się dostać do tego punktu.";
			continue;
		}

		cout << "Odległość: " << distance[i] << '\n';
	}

	return 0;
}