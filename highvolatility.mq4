//+------------------------------------------------------------------+
//|                                               highvolatility.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input double lot_size=0.01;
input double multiplier=1.1;
input double stop_loss=40;
input double gridInterval=100;
input int MagicNumber=1111;
input int    period=50;




int LastSLTicket;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   LastSLTicket=GetLastOrderClosedByStopLoss(MagicNumber);
   CancelPendingOrdersByMagicNumber(MagicNumber);
   
   
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
   
   
   if (istdDev()>0.3){
      if(HasPendingOrdersByMagicNumber(MagicNumber)==false){
         grid(10);
         }
      }
      
   if (GetLastOrderClosedByStopLoss(MagicNumber)!=LastSLTicket){
      LastSLTicket=GetLastOrderClosedByStopLoss(MagicNumber);
      CancelPendingOrdersByMagicNumber(MagicNumber);
      CloseAllTrades(MagicNumber);
      }
  }
//+------------------------------------------------------------------+

double istdDev() {
    double returns[50];
    double sumReturns = 0.0;
    double sumSquaredReturns = 0.0;
    double meanReturns = 0.0;
    double stdDev = 0.0;
    
    // Fill the returns array with the percentage changes in closing prices over the last period bars
    for (int i = 0; i < period; i++) {
        double currentReturn = (i == 0) ? 0.0 : 100*(Close[i] - Close[i - 1]) / Close[i - 1];
        returns[i] = currentReturn;
        sumReturns += currentReturn;
        sumSquaredReturns += pow(currentReturn, 2);
    }
    
    // Calculate the mean return and the standard deviation of the returns
    if (period > 0) {
        meanReturns = sumReturns / period;
        stdDev = sqrt(sumSquaredReturns / period - pow(meanReturns, 2));
    }
    
    return stdDev;
}



void grid(int numLayers)
   {
   
   if (NoPendingOrders()){
   // Place pending orders for each layer
   for (int i = 1; i <= numLayers; i++) {
     // Calculate grid levels for this layer
     double upperGrid = Ask + (i * gridInterval)/10000;
     double lowerGrid = Bid - (i * gridInterval)/10000;
     
   
     // Place sell limit order at upper grid level
     OrderSend(Symbol(), OP_BUYSTOP, lot_size*pow(multiplier,i), upperGrid, 3, upperGrid - stop_loss/10000,0, "Grid Sell", MagicNumber, 0, Red);
     // Place buy limit order at lower grid level
     OrderSend(Symbol(), OP_SELLSTOP, lot_size*pow(multiplier,i), lowerGrid, 3, lowerGrid + stop_loss/10000, 0, "Grid Buy", MagicNumber, 0, Blue);
     Print(upperGrid - stop_loss/10000, upperGrid);
   }
   }
}

bool NoPendingOrders()
{
    bool result = true;
    int total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) && OrderType() >= ORDER_TYPE_BUY_STOP)
        {
            result = false;
            break;
        }
    }
    return result;
}

bool IsOrderClosedByStopLoss(int ticket) {
    double orderOpenPrice = OrderOpenPrice();
    double orderStopLoss = OrderStopLoss();
    double currentBid = Bid;
    double currentAsk = Ask;

    // Check if the order is a buy or sell order
    int orderType = OrderType();
    bool isBuyOrder = (orderType == OP_BUY || orderType == OP_BUYLIMIT || orderType == OP_BUYSTOP);
    bool isSellOrder = (orderType == OP_SELL || orderType == OP_SELLLIMIT || orderType == OP_SELLSTOP);

    // Check if the order has stop loss set
    if (orderStopLoss == 0.0) {
        return false;
    }

    // Check if the order has been closed by stop loss
    if (isBuyOrder && currentBid <= orderStopLoss) {
        return true;
    } else if (isSellOrder && currentAsk >= orderStopLoss) {
        return true;
    }

    // Check if the order is still open
    if (!OrderSelect(ticket, SELECT_BY_TICKET)) {
        return false;
    }

    // Check if the order is still valid based on the current bid/ask price
    if (isBuyOrder && currentAsk < orderOpenPrice) {
        return true;
    } else if (isSellOrder && currentBid > orderOpenPrice) {
        return true;
    }

    return false;
}

   
int GetLastOrderClosedByStopLoss(int magicNumber) {
    int lastTicket = 0;
    datetime lastCloseTime = 0;

    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
            continue;
        }

        if (OrderMagicNumber() != magicNumber) {
            continue;
        }

        if (OrderType() != OP_BUY && OrderType() != OP_SELL) {
            continue;
        }

        if (!IsOrderClosedByStopLoss(OrderTicket())) {
            continue;
        }

        datetime closeTime = OrderCloseTime();
        if (closeTime > lastCloseTime) {
            lastTicket = OrderTicket();
            lastCloseTime = closeTime;
        }
    }

    return lastTicket;
}

void CloseAllTrades(int magic_number) {
    int total_trades = OrdersTotal();  // get total number of open trades
    bool any_remaining = true;

    while (any_remaining) {
        any_remaining = false;

        for (int i = total_trades - 1; i >= 0; i--) {
            if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
                if (OrderMagicNumber() == magic_number) {
                    bool closed = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 3, Red);
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
bool HasPendingOrdersByMagicNumber(int magicNumber) {
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            continue;
        }

        if (OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP || OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT) {
            if (OrderMagicNumber() == magicNumber) {
                return true;
            }
        }
    }

    return false;
}

void CancelPendingOrdersByMagicNumber(int magicNumber) {
    for (int i = OrdersTotal() - 1; i >= 0; i--) {
        if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            continue;
        }

        if (OrderMagicNumber() == magicNumber) {
            if (OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP || OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT) {
                OrderDelete(OrderTicket());
            }
        }
    }
}


