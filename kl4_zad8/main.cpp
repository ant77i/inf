#include <iostream>
#include <limits>
#include <vector>
#include <string>
#include <random>
#include <stack>
#include <fstream>
#include <iostream>
#include <algorithm>
#include <ctime>
#include <utility>


class Cell {
public:
    bool visited = false;
    bool top_wall = true;
    bool bottom_wall = true;
    bool left_wall = true;
    bool right_wall = true;
};

class Maze {
    public:
    
    Maze(int size, int exits) : N(size), E(exits) {
        grid.resize(N, std::vector<Cell>(N));
        rng.seed(static_cast<unsigned int>(time(nullptr)));
    }


    
    void saveToFile(const std::string& filename) {
        std::ofstream file(filename);
        if (!file.is_open()) {
            std::cerr << "B��d: Nie mo�na otworzy� pliku do zapisu: " << filename << std::endl;
            return;
        }

        int ascii_width = 2 * N + 1;
        int ascii_height = 2 * N + 1;
        std::vector<std::string> ascii_maze(ascii_height, std::string(ascii_width, '#'));

        for (int y = 0; y < N; ++y) {
            for (int x = 0; x < N; ++x) {
                int ascii_x = 2 * x + 1;
                int ascii_y = 2 * y + 1;
                ascii_maze[ascii_y][ascii_x] = ' ';
                if (!grid[y][x].right_wall) ascii_maze[ascii_y][ascii_x + 1] = ' ';
                if (!grid[y][x].bottom_wall) ascii_maze[ascii_y + 1][ascii_x] = ' ';
                if (!grid[y][x].top_wall) ascii_maze[ascii_y - 1][ascii_x] = ' ';
                if (!grid[y][x].left_wall) ascii_maze[ascii_y][ascii_x - 1] = ' ';
            }
        }

        for (const auto& row : ascii_maze) {
         file << row << std::endl;
        }
        file.close();
    }



    void generate() {
        std::stack<std::pair<int, int>> stack;
        int start_x = 0, start_y = 0;
    
        grid[start_y][start_x].visited = true;
        stack.push({ start_x, start_y });
    
        while (!stack.empty()) {
            std::pair<int, int> current_pos = stack.top();
            int cx = current_pos.first;
            int cy = current_pos.second;
    
            std::vector<std::pair<int, int>> neighbors;
            int dx[] = { 0, 0, 1, -1 };
            int dy[] = { 1, -1, 0, 0 };
    
            for (int i = 0; i < 4; ++i) {
                int nx = cx + dx[i];
                int ny = cy + dy[i];
    
                if (nx >= 0 && nx < N && ny >= 0 && ny < N && !grid[ny][nx].visited) {
                    neighbors.push_back({ nx, ny });
                }
            }
    
            if (!neighbors.empty()) {
                std::uniform_int_distribution<int> dist(0, neighbors.size() - 1);
    
                std::pair<int, int> next_pos = neighbors[dist(rng)];
                int nx = next_pos.first;
                int ny = next_pos.second;
    
                removeWall(grid[cy][cx], grid[ny][nx], nx - cx, ny - cy);
    
                grid[ny][nx].visited = true;
                stack.push({ nx, ny });
            }
            else {
                stack.pop();
            }
        }
    
        placeExits();
    }

private:
    int N; 
    int E;
    std::vector<std::vector<Cell>> grid;
    std::mt19937 rng; 



    void placeExits() {
        if (E <= 0) return;

        std::vector<std::pair<int, int>> edge_cells;
        for (int i = 0; i < N; ++i) {
            edge_cells.push_back({ i, 0 }); edge_cells.push_back({ i, N - 1 });
            if (i > 0 && i < N - 1) {
                edge_cells.push_back({ 0, i }); edge_cells.push_back({ N - 1, i });
            }
        }

        std::shuffle(edge_cells.begin(), edge_cells.end(), rng);

        int exits_placed = 0;
        for (const auto& cell_pos : edge_cells) {
            if (exits_placed >= E) break;
            int x = cell_pos.first;
            int y = cell_pos.second;

            if (y == 0) { grid[y][x].top_wall = false; exits_placed++; }
            else if (y == N - 1) { grid[y][x].bottom_wall = false; exits_placed++; }
            else if (x == 0) { grid[y][x].left_wall = false; exits_placed++; }
            else if (x == N - 1) { grid[y][x].right_wall = false; exits_placed++; }
        }
    }



    void removeWall(Cell& current, Cell& next, int dx, int dy) {
        if (dx == 1) { current.right_wall = false; next.left_wall = false; }
        else if (dx == -1) { current.left_wall = false; next.right_wall = false; }
        else if (dy == 1) { current.bottom_wall = false; next.top_wall = false; }
        else if (dy == -1) { current.top_wall = false; next.bottom_wall = false; }
    }
};




void getInput(int& n, int& e) {
    while (true) {
        std::cout << "Podaj rozmiar labiryntu N (5-99): ";
        std::cin >> n;
        if (std::cin.fail() || n < 5 || n > 99) {
            std::cout << "Nieprawidłowy rozmiar. Wprowadź liczbę z zakresu 5-99." << std::endl;
            std::cin.clear();
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        }
        else {
            break;
        }
    }

    while (true) {
        std::cout << "Podaj liczbę wyjść E (1-4): ";
        std::cin >> e;
        if (std::cin.fail() || e < 1 || e > 4) {
            std::cout << "Nieprawidłowa liczba wyjść. Wprowadź liczbę z zakresu 1-4." << std::endl;
            std::cin.clear();
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        }
        else {
            break;
        }
    }
}






int main() {
    int n, e;

    std::cout << "Generator Labiryntów\n";
    getInput(n, e);

    try {
        Maze maze(n, e);

        maze.generate();

        std::string filename = "labirynt.txt";
        maze.saveToFile(filename);

        std::cout << "\nPodsumowanie ---\n";
        std::cout << "Rozmiar labiryntu: " << n << "x" << n << std::endl;
        std::cout << "Liczba wyjść: " << e << std::endl;
        std::cout << "Wynik zapisano do pliku: " << filename << std::endl;

    }
    catch (const std::exception& ex) {
        std::cerr << "Wystąpił nieoczekiwany błąd: " << ex.what() << std::endl;
        return 1;
    }

    return 0;
}