#include "sql.hpp"
std::vector<std::string> Data_Info::cmd_imformation(0);
Data_Info::Data_Info()
{
    int rc;
    std::string path;
    path = getenv("HOME");
    path += "/Documents/ItemData.db";
    rc = sqlite3_open(path.c_str(), &db);
    if (rc)
    {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
    }
    //clear file
    FILE *fp;
    fp = fopen(path.c_str(), "w");
    fclose(fp);
    
    Initial_Table();
}

int Data_Info::callback(void *NotUsed, int argc, char **argv, char **azColName)
{
    int i;
    
    for (i = 0; i < argc; i++)
    {
        printf("%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL");
        //cmd_imformation.push_back(argv[i] ? argv[i] : "NULL");
        cmd_imformation.push_back(argv[i] ? argv[i] : "NULL");
    }
    printf("\n");
    return 0;
}

bool Data_Info::Run_SQLcommand(const char *sql)
{
    const char *data = "Callback function called";
    int rc;
    char *err_msg = 0;
    
    rc = sqlite3_exec(db, sql, callback, (void *)data, &err_msg);
    if (rc != SQLITE_OK)
    {
        fprintf(stderr, "SQL error: %s\n", err_msg);
        sqlite3_free(err_msg);
        return false;
    }
    else
    {
        fprintf(stdout, "SQL successfully\n");
        return true;
    }
}

void Data_Info::Initial_Table()//初始化DB
{
    //物品資料的table
    std::string item_table = "CREATE TABLE Item	(            \
    Barcode      TEXT     NOT NULL	UNIQUE,   \
    Item_Name    TEXT    NOT NULL,    \
    Category	TEXT	NOT NULL,	\
    Image	BLOB	NOT NULL,	\
    Prime_Cost	INTEGER     NOT NULL,    \
    List_Price	INTEGER     NOT NULL,    \
    Amount	INTEGER		NOT NULL     \
    );";
    Run_SQLcommand(item_table.c_str());
    //交易資料的table
    item_table = "CREATE TABLE Trans (  \
    Time_Record  TEXT     NOT NULL	UNIQUE,   \
    Barcode	TEXT	NOT NULL,	\
    Amount	INTEGER     NOT NULL,    \
    Price	INTEGER     NOT NULL,    \
    State	INTEGER		NOT NULL     \
    );";
    Run_SQLcommand(item_table.c_str());
}

void Data_Info::Insert_ItemTable(std::string barcode, std::string item_name, std::string category,
                                 std::string image, int prime_cost, int list_price, int amount)
{
    std::stringstream ss;
    std::string sql, image_path;
    
    image_path = getenv("HOME"); //Get Image path
    image_path += image;
    std::ifstream file(image_path, std::ios::in | std::ios::binary);
    if (!file)
    {
        printf("Cannot find Image File\n");
        return;
    }
    
    file.seekg(0, std::ifstream::end);
    std::streampos size = file.tellg();
    file.seekg(0);
    char *buffer = new char[size];
    file.read(buffer, size);
    
    //Inseet data_information
    sqlite3_exec(db, "BEGIN", NULL, NULL, NULL);
    
    const char *command = "INSERT INTO ITEM (Barcode, Item_Name, Category, Image, Prime_Cost, List_Price,Amount)VALUES (?, ?, ?, ?, ?, ?, ?)";
    
    sqlite3_stmt *stmt = NULL;
    int rc = sqlite3_prepare_v2(db, command, -1, &stmt, NULL);
    
    rc = sqlite3_bind_text(stmt, 1, barcode.c_str(),-1,SQLITE_STATIC);
    rc = sqlite3_bind_text(stmt, 2, item_name.c_str(), -1, SQLITE_STATIC);
    rc = sqlite3_bind_text(stmt, 3, category.c_str(), -1, SQLITE_STATIC);
    rc = sqlite3_bind_blob(stmt, 4, buffer, size, SQLITE_STATIC);
    rc = sqlite3_bind_int(stmt, 5, prime_cost);
    rc = sqlite3_bind_int(stmt, 6, list_price);
    rc = sqlite3_bind_int(stmt, 7, amount);
    
    rc = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    sqlite3_exec(db, "COMMIT", NULL, NULL, NULL);
    //Insert Finished
}

void Data_Info::Insert_TransactionTable(std::string time_record, std::string barcode, int amount, int price, int state)
{
    std::stringstream ss;
    std::string sql;
    ss << "'" << time_record << "','" << barcode << "'," << amount << "," << price << "," << state;
    sql = "INSERT INTO Trans ";
    sql += "VALUES (" + ss.str() + ");";
    Run_SQLcommand(sql.c_str());
}

bool Data_Info::Search_ItemTable(std::string barcode, std::string item_name, std::string category,
                                 std::string image, int prime_cost, int list_price, int amount)
{
    std::string sql = "SELECT EXISTS(SELECT Barcode FROM Item WHERE Barcode=";
    std::stringstream ss;
    ss << "\'" << barcode << "\'";
    sql += ss.str() + ");";
    
    Run_SQLcommand(sql.c_str());
    cmd_imformation.clear();
    
    if (cmd_imformation[0] == "1")
    {              //Item Exist
        return true; //Do nothing
    }
    else
    {                                                                                   //Item Not Exist
        Insert_ItemTable(barcode, item_name, category, image, prime_cost, list_price, amount); //商品不存在就存入商品資料庫
        return false;
    }
}

//void Data_Info::test_sql()
//{
//    Run_SQLcommand("select * from Trans");
//    cmd_imformation.clear();
//}
