//+------------------------------------------------------------------+
//|                                              BalanceReporter.mq4 |
//|                                                        Fabio Sol |
//|                                      https://github.com/FabioSol |
//+------------------------------------------------------------------+
#property copyright "Fabio Sol"
#property link      "https://github.com/FabioSol"
#property version   "3.00"
#property description "find bot at t.me/MT4BalanceReporterBot"
#property strict

//--- include


#include <stderror.mqh>
#include <stdlib.mqh>

#include <WinUser32.mqh>
#import "user32.dll"

int GetAncestor(int, int);
#define MT4_WMCMD_EXPERTS  33020 
#import


enum GMT{
GMT_12=-12, //GMT-12
GMT_11=-11, //GMT-11
GMT_10=-10, //GMT-10
GMT_9=-9, //GMT-9
GMT_8=-8, //GMT-8
GMT_7=-7, //GMT-7
GMT_6=-6, //GMT-6
GMT_5=-5, //GMT-5
GMT_4=-4, //GMT-4
GMT_3=-3, //GMT-3
GMT_2=-2, //GMT-2
GMT_1=-1, //GMT-1
GMT_0=0, //GMT0
GMT1=1, //GMT+1
GMT2=2, //GMT+2
GMT3=3, //GMT+3
GMT4=4, //GMT+4
GMT5=5, //GMT+5
GMT6=6, //GMT+6
GMT7=7, //GMT+7
GMT8=8, //GMT+8
GMT9=9, //GMT+9
GMT10=10, //GMT+10
GMT11=11, //GMT+11
GMT12=12, //GMT+12
};

enum h{
h1=1, //1:00
h2=2, //2:00
h3=3, //3:00
h4=4, //4:00
h5=5, //5:00
h6=6, //6:00
h7=7, //7:00
h8=8, //8:00
h9=9, //9:00
h10=10, //10:00
h11=11, //11:00
h12=12, //12:00
h13=13, //13:00
h14=14, //14:00
h15=15, //15:00
h16=16, //16:00
h17=17, //17:00
h18=18, //18:00
h19=19, //19:00
h20=20, //20:00
h21=21, //21:00
h22=22, //22:00
h23=23, //23:00
h24=24 //24:00
};


//--- input parameters
input string      Account_name = "default"; //Account name
input h         hour=h16; //Notification Time
input string      chat_id_1 = "5593746528"; //Fabio
input string      chat_id_2 = "1459609743"; //Heber
input string      chat_id_3 = "1584692498"; //Sam
input double      Alert_relative_drawdown= 10.00; //Alert Drawdown percentage
input int         Alert_minutes = 5; // Minutes Between Alerts
input GMT         TimeZone = GMT_6; //Time Zone


string  token="5977725417:AAExqKKH0s_LlPEPilgVL7R7BpNRNKtULgY";

double   last_balance = AccountBalance();
double   last_equity = AccountEquity();
double   last_free_margin = AccountFreeMargin();

int min_counter = 0;

bool sent=False;

string name=Account_name;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   
   if (name == "default"){
      name = IntegerToString(AccountNumber());
   }
   
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
   check_stop_message(chat_id_1);
   check_stop_message(chat_id_2);
   check_stop_message(chat_id_3);
   
   
   if (TimeHour(client_time())==hour && sent==False){
      string mensaje = StringConcatenate("<b>Account:</b>         ",name," %250a" ,"<b>Balance:         </b> ", AccountBalance(),"(",round((AccountBalance()/last_balance-1)*100),"%)"," %250a","<b>Equity:            </b> ",( AccountEquity()),"(",round((AccountEquity()/last_equity-1)*100),"%)"," %250a", "<b>Free Margin: </b> " ,(AccountFreeMargin()),"(",round((AccountFreeMargin()/last_free_margin-1)*100),"%)"," ");
      last_balance = AccountBalance();
      last_equity = AccountEquity();
      last_free_margin = AccountFreeMargin();
      //string mensaje = StringConcatenate("*bold text* \*  text with escaped characters \%2b \(\>\~\);  escape character is \\   \*   	_italic text_");
    
      
      if(chat_id_1 != "0"){
         Telegram(mensaje,chat_id_1);
      }
      if(chat_id_2 != "0"){
         Telegram(mensaje,chat_id_2);
      }
      if(chat_id_3 != "0"){
         Telegram(mensaje,chat_id_3);
      }
      sent=True;
   }
   else if(TimeHour(client_time())!=hour){
   
   sent=False;
   }
   
   
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   //string mensaje = StringConcatenate("*Account* \* ",Account_name," " ,"*Balance* \*",AccountBalance()," ","*Equity* \*  ",AccountEquity()," ", "*Free Margin* \* " ,AccountFreeMargin()," ");
   if (min_counter>=Alert_minutes){
   
   
      if ((AccountEquity()/AccountBalance()-1)<(-Alert_relative_drawdown)){
      
         string mensaje = StringConcatenate("<b>Alert: Drawdown lower than ",Alert_relative_drawdown,"% </b> "," %250a" ,"<b>Account:</b>         ",name," %250a" ,"<b>Balance:         </b> ", AccountBalance(),"(",round((AccountBalance()/last_balance-1)*100),"%)"," %250a","<b>Equity:            </b> ",( AccountEquity()),"(",round((AccountEquity()/last_equity-1)*100),"%)"," %250a", "<b>Free Margin: </b> " ,(AccountFreeMargin()),"(",round((AccountFreeMargin()/last_free_margin-1)*100),"%)"," ");
      
         if(chat_id_1 != "0"){
            Telegram(mensaje,chat_id_1);
         }
         if(chat_id_2 != "0"){
            Telegram(mensaje,chat_id_2);
         }
         if(chat_id_3 != "0"){
            Telegram(mensaje,chat_id_3);
         }
      min_counter=0;
   }
   
   
   }
   else
      min_counter+=1;
  }
//+------------------------------------------------------------------+



void Telegram(string message, string chat_id)
  {
   //get your token from @BotFather
   //string chat_id="5593746528";//get your chat id from @userinfobot
   
   
   string base_url="https://api.telegram.org";
   string cookie=NULL,headers;
   char post[],result[];
   int res;
   
//--- to enable access to the server, you should add URL "https://api.telegram.org"
//--- in the list of allowed URLs (Main Menu->Tools->Options, tab "Expert Advisors"):
   
   string url=base_url+"/bot"+token+"/sendMessage?chat_id="+(chat_id)+"&text="+message+"&parse_mode=HTML" ;
   
//--- Reset the last error code
   ResetLastError();
   
   int timeout=4000; //--- Timeout below 1000 (1 sec.) is not enough for slow Internet connection
   res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
   
//--- Checking errors
   if(res==-1)
     {
      int error_code=GetLastError();
      string error_msg=ErrorDescription(error_code);
      Print("Error in WebRequest. Error code: ",error_code," Error: ",error_msg);
      if(error_code==4060)
        {
         //--- Perhaps the URL is not listed, display a message about the necessity to add the address
         MessageBox("Add the address '"+base_url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONERROR);
        }
      else
        {
         MessageBox("Access to the server is not possible.\nError: "+error_msg+"\nCode: "+IntegerToString(error_code),"Error",MB_ICONERROR);
        }
     }
   else
     {
      //--- Load successfully
      //MessageBox("The message sent successfully.\nResult: "+CharArrayToString(result),"Success",MB_ICONINFORMATION);
     }
   
  }
  
  
void check_stop_message(string chat_id)
  {
//---
   string url ="https://api.telegram.org/bot"+token+"/getUpdates?chat_id="+chat_id+"&offset=-1&limit=1";
   string cookie=NULL,headers;
   char post[];
   char result[];
   int res;
   int timeout=5000;
   
   res=WebRequest("GET",url,"accept: application/json",timeout,post,result,headers);
   string json = CharArrayToString(result);
   
   int   find = StringFind(json,"Stop "+name);
   
   bool trading=IsTradeAllowed();
   
   
   
   if (find>0&&trading){
      
      
      
      
      do
      CloseAllTrades();
      while(OrdersTotal()>=1);
      
      int main = GetAncestor(WindowHandle(Symbol(), Period()), 2/*GA_ROOT*/);
      PostMessageA(main, WM_COMMAND,  MT4_WMCMD_EXPERTS,0) ;
      
      Telegram(StringConcatenate("Account ",name," stopped by: ",chat_id," %250a", "<b>Balance:         </b> ",(AccountBalance())), chat_id);
      MessageBox(StringConcatenate("Account ",name," stopped by: ",chat_id," Balance: ",(AccountBalance())));
      }
  
  }
  
void CloseAllTrades()
{
   double price=0;
   int totalTrades = OrdersTotal();
   for (int i = totalTrades - 1; i >= 0; i--)
   {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)){
      if (OrderType() == OP_BUY || OrderType() == OP_SELL)
      {
      if (OrderType()==0){
      price=MarketInfo(OrderSymbol(),MODE_BID);
      
      }else if(OrderType()==1){
      price=MarketInfo(OrderSymbol(),MODE_ASK);
      }
      
      
         if (OrderCloseTime() == 0)
         {
            int result = OrderClose(OrderTicket(), OrderLots(), price, 3, clrNONE);
            if (result == ERR_NO_ERROR)
            {
               Print("Order ", OrderTicket(), " closed successfully");
            }
            else
            {
               Print("Error closing order ", OrderTicket(), ": ", ErrorDescription(result));
            }
         }
      }
      }
   }
}

datetime client_time(){
   return(TimeGMT()+TimeZone*3600);
}