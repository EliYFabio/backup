//+------------------------------------------------------------------+
//|                                                Gamma_Scalper.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input double   lot_size=0.01;
input int      period=25;
input double   deviations=1.5;
input int      Max_trades=3;
input double   stop_loss_min_mult=2;
input int      magic = 1234;   
input double   spread_percent =1;
input int      slip=2;
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
   for(int i=0; i<SymbolsTotal(true); i++)
   {
   
   string s = SymbolName(i,true);
   
   if(IsTradeAllowed(s,TimeGMT())==True)
      Operate(s);
   }
  }
//+------------------------------------------------------------------+

void Operate(string symbol)
  {
   double main=iBands(symbol,1,period,deviations,0,0,0,0);
   double upper=iBands(symbol,1,period,deviations,0,0,1,0);
   double lower=iBands(symbol,1,period,deviations,0,0,2,0);
   double uppersl=iBands(symbol,1,period,deviations+1,0,0,1,0);
   double lowersl=iBands(symbol,1,period,deviations+1,0,0,2,0);
   
   int OpenOrderPos=CheckOpenOrders(symbol);
   
   double minstoplevel=MarketInfo(symbol,MODE_STOPLEVEL);
   double vbid    = MarketInfo(symbol,MODE_BID);
   double vask    = MarketInfo(symbol,MODE_ASK);
   double vpoint  = MarketInfo(symbol,MODE_POINT);
   int    vdigits = (int)MarketInfo(symbol,MODE_DIGITS);
   int    vspread = (int)MarketInfo(symbol,MODE_SPREAD);
   int    ticket  = -1;

   
   
   if (OpenOrderPos<0&&((vask-vbid)/vask)<(spread_percent/100)){
         if(vask<=lower){
            ticket = OrderSend(symbol,0,lot_size,vask,slip,NULL,main,NULL,magic,0,clrGreen);
         }else if(vbid>=upper){
            ticket = OrderSend(symbol,1,lot_size,vbid,slip,NULL,main,NULL,magic,0,clrRed);
         }
         
         if(ticket<0){
            Print("OrderSend failed with error #",GetLastError());
         }
         else
            Print("OrderSend placed successfully");
               
         
   }
   else{
      if(OrderSelect( OpenOrderPos, SELECT_BY_POS, MODE_TRADES )==True){
         if(OrderType()==0){
         //Long
         if(vbid>=main){
            if(OrderClose(OrderTicket(),lot_size,vbid,1)==True){
            Print("Order Closed Successfully");
            }
            else
            Print("Order Close error #",GetLastError());
         }
         
         }
         else if(OrderType()==1){
         //Short
         if(vask<=main){
            if(OrderClose(OrderTicket(),lot_size,vask,1)==True){
            Print("Order Closed Successfully");
            }
            else
            Print("Order Close error #",GetLastError());
         
         }
            
         
      
         }
      }
   }
   
  }
  
int CheckOpenOrders(string symbol){ 
        for( int i = 0 ; i < OrdersTotal() ; i++ ) { 
                if(OrderSelect( i, SELECT_BY_POS, MODE_TRADES )==True) 
                {
                if (OrderSymbol() == symbol) 
                  return(i);
                } 
        } 
        
        return(-1); 
} 