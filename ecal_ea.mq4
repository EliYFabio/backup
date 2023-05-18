#property copyright "Copyright © 2006, Nico Roets."
#property link      ""

string   TradeComment = "News time";
extern int TakeProfit=90;
extern int StopLoss=20;
 

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//---- 
  Comment(TradeComment+" on "+  Symbol()); 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
   {
    Comment(" ");
   } 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
{
  double  cnt=0;
  int  ticket, total;
  
// 
 int H=TimeHour(CurTime()); 
 int M=TimeMinute(CurTime());   
 int S=TimeSeconds(CurTime());

 
 double EnmaF = iMA(Symbol(),1,6,0,MODE_EMA,PRICE_CLOSE,0); //Enter EMA
 double EnmaS = iMA(Symbol(),1,34,0,MODE_EMA,PRICE_CLOSE,0); //Enter EMA
 
 double ExmaF = iMA(Symbol(),5,6,0,MODE_EMA,PRICE_CLOSE,0); //Exit EMA
 double ExmaS = iMA(Symbol(),5,34,0,MODE_EMA,PRICE_CLOSE,0); //Exit EMA
 

///--------------------------------Buy order code begin----------------------------------------------------/// 
   // DayOfWeek 0 = Sondag
   
   // DayOfWeek 2 = Dinsdag
   // DayOfWeek 3 = Woensdag
   // DayOfWeek 4 = Donderdag
   // DayOfWeek 5 = Vrydag
   // DayOfWeek 6 = Saterdag

total  = OrdersTotal(); 
if(total < 1) 
{  
//Maandag = DayOfWeek 1 
//-------------------------------Time slot 1----Begin------------------------------------------------------------//
  if(DayOfWeek()==1 && H==17 && (M<=02 && M>=01))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 1---End---------------------------------------------------------------//

//***************************************************************************************************************//

//-------------------------------Time slot 2----Begin------------------------------------------------------------//
  if(DayOfWeek()==1 && H==19 && (M<=02 && M>=01))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 2---End--------------------------------------------------------------//    
    
// Dinsdag = DayOfWeek 2

//-------------------------------Time slot 2----Begin------------------------------------------------------------//
  if(DayOfWeek()==2 && H==13 && (M<=32 && M>=30))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 2---End--------------------------------------------------------------//    
    
//-------------------------------Time slot 2----Begin------------------------------------------------------------//
  if(DayOfWeek()==2 && H==15 && (M<=02 && M>=01))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 2---End--------------------------------------------------------------//    

  
// Woensdag = DayOfWeek 3 
//-------------------------------Time slot 2----Begin------------------------------------------------------------//
  if(DayOfWeek()==3 && H==13 && (M<=32 && M>=30))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       Sleep(120000);
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       Sleep(120000);
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 2---End--------------------------------------------------------------//    
    
//-------------------------------Time slot 2----Begin------------------------------------------------------------//
  if(DayOfWeek()==3 && H==14 && (M<=02 && M>=01))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       Sleep(120000);
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       Sleep(120000);
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 2---End--------------------------------------------------------------//    

//-------------------------------Time slot 3----Begin------------------------------------------------------------//
  if(DayOfWeek()==3 && H==15 && (M<=32 && M>=30))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       Sleep(120000);
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       Sleep(120000);
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 3---End--------------------------------------------------------------//    

// Dondersdag = DayOfWeek 4 

//-------------------------------Time slot 2----Begin------------------------------------------------------------//
  if(DayOfWeek()==4 && H==13 && (M<=32 && M>=30))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 2---End--------------------------------------------------------------//    
    
//-------------------------------Time slot 2----Begin------------------------------------------------------------//
  if(DayOfWeek()==4 && H==15 && (M<=02 && M>=01))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 2---End--------------------------------------------------------------//    

//-------------------------------Time slot 3----Begin------------------------------------------------------------//
  if(DayOfWeek()==4 && H==17 && (M<=02 && M>=01))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 3---End--------------------------------------------------------------//    

// Vrydag = DayOfWeek 5 
//-------------------------------Time slot 2----Begin------------------------------------------------------------//
  if(DayOfWeek()==5 && H==14 && (M<=17 && M>=15))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 2---End--------------------------------------------------------------//    
    
//-------------------------------Time slot 2----Begin------------------------------------------------------------//
  if(DayOfWeek()==5 && H==14 && (M<=47 && M>=45))
    {
       if(EnmaF > EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_BUY,1.0,Ask,0,Ask-StopLoss*Point,Ask+TakeProfit*Point,"Buy Expert",55,0,Aqua); 
       }
    
       if(EnmaF < EnmaS)
       {
       ticket=OrderSend(Symbol(),OP_SELL,1.0,Bid,0,Bid+StopLoss*Point,Bid-TakeProfit*Point,"Sell Expert",56,0,Yellow); 
       }
      OrderPrint();
    
    return(0);
    }
//-------------------------------Time slot 2---End--------------------------------------------------------------//    


}

//-------------------------------Close orders with Exit Moving averages-----------------------------------------//
for (cnt=0; cnt<OrdersTotal(); cnt++) 
     {
       if (OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES)) 
       {
///-------------------------------------------------------------------------------------------------------///           
             if (OrderType()==OP_BUY)
             {
             if (ExmaF < ExmaS)
             {
             OrderClose(OrderTicket(),OrderLots(),Bid,0,DodgerBlue);
             PlaySound("alert.wav");
             }
             return(0);
             }
///-------------------------------------------------------------------------------------------------------///           
             if (OrderType()==OP_SELL) 
             {
             if (ExmaF > ExmaS)
             {
             OrderClose(OrderTicket(),OrderLots(),Ask,0,DodgerBlue);
             PlaySound("alert.wav");
             }
             return(0);
             }
///-------------------------------------------------------------------------------------------------------///           
        } 
     } 
return(0); 
 
 
}
//+------------------------------------------------------------------+

