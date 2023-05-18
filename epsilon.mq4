//+------------------------------------------------------------------+
//|                                                      epsilon_scalper.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters

//
input double      Lot_size=0.01;
input int      Takeprofit_pips=30;
input int      Stoploss_pips=10;
input ENUM_TIMEFRAMES      MACD_timeframe=PERIOD_D1;
input int      MACD_fast=12;
input int      MACD_slow=26;
input int      MACD_signal=9;
input ENUM_TIMEFRAMES      RSI_timeframe=PERIOD_M1;
input int      RSI_period=14;
input int      RSI_overbought=70;
input int      RSI_oversold=30;
input int      Limit_strat_losses=3;
input int      Wait_minutes=1;
input int      magic=1234;   

int counter=0;
double main_MACD=0.0;
double signal_MACD=0.0;
double RSI=0.0;
string signal="Wait";
string tick_signal;
int int_signal;
double sl;
double tp;
color  arrow_color;
double price;
int slip=1;
int last_trade = 0;
bool trading=false;
int order_counter=0;
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

//get signal
   tick_signal=Signal();
   
   
   //change signal or sleep if needed in strategy
   if (OrderSelect(last_trade,SELECT_BY_TICKET,MODE_HISTORY)==true&&trading){
      if(OrderProfit()>0){
         tick_signal="Wait";
         trading=false;
         counter=0;
         Sleep(60*Wait_minutes);
      }
      else if(OrderType()==0)
      {
      tick_signal="Sell";
      }
      else if(OrderType()==1)
      {
      tick_signal="Buy";
      }
      else if(counter==Limit_strat_losses){
      //wait
      trading=false;
      counter=0;
      tick_signal="Wait";
      Print("Wait");
      Sleep(60*Wait_minutes);
      
    }
      
    }
    
    //Execute buy or sell with tp and sl
   
   if ( counter<Limit_strat_losses && tick_signal!="Wait" && !CheckOpenOrders()){
      if (tick_signal=="Buy")
      {
         int_signal=0;
         arrow_color=clrGreen;
         price=Ask;
         sl=Ask-Ask*Stoploss_pips/10000;
         tp=Ask+Ask*Takeprofit_pips/10000;
      }
      else if (tick_signal=="Sell")
      {
         int_signal=1;
         arrow_color=clrCrimson;
         price=Bid;
         sl=Bid+Bid*Stoploss_pips/10000;
         tp=Bid-Bid*Takeprofit_pips/10000;
      }
      
      last_trade=OrderSend(NULL,int_signal,Lot_size,price,slip,sl,tp,NULL,magic,0,arrow_color);
      counter+=1;
      trading=true;
   }
  }
//+------------------------------------------------------------------+

string Signal()
  {
  
  main_MACD=iMACD(NULL,MACD_timeframe,MACD_fast,MACD_slow,MACD_signal,PRICE_CLOSE,MODE_MAIN,0);
  signal_MACD=iMACD(NULL,MACD_timeframe,MACD_fast,MACD_slow,MACD_signal,PRICE_CLOSE,MODE_SIGNAL,0);
  RSI=iRSI(NULL,RSI_timeframe,RSI_period,PRICE_CLOSE,0);
  
  
  if (0>main_MACD>signal_MACD)
      {
      if(RSI<RSI_oversold)
         signal="Buy";
      else
         signal="Wait";
      }
  else if(signal_MACD>main_MACD>0)
      {
      if(RSI>RSI_overbought)
         signal="Sell";
      else
         signal="Wait";
      }
  else
      signal="Wait";
  
  return(signal);
  
  }
  
bool CheckOpenOrders(){ 
        // We need to scan all the open and pending orders to see if there are any.
        // OrdersTotal returns the total number of market and pending orders.
        // What we do is scan all orders and check if they are of the same symbol as the one where the EA is running.
        for( int i = 0 ; i < OrdersTotal() ; i++ ) { 
                // We select the order of index i selecting by position and from the pool of market/pending trades.
                if(OrderSelect( i, SELECT_BY_POS, MODE_TRADES )==True) 
                {// If the pair of the order is equal to the pair where the EA is running.
                if (OrderMagicNumber() == magic) return(true);
                } 
        } 
        // If the loop finishes it mean there were no open orders for that pair.
        return(false); 
} 