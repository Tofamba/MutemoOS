# Mutemo Desk
## Zimbabwe Legal Practice Operating System
### v1.0 — Pilot Build for Sawyer & Mkushi Legal Practitioners

**Mutemo** = Law / Rule in Shona

---

## What This Is

Mutemo Desk is a legal practice operating system built specifically for Zimbabwean legal practice. It gives advocates and legal practitioners:

- **Precedent Vault** — upload firm documents (PDF, DOCX, email), index them, search by meaning (semantic search) in plain English
- **OCR for Scanned Documents** — Magistrates Court rulings and other scanned/photographed documents are automatically read using Tesseract OCR, no manual conversion needed
- **Legal Updates** — a separate, clearly-attributed collection for Zimbabwean legislation (Acts, SIs) and case law (judgments) from ZimLII/Veritas, searchable alongside firm precedents
- **Email Reminders** — daily email summary of upcoming hearings, deadlines, and filings, with a calendar (.ics) attachment for one-tap adding to phone/computer calendars
- **Persistent Storage** — all data (matters, documents, calendar, settings) is saved to disk and survives restarts
- **Optional Password Protection** — set one password to require login before anyone can access the system
- **AI Affidavit Generator** — draft Zimbabwe High Court affidavits powered by Claude AI, using your own firm's precedents as context
- **DOCX Export** — download properly formatted Word documents ready for filing
- **Court Calendar** — track hearings, deadlines, and filing dates

---

## Getting This Onto GitHub

If this folder isn't a git repository yet:

```bash
cd mutemo-desk
git init
git add .
git commit -m "Mutemo Desk v1.3 — initial commit"
```

Then connect it to a repo you've already created on GitHub (e.g. `mutemo-desk`):

```bash
git remote add origin https://github.com/YOUR-USERNAME/mutemo-desk.git
git branch -M main
git push -u origin main
```

**Important:** `.env` is excluded by `.gitignore` and will never be committed — your API keys and email credentials stay local. Only `.env.example` (with placeholder values) is tracked.

For future updates, the usual cycle is:
```bash
git add .
git commit -m "describe what changed"
git push
```

---

## Hosting on Railway (Recommended for the Pilot)

This is the **plug-and-play option** — Nyari gets a URL, opens it in a browser, and everything just works. No Python, Node, Tesseract, or Poppler installs on anyone's machine. Everything runs in a container on Railway's servers, built from the included `Dockerfile`.

### What's Included for This

- **`Dockerfile`** — builds an image with Python, Node.js, Tesseract, and Poppler all pre-installed
- **`.dockerignore`** — keeps the build lean

Railway auto-detects the `Dockerfile` — no extra config file needed.

### One-Time Setup Steps

**1. Push this code to GitHub** (see above) — Railway deploys directly from your repo.

**2. Create a new project**
   - In Railway, click **New Project** → **Deploy from GitHub repo**
   - Select `Tofamba/Mutemo`
   - Railway detects the `Dockerfile` and starts building automatically

**3. Set environment variables**

Go to the service's **Variables** tab and add:
   - `ANTHROPIC_API_KEY` — your real key from console.anthropic.com
   - `MUTEMO_USERNAME` — e.g. `mutemo` (optional, defaults to `mutemo`)
   - `MUTEMO_PASSWORD` — choose a password (this protects the whole app — share it with Nyari separately)
   - `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASSWORD`, `SMTP_FROM` — if you want email reminders working (optional, can add later)

**4. Add a persistent volume**

Go to the service's **Settings** tab → **Volumes** → **New Volume**:
   - Mount path: `/app/data`

This ensures uploaded documents, matters, and calendar events survive redeploys and restarts.

**5. Generate a public URL**

Go to **Settings** → **Networking** → **Generate Domain**. Railway gives you a URL like:

```
https://mutemo-desk.up.railway.app
```

**6. Share with Nyari**

Send her the URL plus the `MUTEMO_USERNAME` and `MUTEMO_PASSWORD` you set — through a secure channel (not email/WhatsApp in plain text; consider a password manager's sharing feature, or read it to her over a call).

### Cost

Railway bills based on actual usage (CPU/RAM/time). For a small pilot like this, expect roughly **$5–10/month**, depending on usage. The persistent volume is included in this — no separate database or storage fees.

### Updating the Deployed App

Whenever you push changes to GitHub:

```bash
git add .
git commit -m "describe what changed"
git push
```

Railway automatically rebuilds and redeploys — usually within a few minutes. No manual steps on the server.

### Checking It's Healthy

Visit `https://your-app.up.railway.app/api/health` — this shows whether Tesseract, Node, email, and the Anthropic key are all correctly configured, without needing to log in (this endpoint is exempt from password protection).

---

## Running Locally (For Development/Testing)

This section is for running on your own machine — useful for development or if you prefer not to use Render. **For the pilot with Nyari, the Render hosting option above is recommended instead.**

### Prerequisites
- Python 3.10+
- Node.js 18+ (for DOCX export)
- Tesseract OCR + Poppler (for scanned document support)
- Anthropic API key → https://console.anthropic.com

**Install system dependencies (Ubuntu/Debian):**
```bash
sudo apt install tesseract-ocr poppler-utils
```

**macOS:**
```bash
brew install tesseract poppler
```

**Windows:**
- Tesseract: https://github.com/UB-Mannheim/tesseract/wiki (installer)
- Poppler: https://github.com/oschwartz10612/poppler-windows (add `bin/` to PATH)

### 1. Install Python dependencies
```bash
cd mutemo-desk
pip install -r requirements.txt
```

### 2. Configure environment

Copy the example environment file and fill in your values:

```bash
cp .env.example .env
```

Edit `.env` and set at minimum:
```
ANTHROPIC_API_KEY=sk-ant-your-key-here
```

The app loads `.env` automatically — no need to `export` variables manually.

### 2b. (Optional) Email reminders

To enable daily email reminders, also set in `.env`:

```
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=youraddress@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_FROM=youraddress@gmail.com
```

**For Gmail:** use an "App Password" (not your normal password) — generate one at https://myaccount.google.com/apppasswords (requires 2-factor authentication enabled).

**For Outlook/Office 365:** `SMTP_HOST=smtp.office365.com`, `SMTP_PORT=587`.

If these variables are not set, the Calendar tab will show a warning, and reminder emails won't send — everything else continues to work normally.

### 3. Run the server
```bash
cd backend
python main.py
```

### 4. Open the app
Open your browser to: **http://localhost:8000**

Or open `frontend/index.html` directly in your browser.

---

## Project Structure

```
mutemo-desk/
├── backend/
│   └── main.py              ← FastAPI application
├── frontend/
│   └── index.html           ← Complete single-page UI
├── requirements.txt
└── README.md
```

---

## How To Use

### Indexing Documents (Precedent Vault)

1. Click **Vault** tab
2. Create a matter (or select an existing one)
3. Upload PDF, DOCX, or email files
4. Click **Index documents into Precedent Vault**
5. Documents are extracted, chunked, and indexed for search

### Searching Precedents

1. Click **Search Vault** tab
2. Type a plain English question: *"lease escalation clauses commercial property"*
3. Optionally filter by matter type or document type
4. AI synthesises an answer from your firm's own documents
5. Click **Use as precedent** to load a result into the affidavit generator

**Search is semantic** — it matches by meaning, not just exact words. A search for "tenant refused to leave" can find documents that say "occupier remained in unlawful possession," even though the wording is completely different. This works using a local AI embedding model (no external API calls, no extra cost).

### Generating Affidavits

1. Click **Draft Affidavit** tab
2. Fill in deponent details, court, parties, and facts
3. Optionally load a precedent from the vault
4. Click **Generate Affidavit**
5. Edit the result directly in the text area
6. Click **Download .docx** to get a Word document

### Court Calendar

1. Click **Court Calendar** tab
2. Add hearings, deadlines, and filing dates
3. Upcoming events are highlighted — urgent events (within 3 days) are flagged
4. Badge on the nav shows urgent event count

### Email Reminders

In the **Court Calendar** tab, the "Email Reminders" card lets you:

1. Enter a recipient email address
2. Choose a daily send time (in Central Africa Time, CAT)
3. Turn reminders on
4. Click **Send Test Email** to confirm it works immediately

Once enabled, an email is sent once per day at the chosen time, summarising:
- Events happening **today** (most urgent)
- Events happening **tomorrow**
- Everything else in the next 7 days

Each email includes an **.ics calendar file** attachment — open it on a phone or computer to add all the events to a personal calendar app with one tap.

If the server hasn't been configured with email credentials, a warning appears and the rest of the system continues to work normally — reminders are optional.

### Data Persistence

All data — matters, documents, calendar events, legal updates, and reminder settings — is automatically saved to `data/mutemo_state.json` after every change. If the server restarts or the computer reboots, everything is reloaded automatically. No setup needed; this works out of the box.

**Note:** the `data/` folder is excluded from git (it's listed in `.gitignore`), since it contains your firm's actual documents and should never be uploaded to a shared repository. Back this folder up separately if needed.

### Semantic Search (Meaning-Based)

Search uses a local AI embedding model (`all-MiniLM-L6-v2`, ~80MB, baked into the Docker image) to find documents by **meaning**, not just matching words. A search for "tenant refused to leave" can surface a document that says "occupier remained in unlawful possession" — no shared words, but the same meaning.

This runs entirely on the server — no external API calls, no extra cost, no additional API key.

**If you uploaded documents before this feature was added**, they won't be in the semantic index yet (only the keyword index). To migrate them, call:

```bash
curl -X POST https://your-app-url/api/admin/reindex
```

(If password protection is enabled, add `-u username:password` to the command.) This is safe to run any time, including repeatedly — it simply re-embeds everything currently in the vault. New uploads are indexed automatically; this is only needed once, for documents uploaded before the upgrade.

If the embedding model fails to load for any reason, search automatically falls back to keyword matching — nothing breaks, results are just less flexible until the issue is resolved. Check `/api/health` to confirm `semantic_search: true`.

### Password Protection

By default, anyone who can reach the app's URL can use it — fine if it's only accessible on `localhost` or a trusted local network. If you plan to host it anywhere more widely accessible, set a password:

In `.env`:
```
MUTEMO_USERNAME=mutemo
MUTEMO_PASSWORD=choose-a-strong-password
```

Restart the server. The browser will now prompt for a username and password before showing anything. Share these credentials with Nyari (and anyone else who needs access) through a secure channel — not email or chat.

If `MUTEMO_PASSWORD` is left unset, no login is required (the `/api/health` endpoint always remains accessible for monitoring).

### Legal Updates (Legislation & Case Law)

This is a **separate collection** from your firm's private precedents — public legislation and judgments from ZimLII/Veritas.

**Important: Mutemo Desk does not scrape these sites.** ZimLII's terms of use explicitly prohibit automated scraping/bulk downloading. Instead:

1. Browse zimlii.org or veritaszim.net normally, as you would in any browser
2. Download the Act, SI, or judgment PDF you need
3. Click **Legal Updates** tab in Mutemo Desk
4. Select type (Legislation or Case Law), source, and optional reference (e.g. "SI 76 of 2025")
5. Upload — it's indexed using the same OCR/classification pipeline

When you search the vault, results from Legal Updates appear separately and are clearly labeled with their source and licence (ZimLII content is CC BY-NC — free to use with attribution, non-commercial).

If your firm later obtains bulk/API access from ZimLII (their terms invite this for legitimate use cases — email them), this section is ready to be fed automatically with no UI changes needed.

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |
| GET | `/api/matters` | List all matters |
| POST | `/api/matters` | Create a matter |
| DELETE | `/api/matters/{id}` | Delete a matter |
| GET | `/api/matters/{id}/documents` | List documents in a matter |
| POST | `/api/upload` | Upload and index a document |
| POST | `/api/search` | Search the precedent vault |
| POST | `/api/generate-affidavit` | Generate an affidavit |
| POST | `/api/export-docx` | Export affidavit as .docx |
| GET | `/api/calendar` | List all calendar events |
| POST | `/api/calendar` | Add a calendar event |
| DELETE | `/api/calendar/{id}` | Delete a calendar event |
| GET | `/api/legal-updates` | List legislation & case law items |
| POST | `/api/legal-updates/upload` | Upload an Act, SI, or judgment |
| DELETE | `/api/legal-updates/{id}` | Delete a legal update item |
| POST | `/api/legal-updates/search` | Search legislation & case law only |
| GET | `/api/reminders/settings` | Get email reminder settings |
| POST | `/api/reminders/settings` | Update email reminder settings |
| POST | `/api/reminders/send-test` | Send a test reminder email immediately |
| POST | `/api/admin/reindex` | Re-index existing documents for semantic search (one-time migration) |
| GET | `/docs` | Interactive API documentation |

---

## Pilot Validation Questions

After showing Advocate Nyari Maphosa, ask:

1. Is the affidavit format correct for High Court filing?
2. What would you change in the AI's language or structure?
3. If you could search 20 years of firm precedents in 3 seconds, what would you search first?
4. Does the calendar capture the types of deadlines you currently miss?
5. What document type would you want generated next?

---

## Roadmap

| Version | What |
|---------|------|
| v1.0 | Affidavit generator + Precedent Vault + Court Calendar ✓ |
| v1.1 | WhatsApp deadline reminders via Twilio |
| v1.2 | More document types (lease, employment contract, company resolution) |
| v1.3 | Multi-user login with firm-level isolation |
| v1.4 | IECMS-ready document export |
| v2.0 | PostgreSQL persistence + offline-first PWA |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | FastAPI (Python) |
| AI | Anthropic Claude API |
| PDF extraction | pdfplumber |
| DOCX parsing | python-docx |
| DOCX generation | docx (Node.js) |
| Frontend | Vanilla HTML/CSS/JS — no framework dependencies |
| Database (pilot) | In-memory (Python dicts) |
| Database (v2) | PostgreSQL + pgvector |

---

## Cost Estimate

| Operation | Approximate Cost |
|-----------|-----------------|
| Affidavit generation | ~$0.02 per document |
| Document classification | ~$0.002 per document |
| Search synthesis | ~$0.01 per search |
| Monthly usage (active lawyer, 100 docs + 50 searches) | ~$3–5/month API cost |

At USD $29/month per user, margins are strong.

---

*Built for Zimbabwean legal practice. 🇿🇼*
*Mutemo — because the law deserves tools that understand it.*
