//+------------------------------------------------------------------+
//|                                                      auto_bt.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
//--- input parameters
input string symbol = "EURUSD";
input int      timeframe = PERIOD_H1;
input datetime start_date = D'2022.01.01';
input datetime end_date = D'2022.01.01';
input string filename = "optimization_results.csv";


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
double parameter_values[][3] = {
    {1.0, 2.0, 3.0},
    {4.0, 5.0, 6.0},
    {7.0, 8.0, 9.0}
};

for (int i = 0; i < ArraySize(parameter_values); i++) {
    double param1 = parameter_values[i][0];
    double param2 = parameter_values[i][1];
    double param3 = parameter_values[i][2];

    // Set the input parameters of your indicator
    SetIndexBuffer(0, param1);
    SetIndexBuffer(1, param2);
    SetIndexBuffer(2, param3);

    // Run the backtest
    int ticket = iCustom(NULL, 0, "Your_Indicator_Name", 0, 0);
    double profit = OrderProfit();

    // Print the results
    Print("Set ", i, ": ", param1, ", ", param2, ", ", param3, " Profit: ", profit);

    // Close the order
    OrderClose(ticket, 0, Bid, 3);
}

   
  }
//+------------------------------------------------------------------+
