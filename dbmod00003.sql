CREATE TABLE IF NOT EXISTSlive_scores (
  event_id   uuid   NOT NULL,
  round_idx  int    NOT NULL,
  match_idx  int    NOT NULL,
  cell_type  text   NOT NULL,
  cell_key   text   NOT NULL,
  hole       int    NOT NULL,
  value      numeric,
  updated_at timestamptz DEFAULT now(),
  PRIMARY KEY (event_id, round_idx, match_idx, cell_type, cell_key, hole)
);

ALTER PUBLICATION supabase_realtime ADD TABLE live_scores;

ALTER TABLE live_scores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all on live_scores" ON live_scores
  FOR ALL USING (true) WITH CHECK (true);