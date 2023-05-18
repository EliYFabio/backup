//+------------------------------------------------------------------+
//|                                                       Autopc.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input double    lot_size    = 0.01;
input double    multiplier  = 1.1;
input double    prev_hours  = 1;
input int       MagicNumber = 1111;
input int       delay = 1000;

input double Mltp_grid=2;
input double Mltp_max=4;
input double Mltp_min=1;

int layers=10;

int tickcounter=delay+1;
double upperGrid;
double lowerGrid;
double stoploss;

int secstotrade;
string ban = "";

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
   
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   if(tickcounter>delay){
   secstotrade=GetTimeToNews(false);
   Print("stt: ",secstotrade);
   tickcounter=0;
   }

   bool GridMade;
   string array[];
   double hours = prev_hours;
   
   if(secstotrade<(prev_hours/3600)){
   GetNextSymbolsOnNews(array);
   
   for (int i = 0; i < ArraySize(array);i++){
      GridMade=pair(array[i]);
      Print(array[i]);
      ban=FindLastClosedOrder();
      Print(ban);
      CloseOrdersBySymbol(ban);
      }
      secstotrade=GetTimeToNews(true);
   }
   else{
   tickcounter+=1;
   }
  }
  
//+------------------------------------------------------------------+


int CountNewlines(string inputString)
{
    int newlineCount = 0;
    for (int i = 0; i < StringLen(inputString); i++)
    {
        if (inputString[i] == '\n')
        {
            newlineCount++;
        }
    }
    return newlineCount+1; 
}


void GetNextSymbolsOnNews(string &array[]){

// Set up the web request parameters
   

   string url = "https://nfs.faireconomy.media/ff_calendar_thisweek.csv";
   string cookie = NULL;
   string referer = NULL;
   int timeout = 5000;
   char data[];
   char response[];
   string headers;
   int counter=0;
   string time;
   int h;
   int closest=0;
   bool first=true;
   datetime now = TimeGMT();
   
   // Make the web request and get the response
   int result = WebRequest("GET", url, cookie, referer, timeout, data,0, response, headers);
   string mResponse = CharArrayToString(response);
   int n_lines = CountNewlines(mResponse);
   
   if (result == 200)
   {
      // Parse the data and write to file
      
      
      string lines[] ;
      StringSplit(mResponse, '\n',lines);
      
         for (int i = 0; i < n_lines; i++) // Skip header row
         {
         string cols[7];
         StringSplit(lines[i],',',cols);
         int ampm = StringFind(cols[3],"pm",0);
         if (ampm > 0){
         h = int(StringSubstr(cols[3],0,StringFind(cols[3],":",0)-1))+12;
         time = StringConcatenate(IntegerToString(h),StringSubstr(cols[3],StringFind(cols[3],":",0),3));
         }else{
         ampm = StringFind(cols[3],"am",0);
         h = int(StringSubstr(cols[3],0,StringFind(cols[3],":",0)));
         time = StringSubstr(cols[3],0,ampm);
         if(h<10){
         time = "0"+time;
         }
         }
         
         time=time+":00";
         
         int secs = StrToTime(StringConcatenate(StringReplace(cols[2],"-",".")," ",time)) - TimeGMT();
         if (secs>0&&first)
         {
         closest=secs;
         first=false;
         }
         if (secs>0&&secs<=closest){
         
         ArrayResize(array,counter+1,2);
         array[counter]=cols[1];
         counter+=1;
         }

         }
         
      
   }
   else
   {
      Print("Error downloading file: ", result);
   }
   return;
}


int GetTimeToNews(bool mode_second){

// Set up the web request parameters
   

   string url = "https://nfs.faireconomy.media/ff_calendar_thisweek.csv";
   string cookie = NULL;
   string referer = NULL;
   int timeout = 5000;
   char data[];
   char response[];
   string headers;
   int counter=0;
   string time;
   int h;
   int closest=0;
   int secondclosest;
   bool first=true;
   bool second=false;
   datetime now = TimeGMT();
   
   // Make the web request and get the response
   int result = WebRequest("GET", url, cookie, referer, timeout, data,0, response, headers);
   string mResponse = CharArrayToString(response);
   int n_lines = CountNewlines(mResponse);
   
   if (result == 200)
   {
      // Parse the data and write to file
      
      
      string lines[] ;
      StringSplit(mResponse, '\n',lines);
      
         for (int i = 0; i < n_lines; i++) // Skip header row
         {
         string cols[7];
         StringSplit(lines[i],',',cols);
         int ampm = StringFind(cols[3],"pm",0);
         if (ampm > 0){
         h = int(StringSubstr(cols[3],0,StringFind(cols[3],":",0)-1))+12;
         time = StringConcatenate(IntegerToString(h),StringSubstr(cols[3],StringFind(cols[3],":",0),3));
         }else{
         ampm = StringFind(cols[3],"am",0);
         h = int(StringSubstr(cols[3],0,StringFind(cols[3],":",0)));
         time = StringSubstr(cols[3],0,ampm);
         if(h<10){
         time = "0"+time;
         }
         }
         
         time=time+":00";
         
         int secs = StrToTime(StringConcatenate(StringReplace(cols[2],"-",".")," ",time)) - TimeGMT();
         if (secs>0&&first)
         {
        
         closest=secs;
         first=false;
         second=true;
         }
         
         if (closest<secs&&second){
         }
         secondclosest=secs;
         second=false;

         }
         
      
   }
   else
   {
      Print("Error downloading file: ", result);
   }
   if (!mode_second){
   return closest;
   }else {
   return secondclosest;
   }
}



void grid(int numLayers, string symbol)
   {  
      
   int counter=0;
   Print("grid");
   if (!HasOrdersOnSymbol(symbol)&&(symbol!=ban)){
   double atr = iATR(symbol,1,50,0);
   double gridInterval=atr*Mltp_grid;
   double max_sl=atr*Mltp_max;
   double min_sl=atr*Mltp_min;
   int digits = NormalizeDouble(MarketInfo(symbol,MODE_DIGITS),0);
   
   double tpbuy=NormalizeDouble(MarketInfo(symbol,MODE_ASK) + (numLayers * gridInterval),digits)+min_sl;
   double tpsell=NormalizeDouble(MarketInfo(symbol,MODE_BID) - (numLayers * gridInterval),digits)-min_sl;
   
   
   // Place pending orders for each layer
   for (int i = 1; i <= numLayers-1; i++) {
   Print("i pending");
     // Calculate grid levels for this layer
     upperGrid = NormalizeDouble(MarketInfo(symbol,MODE_ASK) + (i * gridInterval),digits);
     lowerGrid = NormalizeDouble(MarketInfo(symbol,MODE_BID) - (i * gridInterval),digits);
     
     stoploss=NormalizeDouble((i-numLayers)*(max_sl-min_sl)/(1-numLayers)+min_sl,digits);
   
     // Place sell limit order at upper grid level
     OrderSend(symbol, OP_BUYSTOP, NormalizeDouble(lot_size*pow(multiplier,i),2), upperGrid, 3, upperGrid- stoploss, tpbuy, "Grid Sell", MagicNumber, 0, Red);
     // Place buy limit order at lower grid level
     OrderSend(symbol, OP_SELLSTOP, NormalizeDouble(lot_size*pow(multiplier,i),2), lowerGrid, 3, lowerGrid +stoploss, tpsell, "Grid Buy", MagicNumber, 0, Blue);
     counter=i;
   }
   counter+=1;
   upperGrid = NormalizeDouble(MarketInfo(symbol,MODE_ASK) + (counter * gridInterval),digits);
   lowerGrid = NormalizeDouble(MarketInfo(symbol,MODE_BID) - (counter * gridInterval),digits);
   stoploss=NormalizeDouble(min_sl,digits);
   // Place sell limit order at upper grid level
   
   OrderSend(symbol, OP_BUYSTOP, lot_size*pow(multiplier,counter), upperGrid, 3, upperGrid-stoploss ,upperGrid + stoploss, "Last grid Sell", MagicNumber, 0, Red);
     // Place buy limit order at lower grid level
   OrderSend(symbol, OP_SELLSTOP, lot_size*pow(multiplier,counter), lowerGrid, 3, lowerGrid+stoploss , lowerGrid - stoploss, "Last grid Buy", MagicNumber, 0, Blue);
     
   }
}

bool HasOrdersOnSymbol(string symbol) {
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == symbol) {
           return true;
        }
    }
    return false;
}


bool pair (string currency) {
   Print("Pair");
   Print("currency: ",currency);
    if (currency == "USD") {
        string pairs[7] = {"EURUSD", "USDJPY", "GBPUSD", "USDCHF", "USDCAD", "AUDUSD", "NZDUSD"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(layers, pairs[i]);
    Print(pairs[i]);
    }
    return true;
    } else if (currency == "EUR") {
        string pairs[7] = {"EURUSD", "EURJPY", "EURGBP", "EURCHF", "EURAUD", "EURNZD", "EURCAD"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(layers, pairs[i]);
    Print(pairs[i]);
    }
    return true;
    } else if (currency == "GBP") {
        string pairs[7] = {"GBPUSD", "GBPJPY", "EURGBP", "GBPAUD", "GBPNZD", "GBPCAD", "GBPCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(layers, pairs[i]);
    Print(pairs[i]);
    }
    return true;
    } else if (currency == "JPY") {
        string pairs[7] = {"USDJPY", "EURJPY", "GBPJPY", "AUDJPY", "NZDJPY", "CADJPY", "CHFJPY"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(layers, pairs[i]);
    Print(pairs[i]);
    }
    return true;
    } else if (currency == "CHF") {
        string pairs[6] = {"USDCHF", "EURCHF", "GBPCHF", "AUDCHF", "NZDCHF", "CADCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(layers, pairs[i]);
    Print(pairs[i]);
    }
    return true;
    } else if (currency == "AUD") {
        string pairs[7] = {"AUDUSD", "AUDJPY", "GBPAUD", "EURAUD", "AUDNZD", "AUDCAD", "AUDCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(layers, pairs[i]);
    Print(pairs[i]);
    }
    return true;
    } else if (currency == "NZD") {
        string pairs[7] = {"NZDUSD", "NZDJPY", "GBPNZD", "EURNZD", "AUDNZD", "NZDCAD", "NZDCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(layers, pairs[i]);
    Print(pairs[i]);
    }
    return true;
    } else if (currency == "CAD") {
        string pairs[7] = {"USDCAD", "EURCAD", "GBPCAD", "AUDCAD", "NZDCAD", "CADJPY", "CADCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(layers, pairs[i]);
    Print(pairs[i]);
    }
    return true;
    } 
    return false;
    
    
}

string FindLastClosedOrder() {
    for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderType() <= OP_SELL) {
                return OrderSymbol();
            }
        }
    }
    return ban; // No closed orders found
}

bool CloseOrdersBySymbol(string symbol) {
    bool success = false;
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
               if(OrderType()%2==0){
                if (OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(),MODE_BID), 10, White)) {
                    success = true;
                    }else{
                if (OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(),MODE_ASK), 10, White)) {
                    success = true;    
                    }
                    }
                }
            }
        }
    }
    return success;
}