#include "sql.h"

int main(int argc, char *argv[])
{
    Data_Info item;
    
    item.Insert_ItemTable("47863763", "test", "test1", "/Documents/car.jpg", 100, 100, 100);
    printf("test\n");
    item.Insert_ItemTable("4554", "test", "test1", "/Documents/car.jpg", 100, 100, 100);
    printf("test\n");
    item.Insert_TransactionTable("2017-7-7,21:19", "47863763", 100, 1000, 0);
    printf("test\n");
    
    bool exist = item.Search_ItemTable("4554", "test2", "test1", "/Documents/car.jpg", 200, 222, 40);
    if (exist)
        std::cout << "Item exist" << '\n';
    else
        std::cout << "Item doesn't exist" << '\n';
    
}
