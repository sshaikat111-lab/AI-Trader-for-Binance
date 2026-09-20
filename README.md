# AI-Trader-for-Binance
AI-powered Binance Spot trading bot built with Python (FastAPI) and a live web dashboard. Uses machine learning, technical indicators, and risk management to trade in Paper, Testnet, or Live mode with configurable safety controls.
# AI Trader for Binance

A Python (FastAPI) trading bot with a browser dashboard (HTML/JS).
An AI model estimates the chance that each coin's price is higher a few candles from now.
The bot only trades when that estimate is confident **and** every risk rule passes.

> **Please read:** no trading bot can guarantee profit. Crypto trading can lose all of your money.
> This project starts in **paper mode** (fake money) on purpose. Use it that way for weeks first.

## Windows: one-click start

Double-click **START-AI-TRADER.bat** (in the same folder as `backend` and `frontend`).
It finds or installs Python, builds the environment, installs the libraries, creates `.env`,
starts the server and opens the dashboard. Later runs skip the setup and start in seconds.

To start it when Windows starts: press `Win + R`, type `shell:startup`, and put a shortcut to the .bat file there.
Set `AUTO_START_BOT=true` in `.env` if you also want the bot to begin trading by itself (paper and testnet only; live always needs you to press Start).

## Manual start (paper mode, no API key needed)

You need Python 3.10 or newer.

```bash
cd backend

# 1. create an isolated environment
python -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate

# 2. install
pip install -r requirements.txt

# 3. settings
cp .env.example .env               # Windows: copy .env.example .env

# 4. run
python main.py
```

Open **http://127.0.0.1:8000**, press **Start bot**.

To check the software works without internet: `python smoke_test.py`
(or set `DATA_SOURCE=synthetic` in `.env` to run the dashboard on fake prices).

## The three modes (set `TRADING_MODE` in `.env`)

| Mode | Money | Needs API key | Use it for |
|---|---|---|---|
| `paper` | Simulated, real Binance prices | No | Learning, first weeks of testing |
| `testnet` | Fake money on Binance's test exchange | Testnet key from https://testnet.binance.vision | Testing real order placement |
| `live` | **Real money** | Yes, plus `LIVE_CONFIRM=I_UNDERSTAND_THE_RISK` | Only after long testing |

The mode can only be changed in `.env` (then restart). It cannot be switched from the web page, so nobody
can flip it to live by accident.

## How it decides

1. Every candle (default 15 minutes) it downloads the last ~1000 candles for each coin.
2. It builds indicators (returns, RSI, MACD, Bollinger position, volatility, volume, trend, hour of day).
3. A gradient-boosting model (scikit-learn) is trained on the older 80% of the data and **tested on the newest 20%** it never saw.
   The dashboard shows that score next to a "just guess" baseline. If the model is not better than `MIN_VAL_ACCURACY`, that coin is not traded.
4. It buys only if all of these are true: P(up) >= `BUY_THRESHOLD`, price is above its trend average, volatility is high enough to beat fees, you have free position slots, the daily loss limit is not hit.
5. Position size is set so that hitting the stop-loss loses about `RISK_PER_TRADE` of your account, capped by `MAX_POSITION_PCT`.
6. It exits on: stop-loss, take-profit, a break-even stop after +1x risk, the AI turning bearish, or a time limit.
7. The model is retrained every 50 candles.

It trades spot only, long only (buys then sells; no leverage, no shorting).

## Safety features

- Paper mode by default; live needs a typed confirmation phrase in `.env`.
- API keys stay in `.env` on your computer. They are never sent to the web page.
- Daily loss limit: sells everything and stops opening trades for the rest of the UTC day.
- "Sell everything and stop" button, and a "Sell now" button per position.
- State (positions, trades) is saved to `backend/data/`, so a restart does not lose track of open trades.
- The server listens on `127.0.0.1` only. **Do not expose it to the internet** (it has no password).

## Before you ever use real money

1. Run paper mode for at least 2 to 4 weeks. Compare the result against simply holding the coin.
2. Run testnet for a few days to confirm orders fill and stops work.
3. Create a Binance API key with **Spot trading only, withdrawals OFF, restricted to your IP**.
4. Start with an amount you can afford to lose completely.
5. Keep the bot running on a stable connection. Stop-losses are checked by the bot every 10 seconds
   (they are not orders sitting on Binance). If the bot or your internet stops, open positions are unprotected.

Fees matter: Binance spot costs ~0.1% per trade side. Short timeframes (1m, 5m) make fees hard to beat, which is why the default is 15m.

## Files

```
backend/
  main.py          web server and API
  bot.py           trading loop, risk rules, exits, saved state
  model.py         features and the AI model
  broker.py        PaperBroker (simulated) and CCXTBroker (Binance / testnet)
  data.py          Binance candles, or fake candles for offline tests
  config.py        reads and validates .env
  smoke_test.py    offline self-test
  .env.example     all settings with explanations
frontend/
  index.html       the dashboard
```

## Troubleshooting

- **`Service unavailable from a restricted location` / HTTP 451:** Binance blocks some countries. Do not use a VPN to get around this if it violates Binance's terms.
- **Timestamp errors:** sync your computer's clock.
- **`order value is below Binance minimum`:** Binance needs about 5 to 10 USDT per order. Fund the account with more, or raise `MAX_POSITION_PCT`.
- **The bot never trades:** that is normal. The filters are strict on purpose. The Activity log and the "What the AI thinks" panel say exactly why each coin was skipped.
