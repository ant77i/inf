#include <iostream>
#include <fstream>
#include <climits>

using namespace std;

int N = 9;

int main() {
	ifstream file("data.txt", ios::in);

	/* int graph[N][N] = { { 0, 5, INT_MAX, 10 },
                        { INT_MAX, 0, 3, INT_MAX },
                        { INT_MAX, INT_MAX, 0, 1 },
                        { INT_MAX, INT_MAX, INT_MAX, 0 } }; */

	int graph[N][N] = {0};

	/*
		Trochę nie rozumiem tej tablicy którą nam Pan dał,
		,ponieważ z tego co ja rozumiem to wartość w tablicy na indeksie [i][j] oznacza że
		długość odcinka z punktu i do punktu j to tablica[i][j],
		a to by oznaczało że ta tablica wejściowa jest odpowiedzią.
		Próbowałem się dowiedzieć od reszty grupy, ale dalej nie rozumiem,
		więc przesyłam Panu moją implementacje Floyd-Warshall'a w c++
	*/

	
	for (int i = 0; i < N; i++) {
		for (int j = 0; j < N; j++) {
			string input = "";
			file >> input;

			if (input == "INF") graph[i][j] = INT_MAX;
			else graph[i][j] = stoi(input);
		}
	}
	

	int i, j, k;

	for (k = 0; k < N; k++) {
		for (i = 0; i < N; i++) {
			for (j = 0; j < N; j++) {
				if (graph[i][j] > (graph[i][k] + graph[k][j])
				 && graph[k][j] != INT_MAX
				 && graph[i][k] != INT_MAX) {

					graph[i][j] = graph[i][k] + graph[k][j];
				}
			}
		}
	}

	for (int i = 0; i < N; i++) {
		for (int j = 0; j < N; j++) {
			if (graph[i][j] == INT_MAX) cout << "INF" << ' ';
			else cout << graph[i][j] << "   ";
		}
		cout << '\n';
	}
}