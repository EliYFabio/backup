//+------------------------------------------------------------------+
//|                                                        tests.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#include <Stats.mqh>

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
double prices[] = {10.0, 12.0, 15.0, 13.0, 14.0};
double stds[3];
StandardDeviation(prices,stds,3);
for(int i=0;i<3;i++){
Print("sd: ",stds[i]);
}

  }
//+------------------------------------------------------------------+
