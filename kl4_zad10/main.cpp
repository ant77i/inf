#include <iostream>
#include <vector>
#include <chrono>
#include <fstream>
#include <algorithm>
#include <tuple>
using namespace std;

tuple<int, int, double> selectionSort(vector<double>& v) {
    int n = v.size();
    int porownania = 0;
    int zamiany = 0;
    chrono::time_point<chrono::steady_clock> start, end;

    start = chrono::steady_clock::now();

    for (int i = 0; i < n - 1; ++i) {
        int min_idx = i;

        for (int j = i + 1; j < n; ++j) {
            porownania++;
            if (v[j] < v[min_idx]) {
                min_idx = j; 
            }
        }
        
        zamiany++;
        swap(v[i], v[min_idx]);
    }

    end = chrono::steady_clock::now();

    return {porownania, zamiany, chrono::duration_cast<chrono::microseconds>(end - start).count()};
}

tuple<int, int, double> insertionSort(vector<double>& v) {
	int n = v.size();
    int porownania = 0;
    int zamiany = 0;
    chrono::time_point<chrono::steady_clock> start, end;

	start = chrono::steady_clock::now();

	for (int i = 1; i < n; i++) {
		int j = i;

        porownania++;
		while (j > 0 && v[j - 1] > v[j]) {
            zamiany++;
			swap(v[j], v[j - 1]);
            j--;
		}
	}
    
    end = chrono::steady_clock::now();

    return {porownania, zamiany, chrono::duration_cast<chrono::microseconds>(end - start).count()};
}

tuple<int, int, double> bubbleSort(vector<double>& v) {
	int n = v.size();
    int porownania = 0;
    int zamiany = 0;
    chrono::time_point<chrono::steady_clock> start, end;

	start = chrono::steady_clock::now();

	for (int i = 0; i < n; i++) {
		for (int j = i + 1; j < n; j++) {

            porownania++;
			if (v[i] > v[j]) {
                swap(v[i], v[j]);
                zamiany++;
			}
		}
	}

    end = chrono::steady_clock::now();

    return {porownania, zamiany, chrono::duration_cast<chrono::microseconds>(end - start).count()};
}




int main() {
    int n = 0;

    cout << "Wpisz liczbe elementow: ";
    cin >> n;
    
    vector<double> vec(n, 0);

    for (int i = 0; i < n; i++) {
        vec[i] = rand() % 999 + 1;
    }

    vector<double> vecL = vec;
    vector<double> vecS = vec;
    sort(vecS.begin(), vecS.end());

    vector<double> vecR = vecS;
    reverse(vecR.begin(), vecR.end());

    int i = 0;
    string labels[] = {"Losowych", "Posortowanych", "Odwrotnie posortowanych"};
    for (vector<double> v : {vecL, vecS, vecR}) {
        vector<double> vec1 = v;
        vector<double> vec2 = v;

        auto [porownaniaS, zamianyS, czasS] = selectionSort(v);
        auto [porownaniaI, zamianyI, czasI] = insertionSort(vec1);   
        auto [porownaniaB, zamianyB, czasB] = bubbleSort(vec2);

        cout << "Dla " << labels[i++] << " danych:\n";

        cout << "Selection Sort - Porownania: " << porownaniaS << ", Zamiany: " << zamianyS << ", Czas: " << czasS << "us\n";
        cout << "Insertion Sort - Porownania: " << porownaniaI << ", Zamiany: " << zamianyI << ", Czas: " << czasI << "us\n";
        cout << "Bubble Sort - Porownania: " << porownaniaB << ", Zamiany: " << zamianyB << ", Czas: " << czasB << "us\n";

        cout << "\n----------------------------------------\n\n";
    }

    return 0;
}