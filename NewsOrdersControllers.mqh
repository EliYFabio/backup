//+------------------------------------------------------------------+
//|                                        NewsOrdersControllers.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict





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

void CancelSellPendingOrders(string symbol)
{
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == symbol && fmod(OrderType(),2)==1)
         {
         bool delete_sent=false;
         do
            delete_sent=OrderDelete(OrderTicket());
         while(!delete_sent);
         }
      }
   }
}

void CancelBuyPendingOrders(string symbol)
{
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol() == symbol && fmod(OrderType(),2)==0)
         {
         bool delete_sent=false;
         do
            delete_sent=OrderDelete(OrderTicket());
         while(!delete_sent);
         }
      }
   }
}

void CheckOpenOrdersToClosePending()
{
   datetime now = TimeCurrent();
   datetime timeLimit = now - 24 * 3600; 

   for (int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if (OrderOpenTime() > timeLimit && OrderProfit()!=0)
         {
            if (fmod(OrderType(),2)==0)
            {
               Print("canceling sells");
               CancelSellPendingOrders(OrderSymbol());
            }
            else if (fmod(OrderType(),2)==1)
            {
            Print("canceling buys");
               CancelBuyPendingOrders(OrderSymbol());
            }
         }
      }
   }
}

