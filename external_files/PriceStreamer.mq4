//+------------------------------------------------------------------+
//|                                                  PriceStream.mq4 |
//|                                              Engr. Chuks Alimele |
//|                                           chuksalimele@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Engr. Chuks Alimele"
#property link      "chuksalimele@gmail.com"
#property version   "1.00"
#property strict

int ExtPipe=-1;
struct MarketPrice {
   string symbol;
   double bid;
   double ask;
};

MarketPrice prices [47];

string PRICE_PIPE_PATH = "\\\\.\\pipe\\price_local_route";

bool isPipeOpen = false;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer

   //EventSetTimer(10);
   EventSetMillisecondTimer(50);
   
   string suffix = StringSubstr(Symbol(), 6);
      
   prices[0].symbol = "EURUSD" + suffix;
   prices[1].symbol = "GBPUSD" + suffix;
   prices[2].symbol = "AUDUSD" + suffix;
   prices[3].symbol = "NZDUSD" + suffix;
   prices[4].symbol = "ZARUSD" + suffix;
   prices[5].symbol = "INRUSD" + suffix;
   prices[6].symbol = "USDJPY" + suffix;
   prices[7].symbol = "USDCHF" + suffix;
   prices[8].symbol = "USDCAD" + suffix;
   prices[9].symbol = "USDHKD" + suffix;
   prices[10].symbol = "USDSGD" + suffix;
   prices[11].symbol = "EURCHF" + suffix;
   prices[12].symbol = "EURJPY" + suffix;
   prices[13].symbol = "EURGBP" + suffix;   
   prices[14].symbol = "EURAUD" + suffix;
   prices[15].symbol = "EURCAD" + suffix;
   prices[16].symbol = "EURNZD" + suffix;
   prices[17].symbol = "GBPJPY" + suffix;
   prices[18].symbol = "GBPCHF" + suffix;
   prices[19].symbol = "GBPAUD" + suffix;
   prices[20].symbol = "GBPNZD" + suffix;
   prices[21].symbol = "GBPCAD" + suffix;
   prices[22].symbol = "AUDCAD" + suffix;
   prices[23].symbol = "AUDJPY" + suffix;
   prices[24].symbol = "AUDCHF" + suffix;
   prices[25].symbol = "NZDJPY" + suffix;
   prices[26].symbol = "NZDCHF" + suffix;
   prices[27].symbol = "ZAREUR" + suffix;
   prices[28].symbol = "ZARGBP" + suffix;
   prices[29].symbol = "USDTRY" + suffix;
   prices[30].symbol = "USDSEK" + suffix;
   prices[31].symbol = "USDRUB" + suffix;
   prices[32].symbol = "USDDKK" + suffix;
   prices[33].symbol = "GBPZAR" + suffix;
   prices[34].symbol = "GBPSEK" + suffix;
   prices[35].symbol = "GBPPLN" + suffix;
   prices[36].symbol = "GBPDKK" + suffix;
   prices[37].symbol = "EURZAR" + suffix;
   prices[38].symbol = "EURTRY" + suffix;
   prices[39].symbol = "CADCHF" + suffix;
   prices[40].symbol = "CADJPY" + suffix;
   prices[41].symbol = "GBPTRY" + suffix;
   prices[42].symbol = "CHFJPY" + suffix;
   prices[43].symbol = "TRYJPY" + suffix;
   prices[44].symbol = "XAUUSD" + suffix;
   prices[45].symbol = "XBRUSD" + suffix;
   prices[46].symbol = "XAGUSD" + suffix;
   
        
   
   openPipe();
   
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
   
  }
  
string refactorSymbol(string symbol){
   
   symbol = StringSubstr(symbol, 0, 6);
   
   int index = StringFind(symbol,"/",0);
   if(index>-1){
      return symbol;
   }
   
   symbol = StringSubstr(symbol,0,3)+"/"+StringSubstr(symbol,3,3);
   
   return symbol;
   
}

bool openPipe(){
   
   //--- wait for pipe server
   
   bool bfirst=true;
   
   while(!IsStopped())
     {
      ExtPipe=FileOpen(PRICE_PIPE_PATH,FILE_READ|FILE_WRITE|FILE_BIN|FILE_ANSI);
      if(ExtPipe>=0)
         break;
      if(bfirst)
        {
         bfirst=false;
         Print("Client: waiting for pipe server");
        }
      Sleep(250);
     }
   
   if(IsStopped())
      return false;
   
   Print("Client: pipe opened");
   
   isPipeOpen = true;
   
   return true;

}
  
void sendQuote(string data){
   
   data +="\n";
    
   uint   size_str=StringLen(data);
   
   if(FileWriteString(ExtPipe,data,size_str)<size_str)
     {
      Print("Client: failed to send quote [",GetLastError(),"]");
      isPipeOpen = false;
      openPipe(); 
      return;
     }
   FileFlush(ExtPipe);
   FileSeek(ExtPipe,0,SEEK_SET);//come back

}
  
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   
      if(isPipeOpen == false){
         return;
      }
   
      string data;
      string symbol;
       int len = ArrayRange(prices, 0);
       for(int i=0; i < len; i++){
         
         double bid    = MarketInfo(prices[i].symbol, MODE_BID);
         double ask    = MarketInfo(prices[i].symbol, MODE_ASK);
         
         if(bid != prices[i].bid){
            
            prices[i].bid = bid;
            symbol = refactorSymbol(prices[i].symbol);
            data = symbol + "="+DoubleToStr(bid)+"="+DoubleToStr(ask); 
                        
            sendQuote(data); //send the quote through the pipe      
            
         }
         
         
       }
   
  }
//+------------------------------------------------------------------+
