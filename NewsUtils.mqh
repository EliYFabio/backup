//+------------------------------------------------------------------+
//|                                                    NewsUtils.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

int CountNewlines(string inputString)
   {
    int newlineCount = 0;
    for (int i = 0; i < StringLen(inputString); i++)
    {
        if (inputString[i] == '\n')
        {
            newlineCount++;
        }
    }
    return newlineCount+1;
    }

void CheckEvent(bool onlyhigh){
   if (NextEvent==0){
      
      NextEvent=SecondNextEvent;
      SecondNextEvent=FindNearestFutureDate(csvFile,onlyhigh,NextEvent);
      
   }
   
}


bool trigger(bool onlyhigh,double prevhours){
   
   if(TimeGMT()>=(NextEvent-3600*prevhours)){
      if(TimeGMT()<(NextEvent)){
         //Print("triggered");
         return true;
      }else{
         NextEvent=0;
         CheckEvent(onlyhigh);
         return false;
      }
      }
   else{
      return false;
   }
}
