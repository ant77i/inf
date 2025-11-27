#include <iostream>
#include <vector>
#include <chrono>
#include <algorithm>
#include <cstdlib>
#include <ctime>
using namespace std;

struct wyniki {
    int porownania = 0;
    int zamiany = 0;
    double czas = 0.0;
};

class algorytm {
public:
    virtual ~algorytm() = default;
    virtual wyniki sort(vector<double> v) = 0; // take copy to avoid mutating caller data
    virtual string nazwa() const = 0;
};

class SelectionSort : public algorytm {
public:
    wyniki sort(vector<double> v) override {
        int n = (int)v.size();
        int por = 0;
        int zam = 0;
        auto start = chrono::steady_clock::now();
        for (int i = 0; i < n - 1; ++i) {
            int min_idx = i;
            for (int j = i + 1; j < n; ++j) {
                por++;
                if (v[j] < v[min_idx]) min_idx = j;
            }
            zam++;
            swap(v[i], v[min_idx]);
        }
        auto end = chrono::steady_clock::now();
        return {por, zam, (double)chrono::duration_cast<chrono::microseconds>(end - start).count()};
    }
    string nazwa() const override { return "Selection Sort"; }
};

class InsertionSort : public algorytm {
public:
    wyniki sort(vector<double> v) override {
        int n = (int)v.size();
        int por = 0;
        int zam = 0;
        auto start = chrono::steady_clock::now();
        for (int i = 1; i < n; ++i) {
            int j = i;
            por++;
            while (j > 0 && v[j - 1] > v[j]) {
                zam++;
                swap(v[j], v[j - 1]);
                j--;
            }
        }
        auto end = chrono::steady_clock::now();
        return {por, zam, (double)chrono::duration_cast<chrono::microseconds>(end - start).count()};
    }
    string nazwa() const override { return "Insertion Sort"; }
};

class BubbleSort : public algorytm {
public:
    wyniki sort(vector<double> v) override {
        int n = (int)v.size();
        int por = 0;
        int zam = 0;
        auto start = chrono::steady_clock::now();
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                por++;
                if (v[i] > v[j]) {
                    swap(v[i], v[j]);
                    zam++;
                }
            }
        }
        auto end = chrono::steady_clock::now();
        return {por, zam, (double)chrono::duration_cast<chrono::microseconds>(end - start).count()};
    }
    string nazwa() const override { return "Bubble Sort"; }
};

int main() {
    srand((unsigned)time(nullptr));
    int n = 0;
    cout << "Wpisz liczbe elementow: ";
    if (!(cin >> n) || n < 0) {
        cout << "Niepoprawna liczba.\n";
        return 1;
    }

    vector<double> base(n);
    for (int i = 0; i < n; ++i) base[i] = rand() % 999 + 1;

    vector<double> vecL = base;
    vector<double> vecS = base;
    sort(vecS.begin(), vecS.end());
    vector<double> vecR = vecS;
    reverse(vecR.begin(), vecR.end());

    SelectionSort sel;
    InsertionSort ins;
    BubbleSort bub;

    algorytm* algorithms[] = { &sel, &ins, &bub };
    string nazwy[] = { "Losowych", "Posortowanych", "Odwrotnie posortowanych" };
    vector<vector<double>> dane = { vecL, vecS, vecR };

    for (size_t i = 0; i < dane.size(); ++i) {
        cout << "Dla " << nazwy[i] << " danych:\n";
        for (algorytm* alg : algorithms) {
            wyniki r = alg->sort(dane[i]);
            cout << alg->nazwa() << " - Porownania: " << r.porownania
                 << ", Zamiany: " << r.zamiany
                 << ", Czas: " << r.czas << "us\n";
        }
        cout << "\n----------------------------------------\n\n";
    }

    return 0;
}