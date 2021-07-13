#include <sqlite3.h>
#include <stdio.h>
#include <string>
#include <sstream>
#include <iostream>
#include <fstream>
#include <vector>

class Data_Info
{
public:
    Data_Info();
    void Initial_Table();
    void Insert_ItemTable(std::string barcode, std::string item_name, std::string category,
                          std::string image, int prime_cost, int list_price, int amount);        //插入物品資料的table
    void Insert_TransactionTable(std::string id, std::string barcode, int amount, int price, int state); //插入交易資料的table
    bool Search_ItemTable(std::string time_record, std::string item_name, std::string category,
                          std::string image, int prime_cost, int list_price, int amount);
    
    static std::vector<std::string> cmd_imformation;
    //void test_sql();
    
private:
    static int callback(void *NotUsed, int argc, char **argv, char **azColName);
    bool Run_SQLcommand(const char *);
    sqlite3 *db;
};
//std::vector<std::string>Data_Info::cmd_imformation;
