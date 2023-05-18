//+------------------------------------------------------------------+
//|                                                    SlotStats.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input bool random_gale=True;
input int magic=1234;

input double stopLoss = 40;
input double takeProfit = 45;
input double multiplier = 2;
input double InitialLot=1;

double price;
int type;
double sl;
double tp;
double lotSize;
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
if (!CheckOpenTrades()){
   if(GetLastTradeProfit()<0){
      ContinueChain();
   }else{
      StartNewChain();
   }
   
   
}

   
  }
//+------------------------------------------------------------------+

bool CheckOpenTrades() {
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() == Symbol() && (OrderType() == OP_BUY || OrderType() == OP_SELL)) {
                return true;
            }
        }
    }

    return false;
}

double GetLastTradeProfit() {
    if (OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS, MODE_HISTORY)) {
        return OrderProfit();
    } else {
        Print("Failed to select last order with error ", GetLastError());
        return 0.0;
    }
}
void StartNewChain() {
    type = MathRand() % 2 == 0 ? OP_BUY : OP_SELL;
    
    lotSize=InitialLot;
    
    if (type==OP_BUY){
      price=Ask;
      sl=price-stopLoss/10000;
      tp=price+takeProfit/10000;
    }else{
      price=Bid;
      sl=price+stopLoss/10000;
      tp=price-takeProfit/10000;
    }

    int ticket = OrderSend(Symbol(), type, lotSize, price, 3, sl, tp, "NewChain", 0, 0, Green);
    if (ticket == -1) {
        Print("OrderSend failed with error #", GetLastError());
    }
}

void ContinueChain() {
   
   if (random_gale){
      type = MathRand() % 2 == 0 ? OP_BUY : OP_SELL;
   }

   if (type==OP_BUY){
      price=Ask;
      sl=price-stopLoss/10000;
      tp=price+takeProfit/10000;
    }else{
      price=Bid;
      sl=price+stopLoss/10000;
      tp=price-takeProfit/10000;
    }  
    
    lotSize*=multiplier;

    int ticket = OrderSend(Symbol(), type, lotSize, price, 3, sl, tp, "ContinueChain", 0, 0, Blue);
    if (ticket == -1) {
        Print("OrderSend failed with error #", GetLastError());
        lotSize/=multiplier;
        lotSize-=0.01;
        }
}



