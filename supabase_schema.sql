-- Golf Tournament Tracker - Supabase Schema
-- Run this in Supabase SQL Editor after creating your project

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- EVENTS TABLE
-- ============================================================================
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_name TEXT NOT NULL,
    scoring_type TEXT NOT NULL CHECK (scoring_type IN ('match', 'stroke')),
    blowout_bonus_enabled BOOLEAN DEFAULT FALSE,
    num_rounds INTEGER NOT NULL DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- TEAMS TABLE
-- ============================================================================
CREATE TABLE teams (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    team_name TEXT NOT NULL,
    total_points DECIMAL(10, 2) DEFAULT 0.00,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_teams_event ON teams(event_id);

-- ============================================================================
-- PLAYERS TABLE
-- ============================================================================
CREATE TABLE players (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    player_name TEXT NOT NULL,
    phone_number TEXT,
    email TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_players_name ON players(player_name);

-- ============================================================================
-- TEAM_PLAYERS TABLE
-- ============================================================================
CREATE TABLE team_players (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    is_captain BOOLEAN DEFAULT FALSE,
    UNIQUE(team_id, player_id)
);

CREATE INDEX idx_team_players_team ON team_players(team_id);
CREATE INDEX idx_team_players_player ON team_players(player_id);

-- ============================================================================
-- ROUNDS TABLE
-- ============================================================================
CREATE TABLE rounds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    event_id UUID NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    round_number INTEGER NOT NULL,
    format TEXT NOT NULL,
    round_date DATE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(event_id, round_number)
);

CREATE INDEX idx_rounds_event ON rounds(event_id);

-- ============================================================================
-- MATCHES TABLE
-- ============================================================================
CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    round_id UUID NOT NULL REFERENCES rounds(id) ON DELETE CASCADE,
    team_0_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    team_1_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    match_result TEXT CHECK (match_result IN ('team_0_win', 'team_1_win', 'tie', 'pending')),
    team_0_score INTEGER,
    team_1_score INTEGER,
    hole_finished INTEGER CHECK (hole_finished BETWEEN 1 AND 18),
    margin_of_victory INTEGER,
    blowout_bonus DECIMAL(5, 2) DEFAULT 0.00,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_matches_round ON matches(round_id);
CREATE INDEX idx_matches_teams ON matches(team_0_id, team_1_id);

-- ============================================================================
-- MATCH_PLAYERS TABLE
-- ============================================================================
CREATE TABLE match_players (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    UNIQUE(match_id, player_id)
);

CREATE INDEX idx_match_players_match ON match_players(match_id);
CREATE INDEX idx_match_players_player ON match_players(player_id);

-- ============================================================================
-- HOLE_SCORES TABLE
-- ============================================================================
CREATE TABLE hole_scores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
    hole_number INTEGER NOT NULL CHECK (hole_number BETWEEN 1 AND 18),
    score INTEGER CHECK (score BETWEEN 1 AND 15),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(match_id, player_id, hole_number)
);

CREATE INDEX idx_hole_scores_match ON hole_scores(match_id, hole_number);
CREATE INDEX idx_hole_scores_player ON hole_scores(player_id);

-- ============================================================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to events table
CREATE TRIGGER update_events_updated_at
    BEFORE UPDATE ON events
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Apply to matches table
CREATE TRIGGER update_matches_updated_at
    BEFORE UPDATE ON matches
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) - Optional but Recommended
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_players ENABLE ROW LEVEL SECURITY;
ALTER TABLE rounds ENABLE ROW LEVEL SECURITY;
ALTER TABLE matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE match_players ENABLE ROW LEVEL SECURITY;
ALTER TABLE hole_scores ENABLE ROW LEVEL SECURITY;

-- Allow public read access (anyone can view)
CREATE POLICY "Allow public read on events" ON events FOR SELECT USING (true);
CREATE POLICY "Allow public read on teams" ON teams FOR SELECT USING (true);
CREATE POLICY "Allow public read on players" ON players FOR SELECT USING (true);
CREATE POLICY "Allow public read on team_players" ON team_players FOR SELECT USING (true);
CREATE POLICY "Allow public read on rounds" ON rounds FOR SELECT USING (true);
CREATE POLICY "Allow public read on matches" ON matches FOR SELECT USING (true);
CREATE POLICY "Allow public read on match_players" ON match_players FOR SELECT USING (true);
CREATE POLICY "Allow public read on hole_scores" ON hole_scores FOR SELECT USING (true);

-- Allow public write access (anyone can create/update/delete)
-- WARNING: For production, you should restrict this to authenticated users
CREATE POLICY "Allow public insert on events" ON events FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update on events" ON events FOR UPDATE USING (true);
CREATE POLICY "Allow public delete on events" ON events FOR DELETE USING (true);

CREATE POLICY "Allow public insert on teams" ON teams FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update on teams" ON teams FOR UPDATE USING (true);
CREATE POLICY "Allow public delete on teams" ON teams FOR DELETE USING (true);

CREATE POLICY "Allow public insert on players" ON players FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update on players" ON players FOR UPDATE USING (true);

CREATE POLICY "Allow public insert on team_players" ON team_players FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete on team_players" ON team_players FOR DELETE USING (true);

CREATE POLICY "Allow public insert on rounds" ON rounds FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update on rounds" ON rounds FOR UPDATE USING (true);

CREATE POLICY "Allow public insert on matches" ON matches FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update on matches" ON matches FOR UPDATE USING (true);

CREATE POLICY "Allow public insert on match_players" ON match_players FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete on match_players" ON match_players FOR DELETE USING (true);

CREATE POLICY "Allow public insert on hole_scores" ON hole_scores FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update on hole_scores" ON hole_scores FOR UPDATE USING (true);
CREATE POLICY "Allow public delete on hole_scores" ON hole_scores FOR DELETE USING (true);

-- ============================================================================
-- VIEWS FOR COMMON QUERIES
-- ============================================================================

-- Current standings view
CREATE VIEW vw_current_standings AS
SELECT 
    e.id as event_id,
    e.event_name,
    t.id as team_id,
    t.team_name,
    t.total_points,
    COUNT(DISTINCT m.id) as total_matches,
    COUNT(CASE WHEN m.match_result = 'team_0_win' AND m.team_0_id = t.id THEN 1
               WHEN m.match_result = 'team_1_win' AND m.team_1_id = t.id THEN 1 END) as wins,
    COUNT(CASE WHEN m.match_result = 'tie' THEN 1 END) as ties,
    COALESCE(SUM(CASE WHEN m.team_0_id = t.id OR m.team_1_id = t.id 
                      THEN m.blowout_bonus ELSE 0 END), 0) as total_bonus_points
FROM events e
JOIN teams t ON e.id = t.event_id
LEFT JOIN rounds r ON e.id = r.event_id
LEFT JOIN matches m ON r.id = m.round_id 
    AND (m.team_0_id = t.id OR m.team_1_id = t.id)
GROUP BY e.id, e.event_name, t.id, t.team_name, t.total_points;

-- ============================================================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================================================

-- Uncomment to insert sample data
/*
INSERT INTO events (event_name, scoring_type, blowout_bonus_enabled, num_rounds)
VALUES ('Test Tournament', 'match', true, 2);

INSERT INTO teams (event_id, team_name)
SELECT id, 'Team Red' FROM events WHERE event_name = 'Test Tournament'
UNION ALL
SELECT id, 'Team Blue' FROM events WHERE event_name = 'Test Tournament';

INSERT INTO players (player_name, phone_number) VALUES 
    ('Alice Smith', '555-0001'),
    ('Bob Jones', '555-0002'),
    ('Charlie Brown', '555-0003'),
    ('Diana Prince', '555-0004');
*/

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Check all tables were created
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Check all indexes
SELECT tablename, indexname 
FROM pg_indexes 
WHERE schemaname = 'public'
ORDER BY tablename, indexname;

-- Check RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;
