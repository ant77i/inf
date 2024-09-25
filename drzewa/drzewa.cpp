#include <iostream>
#include <iomanip>

struct TreeNode {
    int data;
    
    TreeNode* left;
    TreeNode* right;

    TreeNode() : data(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : data(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode* left, TreeNode* right) : data(x), left(left), right(right) {}
};

TreeNode* insert(TreeNode* root, int val) {
    if (!root) return new TreeNode(val);



    if (val < root->data) root->left = insert(root->left, val);

    else root->right = insert(root->right, val);

    return root;
}

bool search(TreeNode* root, int val) {
    if (!root) return false;

    if (root->data == val) return true;

    return (val < root->data ? search(root->left, val) : search(root->right, val));
}

void inOrderTraversal(TreeNode* root) {
    if (!root) return;

    inOrderTraversal(root->left);
    std::cout << root->data << '\n';
    inOrderTraversal(root->right);
}

void printTree(TreeNode* root, int space = 0, int indent = 3) {
    if (!root) return;

    space += indent;

    printTree(root->right, space, indent);
    std::cout << '\n' << std::setw(space) << root->data << '\n';
    printTree(root->left, space, indent);
}

int main() {
    TreeNode* root = nullptr;

    root = insert(root, 50);
    insert(root, 30);
    insert(root, 70);
    insert(root, 10);
    insert(root, 50);
    insert(root, 80);
    insert(root, 20);
    insert(root, 40);

    std::cout << "Drzewo w porządku in-order: " << '\n';
    inOrderTraversal(root);

    int searchValue = 50;
    if (search(root, searchValue)) std::cout << "Wartość " << searchValue << " została znaleziona w drzewie." << '\n';
    else std::cout << "Wartość " << searchValue << "  nie została znaleziona w drzewie." << '\n';    

    std::cout << "Wyrysowane drzewo: \n";
    printTree(root);

    return 0;
}