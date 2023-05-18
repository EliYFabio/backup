//+------------------------------------------------------------------+
//|                                                    arbitraje.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input double lot_size=10;
input double magic = 3333;
input int slippage=1;

double p1;
double p2;
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
   p1=MarketInfo("EURUSD",MODE_ASK)*MarketInfo("USDJPY",MODE_ASK)*1/MarketInfo("EURJPY",MODE_BID);
   p2=1/MarketInfo("EURUSD",MODE_BID)*1/MarketInfo("USDJPY",MODE_BID)*MarketInfo("EURJPY",MODE_ASK);
   
   Print(p1);
   Print(p2);

   if(p1>1){
      OrderSend("EURUSD",OP_BUY,lot_size,MarketInfo("EURUSD",MODE_ASK),slippage,0,0,NULL,magic,0,clrNONE);
      OrderSend("USDJPY",OP_BUY,lot_size*MarketInfo("EURUSD",MODE_ASK),MarketInfo("USDJPY",MODE_ASK),slippage,0,0,NULL,magic,0,clrNONE);
      OrderSend("EURJPY",OP_SELL,MarketInfo("EURUSD",MODE_ASK)*MarketInfo("USDJPY",MODE_ASK)*1/(lot_size),MarketInfo("EURJPY",MODE_BID),slippage,0,0,NULL,magic,0,clrNONE);
   }
   if(p2<1){
      //OrderSend("EURUSD",OP_SELL,lot_size,MarketInfo("EURUSD",MODE_BID),slippage,0,0,NULL,magic,0,clrNONE);
      //OrderSend("USDJPY",OP_SELL,lot_size,MarketInfo("USDJPY",MODE_BID),slippage,0,0,NULL,magic,0,clrNONE);
      //OrderSend("EURJPY",OP_BUY,lot_size,MarketInfo("EURJPY",MODE_ASK),slippage,0,0,NULL,magic,0,clrNONE);
      
      CloseAllTrades(magic);
   }
   
   displaySpread(p1,p2);
  }
//+------------------------------------------------------------------+

void CloseAllTrades(int magic_number) {
    int total_trades = OrdersTotal();  // get total number of open trades
    bool any_remaining = true;

    while (any_remaining) {
        any_remaining = false;

        for (int a = total_trades - 1; a >= 0; a--) {
            if (OrderSelect(a, SELECT_BY_POS, MODE_TRADES)) {
                if (OrderMagicNumber() == magic_number) {
                    bool closed;
                    if(OrderType()%2==0) {
                    closed = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 3, Red);
                    }
                    else{
                    closed = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 3, Red);
                    }
                    
                    if (closed) {
                        any_remaining = true;
                    }
                }
            }
        }

        // If any trades with the specified magic number are still open, wait for 1 second and try again
        if (any_remaining) {
            //Sleep(1000);
            continue;
        }
    }
}

void displaySpread(double bid, double ask) {
    string rectangleName = "mySpreadRectangle";   // Unique name for the rectangle object
    int subWindow = 1;                             // Sub-window to use for display
    int textSize = 10;                             // Size of the text
    string textColor = "Black";                    // Color of the text
    string backgroundColor = "White";              // Color of the rectangle
    string text = "Spread: " + DoubleToString(ask - bid, _Digits) + "   Bid: " + DoubleToString(bid, _Digits) + "   Ask: " + DoubleToString(ask, _Digits);

    // Create the rectangle object if it doesn't exist
    if(!ObjectFind(rectangleName)) {
        ObjectCreate(rectangleName, OBJ_RECTANGLE, subWindow, 0, 0);
    }

    // Update the properties of the rectangle object
    ObjectSet(rectangleName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
    ObjectSet(rectangleName, OBJPROP_XDISTANCE, 10);
    ObjectSet(rectangleName, OBJPROP_YDISTANCE, 20);
    ObjectSet(rectangleName, OBJPROP_COLOR, White);
    ObjectSet(rectangleName, OBJPROP_BACK, true);
    ObjectSet(rectangleName, OBJPROP_SELECTABLE, false);
    ObjectSet(rectangleName, OBJPROP_HIDDEN, false);
    ObjectSet(rectangleName, OBJPROP_WIDTH, StringLen(text) * textSize);
    //ObjectSet(rectangleName, OBJPROP_, textSize * 2);
    ObjectSetText(rectangleName, text, textSize, "Arial", textColor);

    // Redraw the chart to display changes
    ChartRedraw();

}
