# AI Trader: User Manual

This manual explains how to install, run and safely use AI Trader. It is written for people who are new to trading bots.
No programming knowledge is needed to follow it.

**Contents**

1. [Read this first](#1-read-this-first)
2. [What you need](#2-what-you-need)
3. [Installation](#3-installation)
4. [Your first run](#4-your-first-run)
5. [The dashboard, panel by panel](#5-the-dashboard-panel-by-panel)
6. [Everyday use](#6-everyday-use)
7. [Trading modes: paper, testnet, live](#7-trading-modes-paper-testnet-live)
8. [AI engines and Gemini (free API key)](#8-ai-engines-and-gemini-free-api-key)
9. [Settings reference](#9-settings-reference)
10. [Changing the behavior: what each setting does](#10-changing-the-behavior-what-each-setting-does)
11. [Understanding messages and reasons](#11-understanding-messages-and-reasons)
12. [Safety checklist](#12-safety-checklist)
13. [Troubleshooting](#13-troubleshooting)
14. [FAQ](#14-faq)
15. [Files, backups, updating, uninstalling](#15-files-backups-updating-uninstalling)
16. [Glossary](#16-glossary)

---

## 1. Read this first

- **No bot can guarantee profit.** Crypto prices are very hard to predict. The AI here is a statistical estimate, and it is often wrong.
- **You can lose money.** In live mode you can lose everything you put in. Only use money you can afford to lose.
- **Start with paper mode.** It uses real prices but fake money. Run it for at least 2 to 4 weeks and compare the result with simply holding the coin.
- **This is not financial advice.** The software is provided as is, with no warranty. You are responsible for your trades, your API keys and your computer's security.
- **Gemini is not a crystal ball.** A language model reading candles is still guessing. It can sound confident and be wrong. Treat the Gemini option as an experiment and test it in paper mode like everything else.
- **The bot often does nothing. That is normal.** The filters are strict on purpose, so many hours can pass with no trade.

---

## 2. What you need

| Item | Details |
|---|---|
| Computer | Windows 10/11, macOS or Linux. It must stay **on, awake and online** while the bot runs. |
| Python | Version 3.10 or newer. **3.12 is recommended.** (The Windows launcher can install it for you.) |
| Internet | Needed for Binance prices. |
| Browser | Any modern browser (Chrome, Edge, Firefox, Safari). |
| Binance account | **Only for testnet or live mode.** Paper mode needs no account and no API key. |

---

## 3. Installation

### 3.1 Windows: one-click (recommended)

1. Download the project and **extract the zip** (right-click, Extract All). Do not run it from inside the zip.
2. Open the extracted folder. You should see `START-AI-TRADER.bat`, and folders named `backend`, `frontend` and `docs`.
3. Double-click **`START-AI-TRADER.bat`**.
4. Wait. The first run takes a few minutes while libraries install.
5. Your browser opens the dashboard by itself. Keep the black window open.

What the launcher does: finds Python (or installs Python 3.12 with `winget` if it can), creates a private environment in `backend\.venv`,
installs the libraries, creates your settings file `backend\.env` in paper mode, starts the server and opens the dashboard.
Later runs skip the setup and start in a few seconds.

If Python was just installed, the launcher asks you to **close the window and double-click it again**. This is normal.

### 3.2 Windows: manual

Open **Command Prompt** (not PowerShell) inside the `backend` folder. In File Explorer, click the address bar, type `cmd` and press Enter.

```bat
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
copy .env.example .env
python main.py
```

Notes:
- `python -m venv .venv` is one command. The next line, `.venv\Scripts\activate`, is a **separate** command and does **not** start with `python`.
- After activating, your prompt starts with `(.venv)`.
- If `python` is not recognised, try `py` instead, or reinstall Python and tick **Add python.exe to PATH**.

### 3.3 macOS and Linux

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
python main.py
```

### 3.4 Running it again later

- **Windows launcher:** double-click `START-AI-TRADER.bat`.
- **Manual:** open a terminal in `backend`, activate the environment (`.venv\Scripts\activate` or `source .venv/bin/activate`), then `python main.py`.

### 3.5 Checking the installation

From the `backend` folder with the environment active, run `python smoke_test.py`.
It runs the whole bot on fake data (no internet needed) and should finish with `ALL CHECKS PASSED`.

---

## 4. Your first run

1. Start the program (section 3). The window shows: `AI Trader ready: PAPER mode (simulated money)`.
2. Open **http://127.0.0.1:8000** if the browser did not open by itself.
3. Look at the mode switch in the top bar. **Paper** should be highlighted, and the thin bar across the top of the page should be blue.
4. Press **Start bot**.
5. Within about 10 to 30 seconds the panel **What the AI thinks** shows a reading for each coin. The bot downloads about 1000 recent candles per coin and trains its model.
6. Watch the **Activity** panel. You will see lines like `BTC/USDT: model trained. Hit-rate on unseen data 53.1% ...`.
7. Leave it running. New signals are calculated **once per candle** (every 15 minutes by default). Between candles, the bot checks stop-loss and take-profit every 10 seconds.

You can close the browser tab at any time. The bot keeps running as long as the program window stays open.

---

## 5. The dashboard, panel by panel

### 5.1 Top bar

| Element | Meaning |
|---|---|
| **Paper / Testnet / Live** switch | Shows the current mode (highlighted) and lets you change it (section 7.4). A thick colored bar across the very top of the page repeats the mode: blue = Paper, amber = Testnet, red = Live. |
| Green pulsing dot | The bot is running. A grey dot means stopped. |
| **Reset paper account** | Only visible in paper mode while the bot is stopped. Erases simulated trades and restores the starting balance. |
| **Start bot / Stop bot** | Starts or stops the trading loop. |
| **Sell everything and stop** | Emergency button. Stops the bot and sells all open positions at market price. |
| "Cannot reach the bot server" | The page cannot talk to the program. Check that the program window is still open. |

A **banner** under the top bar appears when something needs attention:
- red: the daily loss limit was reached and trading is halted;
- amber: the bot is stopped while positions are open (they are **not** being watched), or you are using demo data.

### 5.2 Key figures strip

| Figure | Meaning |
|---|---|
| **Account value** | Free cash plus the current value of open positions, in USDT. |
| **Total profit / loss** | Change since the account was first tracked, with a percentage. |
| **Today** | Change since the start of the current UTC day. |
| **Win rate** | Share of closed trades that made money, and how many trades have closed. |
| **Free cash** | USDT not in a trade. The line below shows how much is in open trades. |

### 5.3 Price chart

- Candlesticks for the selected coin (last 120 candles). Switch coins with the tabs above the chart.
- **Green triangle up** = a buy. **Triangle down** = a sell (green if it made money, red if it lost).
- For an open position, dashed lines show **target** (take-profit), **entry** and **stop** (stop-loss).
- The dark tag on the right edge shows the latest price.

### 5.3.1 Account value over time

A line of your account value. The dashed line is your starting value. This chart fills in after the bot has run for a minute or so,
and it is kept in memory only, so it restarts empty when you restart the program.

### 5.4 What the AI thinks (confidence gauges)

At the top of the panel is the **AI engine** switch: **Statistical model**, **Gemini**, or **Both must agree** (see section 8).
Under it, one block per coin. This is the most important panel.

- The bar runs from **0 to 1**. The black marker is the model's estimate of the **chance the price is higher a few candles from now** (called P(up)).
- The **red zone** on the left ends at the **sell level**. If you hold the coin and the marker enters this zone, the AI exits.
- The **green zone** on the right starts at the **buy level**. The marker must be in this zone (and every other check must pass) for a buy.
- The tag shows the latest decision: **Waiting**, **No trade**, **Bought**, **Sold** or **Holding**.
- The sentence underneath gives the **exact reason**, for example why no trade was made (see section 11).
- If Gemini is in use, a **Gemini box** shows its verdict for that coin (BUY / SELL / HOLD, how confident it is, whether it sees an uptrend, downtrend or sideways market, and a one-sentence reason), with the time it was asked. If Gemini could not answer, the box says why, and the bot opens no new trades on Gemini's advice until it can.
- The grey line at the bottom shows how the statistical model scored on data it had **never seen**, next to a "guess the common direction" baseline.
  If the score is amber and says the model is too weak, that coin is not traded.

A reading around 0.50 means the model has no opinion. Being confident is rare, so do not expect a buy every candle.

### 5.5 Open positions

For each open trade: entry price, current price, stop-loss, target and profit or loss (already net of the estimated exit fee).
**Sell now** sells that position immediately at market price, even if the bot is stopped.

### 5.6 Trade history

The latest 100 trades: time, coin, action, price, amount in USDT, result, and the reason (section 11.3).

### 5.7 Activity

A running log: model training, purchases, sales, warnings and errors (newest first).

### 5.8 Safety settings

A read-only summary of your risk settings. To change them, edit `backend/.env` and restart (section 9).

---

## 6. Everyday use

### Starting and stopping
- **Start bot** begins trading with your current settings. **Stop bot** pauses it.
- **Important:** when the bot is stopped, open positions are **not monitored**, so no stop-loss or take-profit will trigger.
  If you stop the bot while holding coins, either restart it or sell the positions (**Sell now**).
- To shut the program down completely, close its window or press `Ctrl + C` in it.

### Changing mode or AI engine
- **AI engine** (Statistical / Gemini / Both) can be changed at any time, even while running. It applies from the next candle.
- **Mode** (Paper / Testnet / Live) can only be changed when the bot is **stopped** and you have **no open positions**. See section 7.4.

### Emergency
- **Sell everything and stop** sells every open position at market price and stops the bot.
- If Binance rejects an order (for example no funds or a network error), the page shows an error and the position stays open. Check the Activity log and Binance directly.

### Restarting the computer or program
Open positions and trade history are saved to `backend/data/`. After a restart, open the dashboard and press **Start bot**. Positions are picked up again.
(If `AUTO_START_BOT=true`, the bot starts by itself in paper and testnet modes.)

### Running it all day
The computer must not sleep. On Windows, set Settings, System, Power, "Screen and sleep" to **Never** for the plugged-in state.
Unstable internet, sleep or power loss leave positions unprotected.

### Start with Windows (optional)
Press `Win + R`, type `shell:startup`, and put a shortcut to `START-AI-TRADER.bat` in the folder that opens.
Add `AUTO_START_BOT=true` to `.env` if the bot should also begin trading automatically (paper and testnet only; live mode always needs you to press Start).

---

## 7. Trading modes: paper, testnet, live

The program starts in the mode set by `TRADING_MODE` in `backend/.env`. You can change mode later from the dashboard (section 7.4).
Each mode and data source keeps its own balance, history and saved file, so paper, testnet and live records never mix.

### 7.1 Paper (default)
Simulated money with real Binance prices. No API key needed.
The simulation charges a **0.1% fee** and **0.05% slippage** on each side (adjustable). Starting balance is `PAPER_START_BALANCE` (default 1000 USDT).
Paper results are usually a little better than real life, because real orders can fill worse in fast markets.

### 7.2 Testnet
Binance's test exchange with fake money but real order mechanics. Use it to confirm the connection, orders and stops work.

1. Go to **https://testnet.binance.vision** and follow the site's instructions to log in and create an API key.
2. In `backend/.env` set:
   ```
   TRADING_MODE=testnet
   BINANCE_API_KEY=your_testnet_key
   BINANCE_API_SECRET=your_testnet_secret
   ```
3. Restart the program. The top bar shows **Testnet** highlighted.

   (Alternative: leave `TRADING_MODE=paper`, add only the two key lines, restart, then click **Testnet** in the top bar. See section 7.4.)

Note: testnet prices can differ from the real market. The bot reads candles from the real market but fills orders at the testnet price.

### 7.3 Live (real money)
Only consider this after weeks of paper trading and days of testnet.

**Preparation checklist**
1. On Binance, create an API key with **only "Enable Spot & Margin Trading"** ticked.
   **Leave "Enable Withdrawals" OFF.** Restrict the key to your computer's IP address if your IP is stable.
2. Put a **small** amount of USDT in the **Spot wallet**. Binance needs roughly 5 to 10 USDT per order; the bot's default minimum is 10 USDT.
3. If you pay fees with BNB, fees are not converted into the bot's profit figures, so reported P&L will be slightly off. Paying fees in the traded coin or USDT keeps the numbers exact.
4. In `backend/.env` set:
   ```
   TRADING_MODE=live
   BINANCE_API_KEY=your_real_key
   BINANCE_API_SECRET=your_real_secret
   LIVE_CONFIRM=I_UNDERSTAND_THE_RISK
   ```
5. Restart. The top bar shows **Live** highlighted, the page has a thick red bar across the top, and pressing **Start bot** asks you to confirm.

   (Alternative: keep `TRADING_MODE=paper`, add only the two key lines, restart, then click **Live** in the top bar and type the phrase when asked. See section 7.4.)
6. Do not trade the same coins manually on the same account while the bot runs. The bot tracks its own positions and would not know.

If you **start the program** in live mode, it refuses unless the keys **and** `LIVE_CONFIRM=I_UNDERSTAND_THE_RISK` are in `.env`. If you **switch to live from the dashboard**, you type the confirmation phrase in the pop-up instead (section 7.4).

### 7.4 Switching mode from the dashboard

Click **Paper**, **Testnet** or **Live** in the top bar. A pop-up explains the mode and asks you to confirm.

| Rule | Why |
|---|---|
| The bot must be **stopped** | A running bot may be about to place an order. |
| You must have **no open positions** | Positions belong to one account. Use **Sell now** or **Sell everything and stop** first. |
| Testnet and Live need `BINANCE_API_KEY` and `BINANCE_API_SECRET` in `backend/.env` | Keys are never typed into the web page, so they never pass through the browser. Add them, then restart the program once. |
| Live needs you to type `I_UNDERSTAND_THE_RISK` | A deliberate extra step before real money. |
| The program tests the keys first | If Binance rejects them or cannot be reached, you see the reason and the mode does **not** change. |

If a button is dimmed, click it anyway: the pop-up tells you exactly what is missing or blocking the change.
After switching, the page shows that mode's own balance and history. Switching back restores what that mode had before.
The switch lasts until you close the program. On the next start it uses `TRADING_MODE` from `.env` again.

---

## 8. AI engines and Gemini (free API key)

The bot has three "AI engines". Pick one in the **What the AI thinks** panel (or set `STRATEGY` in `.env`).

| Engine | Who decides | Needs a key |
|---|---|---|
| **Statistical model** (`ml`) | A machine-learning model that runs on your computer and learns from recent candles. | No |
| **Gemini** (`gemini`) | Google Gemini analyses the market data and answers BUY, SELL or HOLD. | Yes (free) |
| **Both must agree** (`hybrid`) | The statistical model **and** Gemini must both say buy. To exit, either one saying sell is enough. | Yes (free) |

In every engine, the same **safety rules** run afterwards: position size caps, stop-loss, take-profit, time limit, daily loss limit.
Gemini advises; it can never override them, and it cannot place trades outside them.

### 8.1 How Gemini analyses a coin

At each new candle the bot sends Gemini a compact package of numbers:
the last 48 candles, indicators (RSI, moving-average gap, MACD, Bollinger position, volatility, volume, trend distance),
what the statistical model thinks and how reliable it has been, the trading costs, and whether you are holding the coin
(with its entry, stop and target). Gemini replies with a structured answer: an action, a confidence from 0 to 100%, a trend, and a short reason.

The bot acts on a Gemini **BUY** only if its confidence is at least `GEMINI_MIN_CONFIDENCE` (default 65%), and only if every other rule passes.
Gemini is never asked for news or given internet access, and it is told to answer HOLD when the evidence is weak.

### 8.2 Getting a free Gemini key

1. Open **https://aistudio.google.com/apikey** and sign in with a Google account.
2. Create an API key. No credit card is needed for the free tier.
3. Open `backend/.env` in Notepad and set:
   ```
   GEMINI_API_KEY=paste_your_key_here
   STRATEGY=hybrid
   ```
4. Save, restart the program, and open the dashboard. The AI panel should say `Gemini gemini-3.1-flash-lite: 0 of 200 daily calls used.`

Treat the key like a password: never upload `.env` to GitHub and never share it.

### 8.3 Free-tier limits and privacy

- **Limits differ by model, change often, and are per Google project.** Lighter "Flash-Lite" models normally allow far more free requests per day than the bigger "Flash" models, which is why `gemini-3.1-flash-lite` is the default. Check your real limits at Google AI Studio (Rate limits page).
- The bot protects your quota: it waits at least 7 seconds between calls (`GEMINI_MIN_INTERVAL`), stops after `GEMINI_MAX_CALLS_PER_DAY` (default 200) calls a day, and pauses itself if Google answers "too many requests".
- **Hybrid mode uses far fewer calls**, because Gemini is only asked when the statistical model already wants to buy (plus once per candle for open positions).
- In the worst case (Gemini-only, two coins, 15-minute candles) the bot asks about 8 times an hour, roughly 190 a day. Adding more coins or shorter candles increases this. Lower `GEMINI_MAX_CALLS_PER_DAY` if your own limit is smaller.
- **If Gemini is unavailable** (limit reached, network problem, bad key), the bot **does not open new trades** on its advice and says so in the panel. Stop-losses and take-profits keep working because they do not depend on Gemini.
- **Privacy:** on the free tier, Google may use what you send to improve its products. The bot sends only market numbers and the entry/stop/target of a position. It never sends your Binance keys, balance or personal information.
- Gemini model names change over time. If you see "model not found", set `GEMINI_MODEL` to a current model from the Google AI Studio model list.

### 8.4 Which engine should I use?

Nobody can tell you in advance. The honest approach is to **measure**: run paper mode with one engine for a week or two, reset the paper account, then run another, and compare results
(also against simply holding the coin). Things to keep in mind:

- The statistical model is fast, private and its accuracy on unseen data is displayed, so you can see when it is weak.
- Gemini can explain itself in words, which is useful for learning, but its accuracy is not measured by the bot. Its confidence numbers are opinions, not probabilities.
- **Both must agree** trades least often and is the most cautious.

---

## 9. Settings reference

All settings live in `backend/.env` (created from `.env.example`). Lines starting with `#` are comments. **Restart the program after editing.**
Percentages are written as decimals: `0.01` = 1%.

### 9.1 Core

| Setting | Default | Allowed | Meaning |
|---|---|---|---|
| `TRADING_MODE` | `paper` | `paper`, `testnet`, `live` | Which account the program **starts** in. Can be changed later from the dashboard. |
| `BINANCE_API_KEY` / `BINANCE_API_SECRET` | empty | | Needed for testnet and live only. |
| `LIVE_CONFIRM` | empty | `I_UNDERSTAND_THE_RISK` | Only needed if you **start** the program in live mode. |
| `DATA_SOURCE` | `binance` | `binance`, `synthetic` | `synthetic` = fake prices for offline testing only. Not allowed with testnet/live. |
| `SYMBOLS` | `BTC/USDT,ETH/USDT` | Binance spot pairs ending in `/USDT` | Coins to trade, comma separated. |
| `TIMEFRAME` | `15m` | `1m`,`3m`,`5m`,`15m`,`30m`,`1h` | Candle size. Longer is usually better because fees matter less. |
| `PAPER_START_BALANCE` | `1000` | number | Paper mode starting USDT. |
| `AUTO_START_BOT` | `false` | `true`/`false` | Start trading when the program starts. Ignored in live mode. |
| `HOST` / `PORT` | `127.0.0.1` / `8000` | | Where the dashboard runs. Keep `127.0.0.1`. |

### 9.2 Risk controls

| Setting | Default | Allowed | Meaning |
|---|---|---|---|
| `RISK_PER_TRADE` | `0.01` | above 0, up to `0.05` | Target loss if the stop-loss is hit, as a share of your account. |
| `MAX_POSITION_PCT` | `0.25` | above 0, up to `1` | Largest single trade as a share of your account. Usually the limit that actually applies. |
| `MAX_OPEN_POSITIONS` | `2` | whole number | Trades open at once. |
| `ATR_STOP_MULT` | `2.0` | number | Stop-loss distance = this x the coin's average candle range (ATR). |
| `TAKE_PROFIT_RR` | `2.0` | number | Take-profit distance = this x the stop-loss distance. |
| `MAX_HOLD_CANDLES` | `12` | whole number | Close a trade after this many candles (12 x 15 min = 3 hours). |
| `COOLDOWN_CANDLES` | `2` | whole number | Wait this many candles before re-buying a coin after closing a trade. |
| `DAILY_LOSS_LIMIT` | `0.03` | above 0, up to `0.5` | If the account falls this much from the day's start, sell everything and stop opening trades until the next UTC day. |

### 9.3 Statistical model settings

| Setting | Default | Allowed | Meaning |
|---|---|---|---|
| `BUY_THRESHOLD` | `0.58` | 0.5 up to below 1 | Buy only if P(up) is at least this. Higher = fewer, pickier trades. |
| `SELL_THRESHOLD` | `0.45` | above 0 and below `BUY_THRESHOLD` | If holding and P(up) falls to this or lower, exit. |
| `MIN_VAL_ACCURACY` | `0.52` | number | The coin is only traded if the model scored at least this on unseen data. |
| `MIN_ATR_PCT` | `0.002` | number | Skip buying when the average candle range is below this share of price (0.2%). Prevents trading when moves are too small to beat fees. |
| `TREND_FILTER` | `true` | `true`/`false` | Only buy when the price is above its 50-candle average. |

### 9.4 AI engine and Gemini

| Setting | Default | Allowed | Meaning |
|---|---|---|---|
| `STRATEGY` | `hybrid` | `ml`, `gemini`, `hybrid` | Which AI engine decides. Falls back to `ml` if there is no Gemini key. Can also be changed in the dashboard. |
| `GEMINI_API_KEY` | empty | | Your free key from Google AI Studio. |
| `GEMINI_MODEL` | `gemini-3.1-flash-lite` | any Gemini model name | Which Gemini model to use. |
| `GEMINI_MIN_CONFIDENCE` | `0.65` | 0.5 to 1 | Act on Gemini only if it is at least this confident. |
| `GEMINI_MAX_CALLS_PER_DAY` | `200` | whole number | The bot stops asking after this many calls per day. |
| `GEMINI_MIN_INTERVAL` | `7` | seconds | Minimum wait between Gemini calls (advanced). |
| `GEMINI_TIMEOUT` | `40` | seconds | How long to wait for an answer (advanced). |

### 9.5 Costs (paper mode)

| Setting | Default | Meaning |
|---|---|---|
| `FEE_RATE` | `0.001` | Fee per side (0.1%, the standard Binance spot fee). Also used in break-even stop and profit estimates. |
| `SLIPPAGE` | `0.0005` | Assumed price worsening per side in paper mode (0.05%). |

### 9.6 Advanced (not in `.env.example`; add only if you know why)

| Setting | Default | Meaning |
|---|---|---|
| `LOOP_SECONDS` | `10` | How often prices and stops are checked. |
| `TRAIN_CANDLES` | `1000` | Candles used to train the model (allowed 300 to 1000). |
| `RETRAIN_EVERY` | `50` | Retrain the model after this many candles (about 12.5 hours at 15m). |
| `HORIZON` | `3` | How many candles ahead the model predicts. |
| `MIN_NOTIONAL` | `10` | Smallest order the bot will place, in USDT. |
| `STATE_DIR` | `backend/data` | Where saved state is stored. |

If a setting is invalid, the program stops at startup and prints exactly what to fix.

---

## 10. Changing the behavior: what each setting does

| You want | Change | Effect and trade-off |
|---|---|---|
| Fewer, more selective trades | Raise `BUY_THRESHOLD` (for example 0.62) | Fewer trades, but the bot may go days without any. |
| Smaller risk | Lower `MAX_POSITION_PCT` and `RISK_PER_TRADE` | Smaller wins and smaller losses. |
| Only one trade at a time | `MAX_OPEN_POSITIONS=1` | Less exposure. |
| Slower, calmer trading | `TIMEFRAME=1h` | Fewer trades; fees are a smaller share of each move. |
| Stricter safety stop | Lower `DAILY_LOSS_LIMIT` (for example 0.02) | Trading halts sooner on a bad day. |
| Let winners run longer | Raise `MAX_HOLD_CANDLES` or `TAKE_PROFIT_RR` | Bigger targets are reached less often. |
| Let Gemini be more or less picky | Raise or lower `GEMINI_MIN_CONFIDENCE` | Higher = fewer Gemini-driven trades. |
| Use fewer Gemini calls | Use `hybrid`, longer `TIMEFRAME`, fewer `SYMBOLS` | Saves your free daily quota. |
| More coins | Add to `SYMBOLS` | More opportunities, more exposure; keep `MAX_OPEN_POSITIONS` sensible. |

A **cautious** example for beginners moving to testnet or live:

```
TIMEFRAME=1h
MAX_OPEN_POSITIONS=1
MAX_POSITION_PCT=0.10
RISK_PER_TRADE=0.005
BUY_THRESHOLD=0.62
DAILY_LOSS_LIMIT=0.02
```

This is an illustration of how to make the bot more careful, not a recommendation or a promise of results.
Very short timeframes (1m, 5m) are discouraged: with 0.1% fees on both sides, most small moves cannot pay the cost.

---

## 11. Understanding messages and reasons

### 11.1 Why the bot did not buy (shown under each gauge)

| Message | Meaning |
|---|---|
| `trading halted for today` | The daily loss limit was reached. Resumes at the next UTC day. |
| `model too weak (xx% on unseen data)` | The model scored below `MIN_VAL_ACCURACY` on data it never trained on. |
| `P(up) 0.52 is below the buy level 0.58` | The AI is not confident enough. The most common reason. |
| `price moves too small to beat fees` | Volatility is below `MIN_ATR_PCT`. |
| `price is below its trend average` | Trend filter: the price is below its 50-candle average. |
| `max open positions reached` | All position slots are used. |
| `cooling down after last trade` | Waiting `COOLDOWN_CANDLES` after closing this coin. |
| `could not size the stop-loss` | The volatility reading was unusable this candle. |
| `trade size x USDT is below the minimum` | Your free cash or the size caps give an order smaller than `MIN_NOTIONAL`. Add funds or raise `MAX_POSITION_PCT`. |
| `buy failed: ...` | Binance rejected or failed the order. The coin is paused for one candle. |
| `position open, no exit signal` | Holding; no engine is signalling an exit. |
| `Gemini says HOLD (70%)` | Gemini looked and does not want to buy. |
| `Gemini says BUY but only 55% confident (needs 65%)` | Gemini leans towards buying but is below `GEMINI_MIN_CONFIDENCE`. |
| `Gemini unavailable (...)` | Gemini could not answer (limit, network or key). No new trades on its advice. |
| `Gemini did not answer` | Gemini was needed but no answer arrived. |

Several reasons can appear together, separated by semicolons.

### 11.2 Activity log lines

| Line | Meaning |
|---|---|
| `model trained. Hit-rate on unseen data 53.1% (coin-flip baseline 51.2%) - OK to trade` | Training finished; shows the honest test score. |
| `Gemini on BTC/USDT: BUY (78%), trend up. ...` | Gemini's verdict and reason for that candle. |
| `Gemini on BTC/USDT unavailable: ...` | Gemini could not be used this candle (reason given). |
| `AI engine changed to: hybrid` | You changed the engine. |
| `switched to TESTNET mode` | You changed the trading mode. |
| `BOUGHT 0.0041 BTC at 60,030.00 (stop ..., target ...)` | A buy was made. |
| `SOLD BTC/USDT at ... (reason), P&L +2.37 USDT (+0.95%)` | A sale, with net profit or loss after fees. |
| `up 1x risk, stop-loss moved to break-even` | Price rose by one stop-distance; the stop was lifted to about the entry price (plus fees). |
| `Daily loss limit ... reached` | Everything was sold; no new trades today. |
| `new day: trading resumed` | The UTC day changed after a halt. |
| `price for X unavailable` | Temporary Binance or network problem. Repeated warnings mean a connection problem. |

### 11.3 Trade reasons in the history table

| Reason | Meaning |
|---|---|
| AI signal | Bought on a confident reading from the statistical model. |
| Gemini signal | Bought on a confident Gemini BUY (engine: Gemini). |
| Model + Gemini agreed | Bought because both agreed (engine: Both must agree). |
| AI exit | Sold because P(up) fell to the sell level. |
| Gemini exit | Sold because Gemini advised selling with enough confidence. |
| Stop-loss | Price hit the stop. |
| Break-even stop | Price rose, then fell back to the lifted stop. Result is about zero. |
| Take-profit | Price hit the target. |
| Time limit | Held for `MAX_HOLD_CANDLES`, then closed. |
| Closed by you | You pressed **Sell now**. |
| Daily loss limit | Closed by the daily loss rule. |
| Sell everything | Closed by the emergency button. |

### 11.4 A worked example

Account 1,000 USDT, BTC at 60,000, average candle range (ATR) 180, default settings, paper mode.

- Stop distance = 2 x 180 = 360. Size by risk = 10 USDT / 360 x 60,000 = 1,666 USDT, but the cap is 25% of the account, so the trade is **250 USDT**.
- Fill (with 0.05% slippage and 0.1% fee): entry 60,030, stop 59,670, target 60,750.
- If the stop is hit: about **-2.12 USDT** (-0.21% of the account).
- If the target is hit: about **+2.37 USDT** (+0.24% of the account).
- If price reaches 60,390, the stop moves up to about 60,150 (break-even).

Because the 25% cap usually applies, the real risk per trade is often far lower than `RISK_PER_TRADE` suggests. Costs (fees + slippage, about 0.3% per round trip) take a noticeable share of each small win.

---

## 12. Safety checklist

- [ ] I ran **paper mode** for at least 2 to 4 weeks and compared it to just holding.
- [ ] I ran **testnet** for a few days and confirmed orders and stops worked.
- [ ] My API key has **spot trading only, withdrawals OFF**, and is restricted to my IP if possible.
- [ ] I am using an amount I can afford to **lose completely**.
- [ ] I compared the AI engines in paper mode and understand Gemini's confidence is an opinion, not a guarantee.
- [ ] My Gemini key is private and `.env` is not uploaded anywhere.
- [ ] The highlighted mode in the top bar (and the colored bar across the page) is the one I intend: blue Paper, amber Testnet, red LIVE.
- [ ] My computer will stay on, awake and online. I know stops are **not** placed on Binance; the bot checks them every 10 seconds.
- [ ] I will **not** leave the bot stopped with open positions.
- [ ] `.env` is **never** uploaded, emailed or screenshotted. The dashboard is not exposed to the internet.
- [ ] I check the dashboard and Binance account regularly and know where **Sell everything and stop** is.

---

## 13. Troubleshooting

| Problem | Likely cause and fix |
|---|---|
| `python is not recognized` | Python is missing or not on PATH. Reinstall from python.org with **Add python.exe to PATH**, or use `py`. |
| Error mentioning `No module named '...\.venv'` | You typed `python` in front of the activate command. Run `python -m venv .venv` and `.venv\Scripts\activate` as two separate commands, from the `backend` folder. |
| PowerShell says scripts are disabled | Use Command Prompt (`cmd`) instead of PowerShell. |
| `pip install` fails with a build error | Very new Python versions may lack ready-made libraries. Install Python 3.12 and run again (`py -3.12 -m venv .venv`). |
| Launcher says it installed Python, then stops | Close the window and double-click `START-AI-TRADER.bat` again. |
| Page says "Cannot reach the bot server" | The program window was closed or crashed. Start it again and read the last lines of the window for the reason. |
| "Address already in use" | Another program uses port 8000. Change `PORT` in `.env`, or close the other program. |
| Program stops at startup with a bullet list | A setting in `.env` is invalid or missing (for example live mode without `LIVE_CONFIRM`). Fix what the list says. |
| HTTP 451 or "restricted location" | Binance is not available from your location or network. Do not bypass access restrictions in ways that break Binance's terms. Use `DATA_SOURCE=synthetic` only to test the software. |
| Timestamp or "recvWindow" errors | Your computer's clock is wrong. Turn on automatic time sync. |
| "Invalid API-key, IP, or permissions" | Wrong key or secret, testnet key used in live mode (or the reverse), the key's IP restriction does not include your IP, or Spot trading is not enabled on the key. |
| `order value ... is below Binance minimum` | The order is too small. Add USDT or raise `MAX_POSITION_PCT`. |
| `no X available to sell` and the position will not close | You sold or moved the coin outside the bot. Confirm your Binance holdings, stop the program, and delete `backend/data/state_live_binance.json` (or the testnet/paper equivalent) so the bot forgets the position. |
| Mode buttons are dimmed | The bot is running, positions are open, or the mode needs keys. Click the button; the pop-up gives the exact reason. |
| "Add BINANCE_API_KEY ..." when switching mode | Put the Binance (testnet or live) keys in `backend/.env` and restart the program. |
| "Could not connect to Binance ..." when switching | The keys are wrong for that mode (testnet and live keys are different), the key's IP restriction excludes you, or the network is blocked. The mode did not change. |
| Panel says "Gemini is off" | `GEMINI_API_KEY` is empty in `.env`, or you did not restart after adding it. |
| "Gemini rejected the API key" | The key is wrong or was deleted. Create a new one at aistudio.google.com/apikey. |
| "Gemini model ... was not found" | The model name changed. Set `GEMINI_MODEL` to a current model in Google AI Studio. |
| "Gemini free-tier limit reached" | You used up the free quota. The bot pauses Gemini and opens no Gemini-based trades. It resumes later, or switch to the Statistical model. Lower `GEMINI_MAX_CALLS_PER_DAY` or use `hybrid` to use fewer calls. |
| "Gemini server busy" | Google's servers were overloaded. The bot retries briefly, then skips that candle. |
| The bot never buys | Usually normal. Read the reason under each gauge. Common: P(up) below the buy level, model too weak, price below its trend average. |
| Signals show "Waiting" for a long time | The bot is only reading data at each candle. With a stopped bot no data is read. Press **Start bot**. |
| The account chart is empty | It needs about a minute of running time and is not saved across restarts. |
| Numbers look wrong after switching data source | Each mode and data source has its own state file. Use **Reset paper account** in paper mode. |

If something else goes wrong, copy the last lines of the program window and the Activity log when asking for help.

---

## 14. FAQ

**Will it make money?** Nobody can promise that. The model is a modest statistical tool, and fees are significant. Treat the project as a learning and testing tool first.

**Why does the model score only about 50 to 55%?** Short-term price moves are close to random. A score just above 50% is normal, and with only about 190 test candles per coin, the score has a margin of error of about 3.6 percentage points. Do not read too much into small differences.

**Is Gemini better than the statistical model?** Unknown, and it will differ over time. Gemini reads the same numbers you see; it does not have inside information or live news. Test both in paper mode.

**Does Gemini cost money?** Not on the free tier, within Google's limits. If you enable billing on your Google project, usage may be charged. Keep an eye on your Google account.

**Can I change modes from the page?** Yes: stop the bot, sell any open positions, then click Paper, Testnet or Live (section 7.4). Keys still live only in `.env`.

**Does the AI keep learning?** It retrains on the latest 1000 candles about every 12.5 hours (50 candles at 15 minutes), and once when the bot starts.

**Can I close the browser?** Yes. The bot runs in the program window, not in the page.

**Can I close the program window?** That stops the bot. Open positions stay open on Binance (live or testnet) but are **no longer protected**.

**Does it use leverage or shorting?** No. It trades spot only and is long only (buy, then sell).

**Can I use pairs other than USDT?** Not currently. Only `/USDT` pairs are supported.

**What time zone is "today"?** UTC. The daily loss limit and the "Today" figure reset at midnight UTC. If you are UTC+2, that is 02:00 local time.

**Can I run it on a server so it runs 24/7?** Technically yes, but the dashboard has no password. If you do this, keep it bound to `127.0.0.1` and reach it only through a secure tunnel such as SSH. Never expose port 8000 to the internet.

**Where are my API keys stored?** Only in `backend/.env` on your computer (Binance and Gemini keys). They are never sent to the web page, and the Gemini key is only sent to Google's API.

---

## 15. Files, backups, updating, uninstalling

| Path | Purpose |
|---|---|
| `backend/.env` | Your settings and keys. **Private. Never share.** |
| `backend/data/state_<mode>_<source>.json` | Saved positions, trades, paper cash, starting equity. Back this up if you care about the history. |
| `backend/data/gemini_usage.json` | Counts today's Gemini calls so the daily cap survives restarts. |
| `backend/.venv/` | The private Python environment. Can be deleted and recreated. |

**Reset everything for one mode:** stop the program and delete its state file (or use **Reset paper account**).

**Updating:** replace the project files with the new version but **keep your `.env`**. If `requirements.txt` changed, delete `backend\.venv\installed.flag` and run the launcher again so it reinstalls libraries.

**Uninstalling:** delete the project folder. Nothing else is installed outside it (apart from Python itself, if the launcher installed it).

---

## 16. Glossary

| Term | Meaning |
|---|---|
| **Gemini** | Google's AI model family. Here it reads market numbers and gives a BUY / SELL / HOLD opinion. |
| **AI engine** | Which brain decides: the statistical model, Gemini, or both together. |
| **Confidence** | How sure Gemini says it is (0 to 100%). It is an opinion, not a measured probability. |
| **Candle** | A summary of price for one time period (open, high, low, close). |
| **Spot** | Buying the real coin, without leverage or borrowing. |
| **USDT** | A dollar-pegged coin used as money on Binance. |
| **Paper trading** | Practising with simulated money. |
| **Testnet** | Binance's practice exchange with fake money. |
| **Stop-loss** | A price at which a losing trade is closed to limit the damage. |
| **Take-profit** | A price at which a winning trade is closed to keep the gain. |
| **ATR** | Average True Range: the typical size of a candle. Used to set the stop distance. |
| **P(up)** | The model's estimated probability that the price is higher in a few candles. |
| **Slippage** | The difference between the expected price and the price you actually get. |
| **Drawdown** | A fall in account value from a previous high. |
| **Baseline** | The score you would get by always guessing the more common direction. The model should beat it. |
| **Market order** | An order that executes immediately at the best available price. |
| **UTC** | The world time standard used for the "day" in the daily loss limit. |
