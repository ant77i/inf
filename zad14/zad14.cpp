#include <iostream>
#include <fstream>
#include <vector>
#include <queue>
#include <string>
#include <algorithm>

using namespace std;

struct Position {
    int x, y;
    Position* previous;

    Position(int x, int y, Position* prev = nullptr) : x(x), y(y), previous(prev) {}
};

class Maze {
private:
    vector<vector<char>> grid;

public:
    bool loadFromFile(const string& filename) {
        ifstream file(filename);
        if (!file.is_open()) {
            cerr << "Nie mozna otworzyc pliku: " << filename << endl;
            return false;
        }

        string line;
        while (getline(file, line)) {
            vector<char> row(line.begin(), line.end());
            grid.push_back(row);
        }

        return true;
    }

    void print() const {
        for (const auto& row : grid) {
            for (char c : row) {
                cout << c;
            }
            cout << '\n';
        }
    }

    pair<int, int> findChar(char c) const {
        for (int i = 0; i < grid.size(); ++i) {
            for (int j = 0; j < grid[i].size(); ++j) {
                if (grid[i][j] == c)
                    return make_pair(i, j);
            }
        }
        return make_pair(-1, -1);
    }

    bool canEnter(int x, int y) const {
        return x >= 0 && x < grid.size() &&
            y >= 0 && y < grid[0].size() &&
            (grid[x][y] == '.' || grid[x][y] == 'E');
    }

    void markPath(const vector<Position*>& path) {
        for (Position* p : path) {
            if (grid[p->x][p->y] == '.')
                grid[p->x][p->y] = '*';
        }
    }

    int height() const { grid.size(); }
    int width() const { grid.empty() ? 0 : grid[0].size(); }
};

class PathFinder {
private:
    Maze& maze;

public:
    PathFinder(Maze& l) : maze(l) {}

    vector<Position*> findPath() {
        pair<int, int> start = maze.findChar('S');
        pair<int, int> end = maze.findChar('E');
        int startX = start.first;
        int startY = start.second;
        int endX = end.first;
        int endY = end.second;

        if (startX == -1 || endX == -1) {
            cout << "Brak punktu startowego lub koncowego!" << endl;
            return {};
        }

        vector<vector<bool>> visited(maze.height(), vector<bool>(maze.width(), false));
        queue<Position*> Q;
        Q.push(new Position(startX, startY));
        visited[startX][startY] = true;

        int dx[] = { -1, 1, 0, 0 };
        int dy[] = { 0, 0, -1, 1 };

        Position* goal = nullptr;

        while (!Q.empty()) {
            Position* curr = Q.front();
            Q.pop();

            if (curr->x == endX && curr->y == endY) {
                goal = curr;
                break;
            }

            for (int i = 0; i < 4; ++i) {
                int nx = curr->x + dx[i];
                int ny = curr->y + dy[i];

                if (maze.canEnter(nx, ny) && !visited[nx][ny]) {
                    visited[nx][ny] = true;
                    Q.push(new Position(nx, ny, curr));
                }
            }
        }

        vector<Position*> path;
        while (goal != nullptr) {
            path.push_back(goal);
            goal = goal->previous;
        }

        reverse(path.begin(), path.end());
        return path;
    }
};

int main() {
    Maze maze;
    if (!maze.loadFromFile("labirynt.txt")) {
        return 1;
    }

    PathFinder finder(maze);
    vector<Position*> path = finder.findPath();

    if (path.empty()) {
        cout << "Nie znaleziono sciezki!" << endl;
    }
    else {
        maze.markPath(path);
        cout << "Znaleziono sciezke:\n";
        maze.print();
    }

    return 0;
}