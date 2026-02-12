# Golf Tournament Tracker - Supabase Quick Start

Get your app connected to the cloud in 15 minutes!

## 🎯 What You'll Get

✅ **Multi-device sync** - All devices see the same data
✅ **Real-time updates** - Scores appear instantly everywhere
✅ **Cloud storage** - Never lose data again
✅ **Offline mode** - Works without internet, syncs when back online
✅ **No server costs** - Free tier is plenty for most tournaments

## 🚀 15-Minute Setup

### Step 1: Create Supabase Account (3 minutes)

1. Go to [supabase.com](https://supabase.com)
2. Click "Start your project" → Sign up with GitHub
3. Create new project:
   - Name: `Golf Tracker`
   - Database Password: (save this!)
   - Region: Choose closest to you
4. Wait 2 minutes for setup

### Step 2: Create Database (2 minutes)

1. Click **SQL Editor** in left sidebar
2. Click **New Query**
3. Copy entire contents of `supabase_schema.sql`
4. Paste and click **Run**
5. Should see "Success. No rows returned"

### Step 3: Enable Real-time (1 minute)

1. Go to **Database** → **Replication**
2. Find these tables and toggle them ON:
   - events
   - teams
   - matches
   - hole_scores
3. Click **Save**

### Step 4: Get Your API Keys (1 minute)

1. Go to **Settings** → **API**
2. Copy these (you'll need them):
   ```
   Project URL: https://xxxxx.supabase.co
   anon public key: eyJhbG....(very long string)
   ```

### Step 5: Update Your HTML File (5 minutes)

1. Open `golf-outing-tracker.html`
2. Find line with `<script>` (near top of file)
3. **Add this line** right BEFORE the first `<script>`:
   ```html
   <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
   ```

4. **Add this code** right AFTER the opening `<script>` tag:
   ```javascript
   // Supabase Configuration
   const SUPABASE_URL = 'YOUR_PROJECT_URL_HERE';
   const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY_HERE';
   const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
   ```

5. Replace `YOUR_PROJECT_URL_HERE` with your actual URL
6. Replace `YOUR_ANON_KEY_HERE` with your actual key

### Step 6: Add Integration Code (3 minutes)

Copy the code from `supabase_integration.js` and add it to your HTML file right after the Supabase configuration you just added.

## ✅ Test It!

1. Open the HTML file in Chrome
2. Create a test event
3. Open the SAME file in a different browser (or on your phone)
4. You should see the event appear automatically!
5. Enter a score on one device
6. Watch it appear on the other device instantly! 🎉

## 🔧 Troubleshooting

### "supabase is not defined"
- Make sure you added the Supabase CDN script BEFORE your code
- Check browser console for errors
- Hard refresh (Ctrl+Shift+R)

### Scores not syncing
1. Check Supabase dashboard → Database → Replication
2. Make sure Real-time is enabled for all tables
3. Check browser console for errors

### "Failed to fetch"
- Verify your URL and key are correct (no typos!)
- Check internet connection
- Check Supabase dashboard is accessible

## 📱 Using on Multiple Devices

### Same WiFi Network
1. Just open the HTML file on each device
2. Everything syncs automatically

### Different Networks
**Option A: Upload to web host**
- Upload HTML file to any web host (GitHub Pages, Netlify, Vercel)
- Share the URL with everyone

**Option B: Send file directly**
- Email/text the HTML file to participants
- Everyone opens it on their device
- All sync through Supabase

## 💡 Pro Tips

### Offline Mode
- App automatically saves to local storage when offline
- Syncs to cloud when connection returns
- Shows "Offline mode" indicator

### Data Management
- View all data in Supabase dashboard → Table Editor
- Can manually edit/delete if needed
- Automatic daily backups

### Security
- Current setup: Anyone with the file can edit
- For production: Enable authentication (see Advanced Setup)

## 🎉 You're Done!

Test by:
1. Creating an event on Device A
2. Opening app on Device B
3. Seeing event appear automatically
4. Entering scores on Device A
5. Watching them update on Device B instantly

## 📚 Files You Need

1. **SUPABASE_SETUP.md** - Detailed documentation
2. **supabase_schema.sql** - Database tables (already ran this)
3. **supabase_integration.js** - JavaScript code (already added this)
4. **golf-outing-tracker.html** - Your updated app

## 🆘 Need Help?

**Common Issues:**
- Browser console shows errors → Check API keys
- Data not saving → Check Supabase dashboard logs
- Not syncing → Check Real-time is enabled

**Still stuck?**
- Check Supabase docs: supabase.com/docs
- Post in Supabase Discord: discord.supabase.com

## 🚀 Next Steps

Once working:
- [ ] Test with 2-3 devices
- [ ] Try entering live scores
- [ ] Verify data in Supabase dashboard
- [ ] Share with your tournament group
- [ ] Consider adding authentication for security

Enjoy your cloud-powered golf tracker! ⛳🏌️✨
