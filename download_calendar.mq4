//+------------------------------------------------------------------+
//|                                                      pruebas.mq4 |
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
   // Set up the web request parameters
   string url = "https://nfs.faireconomy.media/ff_calendar_thisweek.csv";
   string filename = "WeekNews.csv";
   string cookie = NULL;
   string referer = NULL;
   int timeout = 5000;
   char data[];
   char response[];
   string headers;
   
   // Make the web request and get the response
   int result = WebRequest("GET", url, cookie, referer, timeout, data,0, response, headers);
   string mResponse = CharArrayToString(response);
   int n_lines = CountNewlines(mResponse);
   
   if (result == 200)
   {
      // Parse the data and write to file
      
      string time;
      int h;
      string lines[] ;
      StringSplit(mResponse, '\n',lines);
      int file_handle = FileOpen(filename, FILE_WRITE|FILE_BIN);
      if (file_handle != INVALID_HANDLE)
      {
         for (int i = 0; i < n_lines; i++) // Skip header row
         {
            StringReplace(lines[i],"-","/");
            string line = lines[i];
            string cols[7];
            StringSplit(lines[i],',',cols);
            int ampm = StringFind(cols[3],"pm",0);
            if (ampm > 0){
            h = int(StringSubstr(cols[3],0,StringFind(cols[3],":",0)));
            if (h<12){
               h+=12;
            }
            Print(h);
            time = StringConcatenate(IntegerToString(h),StringSubstr(cols[3],StringFind(cols[3],":",0),3));
            }else{
            ampm = StringFind(cols[3],"am",0);
            h = int(StringSubstr(cols[3],0,StringFind(cols[3],":",0)));
            
            time = StringSubstr(cols[3],0,ampm);
            if(h<10){
            time = "0"+time;
            }
            if(h>=12){
            time = "00"+StringSubstr(cols[3],2,ampm-2);
            }
            }
            
            time=time+":00";
            
            if(cols[3]=="Time"){
            time="Time";
            }
            
            cols[3]=time;
            line=cols[0]+","+cols[1]+","+cols[2]+","+cols[3]+","+cols[4]+"\r\n";
            FileWriteString(file_handle, line);
         }
         FileClose(file_handle);
         Print("File saved as: ", filename);
      }
      else
      {
         Print("Error saving file: ", GetLastError());
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