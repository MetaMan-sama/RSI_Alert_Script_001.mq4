//+------------------------------------------------------------------+
//|                        RSIAlert.mq4                              |
//| Alerts for RSI entering overbought/oversold regions and divergence |
//+------------------------------------------------------------------+
#property strict

// Input parameters
input string TradeSymbol = "EURUSD";        // Symbol for analysis
input ENUM_TIMEFRAMES Timeframe = PERIOD_H1; // Timeframe for analysis
input int RSIPeriod = 14;                   // RSI period
input double OverboughtLevel = 70.0;        // RSI overbought level
input double OversoldLevel = 30.0;          // RSI oversold level
input bool EnableAlerts = true;             // Enable sound alerts
input bool EnableEmail = false;             // Enable email notifications
input bool EnablePush = false;              // Enable push notifications
input bool EnableDivergenceAlerts = true;   // Enable divergence alerts

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
double PrevPriceHigh = 0.0;
double PrevRSIHigh = 0.0;
double PrevPriceLow = 0.0;
double PrevRSILow = 0.0;

//+------------------------------------------------------------------+
//| Main Function                                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   Print("RSI Alert Script Started.");

   while (!IsStopped()) {
      // Get the current RSI value
      double currentRSI = iRSI(TradeSymbol, Timeframe, RSIPeriod, PRICE_CLOSE, 0);

      // Check for overbought or oversold levels
      if (currentRSI > OverboughtLevel) {
         AlertRSI("RSI Overbought", currentRSI, TradeSymbol, Timeframe);
      } else if (currentRSI < OversoldLevel) {
         AlertRSI("RSI Oversold", currentRSI, TradeSymbol, Timeframe);
      }

      // Check for divergence if enabled
      if (EnableDivergenceAlerts) {
         CheckDivergence();
      }

      Sleep(60000); // Wait 1 minute before checking again
   }
}

//+------------------------------------------------------------------+
//| Check for divergence between price and RSI                      |
//+------------------------------------------------------------------+
void CheckDivergence()
{
   // Get RSI and price values for the last two periods
   double rsiCurrent = iRSI(TradeSymbol, Timeframe, RSIPeriod, PRICE_CLOSE, 0);
   double rsiPrev = iRSI(TradeSymbol, Timeframe, RSIPeriod, PRICE_CLOSE, 1);
   double priceCurrent = iClose(TradeSymbol, Timeframe, 0);
   double pricePrev = iClose(TradeSymbol, Timeframe, 1);

   // Detect bearish divergence (price higher high, RSI lower high)
   if (priceCurrent > PrevPriceHigh && rsiCurrent < PrevRSIHigh) {
      AlertRSI("Bearish Divergence", rsiCurrent, TradeSymbol, Timeframe);
   }

   // Detect bullish divergence (price lower low, RSI higher low)
   if (priceCurrent < PrevPriceLow && rsiCurrent > PrevRSILow) {
      AlertRSI("Bullish Divergence", rsiCurrent, TradeSymbol, Timeframe);
   }

   // Update previous values for the next iteration
   PrevPriceHigh = priceCurrent > PrevPriceHigh ? priceCurrent : PrevPriceHigh;
   PrevRSIHigh = rsiCurrent > PrevRSIHigh ? rsiCurrent : PrevRSIHigh;
   PrevPriceLow = priceCurrent < PrevPriceLow || PrevPriceLow == 0.0 ? priceCurrent : PrevPriceLow;
   PrevRSILow = rsiCurrent < PrevRSILow || PrevRSILow == 0.0 ? rsiCurrent : PrevRSILow;
}

//+------------------------------------------------------------------+
//| Send RSI alerts                                                 |
//+------------------------------------------------------------------+
void AlertRSI(string alertType, double rsiValue, string symbol, ENUM_TIMEFRAMES timeframe)
{
   string message = StringFormat(
      "%s detected on %s (Timeframe: %s)\nRSI Value: %.2f",
      alertType, symbol, EnumToString(timeframe), rsiValue
   );

   if (EnableAlerts) Alert(message);
   if (EnableEmail) SendMail("RSI Alert", message);
   if (EnablePush) SendNotification(message);

   Print(message);
}
