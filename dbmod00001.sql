ALTER TABLE events 
ADD CONSTRAINT events_event_name_unique 
UNIQUE (event_name);