# Golf Tournament Tracker - Supabase Integration Guide

Complete serverless backend setup using Supabase for real-time multi-device sync.

## 🚀 What You Get

✅ **Real-time sync** across all devices
✅ **No server management** - completely serverless
✅ **Free tier** - 500MB database, 2GB bandwidth/month
✅ **User authentication** (optional)
✅ **Automatic backups**
✅ **PostgreSQL database** with REST API
✅ **Live updates** - see scores as they're entered

## 📋 Setup Steps

### Step 1: Create Supabase Account

1. Go to https://supabase.com
2. Click "Start your project"
3. Sign up with GitHub (recommended) or email
4. Create a new project:
   - **Name:** Golf Tournament Tracker
   - **Database Password:** (save this securely!)
   - **Region:** Choose closest to you
   - Click "Create new project"
5. Wait 2-3 minutes for setup to complete

### Step 2: Set Up Database Schema

1. In Supabase dashboard, click **SQL Editor** (left sidebar)
2. Click **New Query**
3. Copy and paste the contents of `supabase_schema.sql` (provided)
4. Click **Run** (or press Ctrl+Enter)
5. You should see "Success. No rows returned"

### Step 3: Configure Row Level Security (RLS)

**Option A: Public Access (Simple - No Login Required)**
- Anyone with the URL can view/edit
- Perfect for trusted groups
- Already configured in the schema

**Option B: User Authentication (Advanced)**
- Users must log in
- Better security
- See "Authentication Setup" section below

### Step 4: Get Your API Keys

1. In Supabase dashboard, click **Settings** (gear icon, left sidebar)
2. Click **API** in the settings menu
3. Copy these values:
   - **Project URL:** `https://xxxxx.supabase.co`
   - **anon (public) key:** `eyJhbGc...` (long string)

### Step 5: Update Your HTML File

1. Open `golf-outing-tracker.html`
2. Find the section marked `<!-- SUPABASE CONFIG -->`
3. Replace with your values:

```javascript
const SUPABASE_URL = 'YOUR_PROJECT_URL';
const SUPABASE_KEY = 'YOUR_ANON_KEY';
```

4. Save the file

### Step 6: Test It!

1. Open the HTML file in your browser
2. Create a test event
3. Open the same file on another device (or browser)
4. You should see the same event appear!

## 🔧 Configuration Options

### Enable Real-Time Updates

In Supabase dashboard:
1. Go to **Database** → **Replication**
2. Find your tables (events, teams, matches, etc.)
3. Toggle **Enable Realtime** for each table
4. Click **Save**

Now scores update live across all devices!

### Set Storage Limits

Free tier includes:
- 500MB database storage
- 2GB bandwidth/month
- Unlimited API requests

For most tournaments, this is plenty. To monitor usage:
1. Go to **Settings** → **Billing**
2. View current usage

## 🔐 Security Best Practices

### Public Mode (Default)
- Anyone can view/edit with the URL
- Good for: Small trusted groups, single events
- Security: Don't share URL publicly

### Authenticated Mode (Optional)
See "Authentication Setup" section below for:
- User login/signup
- Role-based permissions
- Admin-only editing

## 🐛 Troubleshooting

### "Failed to fetch" errors
- Check your SUPABASE_URL and SUPABASE_KEY are correct
- Make sure you're connected to internet
- Verify project is active in Supabase dashboard

### Data not syncing
- Enable Realtime in Supabase dashboard (see above)
- Check browser console for errors (F12)
- Verify RLS policies are set correctly

### Can't insert data
- Check RLS policies allow INSERT operations
- Verify API key is the "anon" key, not "service_role" key
- Check database schema was created successfully

## 📊 Monitoring & Maintenance

### View Data
1. Go to **Table Editor** in Supabase dashboard
2. Select a table (events, teams, matches)
3. View/edit data directly

### Backup Data
Automatic backups included in free tier:
- Daily backups (retained 7 days)
- Download backups: **Settings** → **Database** → **Backups**

### Export Data
```sql
-- In SQL Editor, run:
COPY (SELECT * FROM events) TO STDOUT WITH CSV HEADER;
```

## 🚀 Going Live

### Share with Your Group

**Option 1: Host the HTML File**
- Upload to GitHub Pages (free)
- Upload to Netlify (free)
- Upload to your web host

**Option 2: Direct File Sharing**
- Share the HTML file via email/Dropbox
- Everyone opens their own copy
- All sync to same Supabase database

### Production Checklist
- [ ] Database schema created
- [ ] RLS policies enabled
- [ ] Realtime enabled on tables
- [ ] API keys added to HTML file
- [ ] Tested on multiple devices
- [ ] Backup strategy in place

## 💰 Cost Estimates

**Free Tier (Most users):**
- Up to 500MB database
- 2GB bandwidth/month
- **Cost:** $0/month
- **Good for:** Up to ~50 tournaments/year

**Pro Tier (Heavy users):**
- 8GB database
- 50GB bandwidth/month
- **Cost:** $25/month
- **Good for:** Clubs with weekly events

## 📱 Features Enabled by Supabase

1. ✅ **Multi-device scoring** - Multiple people entering scores simultaneously
2. ✅ **Live scoreboard** - Display on TV that updates in real-time
3. ✅ **Remote access** - Check scores from home
4. ✅ **Data persistence** - Never lose your data
5. ✅ **Historical tracking** - Compare tournaments year-over-year
6. ✅ **Player statistics** - Track performance across events

## 🔄 Migration from LocalStorage

Your existing events in localStorage will still work! The app will:
1. Keep local events in localStorage
2. Save new events to Supabase
3. Load events from both sources

To migrate old events:
1. Open the app with Supabase configured
2. Load old event from localStorage
3. Re-save it (automatically saves to Supabase)

## 📞 Support

- **Supabase Docs:** https://supabase.com/docs
- **Supabase Discord:** https://discord.supabase.com
- **Database Issues:** Check SQL Editor for error messages

## 🎯 Next Steps

After basic setup:
1. Test with a practice event
2. Invite team to test multi-device
3. Set up realtime updates
4. Consider authentication if needed
5. Share with your golf group!

---

Ready to set up? Use the files:
- `supabase_schema.sql` - Database setup
- `golf-outing-tracker-supabase.html` - Updated app with Supabase integration
