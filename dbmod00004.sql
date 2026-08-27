CREATE TABLE IF NOT EXISTS course_library (
  course_key  text PRIMARY KEY,
  course_data jsonb NOT NULL,
  updated_at  timestamptz DEFAULT now()
);