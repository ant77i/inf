#include <iostream>
#include <fstream>
#include <climits>
#include <vector>
#include <queue>

using namespace std;

int N = 9;

bool dfs(int u, vector<bool> &visited, vector<vector<int>> &graph, int parent) {
	visited[u] = true;

	for (const int& v : graph[u]) {
		if (!visited[v]) {
			if (dfs(v, visited, graph, u)) return true;
		} else if (v != parent) return true;
	}

	return false;
}

bool czyDrzewo(vector<vector<int>> &graph) {
	vector<bool> visited(N, false);


	if (dfs(0, visited, graph, -1)) return false;
	

	for (int i = 0; i < N; i++) {
		if (!visited[i]) return false;
	}

	return true;
}

void dijkstra(int source, vector<vector<int>> &graph) {
	priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pQ;

	vector<int> dist(N, INT_MAX);

	pQ.push({0, source});
	dist[source] = 0;

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

	cout << "Odległości od punktu " << source << "do: ";
	for (int i = 0; i < N; i++) cout << "\tPunktu " << i << " = " << dist[i] << '\n';
	cout << '\n';
}

int main() {
	ifstream file("data.txt", ios::in);

	vector<vector<int>> graph(N, vector<int>(N, 0));
	
	for (int i = 0; i < N; i++) {
		for (int j = 0; j < N; j++) {
			file >> graph[i][j];
		}
	}

	if (!czyDrzewo(graph)) {
		cout << "Ten graf to nie drzewo.\n";
		return 0;
	}

	for (int i = 0; i < N; i++) {
		dijkstra(i, graph);
	}

	return 0;
}