//+------------------------------------------------------------------+
//|                                                         ECal.mq4 |
//|                                       Copyright 2006, Nico Roets |
//|                                         http://www.forex-tsd.com |
//|                    Load the American Economic news release dates | 
//|                    and times in GMT at the beginning of the week.|
//+------------------------------------------------------------------+
#property copyright "Copyright 2006, Nico Roets"
#property link      "http://www.forex-tsd.com"
 
extern int MaxTrades=1;
extern double lots=1.0;
extern int StopLoss=25;
extern int TakeProfit=100;
int ID=2600028; 
string   TradeComment = "News time";


int init()
  {
//---- 
  Comment(TradeComment+" on "+  Symbol()); 
//----
   return(0);
  }


void deinit() {
   Comment("");
}
 
int orderscnt(){
int cnt=0;
   for(int i =0;i<OrdersTotal();i++){
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
         if(OrderSymbol()==Symbol() && ID==OrderMagicNumber()){
            cnt++;
         }
      }
   }
   return(cnt);
}
 
int start()
  {
  double sl,tp;
  bool Buy, Sell;
 
  int H=TimeHour(CurTime()); 
  int M=TimeMinute(CurTime());   
  
  double EnmaF = iMA(Symbol(),1,2,0,MODE_EMA,PRICE_CLOSE,0); 
  double EnmaS = iMA(Symbol(),1,15,0,MODE_EMA,PRICE_CLOSE,0);

  Buy = False;
  if (EnmaF>EnmaS)
  Buy = True;
  
  Sell = False;
  if (EnmaF<EnmaS)
  Sell = True;
 
  bool EURx=false, CHFx=false, JPYx=false, GBPx=false;
   
//---EUR------------------------------------------------------------------------------------------------------//   
   
   if (DayOfWeek()==2 && H==17 && (M<=59 && M>=45)) {EURx=true;} else
   if (DayOfWeek()==3 && H==14 && (M<=05 && M>=03)) {EURx=true;} else
   if (DayOfWeek()==3 && H==15 && (M<=35 && M>=33)) {EURx=true;} else
   if (DayOfWeek()==4 && H==13 && (M<=35 && M>=33)) {EURx=true;} else
   if (DayOfWeek()==4 && H==17 && (M<=35 && M>=33)) {EURx=true;} else
   if (DayOfWeek()==5 && H==13 && (M<=35 && M>=33)) {EURx=true;} else
   if (DayOfWeek()==5 && H==15 && (M<=05 && M>=03)) {EURx=true;} 

//------------------------------------------------------------------------------------------------------------//   

//---CHF------------------------------------------------------------------------------------------------------//   
   
   if (DayOfWeek()==2 && H==17 && (M<=59 && M>=45)) {CHFx=true;} else
   if (DayOfWeek()==3 && H==14 && (M<=05 && M>=03)) {CHFx=true;} else
   if (DayOfWeek()==3 && H==15 && (M<=35 && M>=33)) {CHFx=true;} else
   if (DayOfWeek()==4 && H==13 && (M<=35 && M>=33)) {CHFx=true;} else
   if (DayOfWeek()==4 && H==17 && (M<=35 && M>=33)) {CHFx=true;} else
   if (DayOfWeek()==5 && H==13 && (M<=35 && M>=33)) {CHFx=true;} else
   if (DayOfWeek()==5 && H==15 && (M<=05 && M>=03)) {CHFx=true;} 

//------------------------------------------------------------------------------------------------------------//   

//---JPY------------------------------------------------------------------------------------------------------//   
   
   if (DayOfWeek()==2 && H==17 && (M<=59 && M>=45)) {JPYx=true;} else
   if (DayOfWeek()==2 && H==23 && (M<=55 && M>=53)) {JPYx=true;} else
   if (DayOfWeek()==3 && H==23 && (M<=55 && M>=53)) {JPYx=true;} else
   if (DayOfWeek()==4 && H==23 && (M<=35 && M>=33)) {JPYx=true;} else
   if (DayOfWeek()==5 && H==05 && (M<=05 && M>=03)) {JPYx=true;} 

//------------------------------------------------------------------------------------------------------------//   

//---GBP------------------------------------------------------------------------------------------------------//   
   
   if (DayOfWeek()==2 && H==17 && (M<=59 && M>=45)) {GBPx=true;} else
   if (DayOfWeek()==3 && H==10 && (M<=05 && M>=03)) {GBPx=true;} else
   if (DayOfWeek()==5 && H==10 && (M<=35 && M>=33)) {GBPx=true;} 

//------------------------------------------------------------------------------------------------------------//   


 if (EURx)
   { 
  if(Buy && orderscnt()<MaxTrades)
      {
      OrderSend("EURUSDm",OP_BUY,lots,Ask,1,Ask-StopLoss*Point,Ask+TakeProfit*Point,TradeComment,ID,0,DodgerBlue);
      }
  if(Sell && orderscnt()<MaxTrades)
      {
      OrderSend("EURUSDm",OP_SELL,lots,Bid,1,Bid+StopLoss*Point,Bid-TakeProfit*Point,TradeComment,ID,0,Yellow);
      }
   OrderPrint();
   return(0);  
   }
//------------------------------------------------------------------------------------------------------------//   


//------------------------------------------------------------------------------------------------------------//   

 if (CHFx)
   { 
  if(Buy && orderscnt()<MaxTrades)
      {
      OrderSend("USDCHFm",OP_BUY,lots,Ask,1,Ask-StopLoss*Point,Ask+TakeProfit*Point,TradeComment,ID,0,DodgerBlue);
      }
  if(Sell && orderscnt()<MaxTrades)
      {
      OrderSend("USDCHFm",OP_SELL,lots,Bid,1,Bid+StopLoss*Point,Bid-TakeProfit*Point,TradeComment,ID,0,Yellow);
      }
   OrderPrint();
   return(0);  
   }
   
//------------------------------------------------------------------------------------------------------------//   

//------------------------------------------------------------------------------------------------------------//   
 if (JPYx)
   { 
  if(Buy && orderscnt()<MaxTrades)
      {
      OrderSend("USDJPYm",OP_BUY,lots,Ask,1,Ask-StopLoss*Point,Ask+TakeProfit*Point,TradeComment,ID,0,DodgerBlue);
      }
  if(Sell && orderscnt()<MaxTrades)
      {
      OrderSend("USDJPYm",OP_SELL,lots,Bid,1,Bid+StopLoss*Point,Bid-TakeProfit*Point,TradeComment,ID,0,Yellow);
      }
   OrderPrint();
   return(0);  
   }
//------------------------------------------------------------------------------------------------------------//   

//------------------------------------------------------------------------------------------------------------//   
 if (GBPx)
   { 
  if(Buy && orderscnt()<MaxTrades)
      {
      OrderSend("GBPUSDm",OP_BUY,lots,Ask,1,Ask-StopLoss*Point,Ask+TakeProfit*Point,TradeComment,ID,0,DodgerBlue);
      }
  if(Sell && orderscnt()<MaxTrades)
      {
      OrderSend("GBPUSDm",OP_SELL,lots,Bid,1,Bid+StopLoss*Point,Bid-TakeProfit*Point,TradeComment,ID,0,Yellow);
      }
   OrderPrint();
   return(0);  
   }
//------------------------------------------------------------------------------------------------------------//   

 
 return(0);
}

