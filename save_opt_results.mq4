//+------------------------------------------------------------------+
//|                                             save_opt_results.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   // Define the file name and path
string file_name = "optimization_results.csv";
string file_path = TerminalInfoString(TERMINAL_DATA_PATH) + "\\MQL4\\Files\\" + file_name;

// Open the file for writing
int file_handle = FileOpen(file_path, FILE_WRITE, ',');

// Write the header row to the file
FileWrite(file_handle, "Parameter 1,Parameter 2,Parameter 3,Profit");

// Loop through the optimization results and write each row to the file
for (int i = 0; i < OptimizationResultsTotal(); i++) {
    double param1 = OptimizationResults(i, "param1");
    double param2 = OptimizationResults(i, "param2");
    double param3 = OptimizationResults(i, "param3");
    double profit = OptimizationResults(i, "profit");

    string row = DoubleToStr(param1, 6) + "," + DoubleToStr(param2, 6) + "," + DoubleToStr(param3, 6) + "," + DoubleToStr(profit, 2);
    FileWrite(file_handle, row);
}

// Close the file
FileClose(file_handle);

  }
//+------------------------------------------------------------------+
