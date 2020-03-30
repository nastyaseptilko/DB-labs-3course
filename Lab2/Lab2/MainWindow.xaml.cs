using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Lab2
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }
        private void Update_Click(object sender, RoutedEventArgs e)
        {
            string connectionString = DataBase.data;

            string sqlExpression1 = $"INSERT INTO [Items] ([name], [description]) VALUES ('{txbLogin1.Text}', '{txbPassword1.Password}')";
            string sqlExpression2 = "SELECT * FROM Clients";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                try
                {
                    connection.Open();

                    if (txbLogin1.Text.ToString() != string.Empty)
                    {
                        if (txbPassword1.Password.Length < 6)
                        {
                            MessageBox.Show(" слишком мало данных!");
                            return;
                        }



                        SqlCommand command2 = new SqlCommand(sqlExpression2, connection);
                        SqlDataReader reader = command2.ExecuteReader();

                        bool flagPerson = false;
                        if (reader.HasRows)
                        {
                            while (reader.Read())
                            {
                                if (txbLogin1.Text == (string)reader.GetValue(1))
                                {
                                    flagPerson = true;
                                    break;
                                }
                            }
                        }
                        reader.Close();


                        if (!flagPerson)
                        {
                            SqlCommand command1 = new SqlCommand(sqlExpression1, connection);
                            command1.ExecuteNonQuery();
                            MessageBox.Show(" Добавление прошло успешно!");

                            
                            Close();

                            txbLogin1.Text = "";
                            txbPassword1.Password = "";
                            
                        }
                        else
                        {
                            MessageBox.Show("Такой пользователь уже существует!");

                            txbLogin.Text = "";
                            txbPassword1.Password = "";
                           
                        }


                    }
                    else
                    {
                        MessageBox.Show("Введите данные!");
                        txbLogin.Text = "";
                        txbPassword1.Password = "";
                        
                    }
                }

                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
            }
        }

        private void Back_Click(object sender, RoutedEventArgs e)
        {
            try
            {


              
                        using (SqlConnection sqlConnection = new SqlConnection(DataBase.data))
                        {
                            sqlConnection.Open();
                            
                               SqlCommand command = new SqlCommand(
                                 $"DELETE FROM Supermarkets WHERE id = 2");
                            command.ExecuteNonQuery();
                    
                        }
                    
            }
            catch (SqlException ex)
            {
                MessageBox.Show(ex.Message);
            }

        }
        private void Condition_Click(object sender, RoutedEventArgs e)
        {

            string connectionString = DataBase.data;
            string sqlExpression = "SELECT * FROM Clients";

            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(connectionString))
                {
                    sqlConnection.Open();

                    if (txbLogin.Text != string.Empty)
                    {
                        SqlCommand sqlCommand = new SqlCommand(sqlExpression, sqlConnection);
                        SqlDataReader reader = sqlCommand.ExecuteReader();

                        Clients tempClients = new Clients();

                        if (reader.HasRows)
                        {
                            // Наличие юзеров
                            bool flagPerson = false;

                            while (reader.Read())
                            {
                                if (txbLogin.Text == (string)reader.GetValue(1) )
                                {
                                    flagPerson = true;
                                    tempClients.id = reader.GetValue(0);
                                    tempClients.name = reader.GetValue(1);
                                    tempClients.bonus = reader.GetValue(2);
                                    tempClients.age = reader.GetValue(3);
                                    MessageBox.Show("Taкой пользователь есть!");
                                    break;

                                }
                                    
                                
                            }
                            reader.Close();

                            if (flagPerson)
                            {
                                // Передать tempUser
                              
                                Close();
                            }
                            else
                            {
                                MessageBox.Show("Такого пользователя нет!");
                                
                            }
                        }
                        else
                        {
                            MessageBox.Show("В базе еще нет пользователей");
                           
                        }
                    }
                    else
                    {
                        MessageBox.Show("Введите данные");
                        
                    }
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }


        }
    }
}
