#include <iostream>
#include <queue>

struct Client {
    int arrivalTime;
    int serviceTime;
    int clientID;
};

int main() {
    std::queue<Client> bankQ;
    std::queue<Client> serviceWindowOne;
    std::queue<Client> serviceWindowTwo;


    Client clients[] = {
        {0, 12, 1},
        {1, 32, 2},
        {2, 4, 3},
        {3, 78, 4},
    };

    int currentTime = 0;
    int totalClients = 4;
    int nextClientIndex = 0;

    while (nextClientIndex < totalClients || !bankQ.empty() || !serviceWindowOne.empty() || !serviceWindowTwo.empty()) {
        while (nextClientIndex < totalClients && clients[nextClientIndex].arrivalTime == currentTime) {
            bankQ.push(clients[nextClientIndex]);
            std::cout << "Minuta: " << currentTime << '\t' << "Klient: " << clients[nextClientIndex].clientID << " dołącza do kolejki.\n";
        }
    }

    
    return 0;
}