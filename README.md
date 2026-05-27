# 📡 RSI Overbought / Oversold & Divergence Alert — `RSI_Alert_Script_001.mq4`

> **MQL4 Script for MetaTrader 4**  
> Continuously monitors RSI for overbought and oversold threshold breaches, while simultaneously detecting bullish and bearish divergences between RSI and price — firing multi-channel alerts in real time.

---

## Overview

The Relative Strength Index (RSI) is one of the most widely used momentum oscillators in technical analysis. This script automates two of its most powerful use cases:

1. **Threshold Alerts** — Instantly notifies when RSI enters or exceeds overbought (default 70) or oversold (default 30) zones
2. **Divergence Detection** — Continuously scans for bullish and bearish divergences between RSI and price, providing early reversal warnings before they're visible in price action alone

Both functions run simultaneously on a 60-second polling loop.

---

## How It Works

**RSI Calculation:**

Uses MT4's built-in `iRSI()` function:
```
currentRSI = iRSI(symbol, timeframe, period, PRICE_CLOSE, 0)
```

**Threshold Alerts:**

```
RSI > OverboughtLevel → "RSI Overbought" alert
RSI < OversoldLevel   → "RSI Oversold" alert
```

**Divergence Detection:**

The script tracks rolling price and RSI highs/lows across polling cycles:

| Signal | Price Condition | RSI Condition | Meaning |
|---|---|---|---|
| **Bearish Divergence** | Price > previous high | RSI < previous RSI high | Momentum weakening at price high |
| **Bullish Divergence** | Price < previous low | RSI > previous RSI low | Momentum recovering at price low |

Previous highs/lows update dynamically each cycle using running max/min logic.

---

## Input Parameters

| Parameter | Default | Type | Description |
|---|---|---|---|
| `TradeSymbol` | `"EURUSD"` | string | Symbol to monitor |
| `Timeframe` | `PERIOD_H1` | ENUM_TIMEFRAMES | Chart timeframe |
| `RSIPeriod` | `14` | int | RSI calculation period |
| `OverboughtLevel` | `70.0` | double | RSI overbought threshold |
| `OversoldLevel` | `30.0` | double | RSI oversold threshold |
| `EnableAlerts` | `true` | bool | Trigger MT4 sound alerts |
| `EnableEmail` | `false` | bool | Send email notifications |
| `EnablePush` | `false` | bool | Send push notifications to mobile |
| `EnableDivergenceAlerts` | `true` | bool | Enable divergence detection |

---

## Alert Signals

**Threshold alerts:**
```
RSI Overbought detected on EURUSD (Timeframe: PERIOD_H1)
RSI Value: 74.32
```
```
RSI Oversold detected on EURUSD (Timeframe: PERIOD_H1)
RSI Value: 26.85
```

**Divergence alerts:**
```
Bearish Divergence detected on EURUSD (Timeframe: PERIOD_H1)
RSI Value: 68.10
```
```
Bullish Divergence detected on EURUSD (Timeframe: PERIOD_H1)
RSI Value: 33.75
```

All alerts are simultaneously logged to the MT4 **Experts journal**.

---

## RSI Period Reference

| Period | Sensitivity | Typical Use |
|---|---|---|
| 7 | High — many signals | Scalping, M5–M15 |
| 14 | Balanced (Wilder default) | Standard swing, H1–H4 |
| 21 | Low — fewer, higher quality | Position trading, D1 |

---

## Overbought / Oversold Level Guide

| Levels | Market Context |
|---|---|
| 70 / 30 (default) | Standard — appropriate for ranging markets |
| 80 / 20 | Extreme — best for strongly trending markets where 70/30 triggers too often |
| 65 / 35 | Sensitive — useful for early warning in quieter instruments |

**Note:** In a strong uptrend, RSI can remain above 70 for extended periods. Combine overbought signals with structure analysis to avoid premature counter-trend entries.

---

## Divergence vs Overbought/Oversold — When to Use Each

| Signal Type | Best Scenario |
|---|---|
| Overbought/Oversold | Range-bound markets with clear mean reversion tendencies |
| Divergence | Trending markets where you want early reversal warnings |
| Both combined | Divergence forming *while* RSI is in extreme zone = highest probability reversal setup |

---

## Installation

1. Copy `RSI_Alert_Script_001.mq4` to:
   ```
   MetaTrader 4/MQL4/Scripts/
   ```
2. Restart MT4 or right-click **Navigator** → **Refresh**
3. Drag onto a chart
4. Configure parameters and click **OK**

> **Tip:** Run multiple instances on different timeframes or symbols simultaneously by dragging the script onto different chart windows.

---

## Notification Setup

| Channel | Requirement |
|---|---|
| Sound Alert | MT4 running, `EnableAlerts = true` |
| Email | SMTP configured in MT4 → Tools → Options → Email |
| Push | MetaQuotes ID set in MT4 → Tools → Options → Notifications |

---

## Requirements

- MetaTrader 4 (Build 600+)
- `#property strict` compliance (enforced)
- At least `RSIPeriod + 1` bars of history
- MT4 must remain running for continuous monitoring

---

## Disclaimer

This script is provided for **educational and informational purposes only**. RSI signals perform differently across market regimes — overbought/oversold alerts work best in ranges; divergences work best near trend reversals. Neither signal type guarantees a specific outcome. Always test on a demo account before live use.

---

## License

MIT License — free to use, modify, and distribute with attribution.
