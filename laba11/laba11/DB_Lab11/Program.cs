using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SQLite;
using System.IO;

namespace DB_Lab11
{
    class Program
    {
        static void Main(string[] args)
        {
            zz:
            Console.WriteLine("__________________________________________");
            Console.WriteLine("1 | - Вывести список клиентов магазина");
            Console.WriteLine("__________________________________________");
            Console.WriteLine("2 | - Удалить клиента из списка");
            Console.WriteLine("__________________________________________");
            Console.WriteLine("3 | - Изменить клиента из списка");
            Console.WriteLine("__________________________________________");
            Console.WriteLine("4 | - Добавить клиента из списка");
            Console.WriteLine("__________________________________________");


            int number = Convert.ToInt32(Console.ReadLine());
                switch (number)
                {
                    case 1:
                        Select();
                        break;
                    case 2:
                        Delete();
                        break;
                    case 3:
                        Update();
                        break;
                    case 4:
                        Insert();
                        break;
                    default:
                        Console.WriteLine("default");
                        break;
                }

            goto zz;

            void Insert()
            {
                Console.Write("Добавим клиента нашего магазина в БД: ");
                string cityName = Console.ReadLine();

                using (SQLiteConnection Connect = new SQLiteConnection(@"Data Source=D:\Учёба\3 curs\2 сем\DB\laba11\\Shop.db; Version=3;"))
                {
                    string commandText = "INSERT INTO [Clients] ([name]) VALUES(@name)";
                    SQLiteCommand Command = new SQLiteCommand(commandText, Connect);
                    Command.Parameters.AddWithValue("@name", cityName);
                    Connect.Open();
                    Command.ExecuteNonQuery();
                    Connect.Close();
                }
            }


            void Select()
            {
                List<string> cityList = new List<string>();
                using (SQLiteConnection Connect = new SQLiteConnection(@"Data Source=D:\Учёба\3 curs\2 сем\DB\laba11\\Shop.db; Version=3;"))
                {
                    try
                    {
                        Connect.Open();
                        SQLiteCommand Command = new SQLiteCommand
                        {
                            Connection = Connect,
                            CommandText = @"SELECT * FROM Clients"
                        };
                        SQLiteDataReader sqlReader = Command.ExecuteReader();
                        string _dbname = null;
                       // string _dbDescript = null;
                        string _dbId = null;
                        while (sqlReader.Read()) 
                        {
                            _dbname = sqlReader["name"].ToString();
                            //_dbDescript = sqlReader["description"].ToString();
                            _dbId = sqlReader["id"].ToString();
                            cityList.Add(_dbId + " " + _dbname);
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                    }
                    finally
                    {
                        Connect.Close();
                    }
                }

                foreach (var list in cityList)
                    Console.WriteLine(list);
            }
            


            void Update()
            {
                using (SQLiteConnection Connect = new SQLiteConnection(@"Data Source=D:\Учёба\3 curs\2 сем\DB\laba11\\Shop.db; Version=3;"))
                {
                    string commandText = "UPDATE [Clients] SET [name] = @value WHERE [id] = @id";
                    SQLiteCommand Command = new SQLiteCommand(commandText, Connect);
                    Console.WriteLine("Введите id клиента для замены");
                    var id = Console.ReadLine();
                    Console.WriteLine("Введите новое имя клиента");
                    var city = Console.ReadLine();
                    Command.Parameters.AddWithValue("@value", city);
                    Command.Parameters.AddWithValue("@id", id);
                    Connect.Open();
                    Int32 _rowsUpdate = Command.ExecuteNonQuery();
                    Console.WriteLine("Обновлено строк: " + _rowsUpdate);
                    Connect.Close();
                }
            }

            void Delete()
            {
                using (SQLiteConnection Connect = new SQLiteConnection(@"Data Source=D:\Учёба\3 curs\2 сем\DB\laba11\\Shop.db; Version=3;"))
                {
                    string commandText = "DELETE FROM [Clients] WHERE [id] = @id";
                    SQLiteCommand Command = new SQLiteCommand(commandText, Connect);
                    Console.WriteLine("Введите id для удаления");
                    var id = Console.ReadLine();
                    Command.Parameters.AddWithValue("@id", id);
                    Connect.Open();
                    Command.ExecuteNonQuery();
                    Connect.Close();
                }
            }
        }
    }
}
