//+------------------------------------------------------------------+
//|                                                      AtrGrid.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input double lot_size=2;
input double Mltp_grid=2;
input double Mltp_max=2;
input double Mltp_min=.01;
input int atr_period=50;
input ENUM_TIMEFRAMES atr_timeframe=PERIOD_M5;
input int Layers=7;
input double Multiplier=1;
input int MagicNumber=111;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---

   grid(lot_size,atr_timeframe,atr_period,Mltp_min,Mltp_max,Mltp_grid,MagicNumber,Multiplier,Layers,Symbol());
   
  }
//+------------------------------------------------------------------+



void grid(double lotsize,int atrtimeframe,int atrperiod, double mltp_min, double mltp_max, double mltp_grid,int magicnumber,double multiplier,int numLayers, string symbol)
   {  
      
   int counter=0;
   //Print("grid on :" + symbol);
   double atr = iATR(symbol,atrtimeframe,atrperiod,0); 
   double gridInterval=atr*mltp_grid;
   double max_sl=atr*mltp_max;
   double min_sl=atr*mltp_min;
   int digits = NormalizeDouble(MarketInfo(symbol,MODE_DIGITS),0);
   
   double tpbuy=NormalizeDouble(MarketInfo(symbol,MODE_ASK) + (numLayers * gridInterval),digits)+min_sl;
   double tpsell=NormalizeDouble(MarketInfo(symbol,MODE_BID) - (numLayers * gridInterval),digits)-min_sl;
   
   
   double upperGrid;
   double lowerGrid;
   double stoploss;
   
   
   // Place pending orders for each layer
   for (int i = 1; i <= numLayers; i++) {
   //Print("i pending");
     // Calculate grid levels for this layer
     upperGrid = NormalizeDouble(MarketInfo(symbol,MODE_ASK) + (i * gridInterval),digits);
     lowerGrid = NormalizeDouble(MarketInfo(symbol,MODE_BID) - (i * gridInterval),digits);
     
     stoploss=NormalizeDouble((i-numLayers)*(max_sl-min_sl)/(1-numLayers)+min_sl,digits);
     
     bool sent_buy = false;
     bool sent_sell = false; 
     
     do
     {
     // Place sell limit order at upper grid level
     sent_buy=OrderSend(symbol, OP_BUYSTOP, NormalizeDouble(lotsize*pow(multiplier,i),2), upperGrid, 3, upperGrid- stoploss, tpbuy, "Grid Sell"+IntegerToString(i), magicnumber, 0, Red);
     }
     while(!sent_buy);
     
     do{
     // Place buy limit order at lower grid level
     sent_sell=OrderSend(symbol, OP_SELLSTOP, NormalizeDouble(lotsize*pow(multiplier,i),2), lowerGrid, 3, lowerGrid +stoploss, tpsell, "Grid Buy"+IntegerToString(i), magicnumber, 0, Blue);
     }
     while(!sent_sell);
     counter=i;
     
   }
}