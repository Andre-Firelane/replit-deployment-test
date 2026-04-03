# Project Briefing – Tasks CRUD App

## Stack
- **Frontend**: Vanilla HTML/CSS/JS
- **Backend**: Node.js + Express
- **Datenbank**: Supabase (PostgreSQL)
- **Deployment**: Replit (Production) via GitHub

---

## Projektstruktur

```
├── server.js              # Express-Server, liefert Frontend & Supabase-Config
├── public/
│   └── index.html         # Komplette CRUD-App (Vanilla JS)
├── migrations/            # Alle DB-Migrationen in Reihenfolge
│   ├── 001_create_tasks.sql
│   └── 002_add_priority_column.sql
├── .env                   # Lokale Credentials (niemals committen)
├── .env.example           # Vorlage für Credentials
└── CLAUDE.md              # Dieses Briefing
```

---

## Branch-Strategie

| Branch | Zweck |
|--------|-------|
| `dev`  | Entwicklung – hier wird immer gearbeitet |
| `main` | Production – wird auf Replit deployed |

**Regel:** Niemals direkt auf `main` committen. Immer auf `dev` entwickeln, testen, dann nach `main` mergen.

---

## Supabase – Zwei Projekte

| Umgebung | Projekt | Verwendung |
|----------|---------|------------|
| Dev | `tasks-crud-dev` | Lokale Entwicklung (.env) |
| Prod | `tasks-crud-prod` | Replit Deployment Secrets |

### Supabase CLI Setup (einmalig)

```bash
npm install -g supabase
supabase login   # öffnet Browser → mit Access Token authentifizieren
```

### Projekte verknüpfen

```bash
# Dev-Projekt verknüpfen
supabase link --project-ref itqxfugwtesmxzwagonn

# Für Prod-Operationen (explizit angeben)
supabase link --project-ref yjlannwxvxwtvowhysdq
```

Project Refs findest du in: Supabase Dashboard → Project Settings → General → **Reference ID**

---

## Datenbank-Migrations-Workflow

### Neue Migration erstellen

1. Neue Datei in `migrations/` anlegen (Nummerierung fortführen):
   ```
   migrations/003_beschreibung.sql
   ```

2. SQL schreiben – immer so formulieren dass es idempotent ist:
   ```sql
   ALTER TABLE tasks ADD COLUMN IF NOT EXISTS neue_spalte TEXT;
   ```

3. Migration auf Dev anwenden:
   ```bash
   supabase db execute --file migrations/003_beschreibung.sql --project-ref DEV_PROJECT_REF
   ```

4. Lokal testen (`node server.js`)

5. Code anpassen (Frontend, Backend)

6. Committen auf `dev`:
   ```bash
   git add .
   git commit -m "Add: 003_beschreibung"
   git push origin dev
   ```

### Nach Prod deployen (nur wenn alles getestet)

**Reihenfolge ist wichtig: erst DB, dann Code!**

```bash
# 1. Migration auf Prod anwenden
supabase db execute --file migrations/003_beschreibung.sql --project-ref PROD_PROJECT_REF

# 2. Code nach main mergen
git checkout main
git merge dev
git push origin main
git checkout dev

# 3. In Replit → Publish klicken
```

---

## Lokale Entwicklung

```bash
# Dependencies installieren (einmalig)
npm install

# Server starten
node server.js
# → http://localhost:3000
```

### .env Datei (lokale Credentials)

```
SUPABASE_URL=https://[dev-project-ref].supabase.co
SUPABASE_ANON_KEY=[dev-anon-key]
PORT=3000
```

---

## Deployment (Replit)

- Replit trackt den `main` Branch auf GitHub
- Deployment wird **manuell** in Replit → Publishing → Publish ausgelöst
- Production Secrets sind in Replit → Adjust Settings → Production app secrets hinterlegt
- Run command: `node server.js`

---

## Goldene Regeln

1. **Niemals `.env` committen** – steht in `.gitignore`
2. **Niemals direkt in Prod-Supabase experimentieren** – immer erst Dev
3. **Immer erst DB migrieren, dann Code deployen**
4. **Migrations-Dateien niemals rückwirkend ändern** – neue Datei anlegen
5. **Immer auf `dev` Branch arbeiten**, nie auf `main`
