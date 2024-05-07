#include <iostream>
// прототип подпрограммы на ассемблере:
extern void deleteWords(char* text, int numbers[], int size);
extern void printDel(int cnt) {
    std::cout << "Real len: " << cnt << std::endl;
}

int main()
{
    char str[255];
    int pos[10], amount;
    std::cout << "Enter text" << std::endl;
    std::cin.getline(str, 255);
    std::cout << "Enter amount of words:";
    std::cin >> amount;
    std::cout << "Enter numbers of words:";
    for (int i = 0; i < amount; i++) {
        std::cin >> pos[i];
    }
    deleteWords(str, pos, amount);
    std::cout << str << std::endl;
    return 0;
}
