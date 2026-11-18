-- Fairway: database-level protection for locked events (run once in Supabase SQL Editor)

-- 1) A locked event can't be deleted
create or replace function fairway_block_locked_event_delete()
returns trigger language plpgsql as $$
begin
  if coalesce((old.event_data::jsonb ->> 'locked')::boolean, false) then
    raise exception 'Event "%" is locked and can''t be deleted', old.event_name;
  end if;
  return old;
end $$;

drop trigger if exists events_block_locked_delete on events;
create trigger events_block_locked_delete
  before delete on events
  for each row execute function fairway_block_locked_event_delete();

-- 2) Scores, kickouts and sombreros of a locked event can't change
create or replace function fairway_block_locked_scores()
returns trigger language plpgsql as $$
declare
  eid uuid;
  is_locked boolean;
begin
  if tg_op = 'DELETE' then eid := old.event_id; else eid := new.event_id; end if;
  select coalesce((event_data::jsonb ->> 'locked')::boolean, false) into is_locked
    from events where id = eid;
  if coalesce(is_locked, false) then
    raise exception 'This event is locked';
  end if;
  if tg_op = 'DELETE' then return old; else return new; end if;
end $$;

drop trigger if exists live_scores_block_locked on live_scores;
create trigger live_scores_block_locked
  before insert or update or delete on live_scores
  for each row execute function fairway_block_locked_scores();
