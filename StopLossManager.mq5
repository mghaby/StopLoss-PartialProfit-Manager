//+------------------------------------------------------------------+
//|                                              StopLossManager.mq5 |
//|                                        Copyright 2021, Mark Ghaby|
//|                                            http://www.mghaby.com/|
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Mark Ghaby"
#property link      "http://www.mghaby.com/"
#property version   "2.00"

#include <Trade\Trade.mqh>

int lastPosition;
bool lineBool = true;
CTrade trade;

input int targetOne = 30;
input int targetTwo = 50;
input int stopLoss = 40;
input double volumeTargetOneClose = 0.5;
input double volumeTargetTwoClose = 0.5;
input int breakEvenOffset = 2;
input bool InpFridayCloseTrades = false;
input string InpFridayCloseTimeGMT = "21:55";

void OnDeinit(const int reason){
   ObjectDelete(_Symbol, "TP2Buy");
   ObjectDelete(_Symbol, "TP1Buy");
   ObjectDelete(_Symbol, "TP1Sell");
   ObjectDelete(_Symbol, "TP2Sell");
}

//+------------------------------------------------------------------+
void OnTick(){
   double onePip = 10 * SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double targetOneInPips = targetOne * onePip;
   double targetTwoInPips = targetTwo * onePip;
   double stopLossInPips = stopLoss * onePip;
  
   for (int i = PositionsTotal() - 1; i >= 0; i--){
       string symbol = PositionGetSymbol(i);
         if (_Symbol == symbol){
            ulong positionTicket = PositionGetInteger(POSITION_TICKET);
            double positionTP = PositionGetDouble(POSITION_TP);
            double positionOpen = PositionGetDouble(POSITION_PRICE_OPEN);
            double positionVolume = PositionGetDouble(POSITION_VOLUME);
            double positionCurrentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
            datetime targetTimes = PositionGetInteger(POSITION_TIME);
            
            if ((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY){
               while(lineBool){
                 ObjectDelete(_Symbol, "TP2Buy");
                 ObjectDelete(_Symbol, "TP1Buy");
                 ObjectDelete(_Symbol, "TP1Sell");
                 ObjectDelete(_Symbol, "TP2Sell");
                 ObjectCreate(_Symbol, "TP1Buy", OBJ_HLINE, 0, targetTimes, positionOpen + targetOneInPips);
                 ObjectCreate(_Symbol, "TP2Buy", OBJ_HLINE, 0, targetTimes, positionOpen + targetTwoInPips);
                 ObjectSetInteger(0, "TP1Buy", OBJPROP_COLOR, clrOrange);
                 ObjectSetInteger(0, "TP2Buy", OBJPROP_COLOR, clrOrange);
                 lineBool = false;
               }        
            
               if (positionCurrentPrice >= (positionOpen + targetTwoInPips) && ObjectFind(0, "TP2Buy" == 0)){       
                ObjectDelete(_Symbol, "TP2Buy");
                trade.PositionClosePartial(positionTicket, NormalizeDouble((positionVolume * volumeTargetTwoClose), 2), 0);
                lastPosition = positionTicket;
                    
               } else if (positionCurrentPrice >= (positionOpen + targetOneInPips) && ObjectFind(0, "TP1Buy") == 0){
                 ObjectDelete(_Symbol, "TP1Buy");
                 trade.PositionClosePartial(positionTicket, NormalizeDouble((positionVolume * volumeTargetOneClose), 2), 0);
                 trade.PositionModify(positionTicket, (positionOpen + (onePip * breakEvenOffset)), positionTP);
                 lastPosition = positionTicket;    
               }
                  
                  
            } else if ((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL){
               while(lineBool){
                 ObjectDelete(_Symbol, "TP2Buy");
                 ObjectDelete(_Symbol, "TP1Buy");
                 ObjectDelete(_Symbol, "TP1Sell");
                 ObjectDelete(_Symbol, "TP2Sell");
                 ObjectCreate(_Symbol, "TP1Sell", OBJ_HLINE, 0, targetTimes, positionOpen - targetOneInPips);
                 ObjectCreate(_Symbol, "TP2Sell", OBJ_HLINE, 0, targetTimes, positionOpen - targetTwoInPips);
                 ObjectSetInteger(0, "TP1Sell", OBJPROP_COLOR, clrOrange);
                 ObjectSetInteger(0, "TP2Sell", OBJPROP_COLOR, clrOrange);
                 lineBool = false;
               }
            
               if (positionCurrentPrice <= (positionOpen - targetTwoInPips) && ObjectFind(0, "TP2Sell") == 0){
                 ObjectDelete(_Symbol, "TP2Sell");
                 trade.PositionClosePartial(positionTicket, NormalizeDouble((positionVolume * volumeTargetTwoClose), 2), 0);
                 lastPosition = positionTicket;
                    
               } else if (positionCurrentPrice <= (positionOpen - targetOneInPips) && ObjectFind(0, "TP1Sell") == 0){
                 ObjectDelete(_Symbol, "TP1Sell");
                 trade.PositionClosePartial(positionTicket, NormalizeDouble((positionVolume * volumeTargetOneClose), 2), 0);
                 trade.PositionModify(positionTicket, (positionOpen - (onePip * breakEvenOffset)), positionTP);
                 lastPosition = positionTicket;
               }
            }   
            if (lastPosition != positionTicket) lineBool = true;
       }
   }
   
    if (InpFridayCloseTrades && PositionsTotal() > 0 && FridayTimeIsActive()){
      CloseAllPositions();
   }
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Check if Near Market Close GMT (5 mins)                          |
//+------------------------------------------------------------------+
bool FridayTimeIsActive(){
   MqlDateTime dt;

   datetime gmtTime = TimeGMT(dt);
   datetime endTime = StringToTime(TimeToString(gmtTime, TIME_DATE) + " " + InpFridayCloseTimeGMT);

   if (dt.day_of_week == (ENUM_DAY_OF_WEEK)FRIDAY && gmtTime >= endTime){
      return true;
   }
   
   return false;
}
 
//+------------------------------------------------------------------+
//| Close All Positions                                              |
//+------------------------------------------------------------------+
void CloseAllPositions(){
   for (int i = PositionsTotal()-1; i >= 0; i--){
      int ticket = PositionGetTicket(i);
      trade.PositionClose(ticket);
   }
}