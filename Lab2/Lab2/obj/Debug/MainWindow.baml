   M S B A M L   `   `   `  ����?  ;Lab2, Version=1.0.0.0, Culture=neutral, PublicKeyToken=nullclr-namespace:Lab2Lab2  5   	       Lab2.MainWindow   5   	   \ XPresentationFramework, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35W SPresentationCore, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35D 9http://schemas.microsoft.com/winfx/2006/xaml/presentation    5   	   R NSystem.Xaml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     5   	   @d2http://schemas.microsoft.com/expression/blend/2008     5   	   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     5   	   $localclr-namespace:Lab2     5   	     � Title$  
MainWindow��5   	   $	��450��6   $	��800��6)   .��5	      �  � RowDefinitions 5
   
   �� 5      6   �� 5      $
��auto �6   6,    � ColumnDefinitions 5   
   �� 5      6!   �� 5      6!   �� 5      6!   .+�5   
   &   System.Windows.Controls.DataGrid  -   5        $��datarid��5      $��0��5      $��3��6    $��0��64      AutoGenerateColumns .     CanUserAddRows .     CanUserDeleteRows .     CanUserReorderColumns .     
IsReadOnly .    Columns 5      0  *System.Windows.Controls.DataGridTextColumn  5      ,  &System.Windows.Controls.DataGridColumn	   Header$	 Orders��6%   
   Width5  /System.Windows.Controls.DataGridLengthConverter$
 * 6U   1  +System.Windows.Controls.DataGridBoundColumn   Binding 65   ��  �� Path$ orders�6a     5      $	 Items��6%   $
 * 6T    64   �� $ items�6`     5      $	 Clients��6%   $

 auto 6X    66   �� $ clients�6g   5      �� 5   
   -   5         ��Name$ 	txbLogin1��5      
���   �$��25(�69   $��5 0 0 2q�6G   $��0q�6Y    �� 	MaxLength$ 25��6m   $��0.467,123,8.067,258q�6|   $��1��6�   G� 5   
   -   5         G�Name$ txbPassword1��5      
���   �$��25(�6?   $��5 0 0 2q�6M   $��0q�6_   $��4.467,178,10.067,205q�6s   $��1��6�   �� 5   
   -   5        $ txbLogin��5      
���   �$��25(�68   $��5 0 0 2q�6F   $��0q�6X   $��264.467,166,-0.4,205q�6l   $��1��6�   $��2��6�   �� 5   
   -   5        $
��Back��5   "   $��Delete��6   $��50��6A   $��0��6P   $��0,215,264.067,105.4q�6`   $��2��6}   �� 5    
   -   5        $��Update��5    "   $��Update��6   $��50��6E   $��1��6T   $��0.467,215,0.067,105.4q�6d   �� 5!   
   -   5        $��	Condition��5!   %   $��	Condition��6   $��50��6N   $��1��6]   $��2��6m   $��264.467,215,-0.4,105.4q�6�   5"      5#      