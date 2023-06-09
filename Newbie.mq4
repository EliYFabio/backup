//+------------------------------------------------------------------+
//|                                                       Newbie.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

input float PrevHours=1;
input int layers=7;
input double multiplier=2;
input int MagicNumber=111;

input double Mltp_grid=5;
input double Mltp_max=5;
input double Mltp_min=.01;

input double lot_size=0.01;

string url = "https://nfs.faireconomy.media/ff_calendar_thisweek.csv";


int current_total_orders=OrdersHistoryTotal();
bool strategy;
bool downloaded=false;
datetime NextEvent=0;
datetime SecondNextEvent=0;
int window=60*5;

//+------------------------------------------------------------------+
//| Expert initialization function                                 |
//+------------------------------------------------------------------+

int OnInit()
  {
//---
//download newsdata
   downloaded=download_week_data();
// find next upcoming event
   NextEvent=FindNearestFutureDate(TimeGMT());
// find second upcoming event
   SecondNextEvent=FindNearestFutureDate(NextEvent);
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
// check of an order has been closed
   string closed[];
   FindPairsWithClosedOrdersInLastHour(closed);
   
   
// check if it should download new information
   CheckInfo();
   //TO DO: Checar horario de fx (GTM 0 DOMINGO22-VIERNES21)
   
// check if an event has passed (in order to get the next one)
   CheckEvent();
   
// check if the current hour is in range of the next event
   if(trigger()){
      Print("news time");
      //make an array for the symbols wich will be traded
      string symarray[];
            
      // get all symbols wich have news on the next event time and saves them on the symarray
      GetSymbolsOnNews(NextEvent,symarray);
   
      // variable to make sure the grid on the symbol is being made
      bool GridMade=true;
      
      // variable to make sure all grids on all symbols are being made
      strategy=true;
      
      // loop through the array with the symbols on news 
      for (int i = 0; i < ArraySize(symarray);i++){
         // run the function that execute the grid strategy on each pair that contains the symbol
         GridMade=pair(symarray[i]);
         
         // check if the function succeeded 
         if(!GridMade){
            // if it did not succeed at least one time "strategy" id set to false
            strategy=false;
         }
         
      }
   }
   
   //continue to next event only if all grids succeded 
   if(strategy){
      NextEvent=0;
      }
   
   
   // if there hastn been a trigger on the tick, this variable will be the pair of the last order closed
   for(int i=0; i<ArraySize(closed);i++){
      // close all of its orders
      CloseOrdersBySymbol(closed[i]);
      
      
      // cancel the pending orders
      CancelAllPendingOrders(closed[i]);
   }
   
   
   
   }

   
  
//+------------------------------------------------------------------+





bool download_week_data()
   {
   // Set up the web request parameters
   string filename = "WeekNews.csv";
   string cookie = NULL;
   string referer = NULL;
   int timeout = 5000;
   char data[];
   char response[];
   string headers;
   
   // Make the web request and get the response
   int result = WebRequest("GET", url, cookie, referer, timeout, data,0, response, headers);
   string mResponse = CharArrayToString(response);
   int n_lines = CountNewlines(mResponse);
   
   if (result == 200)
   {
      // Parse the data and write to file
      
      string time;
      int h;
      string lines[] ;
      StringSplit(mResponse, '\n',lines);
      int file_handle = FileOpen(filename, FILE_WRITE|FILE_BIN);
      if (file_handle != INVALID_HANDLE)
      {
         for (int i = 0; i < n_lines; i++) // Skip header row
         {
            string line = lines[i];
            string cols[7];
            StringSplit(lines[i],',',cols);
            
            if(cols[2]!="Date"){
               string datearr[3];
               StringSplit(cols[2],'-',datearr);
               cols[2]=datearr[2]+"."+datearr[0]+"."+datearr[1]+" ";
               }
            
            int ampm = StringFind(cols[3],"pm",0);
            if (ampm > 0){
            h = int(StringSubstr(cols[3],0,StringFind(cols[3],":",0)));
            if (h<12){
               h+=12;
            }
            time = StringConcatenate(IntegerToString(h),StringSubstr(cols[3],StringFind(cols[3],":",0),3));
            }else{
            ampm = StringFind(cols[3],"am",0);
            h = int(StringSubstr(cols[3],0,StringFind(cols[3],":",0)));
            
            time = StringSubstr(cols[3],0,ampm);
            if(h<10){
            time = "0"+time;
            }
            if(h>=12){
            time = "00"+StringSubstr(cols[3],2,ampm-2);
            }
            }
            
            time=time+":00";
            
            if(cols[3]=="Time"){
            time="Time";
            }
            
            cols[3]=time;
            line=cols[0]+","+cols[1]+","+cols[2]+cols[3]+","+cols[4]+"\r\n";
            FileWriteString(file_handle, line);
         }
         FileClose(file_handle);
         Print("File saved as: ", filename);
      }
      else
      {
         Print("Error saving file: ", GetLastError());
         return false;
      }
      return true;
   }
   else
   {
      Print("Error downloading file: ", result);
      return false;
   }
}

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

void CheckInfo(){
   
   if(downloaded){
      if(TimeDayOfWeek(TimeGMT())==7){
         downloaded=false;
         }
   }
   else{
      if(TimeDayOfWeek(TimeGMT())==1){
         downloaded=download_week_data();
         Print("downloading new data");
         }
   }
   }

datetime FindNearestFutureDate(datetime currentTime)
{
    // Abrir el archivo CSV
    string csvFile="WeekNews.csv";
    int fileHandle = FileOpen(csvFile, FILE_CSV|FILE_READ);
    if(fileHandle == INVALID_HANDLE)
    {
        Print("Error al abrir el archivo CSV: ", GetLastError());
        return 0;
    }
    
    
    // Variables para almacenar la fecha más cercana encontrada
    datetime nearestDate = 0;
    string nearestDateString = "";
    
    // Leer el archivo CSV línea por línea
    string line;
    int lineCount = 0;
    while(FileIsEnding(fileHandle) == false)
    {
        // Leer la siguiente línea del archivo CSV
        line = FileReadString(fileHandle, CHAR_MAX);
        
        // Incrementar el contador de líneas
        lineCount++;
        
        // Saltar la primera línea si es un encabezado
        if(lineCount == 1 && StringFind(line, "Date") == 0)
        {
            continue;
        }
        
        // Obtener la fecha de la columna 3
        string dateString = StringSubstr(line, 20, 19);
        
        // Convertir la fecha en formato `YYYY.MM.DD HH:MM:SS` a Unix timestamp
        datetime date = StrToTime(dateString);
        
        // Verificar si la fecha es mayor que el tiempo actual y es la primera fecha mayor encontrada,
        // o si la fecha es mayor que el tiempo actual y es más cercana que la fecha anteriormente encontrada
        if(date > currentTime && (nearestDate == 0 || date - currentTime < nearestDate - currentTime))
        {
            nearestDate = date;
            nearestDateString = dateString;
        }
    }
    
    // Cerrar el archivo CSV
    FileClose(fileHandle);
    
    // Verificar si se encontró alguna fecha mayor que la actual
    if(nearestDate != 0)
    {
        // Retornar la fecha más cercana en formato Unix timestamp
        return nearestDate;
    }
    
    // Si no se encontró ninguna fecha mayor que la actual, retornar 0
    return 0;
}

void CheckEvent(){
   if (NextEvent==0){
      
      NextEvent=SecondNextEvent;
      SecondNextEvent=FindNearestFutureDate(NextEvent);
      Print(NextEvent);
   }
   
}


bool trigger(){
   
   if(TimeGMT()>=(NextEvent-3600*PrevHours)&&TimeGMT()<(NextEvent-(3600*PrevHours-window))){
      Print("triggered");
      return true;
      }
   else{
      return false;
   }
}

bool GetSymbolsOnNews(datetime Newsdate, string &array[])
{
    // Abrir el archivo CSV
    string csvFile="WeekNews.csv";
    int fileHandle = FileOpen(csvFile, FILE_CSV|FILE_READ);
    if(fileHandle == INVALID_HANDLE)
    {
        Print("Error al abrir el archivo CSV: ", GetLastError());
        return false;
    }
    
    int counter=0;
    
    
    // Leer el archivo CSV línea por línea
    string line;
    int lineCount = 0;
    while(FileIsEnding(fileHandle) == false)
    {
        // Leer la siguiente línea del archivo CSV
        line = FileReadString(fileHandle, CHAR_MAX);
        
        // Incrementar el contador de líneas
        lineCount++;
        
        // Saltar la primera línea si es un encabezado
        if(lineCount == 1 && StringFind(line, "Date") == 0)
        {
            continue;
        }
        
        string cell[4];
        
        StringSplit(line,',',cell);
        // Obtener la fecha de la columna 3
        string dateString = cell[2];
        
        
        // Convertir la fecha en formato `YYYY.MM.DD HH:MM:SS` a Unix timestamp
        datetime date = StrToTime(dateString);
        
        if(date==Newsdate){
            ArrayResize(array,counter+1,5);
            array[counter]=cell[1];
            counter+=1;
        }
        
    }
    
    // Cerrar el archivo CSV
    FileClose(fileHandle);
    
    return true;  

}



bool pair (string currency) {
    if (currency == "USD") {
        string pairs[7] = {"EURUSD", "USDJPY", "GBPUSD", "USDCHF", "USDCAD", "AUDUSD", "NZDUSD"};
        for(int i=0;i<ArraySize(pairs);i++){
            grid(layers, pairs[i]);
    }
    return true;
    } else if (currency == "EUR") {
        string pairs[7] = {"EURUSD", "EURJPY", "EURGBP", "EURCHF", "EURAUD", "EURNZD", "EURCAD"};
        for(int i=0;i<ArraySize(pairs);i++){
            grid(layers, pairs[i]);
    }
    return true;
    } else if (currency == "GBP") {
        string pairs[7] = {"GBPUSD", "GBPJPY", "EURGBP", "GBPAUD", "GBPNZD", "GBPCAD", "GBPCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
            grid(layers, pairs[i]);
    }
    return true;
    } else if (currency == "JPY") {
        string pairs[7] = {"USDJPY", "EURJPY", "GBPJPY", "AUDJPY", "NZDJPY", "CADJPY", "CHFJPY"};
        for(int i=0;i<ArraySize(pairs);i++){
            grid(layers, pairs[i]);
    }
    return true;
    } else if (currency == "CHF") {
        string pairs[6] = {"USDCHF", "EURCHF", "GBPCHF", "AUDCHF", "NZDCHF", "CADCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
            grid(layers, pairs[i]);
    }
    return true;
    } else if (currency == "AUD") {
        string pairs[7] = {"AUDUSD", "AUDJPY", "GBPAUD", "EURAUD", "AUDNZD", "AUDCAD", "AUDCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(layers, pairs[i]);
    }
    return true;
    } else if (currency == "NZD") {
        string pairs[7] = {"NZDUSD", "NZDJPY", "GBPNZD", "EURNZD", "AUDNZD", "NZDCAD", "NZDCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(layers, pairs[i]);
    }
    return true;
    } else if (currency == "CAD") {
        string pairs[7] = {"USDCAD", "EURCAD", "GBPCAD", "AUDCAD", "NZDCAD", "CADJPY", "CADCHF"};
        for(int i=0;i<ArraySize(pairs);i++){
    grid(layers, pairs[i]);
    }
    return true;
    } 
    return false;
    }
    

    

void grid(int numLayers, string symbol)
   {  
      
   int counter=0;
   Print("grid");
   if (!HasOrdersOnSymbol(symbol)){
   double atr = iATR(symbol,1,50,0); 
   double gridInterval=atr*Mltp_grid;
   double max_sl=atr*Mltp_max;
   double min_sl=atr*Mltp_min;
   int digits = NormalizeDouble(MarketInfo(symbol,MODE_DIGITS),0);
   
   double tpbuy=NormalizeDouble(MarketInfo(symbol,MODE_ASK) + (numLayers * gridInterval),digits)+min_sl;
   double tpsell=NormalizeDouble(MarketInfo(symbol,MODE_BID) - (numLayers * gridInterval),digits)-min_sl;
   
   
   double upperGrid;
   double lowerGrid;
   double stoploss;
   
   
   // Place pending orders for each layer
   for (int i = 1; i <= numLayers; i++) {
   Print("i pending");
     // Calculate grid levels for this layer
     upperGrid = NormalizeDouble(MarketInfo(symbol,MODE_ASK) + (i * gridInterval),digits);
     lowerGrid = NormalizeDouble(MarketInfo(symbol,MODE_BID) - (i * gridInterval),digits);
     
     stoploss=NormalizeDouble((i-numLayers)*(max_sl-min_sl)/(1-numLayers)+min_sl,digits);
     
     bool sent_buy = false;
     bool sent_sell = false; 
     
     do
     {
     // Place sell limit order at upper grid level
     sent_buy=OrderSend(symbol, OP_BUYSTOP, NormalizeDouble(lot_size*pow(multiplier,i),2), upperGrid, 3, upperGrid- stoploss, tpbuy, "Grid Sell"+IntegerToString(i), MagicNumber, 0, Red);
     }
     while(!sent_buy);
     
     do{
     // Place buy limit order at lower grid level
     sent_sell=OrderSend(symbol, OP_SELLSTOP, NormalizeDouble(lot_size*pow(multiplier,i),2), lowerGrid, 3, lowerGrid +stoploss, tpsell, "Grid Buy"+IntegerToString(i), MagicNumber, 0, Blue);
     }
     while(!sent_sell);
     counter=i;
     
   }
   
   
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

bool CloseOrdersBySymbol(string symbol) {
    bool success = false;
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == symbol) {
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
    return success;
}

void FindPairsWithClosedOrdersInLastHour(string &array[]) {
   if (current_total_orders<OrdersHistoryTotal()){
    for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderCloseTime() > (TimeCurrent()-3600*PrevHours)) {
            bool add=true;
            string sym=OrderSymbol();
            int counter=ArraySize(array);
                for (int e=0;e<ArraySize(array);e++){
                  if(array[e]==sym){
                     add=false;
                     Print("add false");
                  }
                }
                if(add){
                counter+=1;
                ArrayResize(array,counter,4);
                array[counter-1]=sym;
                }
            }
        }
    }
    current_total_orders=OrdersHistoryTotal();
    }
}

void CancelAllPendingOrders(string symbol)
{
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == symbol)
         {
         bool delete_sent=false;
         do
            delete_sent=OrderDelete(OrderTicket());
         while(!delete_sent);
         }
      }
   }
}