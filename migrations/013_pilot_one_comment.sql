-- Keep the pilot reservation even if the activity history is cleaned up.
CREATE TABLE pilot_private_reply (
  slot INTEGER PRIMARY KEY CHECK (slot = 1),
  comment_id TEXT NOT NULL UNIQUE
);

CREATE TRIGGER pilot_skip_later_comments
BEFORE INSERT ON sent
WHEN NEW.dm_status IN ('pending', 'queued') AND EXISTS (SELECT 1 FROM pilot_private_reply)
BEGIN
  SELECT RAISE(IGNORE);
END;

CREATE TRIGGER pilot_reserve_first_comment
AFTER INSERT ON sent
WHEN NEW.dm_status IN ('pending', 'queued')
BEGIN
  INSERT INTO pilot_private_reply (slot, comment_id) VALUES (1, NEW.comment_id);
END;
