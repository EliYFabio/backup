//+------------------------------------------------------------------+
//|                                               NewsMqlFinders.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


bool HasOrdersOnSymbol(string symbol) {
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == symbol) {
           return true;
        }
    }
    return false;
}

void FindPairsWithClosedOrdersInLastHour(double prevhours, int currenttotalorders, string &array[]) {
   if (currenttotalorders<OrdersHistoryTotal()){
    for (int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
        if (OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderCloseTime() > (TimeCurrent()-3600*prevhours)&& OrderProfit()!=0) {
            bool add=true;
            string sym=OrderSymbol();
            int counter=ArraySize(array);
                for (int e=0;e<ArraySize(array);e++){
                  if(array[e]==sym){
                     add=false;
                     //Print("add false");
                  }
                }
                if(add){
                counter+=1;
                ArrayResize(array,counter,4);
                array[counter-1]=sym;
                }
            }
            else{
            continue;
            }
        }
    }
    current_total_orders=OrdersHistoryTotal();
    }
}