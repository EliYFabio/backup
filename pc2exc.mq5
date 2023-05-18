//+------------------------------------------------------------------+
//|                                                          pc2.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input double lot_size=0.01;
input double multiplier=1.1;

input double max_stoploss=50;
input double min_stoploss=10;
input double gridInterval=40;
input int   grid_layers=15;
input int MagicNumber=1111;

float max_sl=max_stoploss/10000;
float min_sl=min_stoploss/10000;
int LastSLTicket=0;
int l_osl=-1;
int LastTPTicket=0;
int l_otp=-1;
double upperGrid;
double lowerGrid;
int i;
double stoploss;
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
   if(isFirstFriday() && isTimeBetween(13,30,23,59))
   {
   
   grid(grid_layers);
   
   }
   else{
      CloseAllTrades(MagicNumber);
   }
   l_osl=GetLastOrderClosedByStopLoss(MagicNumber);
   l_otp=GetLastOrderClosedByTakeProfit(MagicNumber);
   
   if (l_osl!=LastSLTicket||l_otp!=LastTPTicket){
      LastSLTicket=l_osl;
      LastTPTicket=l_otp;
      CancelPendingOrdersByMagicNumber(MagicNumber);
      CloseAllTrades(MagicNumber);
      }
   
  }
//+------------------------------------------------------------------+

bool isFirstFriday()
{
    datetime now = TimeCurrent();
    datetime firstDayOfMonth = iTime(_Symbol, PERIOD_D1, 0);
    int dayOfWeek = TimeDayOfWeek(firstDayOfMonth);

    if (dayOfWeek != FRIDAY)
        return false;

    int dayOfMonth = TimeDay(firstDayOfMonth);
    if (dayOfMonth <= 7)
        return true;

    return false;
}

bool isTimeBetween(int h, int m, int H, int M)
{
   int hour=TimeHour(TimeGMT());
   int minute=TimeMinute(TimeGMT());
    
    return (hour == h && minute >= m) || (hour > h && hour < H) || (hour == H && minute <= M);
}

void grid(int numLayers)
   {
   
   
   
   if (NoPendingOrders()){
   // Place pending orders for each layer
   for (i = 1; i <= numLayers-1; i++) {
     // Calculate grid levels for this layer
     upperGrid = Ask + (i * gridInterval)/10000;
     lowerGrid = Bid - (i * gridInterval)/10000;
     
     stoploss=(i-numLayers)*(max_sl-min_sl)/(1-numLayers)+min_sl;
   
     // Place sell limit order at upper grid level
     OrderSend(Symbol(), OP_BUYSTOP, lot_size*pow(multiplier,i), upperGrid, 3, upperGrid- stoploss,0, "Grid Sell", MagicNumber, 0, Red);
     // Place buy limit order at lower grid level
     OrderSend(Symbol(), OP_SELLSTOP, lot_size*pow(multiplier,i), lowerGrid, 3, lowerGrid +stoploss, 0, "Grid Buy", MagicNumber, 0, Blue);
     
   }
   i+=1;
   upperGrid = Ask + (i * gridInterval)/10000;
   lowerGrid = Bid - (i * gridInterval)/10000;
   stoploss=(i-numLayers)*(max_sl-min_sl)/(1-numLayers)+min_sl;
   // Place sell limit order at upper grid level
   
   OrderSend(Symbol(), OP_BUYSTOP, lot_size*pow(multiplier,i), upperGrid, 3, upperGrid-stoploss ,upperGrid + stoploss, "Last grid Sell", MagicNumber, 0, Red);
     // Place buy limit order at lower grid level
   OrderSend(Symbol(), OP_SELLSTOP, lot_size*pow(multiplier,i), lowerGrid, 3, lowerGrid+stoploss , lowerGrid - stoploss, "Last grid Buy", MagicNumber, 0, Blue);
     
   }
}

bool NoPendingOrders()
{
    bool result = true;
    int total = OrdersTotal();
    for (int a = 0; a < total; a++)
    {
        if (OrderSelect(a, SELECT_BY_POS, MODE_TRADES) && OrderType() >= ORDER_TYPE_BUY_STOP)
        {
            result = false;
            break;
        }
    }
    return result;
}



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


void CancelPendingOrdersByMagicNumber(int magicNumber) {
    for (int a = OrdersTotal() - 1; a >= 0; a--) {
        if (!OrderSelect(a, SELECT_BY_POS, MODE_TRADES)) {
            continue;
        }

        if (OrderMagicNumber() == magicNumber) {
            if (OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP || OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT) {
                OrderDelete(OrderTicket());
            }
        }
    }
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
bool IsOrderClosedByTakeProfit(int ticket) {
    double orderOpenPrice = OrderOpenPrice();
    double orderTakeProfit = OrderTakeProfit();
    double currentBid = Bid;
    double currentAsk = Ask;

    // Check if the order is a buy or sell order
    int orderType = OrderType();
    bool isBuyOrder = (orderType == OP_BUY || orderType == OP_BUYLIMIT || orderType == OP_BUYSTOP);
    bool isSellOrder = (orderType == OP_SELL || orderType == OP_SELLLIMIT || orderType == OP_SELLSTOP);

    // Check if the order has TakeProfit set
    if (orderTakeProfit == 0.0) {
        return false;
    }

    // Check if the order has been closed by stop loss
    if (isBuyOrder && currentBid <= orderTakeProfit) {
        return true;
    } else if (isSellOrder && currentAsk >= orderTakeProfit) {
        return true;
    }

    // Check if the order is still open
    if (!OrderSelect(ticket, SELECT_BY_TICKET)) {
        return false;
    }

    // Check if the order is still valid based on the current bid/ask price
    if (isBuyOrder && currentBid < orderOpenPrice) {
        return true;
    } else if (isSellOrder && currentAsk > orderOpenPrice) {
        return true;
    }

    return false;
}

int GetLastOrderClosedByStopLoss(int magicNumber) {
    int lastTicket = 0;
    datetime lastCloseTime = 0;

    for (int a = OrdersTotal() - 1; a >= 0; a--) {
        if (!OrderSelect(a, SELECT_BY_POS, MODE_HISTORY)) {
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

int GetLastOrderClosedByTakeProfit (int magicNumber) {
    int lastTicket = 0;
    datetime lastCloseTime = 0;

    for (int a = OrdersTotal() - 1; a >= 0; a--) {
        if (!OrderSelect(a, SELECT_BY_POS, MODE_HISTORY)) {
            continue;
        }

        if (OrderMagicNumber() != magicNumber) {
            continue;
        }

        if (OrderType() != OP_BUY && OrderType() != OP_SELL) {
            continue;
        }

        if (!IsOrderClosedByTakeProfit(OrderTicket())) {
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