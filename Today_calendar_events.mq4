//+------------------------------------------------------------------+
//|                                        Today_calendar_events.mq4 |
//|                        Copyright 2023, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict




void OnStart()
{
   // Set up the web request parameters
   string url = "https://nfs.faireconomy.media/ff_calendar_thisweek.csv";
   string cookie = NULL;
   string referer = NULL;
   int timeout = 5000;
   char data[];
   char response[];
   string headers;
   
   string time;
   int h;
   
   datetime now = TimeGMT();
   
   // Make the web request and get the response
   int result = WebRequest("GET", url, cookie, referer, timeout, data,0, response, headers);
   string mResponse = CharArrayToString(response);
   int n_lines = CountNewlines(mResponse);
   
   if (result == 200)
   {
      // Parse the data and write to file
      
      
      string lines[] ;
      StringSplit(mResponse, '\n',lines);
      
         for (int i = 0; i < n_lines; i++) // Skip header row
         {
         string cols[7];
         StringSplit(lines[i],',',cols);
         int ampm = StringFind(cols[3],"pm",0);
         if (ampm > 0){
         h = int(StringSubstr(cols[3],0,StringFind(cols[3],":",0)-1))+12;
         time = StringConcatenate(IntegerToString(h),StringSubstr(cols[3],StringFind(cols[3],":",0),3));
         }else{
         ampm = StringFind(cols[3],"am",0);
         h = int(StringSubstr(cols[3],0,StringFind(cols[3],":",0)));
         time = StringSubstr(cols[3],0,ampm);
         if(h<10){
         time = "0"+time;
         }
         }
         
         time=time+":00";
         
         int secs = StrToTime(StringConcatenate(StringReplace(cols[2],"-",".")," ",time)) - TimeGMT();
         if (secs>0&&secs<36000){
         Print(cols[0], time);
         }

         }
         
      
   }
   else
   {
      Print("Error downloading file: ", result);
   }
}
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