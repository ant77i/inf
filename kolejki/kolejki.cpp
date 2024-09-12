#include <iostream>
#include <queue>

int main() {
    std::queue<int> Q;

    Q.push(10);
    Q.push(20);
    Q.push(30);

    std::cout << "Pierwszy element: " << Q.front() << '\n';

    Q.pop();

    std::cout << "Drugi element: " << Q.front() << '\n';

    return 0;
}