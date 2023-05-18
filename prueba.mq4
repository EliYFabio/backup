//+------------------------------------------------------------------+
//|                                                       prueba.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   string url ="https://api.telegram.org/bot5977725417:AAExqKKH0s_LlPEPilgVL7R7BpNRNKtULgY/getUpdates?chat_id=5593746528&offset=-1&limit=1";
   string cookie=NULL,headers;
   char post[];
   char result[];
   int res;
   int timeout=5000;
   
   res=WebRequest("GET",url,"accept: application/json",timeout,post,result,headers);
   string json = CharArrayToString(result);
   
   int   find = StringFind(json,"Stop");
   
   if (find>0){
      MessageBox("Account stopped by");
   }
  
  }
//+------------------------------------------------------------------+
