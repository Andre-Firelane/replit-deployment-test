# Setup-Anleitung – Neues Projekt aufsetzen

Diese Anleitung beschreibt Schritt für Schritt, wie ein neues Projekt mit diesem Stack aufgesetzt wird:
**Vanilla JS Frontend · Node/Express Backend · Supabase DB · Replit Deployment via GitHub**

---

## Übersicht

```
GitHub (main/dev) ──→ Replit (deployed main)
                           ↓
                    Supabase Prod DB

Lokal (dev Branch) ──→ Supabase Dev DB
```

---

## Schritt 1 – GitHub Repository

1. Neues Repository auf GitHub erstellen (z.B. `mein-projekt`)
2. Lokal klonen:
   ```bash
   git clone https://github.com/<user>/<repo>.git
   cd <repo>
   ```
3. `dev` Branch erstellen:
   ```bash
   git checkout -b dev
   git push origin dev
   ```
4. In GitHub → Settings → Branches → Default branch auf `dev` setzen

---

## Schritt 2 – Supabase: Zwei Projekte erstellen

Jedes Projekt braucht **zwei** Supabase-Projekte: eines für Dev, eines für Prod.

### 2.1 Projekte anlegen

1. [supabase.com](https://supabase.com) → New Project
2. **Dev-Projekt** anlegen:
   - Name: `mein-projekt-dev`
   - Region: z.B. West EU (Ireland)
   - Passwort merken (wird nicht weiter benötigt)
3. **Prod-Projekt** anlegen:
   - Name: `mein-projekt-prod`
   - gleiche Region wie Dev

### 2.2 Keys heraussuchen

Für **jedes** der beiden Projekte:

```
Supabase Dashboard → Projekt auswählen → Project Settings → API
```

Dort findest du:
| Wert | Wo | Verwendung |
|------|----|------------|
| **Project URL** | "Project URL" | `SUPABASE_URL` |
| **anon key** | "Project API Keys" → anon/public | `SUPABASE_ANON_KEY` |
| **Reference ID** | Project Settings → General → Reference ID | für CLI-Befehle |

> Die **Service Role Key** wird hier nicht benötigt – niemals im Frontend verwenden.

### 2.3 Initiale Migration auf beiden DBs ausführen

```bash
# Supabase Access Token holen: supabase.com/dashboard/account/tokens
# → "Generate new token" → Name z.B. "local-dev"

# Dev verknüpfen und Migration ausführen
SUPABASE_ACCESS_TOKEN=<token> npx supabase link --project-ref <dev-ref>
SUPABASE_ACCESS_TOKEN=<token> npx supabase db query --linked -f migrations/001_create_tasks.sql

# Prod verknüpfen und Migration ausführen
SUPABASE_ACCESS_TOKEN=<token> npx supabase link --project-ref <prod-ref>
SUPABASE_ACCESS_TOKEN=<token> npx supabase db query --linked -f migrations/001_create_tasks.sql
```

---

## Schritt 3 – Lokale Entwicklungsumgebung

### 3.1 Dependencies installieren

```bash
npm install
```

### 3.2 `.env` Datei anlegen

Im Projektroot `.env` erstellen (niemals committen – steht in `.gitignore`):

```
# Supabase CLI Auth
SUPABASE_ACCESS_TOKEN=sbp_<dein-access-token>

# Dev Supabase (für lokale Entwicklung)
SUPABASE_URL=https://<dev-ref>.supabase.co
SUPABASE_ANON_KEY=<dev-anon-key>

# Prod Supabase (nur für Migrations-Deployment)
SUPABASE_URL_PROD=https://<prod-ref>.supabase.co
SUPABASE_ANON_KEY_PROD=<prod-anon-key>

# Port
PORT=3000
```

### 3.3 Server starten und testen

```bash
node server.js
# → http://localhost:3000
```

---

## Schritt 4 – Replit einrichten

### 4.1 Neues Repl erstellen

1. [replit.com](https://replit.com) → Create Repl
2. **Import from GitHub** wählen
3. Repository auswählen → Branch: `main`
4. Language: Node.js

### 4.2 Production Secrets setzen

```
Replit → Adjust Settings → Production app secrets → Add secret
```

Folgende drei Secrets eintragen (die **Prod**-Werte aus Supabase):

| Key | Value |
|-----|-------|
| `SUPABASE_URL` | `https://<prod-ref>.supabase.co` |
| `SUPABASE_ANON_KEY` | `<prod-anon-key>` |
| `PORT` | wird von Replit automatisch gesetzt – nicht nötig |

> Die Dev-Credentials kommen **nicht** nach Replit. Replit bekommt ausschließlich Prod-Keys.

### 4.3 Run Command setzen

```
Replit → Adjust Settings → Run command:
node server.js
```

### 4.4 Git-Konfiguration in Replit (einmalig)

Im Replit-Terminal ausführen:

```bash
git config pull.rebase true
```

Verhindert Merge-Konflikte wenn Replit eigene Auto-Commits erstellt und wir von GitHub pushen.

### 4.5 Erstes Deployment

```
Replit → Publishing → Publish
```

---

## Schritt 5 – Workflow ab jetzt

Der normale Entwicklungszyklus (dokumentiert in `CLAUDE.md`):

```
dev Branch → lokal testen → Migration auf Dev-DB
    → Commit & Push dev
        → Migration auf Prod-DB
            → merge dev → main → push
                → Replit: Publish
```

**Goldene Reihenfolge beim Deployment:**
1. Migration zuerst auf Prod-DB anwenden
2. Dann Code nach `main` pushen
3. Dann in Replit publishen

---

## Schnellreferenz: Wo kommen welche Keys hin?

| Key | Lokal `.env` | Replit Secrets | Im Code |
|-----|:---:|:---:|:---:|
| Dev `SUPABASE_URL` | ✅ | ❌ | ❌ |
| Dev `SUPABASE_ANON_KEY` | ✅ | ❌ | ❌ |
| Prod `SUPABASE_URL` | ✅ (als `_PROD`) | ✅ (als `SUPABASE_URL`) | ❌ |
| Prod `SUPABASE_ANON_KEY` | ✅ (als `_PROD`) | ✅ (als `SUPABASE_ANON_KEY`) | ❌ |
| `SUPABASE_ACCESS_TOKEN` | ✅ | ❌ | ❌ |
