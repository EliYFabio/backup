//+------------------------------------------------------------------+
//|                                                 EasyTelegram.mqh |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Fabio Sol"
#property link      "https://api.telegram.org"
#property strict


#include <string>

int SendMessage(string bot_token,string chat_id, string text)
{
   string url = "https://api.telegram.org/bot"+bot_token+"/sendMessage?chat_id=" + chat_id + "&text=" + text;
   int result = WebRequest(url, NULL, NULL);
   return result;
}

int ReadLatestMessage(string bot_token,string chat_id)
{
   string url = "https://api.telegram.org/bot"+bot_token+"/getUpdates";
   string response;
   int result = WebRequest(url, NULL, response,);
   if (result == 200)
   {
      // Parse the response to retrieve the latest message
   }
   return result;
}

//int SendPicture(string bot_token,string chat_id, string picture_path)
//{
 //  string url = "https://api.telegram.org/bot"+bot_token+"/sendPhoto";
   // Add the necessary parameters and attach the picture
//   int result = WebRequest(url, NULL, NULL);
//   return result;
//}
