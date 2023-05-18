//+------------------------------------------------------------------+
//|                                               NewsStrategies.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


bool pair (double lotsize,int atrtimeframe,int atrperiod, double mltp_min, double mltp_max, double mltp_grid,int magicnumber,double multiplier, int layers, string currency) {
    if (currency == "USD") {
        string pairs[8] = {"EURUSD", "USDJPY", "GBPUSD", "USDCHF", "USDCAD", "AUDUSD", "NZDUSD","XAUUSD"};
        for(int i=0;i<ArraySize(pairs);i++){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
    }
    return true;
    } else if (currency == "EUR") {
        string pairs[7] = {"EURUSD", "EURJPY", "EURGBP", "EURCHF", "EURAUD", "EURNZD", "EURCAD"};
        for(int i=0;i<ArraySize(pairs);i++){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
    }
    return true;
    } else if (currency == "GBP") {
        string pairs[7] = {"GBPUSD", "GBPJPY", "EURGBP", "GBPAUD", "GBPNZD", "GBPCAD", "GBPCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
    }
    return true;
    } else if (currency == "JPY") {
        string pairs[7] = {"USDJPY", "EURJPY", "GBPJPY", "AUDJPY", "NZDJPY", "CADJPY", "CHFJPY"};
        for(int i=0;i<ArraySize(pairs);i++){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
    }
    return true;
    } else if (currency == "CHF") {
        string pairs[6] = {"USDCHF", "EURCHF", "GBPCHF", "AUDCHF", "NZDCHF", "CADCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
    }
    return true;
    } else if (currency == "AUD") {
        string pairs[7] = {"AUDUSD", "AUDJPY", "GBPAUD", "EURAUD", "AUDNZD", "AUDCAD", "AUDCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
    }
    return true;
    } else if (currency == "NZD") {
        string pairs[7] = {"NZDUSD", "NZDJPY", "GBPNZD", "EURNZD", "AUDNZD", "NZDCAD", "NZDCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
    }
    return true;
    } else if (currency == "CAD") {
        string pairs[7] = {"USDCAD", "EURCAD", "GBPCAD", "AUDCAD", "NZDCAD", "CADJPY", "CADCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
    }
    return true;
    } 
    return false;
    }
    
bool tester_pair (double lotsize,int atrtimeframe,int atrperiod, double mltp_min, double mltp_max, double mltp_grid,int magicnumber,double multiplier,int layers, string currency) {
    //Print("Tester pair: "+Symbol()+" on "+currency);
    if (currency == "USD") {
        string pairs[8] = {"EURUSD", "USDJPY", "GBPUSD", "USDCHF", "USDCAD", "AUDUSD", "NZDUSD","XAUUSD"};
        for(int i=0;i<ArraySize(pairs);i++){
            //Print("Checking "+pairs[i]);
            //Print(pairs[i]==Symbol());
            if(pairs[i]==Symbol()){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
            }
    }
    return true;
    } else if (currency == "EUR") {
        string pairs[7] = {"EURUSD", "EURJPY", "EURGBP", "EURCHF", "EURAUD", "EURNZD", "EURCAD"};
        for(int i=0;i<ArraySize(pairs);i++){
         //Print("Checking "+pairs[i]);
            //Print(pairs[i]==Symbol());
           if(pairs[i]==Symbol()){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
            }
    }
    return true;
    } else if (currency == "GBP") {
        string pairs[7] = {"GBPUSD", "GBPJPY", "EURGBP", "GBPAUD", "GBPNZD", "GBPCAD", "GBPCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
         //Print("Checking "+pairs[i]);
            //Print(pairs[i]==Symbol());
            if(pairs[i]==Symbol()){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
            }
    }
    return true;
    } else if (currency == "JPY") {
        string pairs[7] = {"USDJPY", "EURJPY", "GBPJPY", "AUDJPY", "NZDJPY", "CADJPY", "CHFJPY"};
        for(int i=0;i<ArraySize(pairs);i++){
         //Print("Checking "+pairs[i]);
            //Print(pairs[i]==Symbol());
            if(pairs[i]==Symbol()){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
            }
    }
    return true;
    } else if (currency == "CHF") {
        string pairs[6] = {"USDCHF", "EURCHF", "GBPCHF", "AUDCHF", "NZDCHF", "CADCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
         //Print("Checking "+pairs[i]);
            //Print(pairs[i]==Symbol());
            if(pairs[i]==Symbol()){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
            }
    }
    return true;
    } else if (currency == "AUD") {
        string pairs[7] = {"AUDUSD", "AUDJPY", "GBPAUD", "EURAUD", "AUDNZD", "AUDCAD", "AUDCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
         //Print("Checking "+pairs[i]);
            //Print(pairs[i]==Symbol());
            if(pairs[i]==Symbol()){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
            }
    }
    return true;
    } else if (currency == "NZD") {
        string pairs[7] = {"NZDUSD", "NZDJPY", "GBPNZD", "EURNZD", "AUDNZD", "NZDCAD", "NZDCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
         //Print("Checking "+pairs[i]);
            //Print(pairs[i]==Symbol());
            if(pairs[i]==Symbol()){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
            }
    }
    return true;
    } else if (currency == "CAD") {
        string pairs[7] = {"USDCAD", "EURCAD", "GBPCAD", "AUDCAD", "NZDCAD", "CADJPY", "CADCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
         //Print("Checking "+pairs[i]);
            //Print(pairs[i]==Symbol());
            if(pairs[i]==Symbol()){
            grid(lotsize,atrtimeframe,atrperiod,mltp_min,mltp_max,mltp_grid,magicnumber,multiplier,layers, pairs[i]);
            }
    }
    return true;
    } 
    return false;
    }

    

void grid(double lotsize,int atrtimeframe,int atrperiod, double mltp_min, double mltp_max, double mltp_grid,int magicnumber,double multiplier,int numLayers, string symbol)
   {  
      
   int counter=0;
   //Print("grid on :" + symbol);
   if (!HasOrdersOnSymbol(symbol)){
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
}