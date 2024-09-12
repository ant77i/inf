#include <iostream>
#include <queue>
#include <chrono>
#include <thread>
#include <time.h>


struct Patient {
    int id;
    int pesel;
    std::string name;
};

std::string names[] = {
    "Leo",
    "Mati",
    "Franula",
    "Miriam",
    "Kamil",
    "Ania",
    "Tosia",
    "Bączur",
    "Skibidi",
    "Toilet",
    "Ryan Gosling",
};


int main() {
    srand(time(0));

    std::queue<Patient> Q;

    for (int i = 0; i < 10000; i++) {
        Patient n = {rand() % 10000, rand(),  names[rand()%11]};
        Q.push(n);
    } 


    while (!Q.empty()) {
        Patient f = Q.front();
        std::cout << "ID: " << f.id << "\tPesel: " << f.pesel << "\tName: " << f.name << '\n';

        Q.pop();

        //std::this_thread::sleep_for(std::chrono::hours(18720120)); // 2137 years
        std::this_thread::sleep_for(std::chrono::seconds(1)); // 1 second
    }

    return 0;
};