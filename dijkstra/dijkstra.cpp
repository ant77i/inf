#include <iostream>
#include <vector>
#include <queue>
#include <climits>

using namespace std;

struct Edge {
    int target;
    int weight;
};

void dijkstra(int start, const vector<vector<Edge>>& graph) {
    int n = graph.size();
    vector<int> distance(n, INT_MAX);
    distance[start] = 0;

    priority_queue<pair<int, int>, vector<pair<int, int>, greater<pair<int, int>>>> pq;
    pq.push({0, start});

    while (!pq.empty()) {
        int currDistance = pq.top().first;
        int currVortex = pq.top().second;
        pq.pop();

        if (currDistance > distance[currVortex]) continue;

        
    }


}