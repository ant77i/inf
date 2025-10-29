#include <iostream>
#include <cmath>
#include <math.h>
#include <vector>
#include <string>
#include <ctime>
#include <iomanip>
#include <limits>

using namespace std;

enum AngleMode { RAD, DEG };

struct HistoryEntry {
    string timestamp;
    string operation;
    string arguments;
    string result;
};

class Kalkulator {
public:
    void start() {
        cout << fixed << setprecision(precision);
        while (true) {
            showMenu();
            int opt;
            cout << "\nWybierz opcję: ";
            if (!(cin >> opt)) {
                handleInputError();
                continue;
            }
            if (opt == 14) break; // Wyjście
            handleOption(opt);
        }
    }

private:
    double memory = 0.0;
    double lastResult = NAN;
    vector<HistoryEntry> history;
    vector<string> errorLog;
    AngleMode angleMode = DEG;
    int precision = 6;

    // ---- MENU ----
    void showMenu() {
        cout << "\n===== KALKULATOR NAUKOWY =====\n";
        cout << "1.  Dodawanie\n";
        cout << "2.  Odejmowanie\n";
        cout << "3.  Mnożenie\n";
        cout << "4.  Dzielenie\n";
        cout << "5.  Reszta z dzielenia (mod)\n";
        cout << "6.  Potęgowanie (a^b)\n";
        cout << "7.  Pierwiastek n-tego stopnia\n";
        cout << "8.  Silnia (n!)\n";
        cout << "9.  Funkcje trygonometryczne\n";
        cout << "10. Logarytmy (log10, ln)\n";
        cout << "11. Pamięć (M+, M-, MR, MC)\n";
        cout << "12. Historia działań\n";
        cout << "13. Ustawienia\n";
        cout << "14. Wyjście\n";
    }

    // ---- OBSŁUGA MENU ----
    void handleOption(int opt) {
        double a, b;
        switch (opt) {
        case 1: // Dodawanie
            if (getTwoArgs(a, b)) saveAndShow(a, b, "Dodawanie", dodawanie(a, b));
            break;
        case 2: // Odejmowanie
            if (getTwoArgs(a, b)) saveAndShow(a, b, "Odejmowanie", odejmowanie(a, b));
            break;
        case 3: // Mnożenie
            if (getTwoArgs(a, b)) saveAndShow(a, b, "Mnożenie", mnozenie(a, b));
            break;
        case 4: // Dzielenie
            if (getTwoArgs(a, b)) {
                if (b == 0) { logError("Dzielenie przez zero"); break; }
                saveAndShow(a, b, "Dzielenie", dzielenie(a, b));
            }
            break;
        case 5: // Modulo
            handleModulo();
            break;
        case 6: // Potęgowanie
            if (getTwoArgs(a, b)) saveAndShow(a, b, "Potęgowanie", pow(a, b));
            break;
        case 7: // Pierwiastek
            handleRoot();
            break;
        case 8: // Silnia
            handleFactorial();
            break;
        case 9: // Trygonometria
            handleTrig();
            break;
        case 10: // Logarytmy
            handleLog();
            break;
        case 11: // Pamięć
            handleMemory();
            break;
        case 12: // Historia
            handleHistory();
            break;
        case 13: // Ustawienia
            handleSettings();
            break;
        default:
            logError("Niepoprawna opcja menu");
            break;
        }
    }

    // ---- OPERACJE PODSTAWOWE ----
    double dodawanie(double a, double b) { return a + b; }
    double odejmowanie(double a, double b) { return a - b; }
    double mnozenie(double a, double b) { return a * b; }
    double dzielenie(double a, double b) { return a / b; }

    // ---- MODULO ----
    void handleModulo() {
        int a, b;
        cout << "Podaj dwie liczby całkowite: ";
        if (!(cin >> a >> b)) { handleInputError(); return; }
        if (b == 0) { logError("Dzielenie przez zero w modulo"); return; }
        saveAndShow(a, b, "Modulo", a % b);
    }

    // ---- PIERWIASTEK ----
    void handleRoot() {
        double a; int n;
        cout << "Podaj liczbę i stopień pierwiastka (a n): ";
        if (!(cin >> a >> n)) { handleInputError(); return; }
        if (n == 0) { logError("Pierwiastek stopnia 0 jest niezdefiniowany"); return; }
        if (a < 0 && n % 2 == 0) { logError("Pierwiastek parzystego stopnia z liczby ujemnej"); return; }
        saveAndShow(a, n, "Pierwiastek", pow(a, 1.0 / n));
    }

    // ---- SILNIA ----
    void handleFactorial() {
        int n;
        cout << "Podaj liczbę całkowitą n: ";
        if (!(cin >> n)) { handleInputError(); return; }
        if (n < 0 || n > 20) { logError("Silnia: zakres <0,20>"); return; }

        unsigned long long wynik = 1;
        for (int i = 1; i <= n; i++) wynik *= i;
        saveAndShow(n, "Silnia", (double)wynik);
    }

    // ---- FUNKCJE TRYGONOMETRYCZNE ----
    void handleTrig() {
        double x;
        cout << "Podaj kąt: ";
        if (!(cin >> x)) { handleInputError(); return; }

        if (angleMode == DEG) x = x * M_PI / 180.0;

        cout << "sin = " << sin(x)
             << ", cos = " << cos(x)
             << ", tan = ";
        if (fabs(cos(x)) < 1e-12) cout << "NIESKOŃCZONOŚĆ\n";
        else cout << tan(x) << "\n";
    }

    // ---- LOGARYTMY ----
    void handleLog() {
        double x;
        cout << "Podaj x > 0: ";
        if (!(cin >> x)) { handleInputError(); return; }
        if (x <= 0) { logError("Logarytm z liczby <= 0"); return; }

        cout << "log10(x) = " << log10(x) << ", ln(x) = " << log(x) << "\n";
    }

    // ---- PAMIĘĆ ----
    void handleMemory() {
        char cmd;
        cout << "Wybierz [M+/M-/MR/MC]: ";
        cin >> cmd;
        switch (toupper(cmd)) {
        case 'R':
            cout << "Pamięć = " << memory << "\n"; break;
        case '+':
            if (isnan(lastResult)) { logError("Brak ostatniego wyniku do dodania"); return; }
            memory += lastResult; break;
        case '-':
            if (isnan(lastResult)) { logError("Brak ostatniego wyniku do odjęcia"); return; }
            memory -= lastResult; break;
        case 'C':
            memory = 0; break;
        default:
            logError("Nieznana komenda pamięci"); break;
        }
    }

    // ---- HISTORIA ----
    void handleHistory() {
        cout << "1. Podgląd historii\n2. Wyczyść historię\n3. Podgląd błędów\n";
        int sub; cin >> sub;
        if (sub == 1) {
            for (auto& h : history)
                cout << h.timestamp << " | " << h.operation << " | "
                     << h.arguments << " -> " << h.result << "\n";
        } else if (sub == 2) {
            history.clear();
            cout << "Historia wyczyszczona.\n";
        } else if (sub == 3) {
            for (auto& e : errorLog) cout << e << "\n";
        }
    }

    // ---- USTAWIENIA ----
    void handleSettings() {
        cout << "1. Zmień tryb kątów (obecnie: " << (angleMode == DEG ? "stopnie" : "radiany") << ")\n";
        cout << "2. Zmień precyzję (obecnie: " << precision << ")\n";
        int opt; cin >> opt;
        if (opt == 1) angleMode = (angleMode == DEG ? RAD : DEG);
        else if (opt == 2) { cout << "Podaj liczbę miejsc po przecinku: "; cin >> precision; cout << fixed << setprecision(precision); }
    }

    // ---- POMOCNICZE ----
    bool getTwoArgs(double& a, double& b) {
        cout << "Podaj dwie liczby: ";
        if (!(cin >> a >> b)) { handleInputError(); return false; }
        return true;
    }

    void saveAndShow(double a, double b, string op, double res) {
        cout << "Wynik: " << res << "\n";
        lastResult = res;
        addToHistory(op, to_string(a) + ", " + to_string(b), to_string(res));
    }

    void saveAndShow(double a, string op, double res) {
        cout << "Wynik: " << res << "\n";
        lastResult = res;
        addToHistory(op, to_string(a), to_string(res));
    }

    void addToHistory(string op, string args, string res) {
        time_t now = time(0);
        string t = ctime(&now); t.pop_back();
        history.push_back({ t, op, args, res });
        if (history.size() > 50) history.erase(history.begin());
    }

    void handleInputError() {
        cout << "Błąd wejścia. Spróbuj ponownie.\n";
        logError("Błąd formatu wejścia");
        cin.clear();
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
    }

    void logError(string msg) {
        time_t now = time(0);
        string t = ctime(&now); t.pop_back();
        errorLog.push_back(t + " | " + msg);
        cout << "BŁĄD: " << msg << "\n";
    }
};

int main() {
    Kalkulator k;
    k.start();
    return 0;
}
