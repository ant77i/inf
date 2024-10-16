#include <iostream>
#include <fstream>
#include <climits>
#include <vector>
#include <queue>

using namespace std;

int N = 9;

bool dfs(int i, vector<bool> &visited, vector<vector<int>> &graph, int parent) {
	visited[i] = true;

	for (const int& j : graph[i]) {
		if (!visited[j]) {
			if (dfs(j, visited, graph, i)) return true;
		} else if (j != parent) return true;
	}

	return false;
}

bool czyDrzewo(vector<vector<int>> &graph) {
	vector<bool> visited(N, false);

	for (int i = 0; i < N; i++) {
		if (dfs(0, visited, graph, -1)) return false;
	}

	for (int i = 0; i < N; i++) {
		if (!visited[i]) return false;
	}

	return true;
}

void dijkstra(int i, vector<vector<int>> &graph) {
	priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pQ;

	vector<int> dist(N, INT_MAX);

	pQ.push({0, i});
	dist[i] = 0;

	while (!pQ.empty()) {
		int u = pQ.top().second;
		pQ.pop();

		for (const int& v : graph[u]) {
			int weight = abs(v - u);

			if (dist[v] > dist[u] + weight) {
				dist[v] = dist[u] + weight;
				pQ.push({dist[v], v});
			}
		}
	}

	cout << "Odległości od punktu"
}

int main() {
	ifstream file("data.txt", ios::in);

	vector<vector<int>> graph(N, vector<int>(N, 0));
	
	for (int i = 0; i < N; i++) {
		for (int j = 0; j < N; j++) {
			cin >> graph[i][j];
		}
	}

	if (!czyDrzewo(graph)) {
		cout << "Ten graf to nie drzewo.\n";
		return 0;
	}

	for (int i = 0; i < N; i++) {
		dijsktra(i);
	}
}